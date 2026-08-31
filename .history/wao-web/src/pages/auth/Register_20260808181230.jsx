import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Mail, Lock, Eye, EyeOff, User } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import AuthLayout from './AuthLayout';
import { BRAND } from '../../config/brand';

const INPUT = "w-full bg-white/10 border border-white/20 text-white placeholder-white/30 rounded-sm py-3 text-sm focus:outline-none focus:border-white/50 transition";

const getError = (code) => {
  switch (code) {
    case 'auth/email-already-in-use': return 'An account with this email already exists.';
    case 'auth/invalid-email':        return 'Please enter a valid email address.';
    case 'auth/weak-password':        return 'Password must be at least 6 characters.';
    default:                          return 'Registration failed. Please try again.';
  }
};

export default function Register() {
  const { register } = useAuth();
  const navigate = useNavigate();
  const [form, setForm] = useState({ name: '', email: '', password: '', confirm: '' });
  const [showPw, setShowPw] = useState(false);
  const [showConfirm, setShowConfirm] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const set = (key) => (e) => setForm({ ...form, [key]: e.target.value });

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    if (form.password !== form.confirm) return setError('Passwords do not match.');
    setLoading(true);
    try {
      await register(form.name, form.email, form.password);
      navigate('/verify-email', { replace: true });
    } catch (err) {
      setError(getError(err.code));
    } finally {
      setLoading(false);
    }
  };

  return (
    <AuthLayout title="Create Account" subtitle="Join WAO and start controlli">
      {error && (
        <div className="mb-5 px-4 py-3 bg-red-500/10 border border-red-500/30 text-red-400 text-sm rounded-sm" style={{ fontFamily: BRAND.font.body }}>
          {error}
        </div>
      )}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-xs font-semibold text-white/50 uppercase tracking-widest mb-1.5" style={{ fontFamily: BRAND.font.body }}>Full Name</label>
          <div className="relative">
            <User className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
            <input type="text" required placeholder="John Doe" value={form.name} onChange={set('name')}
              className={`${INPUT} pl-9 pr-4`} style={{ fontFamily: BRAND.font.body }} />
          </div>
        </div>

        <div>
          <label className="block text-xs font-semibold text-white/50 uppercase tracking-widest mb-1.5" style={{ fontFamily: BRAND.font.body }}>Email</label>
          <div className="relative">
            <Mail className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
            <input type="email" required placeholder="you@wao.com" value={form.email} onChange={set('email')}
              className={`${INPUT} pl-9 pr-4`} style={{ fontFamily: BRAND.font.body }} />
          </div>
        </div>

        <div>
          <label className="block text-xs font-semibold text-white/50 uppercase tracking-widest mb-1.5" style={{ fontFamily: BRAND.font.body }}>Password</label>
          <div className="relative">
            <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
            <input type={showPw ? 'text' : 'password'} required placeholder="Min. 6 characters" value={form.password} onChange={set('password')}
              className={`${INPUT} pl-9 pr-10`} style={{ fontFamily: BRAND.font.body }} />
            <button type="button" onClick={() => setShowPw(!showPw)} className="absolute right-3 top-1/2 -translate-y-1/2 text-white/30 hover:text-white/60">
              {showPw ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
            </button>
          </div>
        </div>

        <div>
          <label className="block text-xs font-semibold text-white/50 uppercase tracking-widest mb-1.5" style={{ fontFamily: BRAND.font.body }}>Confirm Password</label>
          <div className="relative">
            <Lock className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-white/30" />
            <input type={showConfirm ? 'text' : 'password'} required placeholder="Repeat password" value={form.confirm} onChange={set('confirm')}
              className={`${INPUT} pl-9 pr-10`} style={{ fontFamily: BRAND.font.body }} />
            <button type="button" onClick={() => setShowConfirm(!showConfirm)} className="absolute right-3 top-1/2 -translate-y-1/2 text-white/30 hover:text-white/60">
              {showConfirm ? <EyeOff className="w-4 h-4" /> : <Eye className="w-4 h-4" />}
            </button>
          </div>
        </div>

        <button type="submit" disabled={loading}
          className="w-full flex items-center justify-center py-3 text-sm font-semibold uppercase tracking-widest text-white transition disabled:opacity-50 mt-2"
          style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
          onMouseEnter={e => { if (!loading) e.currentTarget.style.backgroundColor = BRAND.primaryHover; }}
          onMouseLeave={e => { if (!loading) e.currentTarget.style.backgroundColor = BRAND.primary; }}
        >
          {loading ? <span className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : 'Create Account'}
        </button>
      </form>

      <p className="text-center text-sm text-white/40 mt-6" style={{ fontFamily: BRAND.font.body }}>
        Already have an account?{' '}
        <Link to="/login" className="font-semibold text-white hover:underline">Sign In</Link>
      </p>
    </AuthLayout>
  );
}
