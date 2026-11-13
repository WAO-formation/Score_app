/**
 * WAO Live-Demo Match Seed Script
 * -------------------------------------------------
 * Creates a handful of real `matches` docs (status 'upcoming') dated today
 * and tomorrow, using the real teams already in Firestore (see
 * scripts/checkMatches.js) — NOT the fake SeedingService fixtures that
 * scripts/cleanupFakeMatches.js already removed. For a live demo, so the
 * landing page's "Upcoming Games" section (src/data/upcomingGames.js) and
 * the dashboard Games page have real fixtures to show.
 *
 *   node scripts/seedDemoMatches.js
 *
 * Signs in as the demo admin (scripts/seedAdmin.js) — creating a match is
 * admin-only (see wao_mobile/firestore.rules). Safe to re-run: skips any
 * fixture whose two team names already have an undispatched 'upcoming'
 * match between them.
 */
import { initializeApp } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import {
  getFirestore, collection, getDocs, addDoc, query, where, serverTimestamp, Timestamp,
} from 'firebase/firestore';
import dotenv from 'dotenv';
import { ADMIN } from './seedAdmin.js';

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

// Local calendar day, not UTC — a venue's "today" game should still land on
// today's date in the the browser's/venue's own timezone bucket, matching
// how docToGame derives `date` from startTime.
const atLocalTime = (daysFromNow, hour, minute = 0) => {
  const d = new Date();
  d.setDate(d.getDate() + daysFromNow);
  d.setHours(hour, minute, 0, 0);
  return d;
};

const FIXTURES = [
  { homeTeamId: 'ug_warriors',    homeTeam: 'UG Warriors',    awayTeamId: 'knust_stars',  awayTeam: 'KNUST Stars',  venue: 'UGC CAMPUS',   startTime: atLocalTime(0, 16, 0) },
  { homeTeamId: 'ucc_titans',     homeTeam: 'UCC Titans',     awayTeamId: 'upsa_eagles',  awayTeam: 'UPSA Eagles',  venue: 'UGC CAMPUS',   startTime: atLocalTime(0, 18, 30) },
  { homeTeamId: 'ashesi_thunder', homeTeam: 'Ashesi Thunder', awayTeamId: 'wao_all_stars', awayTeam: 'WAO All-Stars', venue: 'UGC CAMPUS', startTime: atLocalTime(1, 15, 0) },
  { homeTeamId: 'knust_stars',    homeTeam: 'KNUST Stars',    awayTeamId: 'ug_warriors',  awayTeam: 'UG Warriors',  venue: 'UGC CAMPUS',   startTime: atLocalTime(1, 17, 30) },
];

async function run() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  console.log(`\nSeeding demo matches for a live demo (today/tomorrow)...\n`);

  let adminUid;
  try {
    const cred = await signInWithEmailAndPassword(auth, ADMIN.email, ADMIN.password);
    adminUid = cred.user.uid;
    console.log(`Signed in as ${cred.user.email}\n`);
  } catch (err) {
    console.error('Could not sign in as admin — run `node scripts/seedAdmin.js` first.', err.code || err.message);
    process.exit(1);
  }

  const existingSnap = await getDocs(
    query(collection(db, 'matches'), where('status', '==', 'upcoming'))
  );
  const existingPairs = new Set(
    existingSnap.docs.map((d) => `${d.data().teamAId}__${d.data().teamBId}`)
  );

  for (const fx of FIXTURES) {
    const pairKey = `${fx.homeTeamId}__${fx.awayTeamId}`;
    if (existingPairs.has(pairKey)) {
      console.log(`  skip (already has an upcoming match): ${fx.homeTeam} vs ${fx.awayTeam}`);
      continue;
    }

    await addDoc(collection(db, 'matches'), {
      teamAId: fx.homeTeamId,
      teamBId: fx.awayTeamId,
      teamAName: fx.homeTeam,
      teamBName: fx.awayTeam,
      scoreA: 0,
      scoreB: 0,
      status: 'upcoming',
      type: 'friendly',
      startTime: Timestamp.fromDate(fx.startTime),
      venue: fx.venue,
      championshipId: null,
      championshipName: '',
      moderatorUid: adminUid,
      moderatorName: ADMIN.name,
      judges: [],
      judgeUids: [],
      teamAKingdom: 0, teamBKingdom: 0,
      teamAWorkout: 0, teamBWorkout: 0,
      teamAGoalSetting: 0, teamBGoalSetting: 0,
      teamAJudges: 0, teamBJudges: 0,
      quarters: {
        q1: { home: 0, away: 0 }, q2: { home: 0, away: 0 },
        q3: { home: 0, away: 0 }, q4: { home: 0, away: 0 },
      },
      fouls: { home: [], away: [] },
      events: [],
      currentQuarter: 'Q1',
      timeRemaining: '17:00',
      isPlaying: false,
      isFavorite: false,
      updatedAt: serverTimestamp(),
    });
    console.log(`  created: ${fx.homeTeam} vs ${fx.awayTeam} — ${fx.startTime.toLocaleString()} @ ${fx.venue}`);
  }

  console.log('\nDone.');
  process.exit(0);
}

run().catch((err) => {
  console.error('Failed:', err.code || err.message);
  process.exit(1);
});
