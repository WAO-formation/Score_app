/**
 * WAO Demo Player Seed Script
 * -------------------------------------------------
 * Run once to create a demo player account for testing the mobile app's
 * player-facing experience:
 *
 *   node scripts/seedPlayer.js
 *
 * 'player' isn't a self-registerable role (see wao_mobile/firestore.rules:
 * `allow create: if (isOwner(userId) && request.resource.data.role == 'fan')
 * || isAdmin();`), so — same as scripts/seedOfficials.js — this signs in as
 * the demo admin first and creates the Firestore doc for someone else's uid.
 * A *secondary* Firebase Auth app instance runs createUserWithEmailAndPassword
 * so the new account's sign-in doesn't replace the admin session on the
 * primary one. Uses your existing .env VITE_ vars via dotenv. Safe to
 * re-run — skips if the email already has an account.
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

const PLAYER = {
  name: 'Test Player',
  email: 'player@wao-demo.com',
  password: 'Wao@Player2024!',
};

async function seed() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  // Same reasoning as Users.jsx's secondaryAuth: creating an account signs
  // the caller in as that new user, which would knock the admin session
  // (and its write permission) out from under the Firestore write below.
  const secondaryApp = initializeApp(firebaseConfig, 'seed-secondary');
  const secondaryAuth = getAuth(secondaryApp);

  console.log(`\n🌱  Seeding demo player: ${PLAYER.email}\n`);

  try {
    const cred = await signInWithEmailAndPassword(auth, ADMIN_EMAIL, ADMIN_PASSWORD);
    console.log(`✅  Signed in as ${cred.user.email}`);
    await cred.user.getIdToken(true);
  } catch (err) {
    console.error('❌  Could not sign in as the demo admin — run `npm run seed:admin` first.', err.message);
    process.exit(1);
  }

  try {
    const secCred = await createUserWithEmailAndPassword(secondaryAuth, PLAYER.email, PLAYER.password);
    await updateProfile(secCred.user, { displayName: PLAYER.name });

    await setDoc(doc(db, 'users', secCred.user.uid), {
      username: PLAYER.name,
      displayName: PLAYER.name,
      email: PLAYER.email,
      role: 'player',
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
    console.log(`✅  created: ${PLAYER.name} <${PLAYER.email}>`);
    console.log(`\n    Email    : ${PLAYER.email}`);
    console.log(`    Password : ${PLAYER.password}\n`);
  } catch (err) {
    if (err.code === 'auth/email-already-in-use') {
      console.log(`ℹ️   Account already exists: ${PLAYER.email}`);
      try {
        await signInWithEmailAndPassword(secondaryAuth, PLAYER.email, PLAYER.password);
        console.log('✅  Verified existing credentials still work.');
        await signOut(secondaryAuth);
      } catch (signInErr) {
        console.error('⚠️   Account exists but sign-in with the expected password failed:', signInErr.code);
      }
      console.log(`\n    Email    : ${PLAYER.email}`);
      console.log(`    Password : ${PLAYER.password}\n`);
    } else {
      console.error(`❌  failed to create player:`, err.code || err.message);
    }
  }

  process.exit(0);
}

seed();
