import { useState } from 'react';
import { Link } from 'react-router-dom';
import { BRAND } from '../config/brand';

const NAV_LINKS = [
  { label: 'Home', to: '/', active: true },
  { label: 'Games', to: '/games' },
  { label: 'About Us', to: '/about' },
  { label: 'How To Play', to: '/how-to-play' },
  { label: 'Contact Us', to: '/contact' },
];

const Navbar = () => {
  const [open, setOpen] = useState(false);

  return (
    <header className="absolute top-0 left-0 right-0 z-20 w-full px-4 sm:px-6 pt-5">
      <nav
        className="max-w-6xl mx-auto flex items-center justify-between gap-4 px-4 sm:px-6 py-3 rounded-xl bg-white/15 backdrop-blur-md border border-white/25 shadow-lg shadow-black/20"
        style={{ fontFamily: BRAND.font.body }}
      >
        <Link to="/" className="shrink-0">
          <img src="/assets/logo.png" alt="WAO" className="h-9 w-auto" />
        </Link>

        <ul className="hidden md:flex items-center gap-8 text-sm font-medium tracking-wide text-white">
          {NAV_LINKS.map((link) => (
            <li key={link.label}>
              <Link
                to={link.to}
                className="uppercase pb-1 border-b-2 transition-colors"
                style={link.active
                  ? { borderColor: BRAND.primary, color: '#fff' }
                  : { borderColor: 'transparent', color: 'rgba(255,255,255,0.85)' }
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
          <span className={`block h-0.5 w-6 bg-white transition-transform ${open ? 'translate-y-2 rotate-45' : ''}`} />
          <span className={`block h-0.5 w-6 bg-white transition-opacity ${open ? 'opacity-0' : ''}`} />
          <span className={`block h-0.5 w-6 bg-white transition-transform ${open ? '-translate-y-2 -rotate-45' : ''}`} />
        </button>
      </nav>

      {open && (
        <div className="md:hidden max-w-6xl mx-auto mt-2 px-4 py-4 rounded-xl bg-black/80 backdrop-blur-md border border-white/15" style={{ fontFamily: BRAND.font.body }}>
          <ul className="flex flex-col gap-4 text-sm font-medium tracking-wide">
            {NAV_LINKS.map((link) => (
              <li key={link.label}>
                <Link
                  to={link.to}
                  className="uppercase"
                  style={{ color: link.active ? BRAND.primary : 'rgba(255,255,255,0.85)' }}
                  onClick={() => setOpen(false)}
                >
                  {link.label}
                </Link>
              </li>
            ))}
          </ul>
          <Link
            to="/login"
            className="mt-4 inline-flex items-center px-5 py-2.5 rounded-lg text-white text-sm font-semibold uppercase tracking-wide transition-colors"
            style={{ backgroundColor: BRAND.primary }}
            onClick={() => setOpen(false)}
          >
            Join WAO
          </Link>
        </div>
      )}
    </header>
  );
};

export default Navbar;
