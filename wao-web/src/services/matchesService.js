// matchesService.js
//
// Firestore keeps wao_mobile's existing `matches` field names (teamAId/
// teamBId, scoreA/scoreB, flat teamAKingdom/teamBKingdom/... category
// fields — see wao_mobile/lib/Model/teams_games/wao_match.dart) since the
// Flutter app already reads/writes those. wao-web's UI was built around a
// home/away vocabulary before this rewrite — everything below translates
// between the two so GameCard/GameDetails/LiveGame/CreateGame keep working
// against `game.homeTeam` / `game.scoring.kingdom.home` etc. without every
// consumer needing to learn Firestore's on-disk shape.
import {
  collection, doc, addDoc, updateDoc, deleteDoc, setDoc, onSnapshot,
  query, orderBy, limit as fsLimit, serverTimestamp, Timestamp,
} from 'firebase/firestore';
import { db } from '../lib/firebase';

const MATCHES = 'matches';
const RECENT_LIMIT = 300;

// Mobile calls the terminal state "finished"; web's UI (built first) calls
// it "completed" everywhere. Translating here means neither side has to
// change its existing vocabulary.
const STATUS_FROM_FIRESTORE = { finished: 'completed' };
const STATUS_TO_FIRESTORE = { completed: 'finished' };
const toAppStatus = (s) => STATUS_FROM_FIRESTORE[s] || s || 'upcoming';
const toFirestoreStatus = (s) => STATUS_TO_FIRESTORE[s] || s || 'upcoming';

const tsToDate = (ts) => {
  if (!ts) return null;
  if (typeof ts.toDate === 'function') return ts.toDate();
  return ts instanceof Date ? ts : null;
};

export const emptyQuarters = () => ({
  q1: { home: 0, away: 0 }, q2: { home: 0, away: 0 },
  q3: { home: 0, away: 0 }, q4: { home: 0, away: 0 },
});
export const emptyScoring = () => ({
  kingdom: { home: 0, away: 0 }, workout: { home: 0, away: 0 },
  goalSetting: { home: 0, away: 0 }, judges: { home: 0, away: 0 },
});
export const emptyFouls = () => ({ home: [], away: [] });

function docToGame(id, data) {
  const startTime = tsToDate(data.startTime);
  return {
    id,
    homeTeamId: data.teamAId || '',
    awayTeamId: data.teamBId || '',
    homeTeam: data.teamAName || '',
    awayTeam: data.teamBName || '',
    homeScore: data.scoreA ?? 0,
    awayScore: data.scoreB ?? 0,
    status: toAppStatus(data.status),
    statusReason: data.statusReason || '',
    startTime,
    date: startTime ? startTime.toISOString().slice(0, 10) : '',
    time: startTime
      ? `${String(startTime.getHours()).padStart(2, '0')}:${String(startTime.getMinutes()).padStart(2, '0')}`
      : '',
    venue: data.venue || '',
    championshipId: data.championshipId || '',
    championship: data.championshipName || '',
    moderatorUid: data.moderatorUid || '',
    moderatorName: data.moderatorName || '',
    judges: data.judges || [],
    currentQuarter: data.currentQuarter || 'Q1',
    timeRemaining: data.timeRemaining || '17:00',
    isPlaying: data.isPlaying ?? false,
    quarters: data.quarters || emptyQuarters(),
    scoring: {
      kingdom: { home: data.teamAKingdom ?? 0, away: data.teamBKingdom ?? 0 },
      workout: { home: data.teamAWorkout ?? 0, away: data.teamBWorkout ?? 0 },
      goalSetting: { home: data.teamAGoalSetting ?? 0, away: data.teamBGoalSetting ?? 0 },
      judges: { home: data.teamAJudges ?? 0, away: data.teamBJudges ?? 0 },
    },
    fouls: data.fouls || emptyFouls(),
    events: data.events || [],
    completedAt: tsToDate(data.completedAt),
  };
}

export function subscribeToMatches(onData, onError) {
  const q = query(collection(db, MATCHES), orderBy('startTime', 'desc'), fsLimit(RECENT_LIMIT));
  return onSnapshot(
    q,
    (snap) => onData(snap.docs.map((d) => docToGame(d.id, d.data()))),
    onError
  );
}

export async function createMatch(input) {
  const startTime = input.startTime instanceof Date
    ? input.startTime
    : new Date(`${input.date}T${input.time}`);

  const docRef = await addDoc(collection(db, MATCHES), {
    teamAId: input.homeTeamId,
    teamBId: input.awayTeamId,
    teamAName: input.homeTeam,
    teamBName: input.awayTeam,
    scoreA: 0,
    scoreB: 0,
    status: 'upcoming',
    type: input.championshipId ? 'championship' : 'friendly',
    startTime: Timestamp.fromDate(startTime),
    venue: input.venue,
    championshipId: input.championshipId || null,
    championshipName: input.championship || '',
    moderatorUid: input.moderatorUid,
    moderatorName: input.moderatorName || '',
    judges: input.judges || [],
    teamAKingdom: 0, teamBKingdom: 0,
    teamAWorkout: 0, teamBWorkout: 0,
    teamAGoalSetting: 0, teamBGoalSetting: 0,
    teamAJudges: 0, teamBJudges: 0,
    quarters: emptyQuarters(),
    fouls: emptyFouls(),
    events: [],
    currentQuarter: 'Q1',
    timeRemaining: '17:00',
    isPlaying: false,
    isFavorite: false,
    updatedAt: serverTimestamp(),
  });

  if (input.accessCode) {
    await setDoc(doc(db, MATCHES, docRef.id, 'private', 'access'), {
      accessCode: input.accessCode,
    });
  }
  return docRef.id;
}

// Translates a partial app-shape patch (as produced by useGameSimulation's
// addScore/addFoul/advanceQuarter and GamesManagement's status changes)
// into the Firestore field names the rules' update allow-list expects.
const PATCH_MAPPERS = {
  status: (v) => {
    const fsStatus = toFirestoreStatus(v);
    return fsStatus === 'finished'
      ? { status: fsStatus, completedAt: serverTimestamp() }
      : { status: fsStatus };
  },
  statusReason: (v) => ({ statusReason: v }),
  homeScore: (v) => ({ scoreA: v }),
  awayScore: (v) => ({ scoreB: v }),
  quarters: (v) => ({ quarters: v }),
  fouls: (v) => ({ fouls: v }),
  events: (v) => ({ events: v }),
  isPlaying: (v) => ({ isPlaying: v }),
  currentQuarter: (v) => ({ currentQuarter: v }),
  timeRemaining: (v) => ({ timeRemaining: v }),
  moderatorUid: (v) => ({ moderatorUid: v }),
  moderatorName: (v) => ({ moderatorName: v }),
  judges: (v) => ({ judges: v }),
  venue: (v) => ({ venue: v }),
  championship: (v) => ({ championshipName: v }),
  scoring: (v) => ({
    teamAKingdom: v.kingdom.home, teamBKingdom: v.kingdom.away,
    teamAWorkout: v.workout.home, teamBWorkout: v.workout.away,
    teamAGoalSetting: v.goalSetting.home, teamBGoalSetting: v.goalSetting.away,
    teamAJudges: v.judges.home, teamBJudges: v.judges.away,
  }),
};

export function toFirestorePatch(appPatch) {
  const patch = {};
  Object.entries(appPatch).forEach(([key, value]) => {
    const mapper = PATCH_MAPPERS[key];
    if (mapper) Object.assign(patch, mapper(value));
  });
  patch.updatedAt = serverTimestamp();
  return patch;
}

export async function updateMatch(id, appPatch) {
  await updateDoc(doc(db, MATCHES, id), toFirestorePatch(appPatch));
}

export async function deleteMatch(id) {
  await deleteDoc(doc(db, MATCHES, id));
}

// Access code lives in a private subcollection (see firestore.rules) so a
// plain `matches` read can never see it — only an admin or the specific
// moderator assigned to this match can read this subdoc.
export function subscribeToAccessCode(matchId, onData, onError) {
  return onSnapshot(
    doc(db, MATCHES, matchId, 'private', 'access'),
    (snap) => onData(snap.exists() ? snap.data().accessCode : null),
    onError
  );
}

export const generateAccessCode = () => Math.random().toString(36).substring(2, 8).toUpperCase();

// "We can't start the game till it's the day and time" — gate on the exact
// scheduled timestamp, not just the calendar date.
export const canStartGame = (game) => !!game.startTime && Date.now() >= game.startTime.getTime();

// True once the scheduled game DAY has fully gone by (not just the exact
// kickoff time) and nobody ever started it — status is still 'upcoming'.
// Purely a display classification: the Firestore status is left alone (an
// admin can still manually start/postpone/cancel it), this just moves it
// out of the "Upcoming" view into "Past" so stale games don't pile up next
// to real upcoming fixtures. `date` is the same `YYYY-MM-DD` (UTC-derived)
// string docToGame already exposes, so today's cutoff uses the same basis.
export const isPastDue = (game) =>
  game.status === 'upcoming' && !!game.date && game.date < new Date().toISOString().slice(0, 10);

// Main Games list keeps a completed game visible for 7 days after it was
// marked finished; after that it's still fully queryable, just no longer
// surfaced there — Management > Games shows the full history, unfiltered.
const ARCHIVE_WINDOW_MS = 7 * 24 * 60 * 60 * 1000;
export const isRecentOrActive = (game) => {
  if (game.status === 'upcoming' || game.status === 'live') return true;
  if (!game.completedAt) return true; // no timestamp yet (e.g. postponed/cancelled) — don't hide by accident
  return Date.now() - game.completedAt.getTime() <= ARCHIVE_WINDOW_MS;
};
