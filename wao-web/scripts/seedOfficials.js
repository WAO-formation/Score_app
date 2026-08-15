/**
 * WAO Demo Officials Seed Script
 * -------------------------------------------------
 * Run once to create a few demo official/judge accounts so the CreateGame
 * judges picker (and Management > Officials) isn't empty on a fresh
 * project:
 *
 *   node scripts/seedOfficials.js
 *
 * Signs in as the demo admin (scripts/seedAdmin.js) — creating a `users`
 * doc for someone else's uid is admin-only (see wao_mobile/firestore.rules).
 * Mirrors exactly how Management > Users' "Add User" creates an account
 * (src/pages/management/components/Users.jsx): a *secondary* Firebase Auth
 * app instance runs createUserWithEmailAndPassword so the new account's
 * sign-in doesn't replace the admin session on the primary one, which the
 * Firestore writes (and every other account in this loop) still need.
 * Uses your existing .env VITE_ vars via dotenv. Safe to re-run — skips any
 * email that already has an account.
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
const DEFAULT_PASSWORD = 'Wao@2024!';

const DEMO_OFFICIALS = [
  { name: 'James Osei',    email: 'james.osei@wao-demo.com' },
  { name: 'Abena Mensah',  email: 'abena.mensah@wao-demo.com' },
  { name: 'Kwame Asante',  email: 'kwame.asante@wao-demo.com' },
  { name: 'Ama Boateng',   email: 'ama.boateng@wao-demo.com' },
  { name: 'Kofi Darko',    email: 'kofi.darko@wao-demo.com' },
];

async function seed() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  // Same reasoning as Users.jsx's secondaryAuth: creating an account signs
  // the caller in as that new user, which would knock the admin session
  // (and its write permission) out from under the rest of this loop.
  const secondaryApp = initializeApp(firebaseConfig, 'seed-secondary');
  const secondaryAuth = getAuth(secondaryApp);

  console.log(`\n🌱  Seeding ${DEMO_OFFICIALS.length} demo officials\n`);

  try {
    const cred = await signInWithEmailAndPassword(auth, ADMIN_EMAIL, ADMIN_PASSWORD);
    console.log(`✅  Signed in as ${cred.user.email}`);
    await cred.user.getIdToken(true);
  } catch (err) {
    console.error('❌  Could not sign in as the demo admin — run `npm run seed:admin` first.', err.message);
    process.exit(1);
  }

  for (const { name, email } of DEMO_OFFICIALS) {
    try {
      const secCred = await createUserWithEmailAndPassword(secondaryAuth, email, DEFAULT_PASSWORD);
      await updateProfile(secCred.user, { displayName: name });

      await setDoc(doc(db, 'users', secCred.user.uid), {
        username: name,
        displayName: name,
        email,
        role: 'official',
        mustChangePassword: true,
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
      console.log(`✅  created: ${name} <${email}>`);
    } catch (err) {
      if (err.code === 'auth/email-already-in-use') {
        console.log(`ℹ️   skip (already exists): ${name} <${email}>`);
      } else {
        console.error(`❌  failed to create ${name}:`, err.code || err.message);
      }
    }
  }

  console.log(`\nDone. Default password for any new account: ${DEFAULT_PASSWORD} (must change on first login)\n`);
  process.exit(0);
}

seed();
