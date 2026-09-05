/**
 * Diagnostic: dump every doc in `matches` (and `teams`) exactly as stored,
 * signed in as the demo admin. Read-only — no writes. Run once to see
 * ground truth when web and mobile disagree about what games exist.
 *
 *   node scripts/checkMatches.js
 */
import { initializeApp } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import { getFirestore, collection, getDocs } from 'firebase/firestore';
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

async function run() {
  const app = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db = getFirestore(app);

  console.log(`Project: ${firebaseConfig.projectId}\n`);

  try {
    const cred = await signInWithEmailAndPassword(auth, ADMIN_EMAIL, ADMIN_PASSWORD);
    console.log(`Signed in as ${cred.user.email} (${cred.user.uid})\n`);
  } catch (err) {
    console.error('Could not sign in as admin:', err.code || err.message);
    process.exit(1);
  }

  const matchesSnap = await getDocs(collection(db, 'matches'));
  console.log(`=== matches: ${matchesSnap.size} doc(s) ===`);
  matchesSnap.forEach((d) => {
    const m = d.data();
    const start = m.startTime?.toDate ? m.startTime.toDate().toISOString() : m.startTime;
    console.log(`- ${d.id} | status=${m.status} | ${m.teamAName} vs ${m.teamBName} | scoreA=${m.scoreA} scoreB=${m.scoreB} | startTime=${start} | venue=${m.venue}`);
  });

  console.log(`\n=== teams: ${(await getDocs(collection(db, 'teams'))).size} doc(s) ===`);
  const teamsSnap = await getDocs(collection(db, 'teams'));
  teamsSnap.forEach((d) => {
    const t = d.data();
    console.log(`- ${d.id} | ${t.name} | category=${t.category}`);
  });

  process.exit(0);
}

run().catch((err) => {
  console.error('Failed:', err.code || err.message);
  process.exit(1);
});
