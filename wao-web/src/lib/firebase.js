import { initializeApp, getApps } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { getAuth, GoogleAuthProvider } from 'firebase/auth';

const firebaseConfig = {
  apiKey:            import.meta.env.VITE_FIREBASE_API_KEY,
  authDomain:        import.meta.env.VITE_FIREBASE_AUTH_DOMAIN,
  projectId:         import.meta.env.VITE_FIREBASE_PROJECT_ID,
  storageBucket:     import.meta.env.VITE_FIREBASE_STORAGE_BUCKET,
  messagingSenderId: import.meta.env.VITE_FIREBASE_MESSAGING_SENDER_ID,
  appId:             import.meta.env.VITE_FIREBASE_APP_ID,
};

const app = initializeApp(firebaseConfig);
export const db             = getFirestore(app);
export const auth           = getAuth(app);
export const googleProvider = new GoogleAuthProvider();

// A second, independent Firebase App instance pointed at the same project.
// createUserWithEmailAndPassword always signs in as the account it just
// created on whatever Auth instance you call it on — on the primary `auth`
// that would silently kick the signed-in admin out of their own session.
// Running account creation through this instance instead keeps the admin's
// real session untouched. This is a client-side workaround; once there's a
// backend, admin.auth().createUser() in a Cloud Function replaces it.
const secondaryApp = getApps().some(a => a.name === 'secondary')
  ? getApps().find(a => a.name === 'secondary')
  : initializeApp(firebaseConfig, 'secondary');
export const secondaryAuth = getAuth(secondaryApp);
