import { useEffect, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { MailCheck, RefreshCw, LogOut } from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { auth } from '../../lib/firebase';
import AuthLayout from './AuthLayout';
import { BRAND } from '../../config/brand';

export default function VerifyEmail() {
  const { user, logout, resendVerification } = useAuth();
  const navigate = useNavigate();
  const [resent, setResent] = useState(false);
  const [error, setError] = useState('');
  const [checking, setChecking] = useState(false);

  // Poll every 4s to detect when user verifies their email
  useEffect(() => {
    const interval = setInterval(async () => {
      if (!auth.currentUser) return;
      await auth.currentUser.reload();
      if (auth.currentUser.emailVerified) {
        clearInterval(interval);
        navigate('/dashboard', { replace: true });
      }
    }, 4000);
    return () => clearInterval(interval);
  }, [navigate]);

  const handleResend = async () => {
    setError('');
    setResent(false);
    try {
      await resendVerification();
      setResent(true);
    } catch {
      setError('Failed to resend. Please try again.');
    }
  };

  const handleCheckNow = async () => {
    setChecking(true);
    try {
      await auth.currentUser?.reload();
      if (auth.currentUser?.emailVerified) {
        navigate('/dashboard', { replace: true });
      } else {
        setError('Email not verified yet. Please check your inbox.');
      }
    } finally {
      setChecking(false);
    }
  };

  const handleLogout = async () => {
    await logout();
    navigate('/login', { replace: true });
  };

  return (
    <AuthLayout title="Verify Your Email" subtitle="One last step before you play">
      <div className="text-center">
        <div className="w-16 h-16 rounded-full flex items-center justify-center mx-auto mb-5" style={{ backgroundColor: `${BRAND.primary}22` }}>
          <MailCheck className="w-8 h-8" style={{ color: BRAND.primary }} />
        </div>

        <p className="text-sm text-white/60 mb-1" style={{ fontFamily: BRAND.font.body }}>
          We sent a verification link to
        </p>
        <p className="text-white font-semibold mb-4" style={{ fontFamily: BRAND.font.body }}>
          {user?.email}
        </p>
        <p className="text-xs text-white/30 mb-8" style={{ fontFamily: BRAND.font.body }}>
          Click the link in your email to verify your account. This page will redirect automatically.
        </p>

        {resent && (
          <div className="mb-4 px-4 py-3 bg-green-500/10 border border-green-500/30 text-green-400 text-sm rounded-sm" style={{ fontFamily: BRAND.font.body }}>
            Verification email resent successfully.
          </div>
        )}
        {error && (
          <div className="mb-4 px-4 py-3 bg-red-500/10 border border-red-500/30 text-red-400 text-sm rounded-sm" style={{ fontFamily: BRAND.font.body }}>
            {error}
          </div>
        )}

        <div className="space-y-3">
          <button onClick={handleCheckNow} disabled={checking}
            className="w-full flex items-center justify-center gap-2 py-3 text-sm font-semibold uppercase tracking-widest text-white transition disabled:opacity-50"
            style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
            onMouseEnter={e => { if (!checking) e.currentTarget.style.backgroundColor = BRAND.primaryHover; }}
            onMouseLeave={e => { if (!checking) e.currentTarget.style.backgroundColor = BRAND.primary; }}
          >
            {checking ? <span className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : <><RefreshCw className="w-4 h-4" /> I've Verified My Email</>}
          </button>

          <button onClick={handleResend}
            className="w-full py-3 text-sm font-semibold uppercase tracking-widest text-white/50 border border-white/15 hover:border-white/30 hover:text-white/80 transition"
            style={{ fontFamily: BRAND.font.body }}
          >
            Resend Email
          </button>

          <button onClick={handleLogout}
            className="w-full flex items-center justify-center gap-2 py-2 text-xs text-white/25 hover:text-white/50 transition"
            style={{ fontFamily: BRAND.font.body }}
          >
            <LogOut className="w-3 h-3" /> Sign out
          </button>
        </div>
      </div>
    </AuthLayout>
  );
}
