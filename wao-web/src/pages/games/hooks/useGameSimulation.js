import { useState, useEffect, useRef, useCallback } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { useGames, QUARTER_TIMES } from '../../../context/GamesContext';
import { useAuth } from '../../../context/AuthContext';
import { recordGameResult } from '../../../services/teamsService';

const buildInitialGame = (found) => ({
  ...found,
  status: 'live',
  homeScore: found.homeScore || 0,
  awayScore: found.awayScore || 0,
  quarters: found.quarters || { q1: { home: 0, away: 0 }, q2: { home: 0, away: 0 }, q3: { home: 0, away: 0 }, q4: { home: 0, away: 0 } },
  scoring: found.scoring || { kingdom: { home: 0, away: 0 }, workout: { home: 0, away: 0 }, goalSetting: { home: 0, away: 0 }, judges: { home: 0, away: 0 } },
  fouls: found.fouls || { home: [], away: [] },
  events: found.events || [],
});

export const useGameSimulation = () => {
  const { gameId } = useParams();
  const navigate = useNavigate();
  const { user } = useAuth();
  const { getGame, updateGame, getTimerState, setTimerStateForGame } = useGames();

  const { isPlaying, currentQuarter, timeRemaining } = getTimerState(gameId);

  const setIsPlaying = useCallback((val) =>
    setTimerStateForGame(gameId, (prev) => ({ ...prev, isPlaying: typeof val === 'function' ? val(prev.isPlaying) : val })),
  [gameId, setTimerStateForGame]);

  const setCurrentQuarter = useCallback((q) =>
    setTimerStateForGame(gameId, (prev) => ({ ...prev, currentQuarter: q })),
  [gameId, setTimerStateForGame]);

  const setTimeRemaining = useCallback((val) =>
    setTimerStateForGame(gameId, (prev) => ({ ...prev, timeRemaining: typeof val === 'function' ? val(prev.timeRemaining) : val })),
  [gameId, setTimerStateForGame]);

  const [showQuarterTransition, setShowQuarterTransition] = useState(false);
  const quarterRef = useRef(currentQuarter);
  const isEndingRef = useRef(false);

  const formatTime = (seconds) => {
    const m = Math.floor(seconds / 60).toString().padStart(2, '0');
    const s = (seconds % 60).toString().padStart(2, '0');
    return `${m}:${s}`;
  };

  useEffect(() => { quarterRef.current = currentQuarter; }, [currentQuarter]);

  // On mount: mark game as live unless it's already live (don't reset scores
  // on back+resume of an already-live game) or completed (don't resurrect it
  // — re-entering a finished match's /simulate URL used to flip it straight
  // back to 'live', which would also double-record team stats on the next
  // end-game). Skipped for an unauthorized viewer — the redirect effect
  // below bounces them before this would matter, but firestore.rules would
  // reject the write anyway, so there's no point attempting it.
  useEffect(() => {
    const found = getGame(gameId);
    const authorized = found && (user?.role === 'admin' || (!!user?.uid && found.moderatorUid === user.uid));
    if (authorized && found.status !== 'live' && found.status !== 'completed') updateGame(gameId, buildInitialGame(found));
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gameId, user]);

  // Derive game from context on every render — always fresh
  const game = getGame(gameId);

  // Mirrors the firestore.rules write gate: only an admin or the specific
  // moderator assigned to this match may run its live scoring. Everyone
  // else who lands here (e.g. a moderator paging through /games) gets
  // bounced before they can touch the scoreboard. A completed game is also
  // routed away — nothing left to simulate, and staying here risks ending
  // (and re-recording stats for) an already-finished match.
  const isAuthorized = !!game && game.status !== 'completed'
    && (user?.role === 'admin' || (!!user?.uid && game.moderatorUid === user.uid));
  useEffect(() => {
    if (game && !isAuthorized) navigate(`/games/${gameId}`, { replace: true });
  }, [game, isAuthorized, gameId, navigate]);

  const handleEndGame = useCallback(() => {
    setIsPlaying(false);
    if (window.confirm('Game has ended. Save results?')) {
      updateGame(gameId, { status: 'completed' });
      if (game) {
        recordGameResult({
          gameId,
          homeTeamId: game.homeTeamId, awayTeamId: game.awayTeamId,
          homeTeam: game.homeTeam, awayTeam: game.awayTeam,
          homeScore: game.homeScore, awayScore: game.awayScore,
        }).catch((err) => console.error('Failed to update team statistics:', err));
      }
      navigate(`/games/${gameId}`);
    }
    // If cancelled, isEndingRef (set by the caller when this fired from the
    // Q4 buzzer) is deliberately left true — see handleQuarterEnd.
  }, [gameId, navigate, updateGame, game]);

  const handleQuarterEnd = useCallback(() => {
    const q = quarterRef.current;
    if (q < 4) {
      setShowQuarterTransition(true);
      setTimeout(() => {
        const next = q + 1;
        setShowQuarterTransition(false);
        setCurrentQuarter(next);
        setTimeRemaining(QUARTER_TIMES[next]);
        isEndingRef.current = false;
      }, 3000);
    } else {
      // Leave isEndingRef true: if the moderator cancels the "save results?"
      // confirm below, Q4 is at 0:00 with nothing left to play, so resuming
      // Play shouldn't silently re-fire this same confirm on the next tick.
      // They have to use End Game (or adjust the clock) to try again.
      handleEndGame();
    }
  }, [handleEndGame]);

  // Timer tick is handled globally in GamesContext — no interval here
  // Watch for quarter end when timeRemaining hits 0
  useEffect(() => {
    if (timeRemaining === 0 && isPlaying && !isEndingRef.current) {
      isEndingRef.current = true;
      setIsPlaying(false);
      setTimeout(handleQuarterEnd, 100);
    }
  }, [timeRemaining, isPlaying, handleQuarterEnd]);

  const addScore = useCallback((team, category, points, time) => {
    const q = quarterRef.current;
    updateGame(gameId, (prev) => {
      const scoring = {
        ...prev.scoring,
        [category]: { ...prev.scoring[category], [team]: prev.scoring[category][team] + points },
      };
      const totalScore = Object.values(scoring).reduce((sum, cat) => sum + cat[team], 0);
      const qKey = `q${q}`;
      const otherTotal = Object.entries(prev.quarters).reduce(
        (sum, [k, v]) => (k !== qKey ? sum + v[team] : sum), 0
      );
      return {
        ...prev,
        scoring,
        [`${team}Score`]: totalScore,
        quarters: { ...prev.quarters, [qKey]: { ...prev.quarters[qKey], [team]: totalScore - otherTotal } },
        events: [
          { id: Date.now(), quarter: q, time, team, type: 'score', category, points, description: `${points} pt${points > 1 ? 's' : ''} — ${category}` },
          ...prev.events,
        ],
      };
    });
  }, [gameId, updateGame]);

  const addFoul = useCallback((team, player, time) => {
    if (!player?.trim()) return;
    const q = quarterRef.current;
    updateGame(gameId, (prev) => ({
      ...prev,
      fouls: { ...prev.fouls, [team]: [...prev.fouls[team], { player, quarter: `Q${q}`, minute: time }] },
      events: [
        { id: Date.now(), quarter: q, time, team, type: 'foul', player, description: `Foul — ${player}` },
        ...prev.events,
      ],
    }));
  }, [gameId, updateGame]);

  const advanceQuarter = useCallback(() => {
    const q = quarterRef.current;
    if (q >= 4) return;
    const next = q + 1;
    setIsPlaying(false);
    isEndingRef.current = false;
    setCurrentQuarter(next);
    setTimeRemaining(QUARTER_TIMES[next]);
  }, []);

  const resetQuarterTime = useCallback(() => {
    isEndingRef.current = false;
    setTimeRemaining(QUARTER_TIMES[quarterRef.current]);
  }, []);

  const setTime = useCallback((seconds) => {
    isEndingRef.current = false;
    setTimeRemaining(seconds);
  }, []);

  return {
    game: isAuthorized ? game : null, isPlaying, setIsPlaying, currentQuarter, timeRemaining,
    setTime, resetQuarterTime, advanceQuarter, handleEndGame,
    addScore, addFoul, formatTime, showQuarterTransition, gameId, navigate,
  };
};
