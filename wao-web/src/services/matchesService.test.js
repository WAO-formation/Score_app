import { describe, it, expect, vi } from 'vitest';

// docToGame/toFirestorePatch never touch the network, but the module
// imports `db` from lib/firebase, which calls initializeApp — mock it out
// so these tests don't depend on real Firebase env vars being present.
vi.mock('../lib/firebase', () => ({ db: {} }));

const {
  emptyQuarters, emptyScoring, emptyFouls,
  toFirestorePatch, canStartGame, isRecentOrActive, isPastDue, isLiveOverdue, generateAccessCode,
} = await import('./matchesService');

// docToGame isn't exported, so it's exercised indirectly is not possible
// without touching Firestore — the shape it produces is instead covered by
// asserting toFirestorePatch (its inverse for the fields that round-trip)
// against known input/output pairs matching wao_mobile's on-disk schema.

describe('matchesService — Firestore <-> app-shape translation', () => {
  it('maps a status change to completed into finished + completedAt', () => {
    const patch = toFirestorePatch({ status: 'completed' });
    expect(patch.status).toBe('finished');
    expect(patch).toHaveProperty('completedAt');
    expect(patch).toHaveProperty('updatedAt');
  });

  it('leaves non-completed statuses untranslated', () => {
    const patch = toFirestorePatch({ status: 'postponed' });
    expect(patch.status).toBe('postponed');
    expect(patch).not.toHaveProperty('completedAt');
  });

  it('flattens the scoring object into the four teamA*/teamB* category fields', () => {
    const scoring = {
      kingdom: { home: 5, away: 3 },
      workout: { home: 2, away: 4 },
      goalSetting: { home: 1, away: 1 },
      judges: { home: 1, away: 0 },
    };
    const patch = toFirestorePatch({ scoring });
    expect(patch).toMatchObject({
      teamAKingdom: 5, teamBKingdom: 3,
      teamAWorkout: 2, teamBWorkout: 4,
      teamAGoalSetting: 1, teamBGoalSetting: 1,
      teamAJudges: 1, teamBJudges: 0,
    });
  });

  it('translates home/away score keys to scoreA/scoreB', () => {
    const patch = toFirestorePatch({ homeScore: 42, awayScore: 7 });
    expect(patch).toMatchObject({ scoreA: 42, scoreB: 7 });
  });

  it('drops any app-shape key that has no Firestore mapper', () => {
    const patch = toFirestorePatch({ homeTeam: 'Should not appear', homeScore: 10 });
    expect(patch).not.toHaveProperty('homeTeam');
    expect(patch.scoreA).toBe(10);
  });

  it('always stamps updatedAt, even for an empty patch', () => {
    expect(toFirestorePatch({})).toHaveProperty('updatedAt');
  });

  it('converts a reschedule Date into a Firestore Timestamp on startTime', () => {
    const newDate = new Date('2026-09-01T15:00:00Z');
    const patch = toFirestorePatch({ startTime: newDate });
    expect(patch.startTime.toDate().getTime()).toBe(newDate.getTime());
  });

  it('stamps liveStartedAt when a status change moves a game to live', () => {
    const patch = toFirestorePatch({ status: 'live' });
    expect(patch.status).toBe('live');
    expect(patch).toHaveProperty('liveStartedAt');
    expect(patch).not.toHaveProperty('completedAt');
  });

  it('keeps judgeUids in sync with the judges array', () => {
    const judges = [{ uid: 'j1', name: 'Judge One' }, { uid: 'j2', name: 'Judge Two' }];
    const patch = toFirestorePatch({ judges });
    expect(patch.judges).toBe(judges);
    expect(patch.judgeUids).toEqual(['j1', 'j2']);
  });

  it('maps a judgesScore grant to only teamAJudges/teamBJudges, nothing else', () => {
    const patch = toFirestorePatch({ judgesScore: { home: 3, away: 1 } });
    expect(patch).toMatchObject({ teamAJudges: 3, teamBJudges: 1 });
    expect(Object.keys(patch).sort()).toEqual(['teamAJudges', 'teamBJudges', 'updatedAt'].sort());
  });

  it('produces zeroed, all-four-quarter/category default shapes', () => {
    expect(emptyQuarters()).toEqual({
      q1: { home: 0, away: 0 }, q2: { home: 0, away: 0 },
      q3: { home: 0, away: 0 }, q4: { home: 0, away: 0 },
    });
    expect(emptyScoring()).toEqual({
      kingdom: { home: 0, away: 0 }, workout: { home: 0, away: 0 },
      goalSetting: { home: 0, away: 0 }, judges: { home: 0, away: 0 },
    });
    expect(emptyFouls()).toEqual({ home: [], away: [] });
  });
});

describe('canStartGame — gates on the exact scheduled timestamp', () => {
  it('is false with no startTime at all', () => {
    expect(canStartGame({})).toBe(false);
  });

  it('is false before the scheduled time', () => {
    expect(canStartGame({ startTime: new Date(Date.now() + 60_000) })).toBe(false);
  });

  it('is true once the scheduled time has passed', () => {
    expect(canStartGame({ startTime: new Date(Date.now() - 1000) })).toBe(true);
  });
});

describe('isRecentOrActive — Games list 7-day archive window', () => {
  it('always keeps upcoming and live games visible', () => {
    expect(isRecentOrActive({ status: 'upcoming', completedAt: new Date(0) })).toBe(true);
    expect(isRecentOrActive({ status: 'live', completedAt: new Date(0) })).toBe(true);
  });

  it('keeps a completed game with no completedAt (e.g. postponed/cancelled)', () => {
    expect(isRecentOrActive({ status: 'cancelled', completedAt: null })).toBe(true);
  });

  it('keeps a completed game finished within the last 7 days', () => {
    const twoDaysAgo = new Date(Date.now() - 2 * 24 * 60 * 60 * 1000);
    expect(isRecentOrActive({ status: 'completed', completedAt: twoDaysAgo })).toBe(true);
  });

  it('hides a completed game finished more than 7 days ago', () => {
    const eightDaysAgo = new Date(Date.now() - 8 * 24 * 60 * 60 * 1000);
    expect(isRecentOrActive({ status: 'completed', completedAt: eightDaysAgo })).toBe(false);
  });
});

describe('isPastDue — moves a never-started game from Upcoming to Past', () => {
  const today = new Date().toISOString().slice(0, 10);
  const yesterday = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString().slice(0, 10);
  const tomorrow = new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString().slice(0, 10);

  it('is false for an upcoming game scheduled today or later', () => {
    expect(isPastDue({ status: 'upcoming', date: today })).toBe(false);
    expect(isPastDue({ status: 'upcoming', date: tomorrow })).toBe(false);
  });

  it('is true once the scheduled day has fully passed and it was never started', () => {
    expect(isPastDue({ status: 'upcoming', date: yesterday })).toBe(true);
  });

  it('is false for a live or completed game, even with a past date — those have their own real status', () => {
    expect(isPastDue({ status: 'live', date: yesterday })).toBe(false);
    expect(isPastDue({ status: 'completed', date: yesterday })).toBe(false);
  });

  it('is false when there is no date at all', () => {
    expect(isPastDue({ status: 'upcoming', date: '' })).toBe(false);
  });
});

describe('isLiveOverdue — auto-suspend after 24h live', () => {
  it('is false for a non-live game', () => {
    expect(isLiveOverdue({ status: 'upcoming', liveStartedAt: new Date(Date.now() - 25 * 60 * 60 * 1000) })).toBe(false);
  });

  it('is false for a live game with no liveStartedAt yet (pre-existing doc)', () => {
    expect(isLiveOverdue({ status: 'live', liveStartedAt: null })).toBe(false);
  });

  it('is false for a live game under 24 hours old', () => {
    expect(isLiveOverdue({ status: 'live', liveStartedAt: new Date(Date.now() - 60 * 60 * 1000) })).toBe(false);
  });

  it('is true for a live game over 24 hours old', () => {
    expect(isLiveOverdue({ status: 'live', liveStartedAt: new Date(Date.now() - 25 * 60 * 60 * 1000) })).toBe(true);
  });
});

describe('generateAccessCode', () => {
  it('produces a 6-character uppercase alphanumeric code', () => {
    const code = generateAccessCode();
    expect(code).toMatch(/^[A-Z0-9]{6}$/);
  });

  it('is not the same on every call', () => {
    const codes = new Set(Array.from({ length: 20 }, generateAccessCode));
    expect(codes.size).toBeGreaterThan(1);
  });
});
