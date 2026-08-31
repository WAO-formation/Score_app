/**
 * WAO Demo Moderator Seed Script
 * -------------------------------------------------
 * Run once to create a demo moderator account for testing the moderator-only
 * surfaces (Games moderator assignment, /my-games):
 *
 *   node scripts/seedModerator.js
 *
 * Signs in as the demo admin (scripts/seedAdmin.js) — creating a `users` doc
 * for someone else's uid is admin-only (see wao_mobile/firestore.rules).
 * Mirrors scripts/seedOfficials.js: a *secondary* Firebase Auth app instance
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

const MODERATOR = {
  name: 'Test Moderator',
  email: 'moderator@wao-demo.com',
  password: 'Wao@Mod2024!',
};

async function seed() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  const secondaryApp = initializeApp(firebaseConfig, 'seed-secondary');
  const secondaryAuth = getAuth(secondaryApp);

  console.log(`\n🌱  Seeding demo moderator: ${MODERATOR.email}\n`);

  try {
    const cred = await signInWithEmailAndPassword(auth, ADMIN_EMAIL, ADMIN_PASSWORD);
    console.log(`✅  Signed in as ${cred.user.email}`);
    await cred.user.getIdToken(true);
  } catch (err) {
    console.error('❌  Could not sign in as the demo admin — run `npm run seed:admin` first.', err.message);
    process.exit(1);
  }

  try {
    const secCred = await createUserWithEmailAndPassword(secondaryAuth, MODERATOR.email, MODERATOR.password);
    await updateProfile(secCred.user, { displayName: MODERATOR.name });

    await setDoc(doc(db, 'users', secCred.user.uid), {
      username: MODERATOR.name,
      displayName: MODERATOR.name,
      email: MODERATOR.email,
      role: 'moderator',
      // No forced reset — this is a throwaway test account, not a real
      // moderator's first login, so skip the extra ForcePasswordChange step.
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
    console.log(`✅  created: ${MODERATOR.name} <${MODERATOR.email}>`);
    console.log(`\n    Email    : ${MODERATOR.email}`);
    console.log(`    Password : ${MODERATOR.password}\n`);
  } catch (err) {
    if (err.code === 'auth/email-already-in-use') {
      console.log(`ℹ️   Account already exists: ${MODERATOR.email}`);
      console.log(`\n    Email    : ${MODERATOR.email}`);
      console.log(`    Password : ${MODERATOR.password}\n`);
    } else {
      console.error(`❌  failed to create moderator:`, err.code || err.message);
    }
  }

  process.exit(0);
}

seed();
