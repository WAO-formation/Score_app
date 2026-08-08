/**
 * WAO Demo Admin Seed Script
 * -------------------------------------------------
 * Run once to create the demo admin account:
 *
 *   node scripts/seedAdmin.js
 *
 * Uses your existing .env VITE_ vars via dotenv.
 */

import { initializeApp } from 'firebase/app';
import {
  getAuth,
  createUserWithEmailAndPassword,
  signInWithEmailAndPassword,
  updateProfile,
} from 'firebase/auth';
import { getFirestore, doc, setDoc, getDoc } from 'firebase/firestore';
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

const ADMIN = {
  name:     'WAO Admin',
  email:    'afanyuemma2002@gmail.com',
  password: 'Wao@Admin2024!',
  role:     'admin',
};

async function seed() {
  const app  = initializeApp(firebaseConfig);
  const auth = getAuth(app);
  const db   = getFirestore(app);

  console.log(`\n🌱  Seeding demo admin: ${ADMIN.email}\n`);

  try {
    const cred = await createUserWithEmailAndPassword(auth, ADMIN.email, ADMIN.password);
    await updateProfile(cred.user, { displayName: ADMIN.name });
    await setDoc(doc(db, 'users', cred.user.uid), {
      displayName: ADMIN.name,
      email:       ADMIN.email,
      role:        ADMIN.role,
      createdAt:   new Date().toISOString(),
    });
    console.log('✅  Admin account created.');
    console.log(`    Email    : ${ADMIN.email}`);
    console.log(`    Password : ${ADMIN.password}`);
    console.log(`    UID      : ${cred.user.uid}`);
    console.log('\n⚠️   Change the password after first login.\n');
  } catch (err) {
    if (err.code === 'auth/email-already-in-use') {
      console.log('ℹ️   Account exists — ensuring Firestore doc has admin role...');
      const existing = await signInWithEmailAndPassword(auth, ADMIN.email, ADMIN.password);
      const snap = await getDoc(doc(db, 'users', existing.user.uid));
      await setDoc(doc(db, 'users', existing.user.uid), {
        displayName: ADMIN.name,
        email:       ADMIN.email,
        role:        ADMIN.role,
        createdAt:   snap.exists() ? snap.data().createdAt : new Date().toISOString(),
      });
      console.log('✅  Firestore doc updated to admin role.');
    } else {
      console.error('❌  Seed failed:', err.message);
    }
  }

  process.exit(0);
}

seed();
