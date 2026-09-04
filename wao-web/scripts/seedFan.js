/**
 * WAO Demo Fan Seed Script
 * -------------------------------------------------
 * Run once to create a demo fan account for testing the mobile app's
 * fan-facing experience (home feed, news, favorites, How to Play WAO):
 *
 *   node scripts/seedFan.js
 *
 * Unlike the admin/moderator/official seed scripts, a fan account is
 * ordinary self-registration — no admin session or Firestore-doc-for-
 * someone-else's-uid privilege needed (see wao_mobile/firestore.rules:
 * `allow create: if (isOwner(userId) && request.resource.data.role == 'fan')`).
 * Uses your existing .env VITE_ vars via dotenv. Safe to re-run — skips if
 * the email already has an account.
 */

import { initializeApp } from 'firebase/app';
import { getAuth, createUserWithEmailAndPassword, signInWithEmailAndPassword, updateProfile, signOut } from 'firebase/auth';
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

const FAN = {
  name: 'Test Fan',
  email: 'fan@wao-demo.com',
  password: 'Wao@Fan2024!',
};

async function seed() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  console.log(`\n🌱  Seeding demo fan: ${FAN.email}\n`);

  try {
    const cred = await createUserWithEmailAndPassword(auth, FAN.email, FAN.password);
    await updateProfile(cred.user, { displayName: FAN.name });

    // role: 'fan' is the only role a self-write is allowed to claim — see
    // firestore.rules' users/create rule.
    await setDoc(doc(db, 'users', cred.user.uid), {
      username: FAN.name,
      displayName: FAN.name,
      email: FAN.email,
      role: 'fan',
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

    await signOut(auth);
    console.log(`✅  created: ${FAN.name} <${FAN.email}>`);
    console.log(`\n    Email    : ${FAN.email}`);
    console.log(`    Password : ${FAN.password}\n`);
  } catch (err) {
    if (err.code === 'auth/email-already-in-use') {
      console.log(`ℹ️   Account already exists: ${FAN.email}`);
      // Confirm we can still sign in with the known password.
      try {
        await signInWithEmailAndPassword(auth, FAN.email, FAN.password);
        console.log('✅  Verified existing credentials still work.');
      } catch (signInErr) {
        console.error('⚠️   Account exists but sign-in with the expected password failed:', signInErr.code);
      }
      console.log(`\n    Email    : ${FAN.email}`);
      console.log(`    Password : ${FAN.password}\n`);
    } else {
      console.error(`❌  failed to create fan:`, err.code || err.message);
    }
  }

  process.exit(0);
}

seed();
