import { describe, it, expect, vi, beforeEach } from 'vitest';

// In-memory fake for the two teamStatistics docs a game result touches.
// Keyed by team id so bumpTeamStats' two calls (home + away) can each see
// their own prior state.
let store;

vi.mock('../lib/firebase', () => ({ db: {} }));
vi.mock('firebase/firestore', () => ({
  collection: vi.fn(), addDoc: vi.fn(), updateDoc: vi.fn(), deleteDoc: vi.fn(),
  onSnapshot: vi.fn(), query: vi.fn(), orderBy: vi.fn(), where: vi.fn(),
  documentId: vi.fn(), writeBatch: vi.fn(), arrayUnion: vi.fn(), arrayRemove: vi.fn(),
  doc: vi.fn((_db, _col, id) => ({ id })),
  getDoc: vi.fn(async (ref) => ({
    exists: () => store[ref.id] !== undefined,
    data: () => store[ref.id],
  })),
  setDoc: vi.fn(async (ref, data) => { store[ref.id] = data; }),
  serverTimestamp: vi.fn(() => '__server_timestamp__'),
  Timestamp: { now: vi.fn(() => '__timestamp_now__') },
}));

const { recordGameResult, ROLE_TO_LABEL, LABEL_TO_ROLE, ROSTER_ROLES } = await import('./teamsService');

beforeEach(() => { store = {}; });

describe('recordGameResult — denormalizing a finished match into teamStatistics', () => {
  it('records a win for the home team and a loss for the away team', async () => {
    await recordGameResult({
      gameId: 'g1', homeTeamId: 'home1', awayTeamId: 'away1',
      homeTeam: 'Home FC', awayTeam: 'Away FC', homeScore: 55, awayScore: 40,
    });

    expect(store.home1).toMatchObject({
      totalGamesPlayed: 1, wins: 1, draws: 0, losses: 0,
      goalsScored: 55, goalsConceded: 40,
    });
    expect(store.away1).toMatchObject({
      totalGamesPlayed: 1, wins: 0, draws: 0, losses: 1,
      goalsScored: 40, goalsConceded: 55,
    });
  });

  it('records a draw for both teams on equal scores', async () => {
    await recordGameResult({
      gameId: 'g2', homeTeamId: 'h', awayTeamId: 'a',
      homeTeam: 'H', awayTeam: 'A', homeScore: 30, awayScore: 30,
    });
    expect(store.h).toMatchObject({ wins: 0, draws: 1, losses: 0 });
    expect(store.a).toMatchObject({ wins: 0, draws: 1, losses: 0 });
  });

  it('accumulates onto existing stats rather than overwriting them', async () => {
    store.h = { totalGamesPlayed: 4, wins: 3, draws: 0, losses: 1, goalsScored: 120, goalsConceded: 90, recentGames: [] };
    store.a = { totalGamesPlayed: 4, wins: 1, draws: 0, losses: 3, goalsScored: 90, goalsConceded: 120, recentGames: [] };

    await recordGameResult({
      gameId: 'g3', homeTeamId: 'h', awayTeamId: 'a',
      homeTeam: 'H', awayTeam: 'A', homeScore: 20, awayScore: 10,
    });

    expect(store.h).toMatchObject({ totalGamesPlayed: 5, wins: 4, losses: 1, goalsScored: 140, goalsConceded: 100 });
    expect(store.a).toMatchObject({ totalGamesPlayed: 5, wins: 1, losses: 4, goalsScored: 100, goalsConceded: 140 });
  });

  it('preserves activePlayers/inactivePlayers/totalFollowers instead of resetting them', async () => {
    store.h = { activePlayers: 9, inactivePlayers: 2, totalFollowers: 137, recentGames: [] };
    store.a = { recentGames: [] };

    await recordGameResult({
      gameId: 'g4', homeTeamId: 'h', awayTeamId: 'a',
      homeTeam: 'H', awayTeam: 'A', homeScore: 10, awayScore: 5,
    });

    expect(store.h).toMatchObject({ activePlayers: 9, inactivePlayers: 2, totalFollowers: 137 });
    expect(store.a).toMatchObject({ activePlayers: 0, inactivePlayers: 0, totalFollowers: 0 });
  });

  it('prepends the new result and caps recentGames at 10', async () => {
    store.h = {
      recentGames: Array.from({ length: 10 }, (_, i) => ({ gameId: `old-${i}` })),
    };
    store.a = { recentGames: [] };

    await recordGameResult({
      gameId: 'newest', homeTeamId: 'h', awayTeamId: 'a',
      homeTeam: 'H', awayTeam: 'A', homeScore: 1, awayScore: 0,
    });

    expect(store.h.recentGames).toHaveLength(10);
    expect(store.h.recentGames[0]).toMatchObject({ gameId: 'newest', opponentTeamId: 'a', opponentTeamName: 'A', teamScore: 1, opponentScore: 0, isHomeGame: true });
    expect(store.h.recentGames.map((g) => g.gameId)).not.toContain('old-9');
  });

  it('is a no-op when either team id is missing (malformed match doc)', async () => {
    await recordGameResult({ gameId: 'g5', homeTeamId: '', awayTeamId: 'a', homeTeam: 'H', awayTeam: 'A', homeScore: 1, awayScore: 0 });
    expect(Object.keys(store)).toHaveLength(0);
  });
});

describe('role label mapping', () => {
  it('is a true bijection — every roster role round-trips through its label', () => {
    for (const role of ROSTER_ROLES) {
      const label = ROLE_TO_LABEL[role];
      expect(label).toBeDefined();
      expect(LABEL_TO_ROLE[label]).toBe(role);
    }
  });
});
