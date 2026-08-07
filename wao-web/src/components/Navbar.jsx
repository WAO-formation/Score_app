import { useState, useEffect } from 'react';
import { Link, useLocation, useNavigate } from 'react-router-dom';
import { BRAND } from '../config/brand';

const NAV_LINKS = [
  { label: 'Home',       to: '/' },
  { label: 'About Us',   to: '/#about' },
  { label: 'How To Play', to: '/#how-to-play' },
  { label: 'Upcoming Games', to: '/#games' },
  { label: 'Contact Us', to: '/#contact' },
];

const Navbar = () => {
  const [open, setOpen] = useState(false);
  const [scrolled, setScrolled] = useState(false);
  const location = useLocation();
  const navigate = useNavigate();

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 60);
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  // Close mobile menu on route change
  useEffect(() => setOpen(false), [location]);

  // Scroll to hash after navigation
  useEffect(() => {
    if (location.hash) {
      const el = document.querySelector(location.hash);
      if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  }, [location]);

  const handleNavClick = (e, to) => {
    if (!to.includes('#')) return; // let React Router handle plain routes
    e.preventDefault();
    const [path, hash] = to.split('#');
    const targetPath = path || '/';
    if (location.pathname === targetPath) {
      // Already on the right page — just scroll
      const el = document.getElementById(hash);
      if (el) el.scrollIntoView({ behavior: 'smooth', block: 'start' });
    } else {
      // Navigate then scroll (handled by the useEffect above)
      navigate(to);
    }
  };

  const isActive = (to) => {
    if (to === '/') return location.pathname === '/' && !location.hash;
    if (to.includes('#')) return location.hash === `#${to.split('#')[1]}`;
    return location.pathname === to;
  };

  return (
    <header
      className="fixed top-0 left-0 right-0 z-50 w-full transition-all duration-300"
      style={{
        backgroundColor: scrolled ? '#fff' : 'transparent',
        boxShadow: scrolled ? '0 1px 12px rgba(0,0,0,0.08)' : 'none',
        backdropFilter: scrolled ? 'blur(12px)' : 'none',
      }}
    >
      <nav
        className="max-w-6xl mx-auto flex items-center justify-between gap-4 px-6 py-4"
        style={{ fontFamily: BRAND.font.body }}
      >
        <Link to="/" className="shrink-0">
          <img src="/assets/logo.png" alt="WAO" className="h-9 w-auto" />
        </Link>

        <ul className="hidden md:flex items-center gap-8 text-sm font-medium tracking-wide">
          {NAV_LINKS.map((link) => (
            <li key={link.label}>
              <Link
                to={link.to}
                onClick={(e) => handleNavClick(e, link.to)}
                className="uppercase pb-1 border-b-2 transition-colors duration-200"
                style={isActive(link.to)
                  ? { borderColor: BRAND.primary, color: scrolled ? BRAND.dark : '#fff' }
                  : { borderColor: 'transparent', color: scrolled ? BRAND.muted : 'rgba(255,255,255,0.75)' }
                }
              >
                {link.label}
              </Link>
            </li>
          ))}
        </ul>

        <Link
          to="/login"
          className="hidden md:inline-flex items-center px-5 py-2.5 rounded-lg text-white text-sm font-semibold uppercase tracking-wide transition-colors shrink-0"
          style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
          onMouseEnter={e => e.currentTarget.style.backgroundColor = BRAND.primaryHover}
          onMouseLeave={e => e.currentTarget.style.backgroundColor = BRAND.primary}
        >
          Join WAO
        </Link>

        <button
          onClick={() => setOpen((o) => !o)}
          aria-label="Toggle navigation menu"
          aria-expanded={open}
          className="md:hidden inline-flex flex-col justify-center items-center gap-1.5 w-9 h-9 shrink-0"
        >
          <span className={`block h-0.5 w-6 transition-all duration-300 ${open ? 'translate-y-2 rotate-45' : ''}`} style={{ backgroundColor: scrolled ? BRAND.dark : '#fff' }} />
          <span className={`block h-0.5 w-6 transition-all duration-300 ${open ? 'opacity-0' : ''}`} style={{ backgroundColor: scrolled ? BRAND.dark : '#fff' }} />
          <span className={`block h-0.5 w-6 transition-all duration-300 ${open ? '-translate-y-2 -rotate-45' : ''}`} style={{ backgroundColor: scrolled ? BRAND.dark : '#fff' }} />
        </button>
      </nav>

      {open && (
        <div
          className="md:hidden px-6 pb-5"
          style={{ backgroundColor: BRAND.dark, fontFamily: BRAND.font.body }}
        >
          <ul className="flex flex-col gap-4 text-sm font-medium tracking-wide border-t border-white/10 pt-4">
            {NAV_LINKS.map((link) => (
              <li key={link.label}>
                <Link
                  to={link.to}
                  onClick={(e) => handleNavClick(e, link.to)}
                  className="uppercase"
                  style={{ color: isActive(link.to) ? BRAND.primary : 'rgba(255,255,255,0.85)' }}
                >
                  {link.label}
                </Link>
              </li>
            ))}
          </ul>
          <Link
            to="/login"
            className="mt-5 inline-flex items-center px-5 py-2.5 rounded-lg text-white text-sm font-semibold uppercase tracking-wide"
            style={{ backgroundColor: BRAND.primary }}
          >
            Join WAO
          </Link>
        </div>
      )}
    </header>
  );
};

export default Navbar;
