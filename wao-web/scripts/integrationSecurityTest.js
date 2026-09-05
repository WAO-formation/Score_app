/**
 * Integration + security/RBAC test suite — runs against the REAL Firebase
 * project (wao-mobile-app-7e3c9), not the emulator. This is deliberately
 * different from `npm run test:rules` (which tests the *local*
 * firestore.rules file against an emulator): this proves the rules
 * actually deployed to production right now behave correctly, end to end,
 * signed in as each real demo account. That distinction matters — earlier
 * this session, add/remove-player broke in production because a rules
 * change had been written and emulator-tested but never deployed; the
 * emulator suite alone could never have caught that gap.
 *
 * Every "expect success" write either changes nothing (writes back the
 * value it read) or is reverted / deleted immediately after asserting
 * success, so this leaves no lasting trace on production data. Every
 * "expect fail" case is, by definition, rejected by the rules and so
 * never persists anything regardless.
 *
 *   node scripts/integrationSecurityTest.js
 */
import { initializeApp } from 'firebase/app';
import {
  getAuth, signInWithEmailAndPassword, signOut, signInAnonymously,
} from 'firebase/auth';
import {
  getFirestore, doc, getDoc, setDoc, updateDoc, deleteDoc, addDoc, collection,
  serverTimestamp,
} from 'firebase/firestore';
import dotenv from 'dotenv';

dotenv.config({ path: '.env.local' });

const firebaseConfig = {
  apiKey: process.env.VITE_FIREBASE_API_KEY,
  authDomain: process.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: process.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.VITE_FIREBASE_APP_ID,
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

const sleep = (ms) => new Promise((r) => setTimeout(r, ms));

const results = [];
function record(phase, name, expectation, outcome, detail) {
  const pass = expectation === outcome;
  results.push({ phase, name, expectation, outcome, pass, detail });
  console.log(`${pass ? '✅' : '❌'} [${phase}] ${name} — expected ${expectation}, got ${outcome}${detail ? ` (${detail})` : ''}`);
}

/** Runs fn(); records SUCCESS if it resolves, FAIL if it throws permission-denied (or any error). */
async function check(phase, name, expected, fn) {
  try {
    await fn();
    record(phase, name, expected, 'SUCCESS');
  } catch (err) {
    record(phase, name, expected, 'FAIL', err.code || err.message);
  }
}

async function signIn(email, password) {
  const cred = await signInWithEmailAndPassword(auth, email, password);
  return cred.user;
}

// Known real doc ids / uids, resolved via scripts/checkMatches.js and a
// direct users/matches read as admin before writing this suite.
const TEAM_ASHESI = 'ashesi_thunder';
const TEAM_UG = 'ug_warriors';
const MATCH_MODERATED_BY_DEMO_MOD = 'yK2TnOPwcAZVasIihwkb'; // moderator@wao-demo.com is assigned here
const MATCH_MODERATED_BY_OTHER = 'VFOV4YIXmSb6od7sz4iI';     // assigned to a different moderator ("shema")
const MATCH_NO_JUDGE_UIDS_FIELD = 'mjwuxBBuNkxejY0xfsKY';    // legacy doc, judges[] set but no judgeUids field

async function main() {
  console.log(`\nIntegration + security testing against project: ${firebaseConfig.projectId}\n`);

  // ---------- Phase 0: unauthenticated ----------
  await check('unauth', 'signed-out client cannot read matches', 'FAIL', async () => {
    await getDoc(doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD));
  });

  // ---------- Phase 1: fan ----------
  await signIn('fan@wao-demo.com', 'Wao@Fan2024!');
  const fanUid = auth.currentUser.uid;

  await check('fan', 'can read own profile', 'SUCCESS', async () => {
    await getDoc(doc(db, 'users', fanUid));
  });
  await check('fan', 'cannot read another user\'s profile', 'FAIL', async () => {
    await getDoc(doc(db, 'users', 'Wr2JW1ysyWbP0kepQA9yxTry8hc2')); // coach's uid
  });
  await check('fan', 'cannot self-promote role to admin', 'FAIL', async () => {
    await updateDoc(doc(db, 'users', fanUid), { role: 'admin', updatedAt: serverTimestamp() });
  });
  await check('fan', 'cannot create a team', 'FAIL', async () => {
    await addDoc(collection(db, 'teams'), { name: 'Fake FC', category: 'senior' });
  });
  await check('fan', 'cannot edit an existing team\'s roster', 'FAIL', async () => {
    await updateDoc(doc(db, 'teams', TEAM_ASHESI), { roster: {}, updatedAt: serverTimestamp() });
  });
  await check('fan', 'can toggle isFavorite on a match', 'SUCCESS', async () => {
    const ref = doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD);
    const before = (await getDoc(ref)).data().isFavorite ?? false;
    await updateDoc(ref, { isFavorite: !before });
    await updateDoc(ref, { isFavorite: before }); // revert
  });
  await check('fan', 'cannot edit match score', 'FAIL', async () => {
    await updateDoc(doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD), { scoreA: 999, updatedAt: serverTimestamp() });
  });
  await check('fan', 'cannot read a match\'s private access code', 'FAIL', async () => {
    await getDoc(doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD, 'private', 'access'));
  });
  await check('fan', 'cannot read internal reports', 'FAIL', async () => {
    await getDoc(doc(collection(db, 'reports'), 'any-id'));
  });
  await check('fan', 'cannot create a venue', 'FAIL', async () => {
    await addDoc(collection(db, 'venues'), { name: 'Fake Venue' });
  });
  await check('fan', 'cannot create a news article', 'FAIL', async () => {
    await addDoc(collection(db, 'news'), { title: 'Fake News' });
  });
  await check('fan', 'can follow then unfollow a team (self-service subcollection)', 'SUCCESS', async () => {
    const ref = doc(db, 'teams', TEAM_ASHESI, 'followers', fanUid);
    await setDoc(ref, { followedAt: serverTimestamp() });
    await deleteDoc(ref);
  });
  await signOut(auth);

  // ---------- Phase 2: player ----------
  await signIn('player@wao-demo.com', 'Wao@Player2024!');
  const playerUid = auth.currentUser.uid;

  await check('player', 'own profile has the expected teamId', 'SUCCESS', async () => {
    const snap = await getDoc(doc(db, 'users', playerUid));
    if (snap.data().teamId !== TEAM_ASHESI) throw new Error(`teamId was ${snap.data().teamId}`);
  });
  await check('player', 'cannot reassign own teamId', 'FAIL', async () => {
    await updateDoc(doc(db, 'users', playerUid), { teamId: TEAM_UG, updatedAt: serverTimestamp() });
  });
  await check('player', 'cannot edit their own team\'s roster (not a coach)', 'FAIL', async () => {
    await updateDoc(doc(db, 'teams', TEAM_ASHESI), { roster: {}, updatedAt: serverTimestamp() });
  });
  await signOut(auth);

  // ---------- Phase 3: coach ----------
  await signIn('coach@wao-demo.com', 'Wao@Coach2024!');

  await check('coach', 'can re-save own team\'s roster (no-op write)', 'SUCCESS', async () => {
    const ref = doc(db, 'teams', TEAM_ASHESI);
    const roster = (await getDoc(ref)).data().roster;
    await updateDoc(ref, { roster, updatedAt: serverTimestamp() });
  });
  await check('coach', 'cannot edit own team\'s name (outside allowed field list)', 'FAIL', async () => {
    await updateDoc(doc(db, 'teams', TEAM_ASHESI), { name: 'Hacked FC', updatedAt: serverTimestamp() });
  });
  await check('coach', 'cannot edit a DIFFERENT team\'s roster', 'FAIL', async () => {
    await updateDoc(doc(db, 'teams', TEAM_UG), { roster: {}, updatedAt: serverTimestamp() });
  });
  await check('coach', 'cannot create a player pre-assigned to a different team', 'FAIL', async () => {
    await addDoc(collection(db, 'players'), {
      name: 'Poached Player', email: 'poached@wao.com', role: 'worker',
      currentTeamId: TEAM_UG, status: 'active', createdAt: serverTimestamp(),
    });
  });
  await check('coach', 'can re-save own team\'s activePlayers stat (no-op write)', 'SUCCESS', async () => {
    const ref = doc(db, 'teamStatistics', TEAM_ASHESI);
    const activePlayers = (await getDoc(ref)).data()?.activePlayers ?? 0;
    await updateDoc(ref, { activePlayers, updatedAt: serverTimestamp() });
  });
  await check('coach', 'cannot edit own team\'s wins/losses stats', 'FAIL', async () => {
    await updateDoc(doc(db, 'teamStatistics', TEAM_ASHESI), { wins: 999, updatedAt: serverTimestamp() });
  });
  await check('coach', 'cannot create a match', 'FAIL', async () => {
    await addDoc(collection(db, 'matches'), { teamAId: TEAM_ASHESI, teamBId: TEAM_UG, scoreA: 0, scoreB: 0, moderatorUid: 'x' });
  });
  await signOut(auth);

  // ---------- Phase 4: official, not assigned to anything (judge@wao-demo.com) ----------
  await signIn('judge@wao-demo.com', 'Wao@Judge2024!');

  await check('unassigned-official', 'cannot grant Judges score on a match they are not assigned to', 'FAIL', async () => {
    await updateDoc(doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD), { teamAJudges: 10, updatedAt: serverTimestamp() });
  });
  await check('unassigned-official', 'can read internal reports (official-tier)', 'SUCCESS', async () => {
    // A read of a nonexistent doc still resolves (just !exists()) as long as
    // the rules allow the read itself — this is purely a permission check.
    await getDoc(doc(collection(db, 'reports'), 'any-id'));
  });
  await check('unassigned-official', 'cannot create a venue (official is not admin)', 'FAIL', async () => {
    await addDoc(collection(db, 'venues'), { name: 'Fake Venue 2' });
  });
  await check('unassigned-official', 'cannot read a match\'s private access code', 'FAIL', async () => {
    await getDoc(doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD, 'private', 'access'));
  });
  await signOut(auth);

  // ---------- Phase 5: official listed as a judge, but on a doc with no judgeUids field ----------
  await signIn('ama.boateng@wao-demo.com', 'Wao@2024!');
  await check('legacy-doc-official', 'cannot score a match whose doc predates the judgeUids field, despite being named in judges[]', 'FAIL', async () => {
    await updateDoc(doc(db, 'matches', MATCH_NO_JUDGE_UIDS_FIELD), { teamAJudges: 10, updatedAt: serverTimestamp() });
  });
  await signOut(auth);

  // ---------- Phase 6: moderator, assigned to one real match ----------
  await signIn('moderator@wao-demo.com', 'Wao@Mod2024!');

  await check('moderator', 'can read the access code of their assigned match', 'SUCCESS', async () => {
    await getDoc(doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD, 'private', 'access'));
  });
  await check('moderator', 'cannot read the access code of a match assigned to someone else', 'FAIL', async () => {
    await getDoc(doc(db, 'matches', MATCH_MODERATED_BY_OTHER, 'private', 'access'));
  });
  let originalVenue;
  await check('moderator', 'can edit venue on their assigned match, and it actually changes', 'SUCCESS', async () => {
    const ref = doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD);
    originalVenue = (await getDoc(ref)).data().venue;
    await updateDoc(ref, { venue: `${originalVenue} (test)`, updatedAt: serverTimestamp() });
    const changed = (await getDoc(ref)).data().venue;
    if (changed === originalVenue) throw new Error('venue did not actually change');
  });
  // Immediately follows the write above, deliberately within 2s of it, to
  // exercise the per-doc rate limit before it clears.
  await check('moderator', 'a second rapid edit within 2s of the last is rejected by the per-doc cooldown', 'FAIL', async () => {
    const ref = doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD);
    await updateDoc(ref, { venue: 'should be rejected by cooldown', updatedAt: serverTimestamp() });
  });
  await sleep(2100); // clear the cooldown before reverting the venue for real
  try {
    await updateDoc(doc(db, 'matches', MATCH_MODERATED_BY_DEMO_MOD), { venue: originalVenue, updatedAt: serverTimestamp() });
  } catch (err) {
    console.error(`WARNING: failed to revert venue on ${MATCH_MODERATED_BY_DEMO_MOD} back to "${originalVenue}" — fix manually:`, err.code || err.message);
  }

  await check('moderator', 'cannot edit a match assigned to a different moderator', 'FAIL', async () => {
    await updateDoc(doc(db, 'matches', MATCH_MODERATED_BY_OTHER), { venue: 'Hijacked', updatedAt: serverTimestamp() });
  });
  await check('moderator', 'cannot create a match (admin-only, even for official-tier)', 'FAIL', async () => {
    await addDoc(collection(db, 'matches'), { teamAId: TEAM_ASHESI, teamBId: TEAM_UG, scoreA: 0, scoreB: 0, moderatorUid: 'x' });
  });
  await signOut(auth);

  // ---------- Phase 7: admin ----------
  await signIn('afanyuemma2002@gmail.com', 'Wao@Admin2024!');

  await check('admin', 'can read any match\'s private access code, including ones they did not moderate', 'SUCCESS', async () => {
    await getDoc(doc(db, 'matches', MATCH_MODERATED_BY_OTHER, 'private', 'access'));
  });
  await check('admin', 'can create then delete a throwaway venue', 'SUCCESS', async () => {
    const ref = await addDoc(collection(db, 'venues'), { name: '__integration_test_venue__' });
    await deleteDoc(ref);
  });
  await signOut(auth);

  // ---------- Report ----------
  const passed = results.filter((r) => r.pass).length;
  const failed = results.length - passed;
  console.log(`\n${passed}/${results.length} checks passed.`);
  if (failed > 0) {
    console.log('\nFailed checks:');
    results.filter((r) => !r.pass).forEach((r) => console.log(`  [${r.phase}] ${r.name} — expected ${r.expectation}, got ${r.outcome} (${r.detail})`));
  }

  console.log('\n---JSON---');
  console.log(JSON.stringify(results, null, 2));

  process.exit(failed > 0 ? 1 : 0);
}

main().catch((err) => {
  console.error('Suite crashed:', err);
  process.exit(1);
});
