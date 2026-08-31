import { useState, useEffect, useRef, useCallback } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { useGames, QUARTER_TIMES } from '../../../context/GamesContext';

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

  // On mount: mark game as live only if not already live (don't reset scores on back+resume)
  useEffect(() => {
    const found = getGame(gameId);
    if (found && found.status !== 'live') updateGame(gameId, buildInitialGame(found));
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [gameId]);

  // Derive game from context on every render — always fresh
  const game = getGame(gameId);

  const handleEndGame = useCallback(() => {
    setIsPlaying(false);
    if (window.confirm('Game has ended. Save results?')) {
      updateGame(gameId, { status: 'completed' });
      navigate(`/games/${gameId}`);
    }
  }, [gameId, navigate, updateGame]);

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
      handleEndGame();
      isEndingRef.current = false;
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
    game, isPlaying, setIsPlaying, currentQuarter, timeRemaining,
    setTime, resetQuarterTime, advanceQuarter, handleEndGame,
    addScore, addFoul, formatTime, showQuarterTransition, gameId, navigate,
  };
};
