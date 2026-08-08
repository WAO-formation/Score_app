import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Mail, Lock, Eye, EyeOff } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import AuthLayout from './AuthLayout';
import { BRAND } from '../../config/brand';

const INPUT = "w-full bg-white/10 border border-white/20 text-white placeholder-white/30 rounded-sm py-3 text-sm focus:outline-none focus:border-white/50 transition";

const getError = (code) => {
  switch (code) {
    case 'auth/user-not-found':
    case 'auth/wrong-password':
    case 'auth/invalid-credential':  return 'Invalid email or password.';
    case 'auth/too-many-requests':   return 'Too many attempts. Try again later.';
    case 'auth/user-disabled':       return 'This account has been disabled.';
    case 'auth/insufficient-role':   return 'This account does not have access to the WAO portal.';
    case 'auth/popup-closed-by-user': return 'Google sign-in was cancelled.';
    default:                         return 'Something went wrong. Please try again.';
  }
};

export default function Login() {
  const { login, loginWithGoogle } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({ email: '', password: '' });
  const [showPw, setShowPw] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      const cred = await login(form.email, form.password);
      if (!cred.user.emailVerified) {
        navigate('/verify-email', { replace: true });
      } else {
        navigate('/dashboard', { replace: true });
      }
    } catch (err) {
      setError(getError(err.code));
    } finally {
      setLoading(false);
    }
  };

  const handleGoogle = async () => {
    setError('');
    setGoogleLoading(true);
    try {
      await loginWithGoogle();
      navigate('/dashboard', { replace: true });
    } catch (err) {
      setError(getError(err.code));
    } finally {
      setGoogleLoading(false);
    }
  };

  return (
    <AuthLayout title="Welcome Back" subtitle="Sign in to your WAO account">
      {error && (
        <div className="mb-5 px-4 py-3 bg-red-500/10 border border-red-500/30 text-red-400 text-sm rounded-sm" style={{ fontFamily: BRAND.font.body }}>
          {error}
        </div>
      )}

      <form onSubmit={handleSubmit} className="space-y-5">
        <div>
          <label className="block text-xs font-semibold text-white/50 uppercase tracking-widest mb-1.5" style={{ fontFamily: BRAND.font.body }}>Email</label>
          <div className="relative">
            <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
            <input type="email" required placeholder="you@wao.com" value={form.email}
              onChange={e => setForm({ ...form, email: e.target.value })}
              className={`${INPUT} pl-9 pr-4`} style={{ fontFamily: BRAND.font.body }} />
          </div>
        </div>

        <div>
          <div className="flex items-center justify-between mb-1.5">
            <label className="block text-xs font-semibold text-white/50 uppercase tracking-widest" style={{ fontFamily: BRAND.font.body }}>Password</label>
            <Link to="/forgot-password" className="text-xs font-semibold hover:underline" style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}>
              Forgot password?
            </Link>
          </div>
          <div className="relative">
            <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
            <input type={showPw ? 'text' : 'password'} required placeholder="••••••••" value={form.password}
              onChange={e => setForm({ ...form, password: e.target.value })}
              className={`${INPUT} pl-9 pr-10`} style={{ fontFamily: BRAND.font.body }} />
            <button type="button" onClick={() => setShowPw(!showPw)} className="absolute right-3 top-1/2 -translate-y-1/2 text-white/30 hover:text-white/60">
              {showPw ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
            </button>
          </div>
        </div>

        <button type="submit" disabled={loading}
          className="w-full flex items-center justify-center py-3 text-sm font-semibold uppercase tracking-widest text-white transition disabled:opacity-50"
          style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
          onMouseEnter={e => { if (!loading) e.currentTarget.style.backgroundColor = BRAND.primaryHover; }}
          onMouseLeave={e => { if (!loading) e.currentTarget.style.backgroundColor = BRAND.primary; }}
        >
          {loading ? <span className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : 'Sign In'}
        </button>
      </form>

      {/* Divider */}
      <div className="flex items-center gap-3 my-5">
        <div className="flex-1 h-px bg-white/10" />
        <span className="text-xs text-white/25 uppercase tracking-widest" style={{ fontFamily: BRAND.font.body }}>or</span>
        <div className="flex-1 h-px bg-white/10" />
      </div>

      {/* Google */}
      <button onClick={handleGoogle} disabled={googleLoading}
        className="w-full flex items-center justify-center gap-3 py-3 text-sm font-semibold text-white/80 border border-white/15 hover:border-white/30 hover:bg-white/5 transition disabled:opacity-50"
        style={{ fontFamily: BRAND.font.body }}
      >
        {googleLoading ? (
          <span className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
        ) : (
          <>
            <svg className="w-4 h-4" viewBox="0 0 24 24">
              <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
              <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
              <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l3.66-2.84z"/>
              <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
            </svg>
            Continue with Google
          </>
        )}
      </button>

      <p className="text-center text-sm text-white/40 mt-6" style={{ fontFamily: BRAND.font.body }}>
        Don't have an account?{' '}
        <Link to="/register" className="font-semibold text-white hover:underline">Register</Link>
      </p>
    </AuthLayout>
  );
}
