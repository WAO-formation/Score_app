import { initializeApp } from 'firebase/app';
import { getAuth, signInWithEmailAndPassword } from 'firebase/auth';
import { getFirestore, collection, getDocs } from 'firebase/firestore';
import dotenv from 'dotenv';
dotenv.config({ path: '.env.local' });
const firebaseConfig = {
  apiKey: process.env.VITE_FIREBASE_API_KEY, authDomain: process.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId: process.env.VITE_FIREBASE_PROJECT_ID, storageBucket: process.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: process.env.VITE_FIREBASE_MESSAGING_SENDER_ID, appId: process.env.VITE_FIREBASE_APP_ID,
};
const app = initializeApp(firebaseConfig);
const auth = getAuth(app);
const db = getFirestore(app);
await signInWithEmailAndPassword(auth, 'afanyuemma2002@gmail.com', 'Wao@Admin2024!');
const snap = await getDocs(collection(db, 'news'));
console.log(`${snap.size} news doc(s)`);
snap.forEach(d => console.log(d.id, '|', d.data().title, '|', d.data().category, '|', d.data().author));
process.exit(0);
