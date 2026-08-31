import { useState } from 'react';
import { Link } from 'react-router-dom';
import { Mail, ArrowLeft, CheckCircle } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import AuthLayout from './AuthLayout';
import { BRAND } from '../../config/brand';

const INPUT = "w-full bg-white/10 border border-white/20 text-white placeholder-white/30 rounded-sm py-3 text-sm focus:outline-none focus:border-white/50 transition";

export default function ForgotPassword() {
  const { resetPassword } = useAuth();
  const [email, setEmail] = useState('');
  const [sent, setSent] = useState(false);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setLoading(true);
    try {
      await resetPassword(email);
      setSent(true);
    } catch (err) {
      setError(err.code === 'auth/user-not-found' || err.code === 'auth/invalid-email'
        ? 'No account found with this email.'
        : 'Failed to send reset email. Try again.');
    } finally {
      setLoading(false);
    }
  };

  if (sent) return (
    <AuthLayout title="Check Your Email" subtitle="A reset link has been sent">
      <div className="text-center">
        <div className="w-14 h-14 rounded-full flex items-center justify-center mx-auto mb-4" style={{ backgroundColor: `${BRAND.primary}22` }}>
          <CheckCircle className="w-7 h-7" style={{ color: BRAND.primary }} />
        </div>
        <p className="text-sm text-white/50 mb-2" style={{ fontFamily: BRAND.font.body }}>
          We sent a reset link to
        </p>
        <p className="text-white font-semibold mb-6" style={{ fontFamily: BRAND.font.body }}>{email}</p>
        <p className="text-xs text-white/30 mb-6" style={{ fontFamily: BRAND.font.body }}>
          Check your spam folder if you don't see it within a few minutes.
        </p>
        <Link to="/login"
          className="flex items-center justify-center gap-2 w-full py-3 text-sm font-semibold uppercase tracking-widest text-white transition"
          style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
        >
          <ArrowLeft className="w-4 h-4" /> Back to Sign In
        </Link>
      </div>
    </AuthLayout>
  );

  return (
    <AuthLayout title="Forgot Password" subtitle="Enter your email to receive a reset link">
      <Link to="/login" className="flex items-center gap-1.5 text-sm text-white/40 hover:text-white transition mb-6" style={{ fontFamily: BRAND.font.body }}>
        <ArrowLeft className="w-4 h-4" /> Back to Sign In
      </Link>

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
            <input type="email" required placeholder="you@wao.com" value={email}
              onChange={e => setEmail(e.target.value)}
              className={`${INPUT} pl-9 pr-4`} style={{ fontFamily: BRAND.font.body }} />
          </div>
        </div>

        <button type="submit" disabled={loading}
          className="w-full flex items-center justify-center py-3 text-sm font-semibold uppercase tracking-widest text-white transition disabled:opacity-50"
          style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
          onMouseEnter={e => { if (!loading) e.currentTarget.style.backgroundColor = BRAND.primaryHover; }}
          onMouseLeave={e => { if (!loading) e.currentTarget.style.backgroundColor = BRAND.primary; }}
        >
          {loading ? <span className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : 'Send Reset Link'}
        </button>
      </form>
    </AuthLayout>
  );
}
