/**
 * One-time cleanup: remove the leftover fake match docs that wao_mobile's
 * now-deleted SeedingService wrote directly into production Firestore
 * (confirmed via scripts/checkMatches.js — these match the seeder's exact
 * hardcoded fixtures, one referencing a team, "National Champions", that
 * doesn't even exist in the real `teams` collection). Also closes out the
 * one REAL match (created via wao-web's Create Game) that's been stuck
 * "live" for 3+ weeks because nothing ever ended it.
 *
 *   node scripts/cleanupFakeMatches.js
 */
import { initializeApp } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import { getFirestore, doc, deleteDoc, updateDoc, serverTimestamp } from 'firebase/firestore';
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

// Confirmed-fake docs, traced to SeedingService.seedMatches()'s literal fixtures.
const FAKE_MATCH_IDS = [
  '1qUI2NAm1EeOEba02Tuv', // UG Warriors vs KNUST Stars (finished)
  'FwtDHD5XkwMFulLi92iJ', // UCC Titans vs UPSA Eagles (finished)
  'NH5UYR8TULb7iefsaSlJ', // WAO All-Stars vs National Champions (live) — "National Champions" isn't a real team
  'hk96OB3HYdR4Aa7WkpeS', // UPSA Eagles vs UG Warriors (postponed)
];

// Real match (Ashesi Thunder vs UG Warriors, venue "UGC CAMPUS"), stuck live
// since Aug 15 — closing it out at its current 8-5 score per admin's request.
const STUCK_LIVE_MATCH_ID = 'mjwuxBBuNkxejY0xfsKY';

async function run() {
  const app = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db = getFirestore(app);

  try {
    const cred = await signInWithEmailAndPassword(auth, ADMIN_EMAIL, ADMIN_PASSWORD);
    console.log(`Signed in as ${cred.user.email}\n`);
  } catch (err) {
    console.error('Could not sign in as admin:', err.code || err.message);
    process.exit(1);
  }

  console.log('Deleting fake seeded matches...');
  for (const id of FAKE_MATCH_IDS) {
    await deleteDoc(doc(db, 'matches', id));
    console.log(`  deleted ${id}`);
  }

  console.log(`\nClosing out stuck live match ${STUCK_LIVE_MATCH_ID}...`);
  await updateDoc(doc(db, 'matches', STUCK_LIVE_MATCH_ID), {
    status: 'finished',
    completedAt: serverTimestamp(),
    updatedAt: serverTimestamp(),
  });
  console.log('  marked finished');

  console.log('\nDone.');
  process.exit(0);
}

run().catch((err) => {
  console.error('Failed:', err.code || err.message);
  process.exit(1);
});
