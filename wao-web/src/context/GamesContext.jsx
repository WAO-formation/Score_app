import { createContext, useContext, useState, useEffect, useRef } from 'react';
import { setInterval, clearInterval } from 'worker-timers';
import { subscribeToMatches, createMatch, updateMatch, deleteMatch } from '../services/matchesService';

export const QUARTER_TIMES = { 1: 17 * 60, 2: 17 * 60, 3: 13 * 60, 4: 13 * 60 };

// firestore.rules enforces a 2s per-document cooldown on official-tier match
// writes (rate limiting added deliberately — see pastCooldown() in the
// rules). Live scoring needs to feel instant, so local state updates apply
// immediately and Firestore writes are coalesced to at most one per game
// every WRITE_INTERVAL_MS, always reading the freshest local state at flush
// time rather than the value captured when the write was first requested.
const WRITE_INTERVAL_MS = 2200;
const SYNC_KEYS = [
  'status', 'statusReason',
  'homeScore', 'awayScore', 'scoring',
  'quarters', 'fouls', 'events',
  'currentQuarter', 'timeRemaining',
];

const GamesContext = createContext(null);

export const GamesProvider = ({ children }) => {
  const [games, setGames] = useState([]);
  const [loading, setLoading] = useState(true);
  const [timerState, setTimerState] = useState({});
  const timerStateRef = useRef(timerState);
  const gamesRef = useRef(games);
  const lastWriteRef = useRef({});
  const flushTimeoutRef = useRef({});

  useEffect(() => { timerStateRef.current = timerState; }, [timerState]);
  useEffect(() => { gamesRef.current = games; }, [games]);

  useEffect(() => {
    return subscribeToMatches(
      (list) => { setGames(list); setLoading(false); },
      (err) => { console.error('Failed to load games:', err); setLoading(false); }
    );
  }, []);

  const getGame = (id) => games.find((g) => g.id === id);

  const scheduleSync = (id) => {
    if (flushTimeoutRef.current[id]) return; // a flush is already queued — it'll pick up the latest state
    const elapsed = Date.now() - (lastWriteRef.current[id] || 0);
    const delay = Math.max(0, WRITE_INTERVAL_MS - elapsed);
    flushTimeoutRef.current[id] = setTimeout(() => {
      flushTimeoutRef.current[id] = null;
      lastWriteRef.current[id] = Date.now();
      const current = gamesRef.current.find((g) => g.id === id);
      if (!current) return;
      const patch = SYNC_KEYS.reduce((acc, k) => {
        if (k in current) acc[k] = current[k];
        return acc;
      }, {});
      updateMatch(id, patch).catch((err) => console.error('Failed to sync game update:', err));
    }, delay);
  };

  const addGame = (gameInput) => createMatch(gameInput);
  const deleteGame = (id) => deleteMatch(id);

  const updateGame = (id, updater) => {
    setGames((prev) =>
      prev.map((g) => (g.id === id ? (typeof updater === 'function' ? updater(g) : { ...g, ...updater }) : g))
    );
    scheduleSync(id);
  };

  const getTimerState = (id) =>
    timerState[id] ?? { isPlaying: false, currentQuarter: 1, timeRemaining: QUARTER_TIMES[1] };

  const setTimerStateForGame = (id, updater) =>
    setTimerState((prev) => {
      const current = prev[id] ?? { isPlaying: false, currentQuarter: 1, timeRemaining: QUARTER_TIMES[1] };
      return { ...prev, [id]: typeof updater === 'function' ? updater(current) : { ...current, ...updater } };
    });

  const formatTime = (seconds) => {
    const m = Math.floor(seconds / 60).toString().padStart(2, '0');
    const s = (seconds % 60).toString().padStart(2, '0');
    return `${m}:${s}`;
  };

  // Global interval — ticks for every playing game regardless of which page
  // is open, and doubles as the "heartbeat": scheduleSync self-throttles to
  // one write per WRITE_INTERVAL_MS, so calling it every tick just means
  // other viewers' currentQuarter/timeRemaining stay close to real-time
  // even between actual scoring events.
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

  // Sync timer values into games array so all pages see live time
  useEffect(() => {
    setGames((prev) =>
      prev.map((g) => {
        const t = timerState[g.id];
        if (!t) return g;
        return { ...g, timeRemaining: formatTime(t.timeRemaining), currentQuarter: `Q${t.currentQuarter}` };
      })
    );
  }, [timerState]);

  return (
    <GamesContext.Provider value={{ games, loading, getGame, addGame, deleteGame, updateGame, getTimerState, setTimerStateForGame }}>
      {children}
    </GamesContext.Provider>
  );
};

export const useGames = () => {
  const ctx = useContext(GamesContext);
  if (!ctx) throw new Error('useGames must be used inside GamesProvider');
  return ctx;
};
