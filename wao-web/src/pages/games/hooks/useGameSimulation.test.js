import { describe, it, expect, vi, beforeEach } from 'vitest';
import { act, renderHook, waitFor } from '@testing-library/react';

const QUARTER_TIMES = { 1: 17 * 60, 2: 17 * 60, 3: 13 * 60, 4: 13 * 60 };

vi.mock('../../../context/GamesContext', () => ({ useGames: vi.fn(), QUARTER_TIMES }));
vi.mock('../../../context/AuthContext', () => ({ useAuth: vi.fn() }));
vi.mock('../../../services/teamsService', () => ({ recordGameResult: vi.fn(() => Promise.resolve()) }));
vi.mock('react-router-dom', () => ({ useParams: vi.fn(), useNavigate: vi.fn() }));

const { useGames } = await import('../../../context/GamesContext');
const { useAuth } = await import('../../../context/AuthContext');
const { recordGameResult } = await import('../../../services/teamsService');
const { useParams, useNavigate } = await import('react-router-dom');
const { useGameSimulation } = await import('./useGameSimulation');

// A minimal stand-in for GamesContext: real mutable state so updateGame/
// setTimerStateForGame followed by a rerender() behaves like the real
// Firestore-subscription-driven re-render would in the app.
function makeFakeGames(initialGame, initialTimer) {
  const games = { [initialGame.id]: { ...initialGame } };
  const timerState = { [initialGame.id]: initialTimer ?? { isPlaying: false, currentQuarter: 1, timeRemaining: QUARTER_TIMES[1] } };
  return {
    getGame: vi.fn((id) => games[id]),
    updateGame: vi.fn((id, updater) => {
      games[id] = typeof updater === 'function' ? updater(games[id]) : { ...games[id], ...updater };
    }),
    getTimerState: vi.fn((id) => timerState[id]),
    setTimerStateForGame: vi.fn((id, updater) => {
      timerState[id] = typeof updater === 'function' ? updater(timerState[id]) : { ...timerState[id], ...updater };
    }),
    _games: games,
    _timerState: timerState,
  };
}

const baseGame = {
  id: 'g1', status: 'live', moderatorUid: 'mod-1',
  homeTeamId: 'home1', awayTeamId: 'away1', homeTeam: 'Home FC', awayTeam: 'Away FC',
  homeScore: 0, awayScore: 0,
  quarters: { q1: { home: 0, away: 0 }, q2: { home: 0, away: 0 }, q3: { home: 0, away: 0 }, q4: { home: 0, away: 0 } },
  scoring: { kingdom: { home: 0, away: 0 }, workout: { home: 0, away: 0 }, goalSetting: { home: 0, away: 0 }, judges: { home: 0, away: 0 } },
  fouls: { home: [], away: [] },
  events: [],
};

const navigateMock = vi.fn();

beforeEach(() => {
  vi.clearAllMocks();
  useParams.mockReturnValue({ gameId: 'g1' });
  useNavigate.mockReturnValue(navigateMock);
});

describe('useGameSimulation — access gating', () => {
  it('admin gets the real game object', () => {
    const fake = makeFakeGames(baseGame);
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'admin-1', role: 'admin' } });

    const { result } = renderHook(() => useGameSimulation());
    expect(result.current.game).not.toBeNull();
    expect(result.current.game.id).toBe('g1');
  });

  it('the assigned moderator gets the real game object', () => {
    const fake = makeFakeGames(baseGame);
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });

    const { result } = renderHook(() => useGameSimulation());
    expect(result.current.game).not.toBeNull();
  });

  it('a different moderator is blocked and redirected — this is the fix for the access-control gap', async () => {
    const fake = makeFakeGames(baseGame);
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'some-other-moderator', role: 'moderator' } });

    const { result } = renderHook(() => useGameSimulation());
    expect(result.current.game).toBeNull();
    await waitFor(() => expect(navigateMock).toHaveBeenCalledWith('/games/g1', { replace: true }));
  });

  it('a completed game is blocked and redirected even for the assigned moderator', async () => {
    const fake = makeFakeGames({ ...baseGame, status: 'completed' });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });

    const { result } = renderHook(() => useGameSimulation());
    expect(result.current.game).toBeNull();
    await waitFor(() => expect(navigateMock).toHaveBeenCalledWith('/games/g1', { replace: true }));
  });

  it('marks an upcoming game live on mount for an authorized viewer, but never resurrects a completed one', () => {
    const upcoming = makeFakeGames({ ...baseGame, status: 'upcoming' });
    useGames.mockReturnValue(upcoming);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });
    renderHook(() => useGameSimulation());
    expect(upcoming._games.g1.status).toBe('live');

    vi.clearAllMocks();
    useParams.mockReturnValue({ gameId: 'g1' });
    useNavigate.mockReturnValue(navigateMock);
    const completed = makeFakeGames({ ...baseGame, status: 'completed' });
    useGames.mockReturnValue(completed);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });
    renderHook(() => useGameSimulation());
    expect(completed._games.g1.status).toBe('completed');
  });
});

describe('useGameSimulation — scoring math', () => {
  it('addScore updates the category, the quarter breakdown, and the running total together', () => {
    const fake = makeFakeGames(baseGame, { isPlaying: true, currentQuarter: 1, timeRemaining: 900 });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });

    const { result } = renderHook(() => useGameSimulation());
    act(() => result.current.addScore('home', 'kingdom', 3, '15:00'));

    const g = fake._games.g1;
    expect(g.scoring.kingdom.home).toBe(3);
    expect(g.homeScore).toBe(3);
    expect(g.quarters.q1.home).toBe(3);
    expect(g.events[0]).toMatchObject({ team: 'home', type: 'score', category: 'kingdom', points: 3 });
  });

  it('accumulates points across categories and quarters into the correct running total', () => {
    const fake = makeFakeGames(baseGame, { isPlaying: true, currentQuarter: 1, timeRemaining: 900 });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });

    const { result } = renderHook(() => useGameSimulation());
    act(() => result.current.addScore('home', 'kingdom', 3, '15:00'));
    act(() => result.current.addScore('home', 'workout', 2, '14:00'));

    const g = fake._games.g1;
    expect(g.homeScore).toBe(5);
    expect(g.quarters.q1.home).toBe(5);
  });

  it('addFoul records the foul and a matching event, and ignores a blank player name', () => {
    const fake = makeFakeGames(baseGame, { isPlaying: true, currentQuarter: 2, timeRemaining: 500 });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });

    const { result } = renderHook(() => useGameSimulation());
    act(() => result.current.addFoul('away', '  ', '10:00'));
    expect(fake._games.g1.fouls.away).toHaveLength(0);

    act(() => result.current.addFoul('away', 'Jane Doe', '10:00'));
    expect(fake._games.g1.fouls.away).toEqual([{ player: 'Jane Doe', quarter: 'Q2', minute: '10:00' }]);
    expect(fake._games.g1.events[0]).toMatchObject({ team: 'away', type: 'foul', player: 'Jane Doe' });
  });
});

describe('useGameSimulation — quarter progression', () => {
  it('advanceQuarter moves to the next quarter, resets the clock, and pauses', () => {
    const fake = makeFakeGames(baseGame, { isPlaying: true, currentQuarter: 1, timeRemaining: 300 });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });

    const { result } = renderHook(() => useGameSimulation());
    act(() => result.current.advanceQuarter());

    expect(fake._timerState.g1).toMatchObject({ isPlaying: false, currentQuarter: 2, timeRemaining: QUARTER_TIMES[2] });
  });

  it('refuses to advance past Q4', () => {
    const fake = makeFakeGames(baseGame, { isPlaying: false, currentQuarter: 4, timeRemaining: 60 });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });

    const { result } = renderHook(() => useGameSimulation());
    act(() => result.current.advanceQuarter());

    expect(fake._timerState.g1.currentQuarter).toBe(4);
  });
});

describe('useGameSimulation — ending the game', () => {
  it('manual End Game, confirmed: marks the game completed and records both teams\' stats', async () => {
    const fake = makeFakeGames({ ...baseGame, homeScore: 60, awayScore: 55 }, { isPlaying: true, currentQuarter: 3, timeRemaining: 200 });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });
    vi.spyOn(window, 'confirm').mockReturnValue(true);

    const { result } = renderHook(() => useGameSimulation());
    act(() => result.current.handleEndGame());

    expect(fake._games.g1.status).toBe('completed');
    expect(recordGameResult).toHaveBeenCalledWith(expect.objectContaining({
      gameId: 'g1', homeTeamId: 'home1', awayTeamId: 'away1', homeScore: 60, awayScore: 55,
    }));
    expect(navigateMock).toHaveBeenCalledWith('/games/g1');
  });

  it('manual End Game, cancelled: leaves the game live and never records stats', () => {
    const fake = makeFakeGames(baseGame, { isPlaying: true, currentQuarter: 3, timeRemaining: 200 });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });
    vi.spyOn(window, 'confirm').mockReturnValue(false);

    const { result } = renderHook(() => useGameSimulation());
    act(() => result.current.handleEndGame());

    expect(fake._games.g1.status).toBe('live');
    expect(recordGameResult).not.toHaveBeenCalled();
  });

  it('the Q4 buzzer (time hits 0 while playing) auto-triggers End Game', async () => {
    const fake = makeFakeGames({ ...baseGame, homeScore: 10, awayScore: 8 }, { isPlaying: true, currentQuarter: 4, timeRemaining: 0 });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });
    vi.spyOn(window, 'confirm').mockReturnValue(true);

    renderHook(() => useGameSimulation());

    await waitFor(() => expect(fake._games.g1.status).toBe('completed'), { timeout: 2000 });
    expect(recordGameResult).toHaveBeenCalledWith(expect.objectContaining({ homeScore: 10, awayScore: 8 }));
  });

  it('cancelling the Q4 buzzer confirm does not leave it re-firing on every render', async () => {
    const fake = makeFakeGames(baseGame, { isPlaying: true, currentQuarter: 4, timeRemaining: 0 });
    useGames.mockReturnValue(fake);
    useAuth.mockReturnValue({ user: { uid: 'mod-1', role: 'moderator' } });
    const confirmSpy = vi.spyOn(window, 'confirm').mockReturnValue(false);

    const { rerender } = renderHook(() => useGameSimulation());
    await waitFor(() => expect(confirmSpy).toHaveBeenCalledTimes(1));

    // Re-rendering with the same 0-time/playing state (as a real resumed
    // Play press would look like) must not pop a second confirm on its own —
    // only re-arming via advanceQuarter/resetQuarterTime/setTime should.
    rerender();
    await new Promise((r) => setTimeout(r, 150));
    expect(confirmSpy).toHaveBeenCalledTimes(1);
    expect(fake._games.g1.status).toBe('live');
  });
});
