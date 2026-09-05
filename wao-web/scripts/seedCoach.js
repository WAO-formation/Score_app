/**
 * WAO Demo Coach Seed Script
 * -------------------------------------------------
 * Run once to create a demo coach account, tied to the same team as the
 * demo player (scripts/seedPlayer.js + linkPlayerToTeam.js), so the coach's
 * roster-management tools on mobile have something real to manage:
 *
 *   node scripts/seedCoach.js
 *
 * 'coach' isn't a self-registerable role (see wao_mobile/firestore.rules:
 * `allow create: if (isOwner(userId) && request.resource.data.role == 'fan')
 * || isAdmin();`), so — same as scripts/seedPlayer.js — this signs in as
 * the demo admin first and creates the account/profile doc for someone
 * else's uid. teamId is set in the same write: it's the admin-assigned
 * link firestore.rules' isCoachOfTeam() checks before letting this account
 * touch teams/{teamId}.roster or players/ for that team.
 * Safe to re-run — verifies existing credentials if the account exists.
 */

import { initializeApp } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, updateProfile, signOut } from 'firebase/auth';
import { getFirestore, doc, setDoc, serverTimestamp } from 'firebase/firestore';
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

const COACH = {
  name: 'Test Coach',
  email: 'coach@wao-demo.com',
  password: 'Wao@Coach2024!',
};
const TEAM_ID = 'ashesi_thunder'; // same team the demo player is on

async function seed() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  const secondaryApp = initializeApp(firebaseConfig, 'seed-secondary');
  const secondaryAuth = getAuth(secondaryApp);

  console.log(`\n🌱  Seeding demo coach: ${COACH.email}\n`);

  try {
    const cred = await signInWithEmailAndPassword(auth, ADMIN_EMAIL, ADMIN_PASSWORD);
    console.log(`✅  Signed in as ${cred.user.email}`);
    await cred.user.getIdToken(true);
  } catch (err) {
    console.error('❌  Could not sign in as the demo admin — run `npm run seed:admin` first.', err.message);
    process.exit(1);
  }

  try {
    const secCred = await createUserWithEmailAndPassword(secondaryAuth, COACH.email, COACH.password);
    await updateProfile(secCred.user, { displayName: COACH.name });

    await setDoc(doc(db, 'users', secCred.user.uid), {
      username: COACH.name,
      displayName: COACH.name,
      email: COACH.email,
      role: 'coach',
      teamId: TEAM_ID,
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
      favoriteTeamIds: [],
      favoriteMatchIds: [],
      totalMatches: 0,
      totalTeams: 0,
      themePreference: 'system',
      notificationsEnabled: true,
      emailNotifications: false,
      language: 'English',
    });

    await signOut(secondaryAuth);
    console.log(`✅  created: ${COACH.name} <${COACH.email}>, coaching ${TEAM_ID}`);
    console.log(`\n    Email    : ${COACH.email}`);
    console.log(`    Password : ${COACH.password}\n`);
  } catch (err) {
    if (err.code === 'auth/email-already-in-use') {
      console.log(`ℹ️   Account already exists: ${COACH.email}`);
      try {
        await signInWithEmailAndPassword(secondaryAuth, COACH.email, COACH.password);
        console.log('✅  Verified existing credentials still work.');
        await signOut(secondaryAuth);
      } catch (signInErr) {
        console.error('⚠️   Account exists but sign-in with the expected password failed:', signInErr.code);
      }
      console.log(`\n    Email    : ${COACH.email}`);
      console.log(`    Password : ${COACH.password}\n`);
    } else {
      console.error(`❌  failed to create coach:`, err.code || err.message);
    }
  }

  process.exit(0);
}

seed().catch((err) => {
  console.error('❌  Failed:', err.code || err.message);
  process.exit(1);
});
