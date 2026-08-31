import { createContext, useContext, useState, useEffect, useRef } from 'react';
import { setInterval, clearInterval } from 'worker-timers';
import { gamesData } from '../config/constants';

export const QUARTER_TIMES = { 1: 17 * 60, 2: 17 * 60, 3: 13 * 60, 4: 13 * 60 };

const GamesContext = createContext(null);

export const GamesProvider = ({ children }) => {
  const [games, setGames] = useState(gamesData);
  const [timerState, setTimerState] = useState({});
  const timerStateRef = useRef(timerState);
  const intervalsRef = useRef({});

  useEffect(() => { timerStateRef.current = timerState; }, [timerState]);

  const getGame = (id) => games.find((g) => g.id === parseInt(id));
  const addGame = (game) => setGames((prev) => [...prev, game]);
  const deleteGame = (id) => setGames((prev) => prev.filter((g) => g.id !== parseInt(id)));
  const updateGame = (id, updater) =>
    setGames((prev) =>
      prev.map((g) => (g.id === parseInt(id) ? (typeof updater === 'function' ? updater(g) : { ...g, ...updater }) : g))
    );

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

  // Global interval — ticks for every playing game regardless of which page is open
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
        });
        return changed ? next : prev;
      });
    }, 1000);
    return () => clearInterval(id);
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
    <GamesContext.Provider value={{ games, getGame, addGame, deleteGame, updateGame, getTimerState, setTimerStateForGame }}>
      {children}
    </GamesContext.Provider>
  );
};

export const useGames = () => {
  const ctx = useContext(GamesContext);
  if (!ctx) throw new Error('useGames must be used inside GamesProvider');
  return ctx;
};
