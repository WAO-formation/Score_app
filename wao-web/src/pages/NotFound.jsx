import { Link, useNavigate } from 'react-router-dom';
import { ArrowLeft, Home } from 'lucide-react';
import { BRAND } from '../config/brand';

const FONTS = `@import url('https://fonts.googleapis.com/css2?family=Anton&family=Oswald:wght@400;500;600&display=swap');`;

const NotFound = () => {
  const navigate = useNavigate();

  return (
    <div
      className="min-h-screen flex items-center justify-center p-6 bg-cover bg-center relative overflow-hidden"
      style={{ backgroundImage: "url('/assets/Hero.png')" }}
    >
      <style>{FONTS}</style>
      <div className="absolute inset-0 bg-black/80" />
      <div className="absolute inset-0 bg-gradient-to-t from-black via-transparent to-black/60" />

      <div className="relative z-10 text-center max-w-lg w-full">

        {/* Logo */}
        <Link to="/" className="inline-block mb-10">
          <img src="/assets/logo.png" alt="WAO" className="h-10 w-auto mx-auto" />
        </Link>

        {/* Ghost 404 */}
        <div className="relative mb-6">
          <span
            className="block select-none pointer-events-none uppercase leading-none"
            style={{
              fontFamily: BRAND.font.heading,
              fontSize: 'clamp(120px, 22vw, 220px)',
              color: 'transparent',
              WebkitTextStroke: `1px rgba(255,255,255,0.08)`,
              letterSpacing: '-0.04em',
            }}
          >
            404
          </span>
          <div className="absolute inset-0 flex flex-col items-center justify-center">
            <p
              className="text-xs font-semibold uppercase tracking-[0.3em] mb-2"
              style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}
            >
              Error · Page Not Found
            </p>
            <h1
              className="text-white uppercase text-3xl sm:text-4xl leading-tight"
              style={{ fontFamily: BRAND.font.heading }}
            >
              Out of Bounds.
            </h1>
          </div>
        </div>

        <p
          className="text-white/40 text-sm leading-relaxed max-w-sm mx-auto mb-10"
          style={{ fontFamily: BRAND.font.body }}
        >
          The page you're looking for doesn't exist or has been moved. Let's get you back in the game.
        </p>

        <div className="flex flex-col sm:flex-row items-center justify-center gap-3">
          <button
            onClick={() => navigate(-1)}
            className="flex items-center justify-center gap-2 px-6 py-3 text-sm font-semibold uppercase tracking-widest text-white border border-white/20 hover:border-white/40 hover:bg-white/5 transition w-full sm:w-auto"
            style={{ fontFamily: BRAND.font.body }}
          >
            <ArrowLeft className="w-4 h-4" /> Go Back
          </button>
          <Link
            to="/"
            className="flex items-center justify-center gap-2 px-6 py-3 text-sm font-semibold uppercase tracking-widest text-white transition w-full sm:w-auto"
            style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
            onMouseEnter={e => e.currentTarget.style.backgroundColor = BRAND.primaryHover}
            onMouseLeave={e => e.currentTarget.style.backgroundColor = BRAND.primary}
          >
            <Home className="w-4 h-4" /> Back to Home
          </Link>
        </div>

        <p className="mt-12 text-xs text-white/20" style={{ fontFamily: BRAND.font.body }}>
          WAO © {new Date().getFullYear()}
        </p>
      </div>
    </div>
  );
};

export default NotFound;
