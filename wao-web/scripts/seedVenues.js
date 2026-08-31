/**
 * WAO Demo Venues Seed Script
 * -------------------------------------------------
 * Run once to create a few demo venues so the CreateGame venue picker isn't
 * empty on a fresh project:
 *
 *   node scripts/seedVenues.js
 *
 * Signs in as the demo admin (scripts/seedAdmin.js) since venues.create is
 * admin-only (see wao_mobile/firestore.rules). Uses your existing .env
 * VITE_ vars via dotenv. Safe to re-run — skips any venue name that already
 * exists.
 */

import { initializeApp } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import { getFirestore, collection, addDoc, getDocs, serverTimestamp } from 'firebase/firestore';
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

const DEMO_VENUES = [
  'Cornerstone Baptist Church Court, Dome',
  'TBC Court, Tesano',
  'UPSA Arena',
];

async function seed() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  console.log(`\n🌱  Seeding ${DEMO_VENUES.length} demo venues\n`);

  try {
    const cred = await signInWithEmailAndPassword(auth, ADMIN_EMAIL, ADMIN_PASSWORD);
    console.log(`✅  Signed in as ${cred.user.email} (uid: ${cred.user.uid})`);
    await cred.user.getIdToken(true);
  } catch (err) {
    console.error('❌  Could not sign in as the demo admin — run `npm run seed:admin` first.', err.message);
    process.exit(1);
  }

  let existing;
  try {
    existing = await getDocs(collection(db, 'venues'));
  } catch (err) {
    console.error('❌  Reading venues failed:', err.code, err.message);
    console.error('    projectId:', firebaseConfig.projectId, '| authUser:', auth.currentUser?.uid, auth.currentUser?.email);
    process.exit(1);
  }
  const existingNames = new Set(existing.docs.map((d) => d.data().name));

  for (const name of DEMO_VENUES) {
    if (existingNames.has(name)) {
      console.log(`ℹ️   skip (already exists): ${name}`);
      continue;
    }
    await addDoc(collection(db, 'venues'), { name, createdAt: serverTimestamp() });
    console.log(`✅  created: ${name}`);
  }

  console.log('\nDone.\n');
  process.exit(0);
}

seed();
