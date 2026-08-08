import { Link } from 'react-router-dom';
import { BRAND } from '../../config/brand';

const FONTS = `@import url('https://fonts.googleapis.com/css2?family=Anton&family=Oswald:wght@400;500;600&display=swap');`;

const AuthLayout = ({ children, title, subtitle }) => (
  <div
    className="min-h-screen flex items-center justify-center p-4 bg-cover bg-center relative"
    style={{ backgroundImage: "url('/assets/Hero.png')" }}
  >
    <style>{FONTS}</style>
    <div className="absolute inset-0 bg-black/70" />
    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-black/40" />

    <div className="relative z-10 w-full max-w-md">
      {/* Logo */}
      <Link to="/" className="flex items-center justify-center gap-3 mb-8">
        <img src="/assets/logo.png" alt="WAO" className="h-10 w-auto" />
      </Link>

      {/* Card */}
      <div className="bg-white/5 border border-white/10 backdrop-blur-md rounded-2xl p-8 shadow-2xl">
        <h1
          className="text-2xl text-white uppercase mb-1"
          style={{ fontFamily: BRAND.font.heading }}
        >
          {title}
        </h1>
        <p
          className="text-sm text-white/50 mb-7"
          style={{ fontFamily: BRAND.font.body }}
        >
          {subtitle}
        </p>
        {children}
      </div>

      <p
        className="text-center text-xs text-white/25 mt-6"
        style={{ fontFamily: BRAND.font.body }}
      >
        WAO © {new Date().getFullYear()}
      </p>
    </div>
  </div>
);

export default AuthLayout;
