import { createContext, useContext, useEffect, useState } from 'react';
import {
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  sendPasswordResetEmail,
  sendEmailVerification,
  signInWithPopup,
  updateProfile,
  signOut,
  onAuthStateChanged,
} from 'firebase/auth';
import { doc, getDoc, setDoc } from 'firebase/firestore';
import { auth, db, googleProvider } from '../lib/firebase';

const AuthContext = createContext(null);

const ALLOWED_ROLES = ['admin', 'moderator'];

async function loadAllowedProfile(firebaseUser) {
  const snap = await getDoc(doc(db, 'users', firebaseUser.uid));
  if (!snap.exists()) return null;
  const data = snap.data();
  if (!ALLOWED_ROLES.includes(data.role)) return null;
  return {
    uid: firebaseUser.uid,
    email: firebaseUser.email,
    emailVerified: firebaseUser.emailVerified,
    displayName: data.displayName || data.username || firebaseUser.displayName || firebaseUser.email,
    username: data.username || '',
    phone: data.phone || '',
    bio: data.bio || '',
    photoUrl: data.photoUrl || null,
    role: data.role,
    mustChangePassword: !!data.mustChangePassword,
  };
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const unsub = onAuthStateChanged(auth, async (firebaseUser) => {
      if (!firebaseUser) {
        setUser(null);
        setLoading(false);
        return;
      }
      const profile = await loadAllowedProfile(firebaseUser);
      if (!profile) {
        await signOut(auth);
        setUser(null);
      } else {
        setUser(profile);
      }
      setLoading(false);
    });
    return unsub;
  }, []);

  const login = async (email, password) => {
    const cred = await signInWithEmailAndPassword(auth, email, password);
    const profile = await loadAllowedProfile(cred.user);
    if (!profile) {
      await signOut(auth);
      throw { code: 'auth/insufficient-role' };
    }
    setUser(profile);
    return cred;
  };

  const register = async (name, email, password) => {
    const cred = await createUserWithEmailAndPassword(auth, email, password);
    await updateProfile(cred.user, { displayName: name });
    // Create Firestore user doc with default 'user' role — admin must elevate manually
    await setDoc(doc(db, 'users', cred.user.uid), {
      displayName: name,
      email,
      role: 'fan',
      createdAt: new Date().toISOString(),
    });
    await sendEmailVerification(cred.user);
    return cred;
  };

  const loginWithGoogle = async () => {
    const cred = await signInWithPopup(auth, googleProvider);
    const firebaseUser = cred.user;

    // Upsert Firestore doc if first time signing in with Google
    const snap = await getDoc(doc(db, 'users', firebaseUser.uid));
    if (!snap.exists()) {
      await setDoc(doc(db, 'users', firebaseUser.uid), {
        displayName: firebaseUser.displayName || firebaseUser.email,
        email: firebaseUser.email,
        role: 'fan',
        createdAt: new Date().toISOString(),
      });
    }

    const profile = await loadAllowedProfile(firebaseUser);
    if (!profile) {
      await signOut(auth);
      throw { code: 'auth/insufficient-role' };
    }
    setUser(profile);
    return cred;
  };

  // Re-reads the current user's Firestore doc and updates context state.
  // Call this after saving profile edits (Profile.jsx) so the sidebar/header
  // name and role badge reflect the change immediately, without waiting for
  // the next auth-state event (page refresh).
  const refreshProfile = async () => {
    if (!auth.currentUser) return;
    const profile = await loadAllowedProfile(auth.currentUser);
    if (!profile) {
      await signOut(auth);
      setUser(null);
    } else {
      setUser(profile);
    }
  };

  const logout = () => signOut(auth);

  const resetPassword = (email) => sendPasswordResetEmail(auth, email);

  const resendVerification = () => {
    if (auth.currentUser) return sendEmailVerification(auth.currentUser);
    return Promise.reject(new Error('No user logged in'));
  };

  return (
    <AuthContext.Provider value={{ user, loading, login, register, loginWithGoogle, logout, resetPassword, resendVerification, refreshProfile }}>
      {!loading && children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used inside AuthProvider');
  return ctx;
};
