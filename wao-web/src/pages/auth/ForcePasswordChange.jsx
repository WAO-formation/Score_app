import { useState } from 'react';
import { Lock, Eye, EyeOff, ShieldCheck } from 'lucide-react';
import { doc, updateDoc, serverTimestamp } from 'firebase/firestore';
import { updatePassword } from 'firebase/auth';
import { useAuth } from '../../context/AuthContext';
import { auth, db } from '../../lib/firebase';
import AuthLayout from './AuthLayout';
import { BRAND } from '../../config/brand';

const INPUT = "w-full bg-white/10 border border-white/20 text-white placeholder-white/30 rounded-sm py-3 text-sm focus:outline-none focus:border-white/50 transition";

// Shown instead of the dashboard whenever a user's Firestore doc has
// mustChangePassword: true — set on every account an admin creates with the
// shared default password (see Users.jsx). Blocks the whole app behind
// ProtectedRoute until they've set a password only they know.
export default function ForcePasswordChange() {
  const { user, refreshProfile, logout } = useAuth();
  const [form, setForm] = useState({ next: '', confirm: '' });
  const [showPw, setShowPw] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    if (form.next.length < 6) return setError('Password must be at least 6 characters.');
    if (form.next !== form.confirm) return setError('Passwords do not match.');

    setLoading(true);
    try {
      await updatePassword(auth.currentUser, form.next);
      await updateDoc(doc(db, 'users', user.uid), {
        mustChangePassword: false,
        updatedAt: serverTimestamp(),
      });
      await refreshProfile();
    } catch (err) {
      setError(
        err.code === 'auth/requires-recent-login'
          ? 'This session is too old for a password change — sign out and back in, then try again.'
          : 'Failed to set your new password. Please try again.'
      );
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout title="Set a New Password" subtitle="You're signed in with a default password — choose one only you know">
      <div className="flex items-center gap-2 mb-5 text-white/60 text-xs" style={{ fontFamily: BRAND.font.body }}>
        <ShieldCheck className="w-4 h-4 flex-shrink-0" />
        <span>Signed in as {user?.email}</span>
      </div>

      {error && (
        <div className="mb-5 px-4 py-3 bg-red-500/10 border border-red-500/30 text-red-400 text-sm rounded-sm" style={{ fontFamily: BRAND.font.body }}>
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-5">
        <div>
          <label className="block text-xs font-semibold text-white/50 uppercase tracking-widest mb-1.5" style={{ fontFamily: BRAND.font.body }}>New Password</label>
          <div className="relative">
            <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
            <input
              type={showPw ? 'text' : 'password'} required placeholder="Min. 6 characters"
              value={form.next}
              onChange={e => setForm({ ...form, next: e.target.value })}
              className={`${INPUT} pl-9 pr-10`} style={{ fontFamily: BRAND.font.body }}
            />
            <button type="button" onClick={() => setShowPw(!showPw)} className="absolute right-3 top-1/2 -translate-y-1/2 text-white/30 hover:text-white/60">
              {showPw ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
            </button>
          </div>
        </div>

        <div>
          <label className="block text-xs font-semibold text-white/50 uppercase tracking-widest mb-1.5" style={{ fontFamily: BRAND.font.body }}>Confirm Password</label>
          <div className="relative">
            <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
            <input
              type={showPw ? 'text' : 'password'} required placeholder="Repeat password"
              value={form.confirm}
              onChange={e => setForm({ ...form, confirm: e.target.value })}
              className={`${INPUT} pl-9 pr-4`} style={{ fontFamily: BRAND.font.body }}
            />
          </div>
        </div>

        <button type="submit" disabled={loading}
          className="w-full flex items-center justify-center py-3 text-sm font-semibold uppercase tracking-widest text-white transition disabled:opacity-50"
          style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
          onMouseEnter={e => { if (!loading) e.currentTarget.style.backgroundColor = BRAND.primaryHover; }}
          onMouseLeave={e => { if (!loading) e.currentTarget.style.backgroundColor = BRAND.primary; }}
        >
          {loading ? <span className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : 'Set Password & Continue'}
        </button>
      </form>

      <button onClick={logout} className="w-full text-center text-xs text-white/25 hover:text-white/50 transition mt-6" style={{ fontFamily: BRAND.font.body }}>
        Sign out instead
      </button>
    </AuthLayout>
  );
}
