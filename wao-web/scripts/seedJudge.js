/**
 * WAO Demo Judge (Official) Seed Script
 * -------------------------------------------------
 * Run once to create a demo judge/official account for testing the
 * official-only surface (/officiating, judge-tier scoring):
 *
 *   node scripts/seedJudge.js
 *
 * Signs in as the demo admin (scripts/seedAdmin.js) — creating a `users` doc
 * for someone else's uid is admin-only (see wao_mobile/firestore.rules).
 * Mirrors scripts/seedModerator.js: a *secondary* Firebase Auth app instance
 * runs createUserWithEmailAndPassword so the new account's sign-in doesn't
 * replace the admin session the Firestore write still needs.
 * Uses your existing .env VITE_ vars via dotenv. Safe to re-run — skips if
 * the email already has an account.
 */

import { initializeApp } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword, createUserWithEmailAndPassword, updateProfile, signOut } from 'firebase/auth';
import { getFirestore, doc, setDoc, serverTimestamp } from 'firebase/firestore';
import dotenv from 'dotenv';

dotenv.config({ path: '.env.local' });
dotenv.config(); // fallback to .env

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

const JUDGE = {
  name: 'Test Judge',
  email: 'judge@wao-demo.com',
  password: 'Wao@Judge2024!',
};

async function seed() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  const secondaryApp = initializeApp(firebaseConfig, 'seed-secondary');
  const secondaryAuth = getAuth(secondaryApp);

  console.log(`\n🌱  Seeding demo judge: ${JUDGE.email}\n`);

  try {
    const cred = await signInWithEmailAndPassword(auth, ADMIN_EMAIL, ADMIN_PASSWORD);
    console.log(`✅  Signed in as ${cred.user.email}`);
    await cred.user.getIdToken(true);
  } catch (err) {
    console.error('❌  Could not sign in as the demo admin — run `npm run seed:admin` first.', err.message);
    process.exit(1);
  }

  try {
    const secCred = await createUserWithEmailAndPassword(secondaryAuth, JUDGE.email, JUDGE.password);
    await updateProfile(secCred.user, { displayName: JUDGE.name });

    await setDoc(doc(db, 'users', secCred.user.uid), {
      username: JUDGE.name,
      displayName: JUDGE.name,
      email: JUDGE.email,
      role: 'official',
      // No forced reset — this is a throwaway test account, not a real
      // judge's first login, so skip the extra ForcePasswordChange step.
      mustChangePassword: false,
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
    console.log(`✅  created: ${JUDGE.name} <${JUDGE.email}>`);
    console.log(`\n    Email    : ${JUDGE.email}`);
    console.log(`    Password : ${JUDGE.password}\n`);
  } catch (err) {
    if (err.code === 'auth/email-already-in-use') {
      console.log(`ℹ️   Account already exists: ${JUDGE.email}`);
      console.log(`\n    Email    : ${JUDGE.email}`);
      console.log(`    Password : ${JUDGE.password}\n`);
    } else {
      console.error(`❌  failed to create judge:`, err.code || err.message);
    }
  }

  process.exit(0);
}

seed();
