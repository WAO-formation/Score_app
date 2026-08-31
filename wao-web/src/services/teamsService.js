// teamsService.js
//
// Firestore-backed CRUD + live subscriptions for the Teams vertical, reusing
// the exact schema wao_mobile already reads/writes (see
// wao_mobile/lib/Model/teams_games/wao_team.dart,
// wao_mobile/lib/Model/teams_games/team/wao_player.dart and
// wao_mobile/lib/Model/teams_games/team/team_stat.dart) — nothing here
// redesigns that schema, it only adapts it to what wao-web's existing
// Teams/TeamDetails/CreateTeam UI expects (a capitalized display category,
// capitalized role labels, a flat `players` list instead of role-keyed id
// arrays, etc).
import {
  collection, doc, addDoc, updateDoc, deleteDoc, getDoc, setDoc, onSnapshot,
  query, orderBy, where, documentId, writeBatch,
  arrayUnion, arrayRemove, serverTimestamp, Timestamp,
} from 'firebase/firestore';
import { db } from '../lib/firebase';

const TEAMS = 'teams';
const PLAYERS = 'players';
const TEAM_STATS = 'teamStatistics';

// Mobile's WaoPlayer.role enum. Order here has no UI meaning — the web
// components keep their own hand-written dropdown order (which already
// lists Servitor before Sacrificer) so editing this array does not reorder
// any <select>.
export const ROSTER_ROLES = ['king', 'worker', 'protague', 'antague', 'warrior', 'sacrificer', 'servitor', 'substitute'];

// wao-web's existing UI (ROLE_STYLES / availableRoles in TeamDetails.jsx and
// CreateTeam.jsx) spells two of these "Protaque"/"Antaque" — a pre-existing
// UI typo relative to the mobile schema's "protague"/"antague". We don't
// touch the visible copy, just map both directions so writes land on the
// real enum values.
export const ROLE_TO_LABEL = {
  king: 'King', worker: 'Worker', protague: 'Protaque', antague: 'Antaque',
  warrior: 'Warrior', sacrificer: 'Sacrificer', servitor: 'Servitor', substitute: 'Substitute',
};
export const LABEL_TO_ROLE = Object.fromEntries(Object.entries(ROLE_TO_LABEL).map(([k, v]) => [v, k]));

const ROLE_TO_ROSTER_FIELD = Object.fromEntries(ROSTER_ROLES.map((r) => [r, `${r}Ids`]));

const CATEGORY_TO_LABEL = { senior: 'Senior', junior: 'Junior', youth: 'Youth' };
const capitalize = (s) => (s ? s.charAt(0).toUpperCase() + s.slice(1) : '');

const emptyRoster = () => ROSTER_ROLES.reduce((acc, r) => { acc[ROLE_TO_ROSTER_FIELD[r]] = []; return acc; }, {});

const initials = (name = '') => {
  const trimmed = name.trim();
  return trimmed ? trimmed.substring(0, 2).toUpperCase() : '??';
};

function docToTeam(id, data, statsData) {
  const roster = { ...emptyRoster(), ...(data.roster || {}) };
  return {
    id,
    name: data.name || '',
    // `category` stays lowercase everywhere it's written; this is only the
    // capitalized value the current UI displays/filters by.
    category: CATEGORY_TO_LABEL[data.category] || capitalize(data.category) || '',
    categoryValue: data.category || '',
    campusId: data.campusId || null,
    coach: data.coach || '',
    secretary: data.secretary || '',
    director: data.director || '',
    logoUrl: data.logoUrl || '',
    isTopTeam: !!data.isTopTeam,
    ranking: data.ranking ?? 0,
    roster,
    // Not part of WaoTeam in mobile — schemaless extra fields the web app
    // owns; mobile simply never reads them. `icon` falls back to
    // name-derived initials (the same convention used elsewhere, e.g.
    // matchesService-backed game cards) when no custom icon was saved.
    icon: data.icon || initials(data.name),
    description: data.description || '',
    founded: data.founded || '',
    gamesPlayed: statsData?.totalGamesPlayed ?? 0,
    createdAt: data.createdAt || null,
    updatedAt: data.updatedAt || null,
  };
}

function docToPlayer(id, data) {
  return {
    id,
    name: data.name || '',
    email: data.email || '',
    profileImageUrl: data.profileImageUrl || null,
    // `role` is the capitalized label the existing PlayerCard/ROLE_STYLES
    // expect; `roleValue` is the raw lowercase enum, kept around so
    // updatePlayer/removePlayerFromTeam know which roster array to touch.
    role: ROLE_TO_LABEL[data.role] || data.role || '',
    roleValue: data.role || '',
    status: data.status || 'active',
    currentTeamId: data.currentTeamId || null,
    currentTeamName: data.currentTeamName || null,
    gamesPlayed: data.gamesPlayed ?? 0,
    goalsScored: data.goalsScored ?? 0,
    assists: data.assists ?? 0,
    jerseyNumber: data.jerseyNumber ?? null,
    number: data.jerseyNumber ?? null, // alias matching the existing PlayerCard's `player.number`
    age: data.age ?? null,
  };
}

const emptyStats = (teamId) => ({
  teamId, totalGamesPlayed: 0, wins: 0, draws: 0, losses: 0,
  goalsScored: 0, goalsConceded: 0, activePlayers: 0, inactivePlayers: 0, totalFollowers: 0,
  recentGames: [], lastGameDate: null, updatedAt: null,
});

// ── Teams ───────────────────────────────────────────────────────────────

// `teamStatistics` is a small, bounded collection (one doc per team), so
// subscribing to the whole thing alongside `teams` and merging client-side
// is cheap and keeps gamesPlayed live without a query per row.
export function subscribeToTeams(onData, onError) {
  let teamsSnap = null;
  let statsById = {};

  const emit = () => {
    if (!teamsSnap) return;
    onData(teamsSnap.docs.map((d) => docToTeam(d.id, d.data(), statsById[d.id])));
  };

  const unsubTeams = onSnapshot(
    query(collection(db, TEAMS), orderBy('name')),
    (snap) => { teamsSnap = snap; emit(); },
    onError
  );
  const unsubStats = onSnapshot(
    collection(db, TEAM_STATS),
    (snap) => {
      statsById = {};
      snap.docs.forEach((d) => { statsById[d.id] = d.data(); });
      emit();
    },
    onError
  );

  return () => { unsubTeams(); unsubStats(); };
}

export function subscribeToTeam(id, onData, onError) {
  return onSnapshot(
    doc(db, TEAMS, id),
    (snap) => onData(snap.exists() ? docToTeam(snap.id, snap.data()) : null),
    onError
  );
}

export async function getTeam(id) {
  const snap = await getDoc(doc(db, TEAMS, id));
  return snap.exists() ? docToTeam(snap.id, snap.data()) : null;
}

export function subscribeToTeamStats(teamId, onData, onError) {
  return onSnapshot(
    doc(db, TEAM_STATS, teamId),
    (snap) => onData(snap.exists() ? { ...emptyStats(teamId), ...snap.data() } : emptyStats(teamId)),
    onError
  );
}

// `input.category` must already be the lowercase enum value
// ('senior'|'junior'|'youth') — callers convert from whatever label their
// form shows before calling this.
export async function createTeam(input) {
  const docRef = await addDoc(collection(db, TEAMS), {
    name: input.name || '',
    category: input.category || 'senior',
    campusId: input.campusId || null,
    coach: input.coach || '',
    secretary: input.secretary || '',
    director: input.director || '',
    logoUrl: input.logoUrl || '',
    isTopTeam: input.isTopTeam ?? false,
    ranking: input.ranking ?? 0,
    roster: emptyRoster(),
    icon: input.icon || '',
    description: input.description || '',
    founded: input.founded || '',
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });
  return docRef.id;
}

export async function updateTeam(id, patch) {
  await updateDoc(doc(db, TEAMS, id), { ...patch, updatedAt: serverTimestamp() });
}

// Only removes the team doc itself. teamStatistics/{id} and any players
// still pointing at this team via currentTeamId are left alone — there's no
// UI surface today for reassigning/cleaning those up, and silently cascading
// deletes across collections felt riskier than leaving a now-orphaned
// pointer (mobile already treats a stale currentTeamId as "no longer on a
// roster" via the team's own roster arrays, not via this field).
export async function deleteTeam(id) {
  await deleteDoc(doc(db, TEAMS, id));
}

// ── Match results ───────────────────────────────────────────────────────

// Mirrors wao_mobile's TeamService.updateTeamStatisticsAfterGame (see
// wao_mobile/lib/Model/teams_games/team/team_stat.dart for the exact
// GameResult/TeamStatistics shape) — that method is only ever called from
// the Flutter app's own match-ending flow, so a game ended from wao-web
// left both teams' wins/losses/recentGames stale until this existed.
// Not transactional, same as the Dart original: a read followed by a set.
async function bumpTeamStats(teamId, { gameId, opponentTeamId, opponentTeamName, teamScore, opponentScore, isHomeGame, playedAt }) {
  const ref = doc(db, TEAM_STATS, teamId);
  const snap = await getDoc(ref);
  const current = snap.exists() ? snap.data() : {};

  const isWin = teamScore > opponentScore;
  const isDraw = teamScore === opponentScore;

  // serverTimestamp() can't be used inside an array element, so recentGames
  // entries get a concrete Timestamp instead (matches Dart's DateTime.now()
  // capture-at-call-time semantics).
  const recentGames = [
    { gameId, opponentTeamId, opponentTeamName, teamScore, opponentScore, playedAt, isHomeGame },
    ...(current.recentGames || []),
  ].slice(0, 10);

  await setDoc(ref, {
    teamId,
    totalGamesPlayed: (current.totalGamesPlayed || 0) + 1,
    wins: (current.wins || 0) + (isWin ? 1 : 0),
    draws: (current.draws || 0) + (isDraw ? 1 : 0),
    losses: (current.losses || 0) + (!isWin && !isDraw ? 1 : 0),
    goalsScored: (current.goalsScored || 0) + teamScore,
    goalsConceded: (current.goalsConceded || 0) + opponentScore,
    activePlayers: current.activePlayers || 0,
    inactivePlayers: current.inactivePlayers || 0,
    totalFollowers: current.totalFollowers || 0,
    recentGames,
    lastGameDate: playedAt,
    updatedAt: serverTimestamp(),
  });
}

// Call once, right when a match flips to completed. Silently no-ops if
// either team id is missing (e.g. a legacy/malformed match doc) rather than
// throwing — a missing stats update shouldn't block the game from ending.
export async function recordGameResult({ gameId, homeTeamId, awayTeamId, homeTeam, awayTeam, homeScore, awayScore }) {
  if (!homeTeamId || !awayTeamId) return;
  const playedAt = Timestamp.now();
  await Promise.all([
    bumpTeamStats(homeTeamId, {
      gameId, opponentTeamId: awayTeamId, opponentTeamName: awayTeam,
      teamScore: homeScore ?? 0, opponentScore: awayScore ?? 0, isHomeGame: true, playedAt,
    }),
    bumpTeamStats(awayTeamId, {
      gameId, opponentTeamId: homeTeamId, opponentTeamName: homeTeam,
      teamScore: awayScore ?? 0, opponentScore: homeScore ?? 0, isHomeGame: false, playedAt,
    }),
  ]);
}

// ── Players / roster ───────────────────────────────────────────────────

function chunk(arr, size) {
  const out = [];
  for (let i = 0; i < arr.length; i += size) out.push(arr.slice(i, i + size));
  return out;
}

// Firestore's `in` operator caps at 10 values; a team's roster maxes out at
// 12 (7 starters + 5 subs), so this is at most 2 chunks. Subscribes live to
// each chunk so edits to a player doc (name, stats, etc.) reflect instantly.
export function subscribeToPlayersByIds(ids, onData, onError) {
  const uniqueIds = [...new Set(ids)].filter(Boolean);
  if (uniqueIds.length === 0) { onData([]); return () => {}; }

  const chunks = chunk(uniqueIds, 10);
  const cache = {};
  const unsubs = chunks.map((c, idx) =>
    onSnapshot(
      query(collection(db, PLAYERS), where(documentId(), 'in', c)),
      (snap) => {
        cache[idx] = snap.docs.map((d) => docToPlayer(d.id, d.data()));
        onData(Object.values(cache).flat());
      },
      onError
    )
  );
  return () => unsubs.forEach((u) => u());
}

// Creates a real `players` doc and arrayUnions its id into the team's
// roster.{role}Ids array in one batch. `playerInput.role` may be either the
// capitalized UI label or the raw lowercase value.
export async function addPlayerToTeam(teamId, playerInput) {
  const roleValue = LABEL_TO_ROLE[playerInput.role] || playerInput.role;
  const rosterField = ROLE_TO_ROSTER_FIELD[roleValue];
  if (!rosterField) throw new Error(`Unknown player role: ${playerInput.role}`);

  const playerRef = doc(collection(db, PLAYERS));
  const teamRef = doc(db, TEAMS, teamId);
  const toNumberOrNull = (v) => (v === '' || v === undefined || v === null ? null : Number(v));

  const batch = writeBatch(db);
  batch.set(playerRef, {
    name: playerInput.name || '',
    email: playerInput.email || '',
    profileImageUrl: playerInput.profileImageUrl || null,
    role: roleValue,
    status: 'active',
    currentTeamId: teamId,
    currentTeamName: playerInput.teamName || '',
    joinedTeamAt: serverTimestamp(),
    gamesPlayed: 0,
    goalsScored: 0,
    assists: 0,
    jerseyNumber: toNumberOrNull(playerInput.number ?? playerInput.jerseyNumber),
    age: toNumberOrNull(playerInput.age),
    createdAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });
  batch.update(teamRef, {
    [`roster.${rosterField}`]: arrayUnion(playerRef.id),
    updatedAt: serverTimestamp(),
  });
  await batch.commit();
  return playerRef.id;
}

// Plain field edits (name/number/age/status/etc). Pass `{ teamId,
// previousRoleValue }` when `patch.role` is changing so the player also
// moves from its old roster.{role}Ids array to the new one — without that
// context this only updates the player doc's `role` field, which would
// desync it from the team's roster arrays.
export async function updatePlayer(playerId, patch, { teamId, previousRoleValue } = {}) {
  const fsPatch = { updatedAt: serverTimestamp() };
  if (patch.name !== undefined) fsPatch.name = patch.name;
  if (patch.email !== undefined) fsPatch.email = patch.email;
  if (patch.status !== undefined) fsPatch.status = patch.status;
  if (patch.age !== undefined) fsPatch.age = patch.age === '' || patch.age == null ? null : Number(patch.age);
  const numberPatch = patch.number ?? patch.jerseyNumber;
  if (numberPatch !== undefined) fsPatch.jerseyNumber = numberPatch === '' || numberPatch == null ? null : Number(numberPatch);

  let newRoleValue;
  if (patch.role !== undefined) {
    newRoleValue = LABEL_TO_ROLE[patch.role] || patch.role;
    fsPatch.role = newRoleValue;
  }

  if (newRoleValue && teamId && previousRoleValue && newRoleValue !== previousRoleValue) {
    const batch = writeBatch(db);
    batch.update(doc(db, PLAYERS, playerId), fsPatch);
    batch.update(doc(db, TEAMS, teamId), {
      [`roster.${ROLE_TO_ROSTER_FIELD[previousRoleValue]}`]: arrayRemove(playerId),
      [`roster.${ROLE_TO_ROSTER_FIELD[newRoleValue]}`]: arrayUnion(playerId),
      updatedAt: serverTimestamp(),
    });
    await batch.commit();
  } else {
    await updateDoc(doc(db, PLAYERS, playerId), fsPatch);
  }
}

// Removes the id from the team's roster array and deletes the player doc
// outright. These are dedicated team-roster players in this app's flow (not
// self-registered app users), and the current UI's "Remove Player" action
// has always meant "this person is gone" rather than "unassign but keep
// their record" — deleting matches that semantics. `role` may be the
// capitalized label or the raw lowercase value.
export async function removePlayerFromTeam(teamId, playerId, role) {
  const roleValue = LABEL_TO_ROLE[role] || role;
  const rosterField = ROLE_TO_ROSTER_FIELD[roleValue];

  const batch = writeBatch(db);
  if (rosterField) {
    batch.update(doc(db, TEAMS, teamId), {
      [`roster.${rosterField}`]: arrayRemove(playerId),
      updatedAt: serverTimestamp(),
    });
  }
  batch.delete(doc(db, PLAYERS, playerId));
  await batch.commit();
}
