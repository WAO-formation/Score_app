import { initializeApp } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import { getFirestore, collection, query, where, limit, getDocs } from 'firebase/firestore';
import dotenv from 'dotenv';

dotenv.config({ path: '.env.local' });
dotenv.config();

const firebaseConfig = {
  apiKey: process.env.VITE_FIREBASE_API_KEY,
  authDomain: process.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket: process.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId: process.env.VITE_FIREBASE_APP_ID,
};

const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);

await signInWithEmailAndPassword(auth, 'fan@wao-demo.com', 'Wao@Fan2024!');
console.log('Signed in as fan.');

try {
  const q = query(collection(db, 'teams'), where('isTopTeam', '==', true), limit(5));
  const snap = await getDocs(q);
  console.log(`getTopTeams-equivalent query succeeded: ${snap.size} doc(s)`);
  snap.forEach((d) => console.log(' -', d.id, JSON.stringify(d.data())));
} catch (err) {
  console.log('getTopTeams-equivalent query FAILED:', err.code, err.message);
}

// Also check what the plain teams collection generally looks like.
try {
  const allSnap = await getDocs(collection(db, 'teams'));
  console.log(`\nAll teams: ${allSnap.size} doc(s)`);
  allSnap.forEach((d) => {
    const data = d.data();
    console.log(` - ${d.id}: isTopTeam=${data.isTopTeam} category=${data.category} roster=${typeof data.roster} rosterKeys=${data.roster ? Object.keys(data.roster) : 'n/a'}`);
  });
} catch (err) {
  console.log('plain teams read FAILED:', err.code, err.message);
}

process.exit(0);
