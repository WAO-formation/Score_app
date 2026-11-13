/**
 * WAO Demo Player <-> Team Link Script
 * -------------------------------------------------
 * Ties the demo player account (scripts/seedPlayer.js) to a real team so
 * the mobile app's player-only "Team Activities" tab has something to show:
 *
 *   node scripts/linkPlayerToTeam.js
 *
 * Does two separate things, both admin-only writes per firestore.rules:
 *   1. Sets `teamId` on the player's own `users/{uid}` doc — this is what
 *      TeamActivitiesPage reads to know which team's tab content to show.
 *   2. Creates a `players` doc for them and adds it to the team's roster
 *      (`teams/{teamId}.roster.workerIds`) — this is what makes them show
 *      up in that team's "Team Lineup" panel, the same panel fans see on
 *      any match's roster view.
 *
 * These are two independent data models in this codebase (account role vs.
 * roster membership) — see the note in TeamActivitiesPage. Safe to re-run:
 * skips creating a second player doc if one already exists for this email.
 */

import { initializeApp } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword, signOut } from 'firebase/auth';
import {
  getFirestore, collection, doc, getDoc, getDocs, query, where,
  setDoc, updateDoc, arrayUnion, serverTimestamp,
} from 'firebase/firestore';
import dotenv from 'dotenv';

dotenv.config({ path: '.env.local' });
dotenv.config();

const firebaseConfig = {
  apiKey:            process.env.VITE_FIREBASE_API_KEY,
  authDomain:        process.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId:         process.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket:     process.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId:             process.env.VITE_FIREBASE_APP_ID,
};

const ADMIN_EMAIL = 'afanyuemma2002@gmail.com';
const ADMIN_PASSWORD = 'Wao@Admin2024!';

const PLAYER_EMAIL = 'player@wao-demo.com';
const PLAYER_NAME = 'Test Player';
const TEAM_ID = 'ashesi_thunder';
const ROSTER_FIELD = 'workerIds'; // TeamRoster's field for PlayerRole.worker
const PLAYER_ROLE = 'worker';

async function seed() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  console.log(`\n🌱  Linking ${PLAYER_EMAIL} to team ${TEAM_ID}\n`);

  await signInWithEmailAndPassword(auth, ADMIN_EMAIL, ADMIN_PASSWORD);
  console.log(`✅  Signed in as admin`);

  // Find the player's users/{uid} doc by email (need the uid to write to it).
  const usersSnap = await getDocs(query(collection(db, 'users'), where('email', '==', PLAYER_EMAIL)));
  if (usersSnap.empty) {
    console.error(`❌  No users doc found for ${PLAYER_EMAIL} — run scripts/seedPlayer.js first.`);
    process.exit(1);
  }
  const playerUid = usersSnap.docs[0].id;

  const teamRef = doc(db, 'teams', TEAM_ID);
  const teamSnap = await getDoc(teamRef);
  if (!teamSnap.exists()) {
    console.error(`❌  Team ${TEAM_ID} not found.`);
    process.exit(1);
  }
  const teamName = teamSnap.data().name;

  // 1. Tie the account to the team (read by TeamActivitiesPage).
  await updateDoc(doc(db, 'users', playerUid), {
    teamId: TEAM_ID,
    updatedAt: serverTimestamp(),
  });
  console.log(`✅  users/${playerUid}.teamId = ${TEAM_ID}`);

  // 2. Create (or reuse) a players/ doc and add it to the roster, so they
  //    actually appear in that team's lineup.
  const playersSnap = await getDocs(query(collection(db, 'players'), where('email', '==', PLAYER_EMAIL)));
  let playerId;
  if (!playersSnap.empty) {
    playerId = playersSnap.docs[0].id;
    console.log(`ℹ️   players/${playerId} already exists for ${PLAYER_EMAIL}`);
  } else {
    const newPlayerRef = doc(collection(db, 'players'));
    playerId = newPlayerRef.id;
    await setDoc(newPlayerRef, {
      name: PLAYER_NAME,
      email: PLAYER_EMAIL,
      role: PLAYER_ROLE,
      status: 'active',
      currentTeamId: TEAM_ID,
      currentTeamName: teamName,
      joinedTeamAt: serverTimestamp(),
      gamesPlayed: 0,
      goalsScored: 0,
      assists: 0,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
      jerseyNumber: null,
      age: null,
    });
    console.log(`✅  created players/${playerId}`);
  }

  await updateDoc(teamRef, {
    [`roster.${ROSTER_FIELD}`]: arrayUnion(playerId),
    updatedAt: serverTimestamp(),
  });
  console.log(`✅  added to teams/${TEAM_ID}.roster.${ROSTER_FIELD}`);

  console.log(`\nDone. ${PLAYER_NAME} <${PLAYER_EMAIL}> is now on ${teamName}.\n`);

  await signOut(auth);
  process.exit(0);
}

seed().catch((err) => {
  console.error('❌  Failed:', err.code || err.message);
  process.exit(1);
});
