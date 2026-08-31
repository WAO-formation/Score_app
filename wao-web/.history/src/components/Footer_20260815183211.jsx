import { useLayoutEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const NAV = [
  { label: 'Home',          to: '/' },
  { label: 'About',         to: '/#about' },
  { label: 'How To Play',   to: '/#how-to-play' },
  { label: 'Upcoming Games', to: '/#games' },
  { label: 'Contact',       to: '/#contact' },
];

const scrollTo = (to) => {
  const hash = to.split('#')[1];
  if (!hash) { window.scrollTo({ top: 0, behavior: 'smooth' }); return; }
  document.getElementById(hash)?.scrollIntoView({ behavior: 'smooth', block: 'start' });
};

const SOCIALS = [
  {
    label: 'Instagram',
    href: '#',
    icon: (
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round" className="h-4 w-4">
        <rect x="2" y="2" width="20" height="20" rx="5" ry="5" />
        <circle cx="12" cy="12" r="4" />
        <circle cx="17.5" cy="6.5" r="0.5" fill="currentColor" stroke="none" />
      </svg>
    ),
  },
  {
    label: 'X / Twitter',
    href: '#',
    icon: (
      <svg viewBox="0 0 24 24" fill="currentColor" className="h-4 w-4">
        <path d="M18.244 2.25h3.308l-7.227 8.26 8.502 11.24H16.17l-5.214-6.817L4.99 21.75H1.68l7.73-8.835L1.254 2.25H8.08l4.713 6.231zm-1.161 17.52h1.833L7.084 4.126H5.117z" />
      </svg>
    ),
  },
  {
    label: 'Facebook',
    href: '#',
    icon: (
      <svg viewBox="0 0 24 24" fill="currentColor" className="h-4 w-4">
        <path d="M24 12.073C24 5.405 18.627 0 12 0S0 5.405 0 12.073C0 18.1 4.388 23.094 10.125 24v-8.437H7.078v-3.49h3.047V9.41c0-3.025 1.792-4.697 4.533-4.697 1.312 0 2.686.236 2.686.236v2.97h-1.513c-1.491 0-1.956.93-1.956 1.886v2.267h3.328l-.532 3.49h-2.796V24C19.612 23.094 24 18.1 24 12.073z" />
      </svg>
    ),
  },
  {
    label: 'YouTube',
    href: '#',
    icon: (
      <svg viewBox="0 0 24 24" fill="currentColor" className="h-4 w-4">
        <path d="M23.498 6.186a3.016 3.016 0 0 0-2.122-2.136C19.505 3.545 12 3.545 12 3.545s-7.505 0-9.377.505A3.017 3.017 0 0 0 .502 6.186C0 8.07 0 12 0 12s0 3.93.502 5.814a3.016 3.016 0 0 0 2.122 2.136c1.871.505 9.376.505 9.376.505s7.505 0 9.377-.505a3.015 3.015 0 0 0 2.122-2.136C24 15.93 24 12 24 12s0-3.93-.502-5.814zM9.545 15.568V8.432L15.818 12l-6.273 3.568z" />
      </svg>
    ),
  },
];

const Footer = () => {
  const rootRef = useRef(null);
  const year = new Date().getFullYear();

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();
    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        // Ghost headline: slow horizontal drift scrubbed to scroll
        gsap.to('.footer-ghost', {
          xPercent: -6,
          ease: 'none',
          scrollTrigger: {
            trigger: rootRef.current,
            start: 'top bottom',
            end: 'bottom top',
            scrub: 1.5,
          },
        });

        // Grid columns: staggered fade-up
        gsap.set('.footer-col', { opacity: 0, y: 36 });
        gsap.to('.footer-col', {
          opacity: 1,
          y: 0,
          duration: 0.75,
          stagger: 0.1,
          ease: 'power3.out',
          scrollTrigger: { trigger: '.footer-grid', start: 'top 88%' },
        });
      }, rootRef);
      return () => ctx.revert();
    });
    return () => mm.revert();
  }, []);

  return (
    <footer ref={rootRef} style={{ backgroundColor: BRAND.ink }} className="w-full overflow-hidden">
      {/* Top bar — ghost headline */}
      <div
        className="border-b px-6 py-14 sm:px-12 lg:px-24"
        style={{ borderColor: 'rgba(255,255,255,0.07)' }}
      >
        <div className="mx-auto max-w-6xl text-center">
          <h2
            className="footer-ghost text-5xl uppercase leading-none sm:text-7xl lg:text-8xl"
            style={{
              fontFamily: BRAND.font.heading,
              color: 'transparent',
              WebkitTextStroke: '1px rgba(255,255,255,0.18)',
            }}
          >
            Let&apos;s Play WAO!
          </h2>
        </div>
      </div>

      {/* Main grid */}
      <div className="footer-grid mx-auto max-w-6xl px-6 py-14 sm:px-12 lg:px-24">
        <div className="grid grid-cols-2 gap-10 sm:grid-cols-4">
          {/* Brand */}
          <div className="footer-col col-span-2 sm:col-span-1">
            <Link to="/" className="inline-block">
              <img src="/assets/logo.png" alt="WAO!" className="h-9 w-auto" />
            </Link>
            <p
              className="mt-4 text-sm leading-relaxed"
              style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.4)' }}
            >
              A two-ball, hand-controlled sport born in Accra, Ghana built to champion world oneness through sport.
            </p>
            <Link
              to="/login"
              className="mt-5 inline-block rounded-full px-5 py-2 text-xs font-semibold uppercase tracking-widest transition-all duration-300 hover:opacity-90"
              style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary, color: '#fff' }}
            >
              Join WAO
            </Link>
          </div>

          {/* Nav */}
          <div className="footer-col col-span-2 sm:col-span-1">
            <p
              className="text-[10px] font-semibold uppercase tracking-[0.3em]"
              style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.3)' }}
            >
              Explore
            </p>
            <ul className="mt-5 flex flex-col gap-3">
              {NAV.map((l) => (
                <li key={l.label}>
                  <Link
                    to={l.to}
                    onClick={(e) => { e.preventDefault(); scrollTo(l.to); }}
                    className="text-sm transition-colors duration-200 hover:text-white"
                    style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.6)' }}
                  >
                    {l.label}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          {/* Contact */}
          <div className="footer-col col-span-2 sm:col-span-1">
            <p
              className="text-[10px] font-semibold uppercase tracking-[0.3em]"
              style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.3)' }}
            >
              Contact
            </p>
            <ul className="mt-5 flex flex-col gap-3">
              <li>
                <a
                  href="tel:+233242786261"
                  className="text-sm transition-colors duration-200 hover:text-white"
                  style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.6)' }}
                >
                  +233 24 278 6261
                </a>
              </li>
              <li
                className="text-sm leading-relaxed"
                style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.6)' }}
              >
                Cornerstone Baptist Church Court,<br />Dome, Accra
              </li>
            </ul>
          </div>

          {/* App download */}
          <div className="footer-col col-span-2">
            <p
              className="text-[10px] font-semibold uppercase tracking-[0.3em]"
              style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.3)' }}
            >
              Get the App
            </p>
            <div className="mt-5 flex flex-col gap-3 sm:flex-row">
              <button
                className="flex items-center gap-3 rounded-xl px-5 py-3 transition-all duration-300 hover:scale-105"
                style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)' }}
              >
                <svg className="h-6 w-6 shrink-0" viewBox="0 0 24 24" fill="white">
                  <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
                </svg>
                <div className="text-left">
                  <p className="text-[9px] uppercase tracking-widest" style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.4)' }}>
                    Download on the
                  </p>
                  <p className="text-sm uppercase" style={{ fontFamily: BRAND.font.heading, color: '#fff' }}>
                    App Store
                  </p>
                </div>
              </button>

              <button
                className="flex items-center gap-3 rounded-xl px-5 py-3 transition-all duration-300 hover:scale-105"
                style={{ background: 'rgba(255,255,255,0.06)', border: '1px solid rgba(255,255,255,0.12)' }}
              >
                <svg className="h-6 w-6 shrink-0" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path d="M3.18 23.76c.3.17.64.24.99.2l12.6-7.27-2.72-2.72-10.87 9.79z" fill="#EA4335" />
                  <path d="M21.37 10.34l-2.8-1.62-3.07 2.74 3.07 3.07 2.82-1.63c.8-.46.8-1.7-.02-2.56z" fill="#FBBC04" />
                  <path d="M2.17.54C1.8.76 1.55 1.17 1.55 1.7v20.6c0 .53.25.94.62 1.16l.1.06 11.54-11.54v-.27L2.27.48l-.1.06z" fill="#4285F4" />
                  <path d="M16.77 15.69l-3.06-3.07v-.27l3.06-3.06 3.06 1.77-3.06 4.63z" fill="#34A853" />
                </svg>
                <div className="text-left">
                  <p className="text-[9px] uppercase tracking-widest" style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.4)' }}>
                    Get it on
                  </p>
                  <p className="text-sm uppercase" style={{ fontFamily: BRAND.font.heading, color: '#fff' }}>
                    Google Play
                  </p>
                </div>
              </button>
            </div>
          </div>
        </div>
      </div>

      {/* Bottom bar */}
      <div
        className="border-t px-6 py-6 sm:px-12 lg:px-24"
        style={{ borderColor: 'rgba(255,255,255,0.07)' }}
      >
        <div className="mx-auto flex max-w-6xl flex-col items-center justify-between gap-4 sm:flex-row">
          <p
            className="text-xs"
            style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.3)' }}
          >
            &copy; {year} Waoherds Limited. All rights reserved.
          </p>

          <div className="flex items-center gap-4">
            {SOCIALS.map((s) => (
              <a
                key={s.label}
                href={s.href}
                aria-label={s.label}
                className="flex h-8 w-8 items-center justify-center rounded-full transition-all duration-200 hover:scale-110"
                style={{ background: 'rgba(255,255,255,0.07)', color: 'rgba(255,255,255,0.5)' }}
                onMouseEnter={(e) => (e.currentTarget.style.color = '#fff')}
                onMouseLeave={(e) => (e.currentTarget.style.color = 'rgba(255,255,255,0.5)')}
              >
                {s.icon}
              </a>
            ))}
          </div>

          <p
            className="text-xs uppercase tracking-widest"
            style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.2)' }}
          >
            Est. 2012 &middot; Accra, Ghana
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;
