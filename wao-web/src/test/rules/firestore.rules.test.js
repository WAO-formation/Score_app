import { readFileSync } from 'fs';
import { fileURLToPath } from 'url';
import path from 'path';
import { beforeAll, afterAll, beforeEach, describe, it } from 'vitest';
import {
  initializeTestEnvironment, assertSucceeds, assertFails,
} from '@firebase/rules-unit-testing';
import {
  doc, getDoc, getDocs, query, where, setDoc, updateDoc, deleteDoc, addDoc, collection, serverTimestamp, Timestamp,
} from 'firebase/firestore';

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const RULES_PATH = path.resolve(__dirname, '../../../../wao_mobile/firestore.rules');

const [emuHost, emuPort] = (process.env.FIRESTORE_EMULATOR_HOST || 'localhost:8085').split(':');

let testEnv;

const ADMIN = 'admin-uid';
const MOD_A = 'mod-a-uid';     // assigned to match1
const MOD_B = 'mod-b-uid';     // NOT assigned to match1
const JUDGE_A = 'judge-a-uid'; // assigned to match1's judges/judgeUids
const JUDGE_B = 'judge-b-uid'; // NOT assigned to match1
const FAN = 'fan-uid';
const COACH_A = 'coach-a-uid'; // coach of team1

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: 'demo-wao-rules',
    firestore: {
      rules: readFileSync(RULES_PATH, 'utf8'),
      host: emuHost,
      port: Number(emuPort),
    },
  });
});

afterAll(async () => { await testEnv.cleanup(); });

beforeEach(async () => {
  await testEnv.clearFirestore();
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'users', ADMIN), { role: 'admin' });
    await setDoc(doc(db, 'users', MOD_A), { role: 'moderator' });
    await setDoc(doc(db, 'users', MOD_B), { role: 'moderator' });
    await setDoc(doc(db, 'users', JUDGE_A), { role: 'official' });
    await setDoc(doc(db, 'users', JUDGE_B), { role: 'official' });
    await setDoc(doc(db, 'users', FAN), { role: 'fan' });
    await setDoc(doc(db, 'users', COACH_A), { role: 'coach', teamId: 'team1' });
  });
});

const asAdmin = () => testEnv.authenticatedContext(ADMIN).firestore();
const asModA = () => testEnv.authenticatedContext(MOD_A).firestore();
const asModB = () => testEnv.authenticatedContext(MOD_B).firestore();
const asJudgeA = () => testEnv.authenticatedContext(JUDGE_A).firestore();
const asJudgeB = () => testEnv.authenticatedContext(JUDGE_B).firestore();
const asFan = () => testEnv.authenticatedContext(FAN).firestore();
const asCoachA = () => testEnv.authenticatedContext(COACH_A).firestore();
const unauth = () => testEnv.unauthenticatedContext().firestore();

// Seeds match1 with moderatorUid = MOD_A and JUDGE_A as its sole judge,
// updatedAt `secondsAgo` seconds in the past (bypassing rules) so
// cooldown-dependent tests can control it.
async function seedMatch(secondsAgo = 10, overrides = {}) {
  await testEnv.withSecurityRulesDisabled(async (ctx) => {
    await setDoc(doc(ctx.firestore(), 'matches', 'match1'), {
      teamAId: 't1', teamBId: 't2', teamAName: 'Home', teamBName: 'Away',
      scoreA: 0, scoreB: 0, status: 'live',
      moderatorUid: MOD_A, moderatorName: 'Mod A',
      judges: [{ uid: JUDGE_A, name: 'Judge A' }], judgeUids: [JUDGE_A],
      teamAJudges: 0, teamBJudges: 0,
      quarters: {}, fouls: { home: [], away: [] }, events: [],
      currentQuarter: 'Q1', timeRemaining: '17:00', isPlaying: false,
      updatedAt: Timestamp.fromMillis(Date.now() - secondsAgo * 1000),
      ...overrides,
    });
  });
}

describe('matches — create', () => {
  it('rejects a fan (non-official) creating a match', async () => {
    await assertFails(addDoc(collection(asFan(), 'matches'), {
      scoreA: 0, scoreB: 0, moderatorUid: MOD_A, updatedAt: serverTimestamp(),
    }));
  });

  it('rejects a moderator creating a match — only admins assign moderators/judges to new games', async () => {
    await assertFails(addDoc(collection(asModA(), 'matches'), {
      scoreA: 0, scoreB: 0, moderatorUid: MOD_A, updatedAt: serverTimestamp(),
    }));
  });

  it('rejects a judge creating a match', async () => {
    await assertFails(addDoc(collection(asJudgeA(), 'matches'), {
      scoreA: 0, scoreB: 0, moderatorUid: MOD_A, updatedAt: serverTimestamp(),
    }));
  });

  it('allows an admin to create a valid match doc', async () => {
    await assertSucceeds(addDoc(collection(asAdmin(), 'matches'), {
      scoreA: 0, scoreB: 0, moderatorUid: MOD_A, updatedAt: serverTimestamp(),
    }));
  });

  it('rejects a create with a non-zero starting score', async () => {
    await assertFails(addDoc(collection(asAdmin(), 'matches'), {
      scoreA: 1, scoreB: 0, moderatorUid: MOD_A, updatedAt: serverTimestamp(),
    }));
  });

  it('rejects a create missing moderatorUid', async () => {
    await assertFails(addDoc(collection(asAdmin(), 'matches'), {
      scoreA: 0, scoreB: 0, updatedAt: serverTimestamp(),
    }));
  });
});

describe('matches — update: assigned-moderator enforcement', () => {
  it('the assigned moderator can update scoring fields on their own match', async () => {
    await seedMatch();
    await assertSucceeds(updateDoc(doc(asModA(), 'matches', 'match1'), {
      scoreA: 5, updatedAt: serverTimestamp(),
    }));
  });

  it('admin can update any match regardless of moderatorUid', async () => {
    await seedMatch();
    await assertSucceeds(updateDoc(doc(asAdmin(), 'matches', 'match1'), {
      scoreA: 5, updatedAt: serverTimestamp(),
    }));
  });

  it('a DIFFERENT moderator cannot update a match they were not assigned to', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asModB(), 'matches', 'match1'), {
      scoreA: 5, updatedAt: serverTimestamp(),
    }));
  });

  it('a fan cannot update scoring fields at all', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asFan(), 'matches', 'match1'), {
      scoreA: 5, updatedAt: serverTimestamp(),
    }));
  });

  it('an unauthenticated client cannot update', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(unauth(), 'matches', 'match1'), {
      scoreA: 5, updatedAt: serverTimestamp(),
    }));
  });
});

describe('matches — update: field whitelist and score bounds', () => {
  it('rejects sneaking an unlisted field in alongside an allowed one', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asModA(), 'matches', 'match1'), {
      scoreA: 5, teamAId: 'someone-elses-team', updatedAt: serverTimestamp(),
    }));
  });

  it('allows status + statusReason together (Management > Games postpone/suspend/cancel flow)', async () => {
    await seedMatch();
    await assertSucceeds(updateDoc(doc(asModA(), 'matches', 'match1'), {
      status: 'postponed', statusReason: 'Rain delay', updatedAt: serverTimestamp(),
    }));
  });

  it('allows status + statusReason + previousStatus together (suspend, so Unsuspend can restore it)', async () => {
    await seedMatch();
    await assertSucceeds(updateDoc(doc(asModA(), 'matches', 'match1'), {
      status: 'suspended', statusReason: 'Crowd incident', previousStatus: 'upcoming', updatedAt: serverTimestamp(),
    }));
  });

  it('allows resuming a postponed game (status back to upcoming + new startTime, previousStatus cleared)', async () => {
    await seedMatch();
    await assertSucceeds(updateDoc(doc(asModA(), 'matches', 'match1'), {
      status: 'upcoming', statusReason: '', previousStatus: '',
      startTime: Timestamp.fromMillis(Date.now() + 86400000), updatedAt: serverTimestamp(),
    }));
  });

  it('allows the assigned moderator to reschedule a past-due game (new startTime)', async () => {
    await seedMatch();
    await assertSucceeds(updateDoc(doc(asModA(), 'matches', 'match1'), {
      startTime: Timestamp.fromMillis(Date.now() + 86400000), updatedAt: serverTimestamp(),
    }));
  });

  it('allows updating venue alongside a reschedule', async () => {
    await seedMatch();
    await assertSucceeds(updateDoc(doc(asModA(), 'matches', 'match1'), {
      venue: 'New Venue', updatedAt: serverTimestamp(),
    }));
  });

  it('rejects a negative score', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asModA(), 'matches', 'match1'), {
      scoreA: -1, updatedAt: serverTimestamp(),
    }));
  });

  it('rejects a score above the 999 cap', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asModA(), 'matches', 'match1'), {
      scoreA: 1000, updatedAt: serverTimestamp(),
    }));
  });

  it('rejects an update that forges a non-server updatedAt to dodge the cooldown', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asModA(), 'matches', 'match1'), {
      scoreA: 5, updatedAt: Timestamp.now(),
    }));
  });
});

describe('matches — update: per-document cooldown', () => {
  it('rejects a second scoring write inside the 2s cooldown window', async () => {
    await seedMatch(0); // updatedAt = now
    await assertFails(updateDoc(doc(asModA(), 'matches', 'match1'), {
      scoreA: 5, updatedAt: serverTimestamp(),
    }));
  });

  it('allows a scoring write once the cooldown has elapsed', async () => {
    await seedMatch(3); // updatedAt = 3s ago, past the 2s cooldown
    await assertSucceeds(updateDoc(doc(asModA(), 'matches', 'match1'), {
      scoreA: 5, updatedAt: serverTimestamp(),
    }));
  });
});

describe('matches — update: judge-tier Judges-score grant', () => {
  it('the assigned judge can grant teamAJudges/teamBJudges while the match is live', async () => {
    await seedMatch();
    await assertSucceeds(updateDoc(doc(asJudgeA(), 'matches', 'match1'), {
      teamAJudges: 3, teamBJudges: 1, updatedAt: serverTimestamp(),
    }));
  });

  it('an official NOT assigned as a judge on this match cannot grant a score', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asJudgeB(), 'matches', 'match1'), {
      teamAJudges: 3, updatedAt: serverTimestamp(),
    }));
  });

  it('the assigned judge cannot grant a score while the match is not live', async () => {
    await seedMatch(10, { status: 'upcoming' });
    await assertFails(updateDoc(doc(asJudgeA(), 'matches', 'match1'), {
      teamAJudges: 3, updatedAt: serverTimestamp(),
    }));
  });

  it('the assigned judge cannot piggyback a different field onto a score grant', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asJudgeA(), 'matches', 'match1'), {
      teamAJudges: 3, scoreA: 99, updatedAt: serverTimestamp(),
    }));
  });

  it('the assigned judge cannot touch scoreA/scoreB directly', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asJudgeA(), 'matches', 'match1'), {
      scoreA: 5, updatedAt: serverTimestamp(),
    }));
  });

  it('the 2s per-document cooldown applies to judge writes too', async () => {
    await seedMatch(0); // updatedAt = now
    await assertFails(updateDoc(doc(asJudgeA(), 'matches', 'match1'), {
      teamAJudges: 3, updatedAt: serverTimestamp(),
    }));
  });
});

describe('matches — update: isFavorite self-service carve-out', () => {
  it('any signed-in user (even a fan) may toggle isFavorite alone', async () => {
    await seedMatch();
    await assertSucceeds(updateDoc(doc(asFan(), 'matches', 'match1'), { isFavorite: true }));
  });

  it('cannot piggyback a scoring change onto an isFavorite update', async () => {
    await seedMatch();
    await assertFails(updateDoc(doc(asFan(), 'matches', 'match1'), { isFavorite: true, scoreA: 99 }));
  });
});

describe('matches — delete', () => {
  it('rejects delete by a fan', async () => {
    await seedMatch();
    await assertFails(deleteDoc(doc(asFan(), 'matches', 'match1')));
  });

  it('allows delete by any official-tier account', async () => {
    await seedMatch();
    await assertSucceeds(deleteDoc(doc(asModA(), 'matches', 'match1')));
  });
});

describe('matches/private/access — accessCode visibility', () => {
  async function seedAccessCode() {
    await seedMatch();
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'matches', 'match1', 'private', 'access'), { accessCode: 'ABC123' });
    });
  }

  it('the assigned moderator can read the access code', async () => {
    await seedAccessCode();
    await assertSucceeds(getDoc(doc(asModA(), 'matches', 'match1', 'private', 'access')));
  });

  it('admin can read the access code for any match', async () => {
    await seedAccessCode();
    await assertSucceeds(getDoc(doc(asAdmin(), 'matches', 'match1', 'private', 'access')));
  });

  it('a different moderator cannot read the access code', async () => {
    await seedAccessCode();
    await assertFails(getDoc(doc(asModB(), 'matches', 'match1', 'private', 'access')));
  });
});

describe('users — read boundaries', () => {
  it('a moderator can read their own profile', async () => {
    await assertSucceeds(getDoc(doc(asModA(), 'users', MOD_A)));
  });

  it('a fan cannot read another user\'s profile', async () => {
    await assertFails(getDoc(doc(asFan(), 'users', MOD_A)));
  });

  it('admin can read any user\'s profile', async () => {
    await assertSucceeds(getDoc(doc(asAdmin(), 'users', FAN)));
  });

  it('a moderator can read another user\'s profile (needed to look up moderators/judges when creating a game)', async () => {
    await assertSucceeds(getDoc(doc(asModB(), 'users', MOD_A)));
  });

  it('a moderator can run the role-filtered query CreateGamePage uses to populate the moderator picker', async () => {
    await assertSucceeds(getDocs(query(collection(asModA(), 'users'), where('role', '==', 'moderator'))));
  });

  it('a fan cannot run that same role-filtered query', async () => {
    await assertFails(getDocs(query(collection(asFan(), 'users'), where('role', '==', 'moderator'))));
  });
});

describe('teamStatistics — write boundaries', () => {
  async function seedStats() {
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'teamStatistics', 'team1'), {
        wins: 0, losses: 0, draws: 0, totalFollowers: 0, updatedAt: Timestamp.now(),
      });
    });
  }

  it('an official-tier account can write win/loss stats (the wao-web game-end path)', async () => {
    await seedStats();
    await assertSucceeds(updateDoc(doc(asModA(), 'teamStatistics', 'team1'), { wins: 1, updatedAt: serverTimestamp() }));
  });

  it('a fan cannot hand-edit win/loss counts', async () => {
    await seedStats();
    await assertFails(updateDoc(doc(asFan(), 'teamStatistics', 'team1'), { wins: 99, updatedAt: serverTimestamp() }));
  });

  it('a fan CAN update totalFollowers alone (following a team)', async () => {
    await seedStats();
    await assertSucceeds(updateDoc(doc(asFan(), 'teamStatistics', 'team1'), { totalFollowers: 1, updatedAt: serverTimestamp() }));
  });

  it('a fan cannot piggyback a win-count change onto a totalFollowers update', async () => {
    await seedStats();
    await assertFails(updateDoc(doc(asFan(), 'teamStatistics', 'team1'), { totalFollowers: 1, wins: 99, updatedAt: serverTimestamp() }));
  });
});

describe('teams / players — CRUD boundaries', () => {
  it('any signed-in user can read teams and players', async () => {
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'teams', 'team1'), { name: 'Home FC' });
    });
    const { getDoc } = await import('firebase/firestore');
    await assertSucceeds(getDoc(doc(asFan(), 'teams', 'team1')));
  });

  it('a fan cannot create a team', async () => {
    await assertFails(setDoc(doc(asFan(), 'teams', 'team2'), { name: 'Fan Team' }));
  });

  it('a moderator can create a team', async () => {
    await assertSucceeds(setDoc(doc(asModA(), 'teams', 'team2'), { name: 'New Team' }));
  });

  it('a fan cannot create a player', async () => {
    await assertFails(setDoc(doc(asFan(), 'players', 'p1'), { name: 'New Player' }));
  });
});

describe('teams — roster size cap (12 players)', () => {
  const emptyRoster = () => ({
    kingIds: [], workerIds: [], protagueIds: [], antagueIds: [],
    warriorIds: [], sacrificerIds: [], servitorIds: [], substituteIds: [],
  });
  const rosterOfSize = (n) => ({ ...emptyRoster(), workerIds: Array.from({ length: n }, (_, i) => `p${i}`) });

  beforeEach(async () => {
    await testEnv.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'teams', 'team1'), {
        name: 'Team One', roster: emptyRoster(), updatedAt: serverTimestamp(),
      });
    });
  });

  it('a coach can write a roster at exactly the 12-player cap', async () => {
    await assertSucceeds(updateDoc(doc(asCoachA(), 'teams', 'team1'), {
      roster: rosterOfSize(12), updatedAt: serverTimestamp(),
    }));
  });

  it('a coach cannot write a roster of 13 players', async () => {
    await assertFails(updateDoc(doc(asCoachA(), 'teams', 'team1'), {
      roster: rosterOfSize(13), updatedAt: serverTimestamp(),
    }));
  });

  it('the cap applies to admins/officials too, not just coaches', async () => {
    await assertFails(updateDoc(doc(asAdmin(), 'teams', 'team1'), {
      roster: rosterOfSize(13), updatedAt: serverTimestamp(),
    }));
  });
});
