import { createContext, useContext, useState, useEffect, useRef } from 'react';
import { setInterval, clearInterval } from 'worker-timers';
import { subscribeToMatches, createMatch, updateMatch, deleteMatch, isLiveOverdue } from '../services/matchesService';
import { useAuth } from './AuthContext';

export const QUARTER_TIMES = { 1: 17 * 60, 2: 17 * 60, 3: 13 * 60, 4: 13 * 60 };

// firestore.rules enforces a 2000ms per-document cooldown on official-tier
// match writes (rate limiting added deliberately — see pastCooldown() in
// the rules). Live scoring needs to feel instant, so local state updates
// apply immediately and Firestore writes are coalesced to at most one per
// game every WRITE_INTERVAL_MS, always reading the freshest local state at
// flush time rather than the value captured when the write was first
// requested.
//
// This must stay comfortably above the 2000ms rules cooldown, not just
// above it — 2200ms (100ms of margin) was too thin: ordinary network
// latency variance between two consecutive writes could push the *server's*
// timestamp gap under 2000ms even though the client waited 2200ms between
// initiating them, which the rules then reject outright. That surfaced as
// scores visibly ticking up then reverting (the optimistic local value got
// overwritten by the next real-time snapshot, which still held the last
// *successfully persisted* score). 600ms of margin is far more forgiving of
// realistic round-trip jitter.
const WRITE_INTERVAL_MS = 2600;
const SYNC_KEYS = [
  'status', 'statusReason',
  'homeScore', 'awayScore', 'scoring',
  'quarters', 'fouls', 'events',
  'currentQuarter', 'timeRemaining', 'isPlaying',
];

const GamesContext = createContext(null);

export const GamesProvider = ({ children }) => {
  const { user } = useAuth();
  const [games, setGames] = useState([]);
  const [loading, setLoading] = useState(true);
  const [timerState, setTimerState] = useState({});
  const timerStateRef = useRef(timerState);
  const gamesRef = useRef(games);
  const lastWriteRef = useRef({});
  const flushTimeoutRef = useRef({});
  // Separate, much simpler throttle for a judge's Judges-category score
  // submissions (see submitJudgeScore below) — kept independent of
  // pendingFieldsRef/scheduleSync because that flush's SYNC_KEYS fallback
  // assumes an admin/moderator session and would try to write fields
  // (status, scoreA, ...) a judge has no rules permission to touch.
  const judgeWriteTimeoutRef = useRef({});
  // Which fields an updateGame() call actually touched since the last flush,
  // per game id — the throttled flush below only writes these (falling back
  // to SYNC_KEYS when nothing was recorded, e.g. a flush triggered purely by
  // the ticking clock). Without this, any updateGame() patch outside
  // SYNC_KEYS (startTime, venue, moderatorUid/judges reassignment,
  // previousStatus, ...) updated local state but was silently dropped from
  // the actual Firestore write, reverting on the next snapshot.
  const pendingFieldsRef = useRef({});

  useEffect(() => { timerStateRef.current = timerState; }, [timerState]);
  useEffect(() => { gamesRef.current = games; }, [games]);

  useEffect(() => {
    return subscribeToMatches(
      (list) => { setGames(list); setLoading(false); },
      (err) => { console.error('Failed to load games:', err); setLoading(false); }
    );
  }, []);

  const parseTimeToSeconds = (str) => {
    if (typeof str === 'number') return str;
    const [m, s] = (str || '17:00').split(':').map(Number);
    return (m || 0) * 60 + (s || 0);
  };

  // On games load, seed timerState for any live game not yet tracked
  useEffect(() => {
    if (!games.length) return;
    setTimerState((prev) => {
      const patch = {};
      games.forEach((g) => {
        if (prev[g.id]) return; // already tracked
        const q = parseInt((g.currentQuarter || 'Q1').replace('Q', ''), 10) || 1;
        patch[g.id] = {
          isPlaying: g.isPlaying ?? false,
          currentQuarter: q,
          timeRemaining: parseTimeToSeconds(g.timeRemaining),
        };
      });
      return Object.keys(patch).length ? { ...prev, ...patch } : prev;
    });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [games.length]);

  const getGame = (id) => games.find((g) => g.id === id);

  const scheduleSync = (id) => {
    if (flushTimeoutRef.current[id]) return;
    const elapsed = Date.now() - (lastWriteRef.current[id] || 0);
    const delay = Math.max(0, WRITE_INTERVAL_MS - elapsed);
    flushTimeoutRef.current[id] = setTimeout(() => {
      flushTimeoutRef.current[id] = null;
      lastWriteRef.current[id] = Date.now();
      const current = gamesRef.current.find((g) => g.id === id);
      if (!current) return;
      const t = timerStateRef.current[id];
      const fields = pendingFieldsRef.current[id];
      delete pendingFieldsRef.current[id];
      const keys = fields && fields.size ? [...fields] : SYNC_KEYS;
      const patch = keys.reduce((acc, k) => {
        if (k in current) acc[k] = current[k];
        return acc;
      }, {});
      // Merge live timer values — these aren't in the games array anymore
      if (t) {
        patch.isPlaying = t.isPlaying;
        patch.currentQuarter = `Q${t.currentQuarter}`;
        patch.timeRemaining = formatTime(t.timeRemaining);
      }
      updateMatch(id, patch).catch((err) => {
        console.error('Failed to sync game update, retrying shortly:', err);
        // Re-mark these fields pending so the retry writes them (not just
        // whatever SYNC_KEYS covers) and reschedule — otherwise a failed
        // write (e.g. a cooldown near-miss) only gets picked up again by
        // the next unrelated trigger (the per-second tick, if this game
        // happens to be playing), which can lag visibly behind the score
        // the moderator actually just entered.
        const pending = pendingFieldsRef.current[id] || (pendingFieldsRef.current[id] = new Set());
        keys.forEach((k) => pending.add(k));
        scheduleSync(id);
      });
    }, delay);
  };

  const addGame = (gameInput) => createMatch(gameInput);
  const deleteGame = (id) => deleteMatch(id);

  const updateGame = (id, updater) => {
    setGames((prev) =>
      prev.map((g) => (g.id === id ? (typeof updater === 'function' ? updater(g) : { ...g, ...updater }) : g))
    );
    const set = pendingFieldsRef.current[id] || (pendingFieldsRef.current[id] = new Set());
    if (typeof updater === 'function') {
      // Function-form updaters are only ever used by the live-scoring hook
      // to touch score/foul/quarter/timer state — safe to assume the full
      // SYNC_KEYS set rather than inspecting what it actually changed.
      SYNC_KEYS.forEach((k) => set.add(k));
    } else {
      Object.keys(updater).forEach((k) => set.add(k));
    }
    scheduleSync(id);
  };

  // A judge grants points to the Judges (10%) category from /officiating.
  // Optimistic locally like everything else here, but written on its own
  // throttled timer straight through matchesService rather than via
  // updateGame/scheduleSync — see judgeWriteTimeoutRef above.
  const submitJudgeScore = (id, team, delta) => {
    setGames((prev) =>
      prev.map((g) => {
        if (g.id !== id) return g;
        const judges = { ...g.scoring.judges };
        judges[team] = Math.max(0, (judges[team] || 0) + delta);
        return { ...g, scoring: { ...g.scoring, judges } };
      })
    );
    if (judgeWriteTimeoutRef.current[id]) return; // already scheduled — flush picks up the latest state
    const flushJudgeScore = () => {
      judgeWriteTimeoutRef.current[id] = null;
      const current = gamesRef.current.find((g) => g.id === id);
      if (!current) return;
      updateMatch(id, { judgesScore: current.scoring.judges }).catch((err) => {
        // Same cooldown-near-miss risk as scheduleSync above, and this timer
        // runs independently of it — a moderator and a judge scoring the
        // same live match at once write on two uncoordinated ~2.6s cycles,
        // so a collision here isn't fully eliminated by widening the
        // interval alone. Retry rather than silently drop the grant.
        console.error('Failed to submit judge score, retrying shortly:', err);
        judgeWriteTimeoutRef.current[id] = setTimeout(flushJudgeScore, WRITE_INTERVAL_MS);
      });
    };
    judgeWriteTimeoutRef.current[id] = setTimeout(flushJudgeScore, WRITE_INTERVAL_MS);
  };

  const getTimerState = (id) => {
    if (timerState[id]) return timerState[id];
    // Seed from Firestore data on first access (e.g. after a page refresh)
    const game = games.find((g) => g.id === id);
    if (game) {
      const q = parseInt((game.currentQuarter || 'Q1').replace('Q', ''), 10) || 1;
      return {
        isPlaying: game.isPlaying ?? false,
        currentQuarter: q,
        timeRemaining: parseTimeToSeconds(game.timeRemaining),
      };
    }
    return { isPlaying: false, currentQuarter: 1, timeRemaining: QUARTER_TIMES[1] };
  };

  // Every caller of this (play/pause toggle, quarter advance, time adjust)
  // represents a moderator-driven change that needs to reach Firestore on
  // its own — previously these only got persisted by piggybacking on the
  // next score/foul write or the next playing tick, so pausing and then
  // walking away (e.g. after manually advancing a quarter) silently never
  // synced at all.
  const setTimerStateForGame = (id, updater) => {
    setTimerState((prev) => {
      const current = prev[id] ?? { isPlaying: false, currentQuarter: 1, timeRemaining: QUARTER_TIMES[1] };
      return { ...prev, [id]: typeof updater === 'function' ? updater(current) : { ...current, ...updater } };
    });
    scheduleSync(id);
  };

  const formatTime = (seconds) => {
    const m = Math.floor(seconds / 60).toString().padStart(2, '0');
    const s = (seconds % 60).toString().padStart(2, '0');
    return `${m}:${s}`;
  };

  // Returns live-formatted { timeRemaining, currentQuarter } for a game,
  // falling back to the Firestore-stored values when the timer isn't running.
  const getFormattedTimer = (id) => {
    const t = timerState[id];
    if (t) return { timeRemaining: formatTime(t.timeRemaining), currentQuarter: `Q${t.currentQuarter}` };
    const game = games.find((g) => g.id === id);
    return {
      timeRemaining: game?.timeRemaining ?? '17:00',
      currentQuarter: game?.currentQuarter ?? 'Q1',
    };
  };

  // A live game nobody ever ended (moderator went offline, forgot to hit End
  // Game, ...) gets auto-suspended 24h after it went live, until someone
  // manually resumes it — "enforce all restrictions" per the suspend/resume
  // flow already built into Management > Games and My Games. Only an admin
  // or the assigned moderator has rules permission to write a match's
  // status, so this only runs (and only acts on games it's allowed to
  // touch) for those two roles — a judge's session just never fires it.
  useEffect(() => {
    if (user?.role !== 'admin' && user?.role !== 'moderator') return;
    const checkOverdueLiveGames = () => {
      gamesRef.current.forEach((g) => {
        if (!isLiveOverdue(g)) return;
        if (user.role !== 'admin' && g.moderatorUid !== user.uid) return;
        updateGame(g.id, {
          status: 'suspended',
          statusReason: 'Auto-suspended — live for over 24 hours. Resume once play restarts.',
          previousStatus: 'live',
        });
      });
    };
    checkOverdueLiveGames();
    const id = setInterval(checkOverdueLiveGames, 5 * 60 * 1000);
    return () => clearInterval(id);
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [user?.uid, user?.role]);

  // Global interval — ticks for every playing game regardless of which page is open.
  useEffect(() => {
    const id = setInterval(() => {
      setTimerState((prev) => {
        const next = { ...prev };
        let changed = false;
        Object.keys(next).forEach((gameId) => {
          const t = next[gameId];
          if (!t.isPlaying || t.timeRemaining <= 0) return;
          changed = true;
          next[gameId] = { ...t, timeRemaining: t.timeRemaining - 1 };
          scheduleSync(gameId);
        });
        return changed ? next : prev;
      });
    }, 1000);
    return () => clearInterval(id);
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return (
    <GamesContext.Provider value={{ games, loading, getGame, addGame, deleteGame, updateGame, submitJudgeScore, getTimerState, setTimerStateForGame, getFormattedTimer }}>
      {children}
    </GamesContext.Provider>
  );
};

export const useGames = () => {
  const ctx = useContext(GamesContext);
  if (!ctx) throw new Error('useGames must be used inside GamesProvider');
  return ctx;
};
