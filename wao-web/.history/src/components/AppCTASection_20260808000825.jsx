import { useLayoutEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const AppCTASection = () => {
  const rootRef = useRef(null);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();
    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set(['.app-eyebrow', '.app-title', '.app-sub', '.app-badge'], { opacity: 0, y: 24 });
        gsap
          .timeline({ defaults: { ease: 'power3.out' }, scrollTrigger: { trigger: rootRef.current, start: 'top 75%' } })
          .to('.app-eyebrow', { opacity: 1, y: 0, duration: 0.6 })
          .to('.app-title',   { opacity: 1, y: 0, duration: 0.7 }, '-=0.35')
          .to('.app-sub',     { opacity: 1, y: 0, duration: 0.6 }, '-=0.35')
          .to('.app-badge',   { opacity: 1, y: 0, duration: 0.5, stagger: 0.12 }, '-=0.25');
      }, rootRef);
      return () => ctx.revert();
    });
    return () => mm.revert();
  }, []);

  return (
    <section
      ref={rootRef}
      className="relative overflow-hidden px-6 py-12 text-center rounded-3xl mx-6 sm:mx-12 lg:mx-24 my-12"
      style={{ backgroundColor: BRAND.ink }}
    >
      {/* Grid pattern */}
      <div
        className="absolute inset-0"
        style={{
          backgroundImage:
            'linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px)',
          backgroundSize: '44px 44px',
          maskImage: 'radial-gradient(ellipse 65% 55% at 50% 20%, black 40%, transparent 100%)',
          WebkitMaskImage: 'radial-gradient(ellipse 65% 55% at 50% 20%, black 40%, transparent 100%)',
        }}
      />
      {/* Red glow */}
      <div
        className="absolute inset-0"
        style={{ background: `radial-gradient(ellipse 55% 40% at 50% 10%, ${BRAND.primary}3d, transparent 70%)` }}
      />

      <div className="relative z-10 mx-auto max-w-2xl">
        <p
          className="app-eyebrow text-xs font-semibold uppercase tracking-[0.3em]"
          style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.5)' }}
        >
          WAO in your pocket
        </p>

        <h2
          className="app-title mt-4 text-4xl uppercase leading-[1.05] text-white sm:text-5xl md:text-6xl"
          style={{ fontFamily: BRAND.font.heading }}
        >
          Take WAO!<br />Everywhere You Go
        </h2>

        <p
          className="app-sub mx-auto mt-6 max-w-md text-base leading-relaxed"
          style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.6)' }}
        >
         Follow. Learn. Experience. Get live scores, team updates, match news, and everything WAO! in one powerful app.
        </p>

        <div className="mt-12 flex flex-col sm:flex-row items-center justify-center gap-4">
          {/* Apple App Store */}
          <button
            className="app-badge group flex items-center gap-4 rounded-2xl px-7 py-2 w-full sm:w-auto transition-all duration-300 hover:scale-105"
            style={{ background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.15)', backdropFilter: 'blur(8px)' }}
          >
            <svg className="h-8 w-8 shrink-0" viewBox="0 0 24 24" fill="white" xmlns="http://www.w3.org/2000/svg">
              <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.8-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M13 3.5c.73-.83 1.94-1.46 2.94-1.5.13 1.17-.34 2.35-1.04 3.19-.69.85-1.83 1.51-2.95 1.42-.15-1.15.41-2.35 1.05-3.11z" />
            </svg>
            <div className="text-left">
              <p className="text-[10px] uppercase tracking-widest" style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.45)' }}>
                Download on the
              </p>
              <p className="text-lg uppercase" style={{ fontFamily: BRAND.font.heading, color: '#fff' }}>
                Apple Store
              </p>
            </div>
          </button>

          {/* Google Play */}
          <button
            className="app-badge group flex items-center gap-4 rounded-2xl px-7 py-4 w-full sm:w-auto transition-all duration-300 hover:scale-105"
            style={{ background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.15)', backdropFilter: 'blur(8px)' }}
          >
            <svg className="h-8 w-8 shrink-0" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path d="M3.18 23.76c.3.17.64.24.99.2l12.6-7.27-2.72-2.72-10.87 9.79z" fill="#EA4335"/>
              <path d="M21.37 10.34l-2.8-1.62-3.07 2.74 3.07 3.07 2.82-1.63c.8-.46.8-1.7-.02-2.56z" fill="#FBBC04"/>
              <path d="M2.17.54C1.8.76 1.55 1.17 1.55 1.7v20.6c0 .53.25.94.62 1.16l.1.06 11.54-11.54v-.27L2.27.48l-.1.06z" fill="#4285F4"/>
              <path d="M16.77 15.69l-3.06-3.07v-.27l3.06-3.06 3.06 1.77-3.06 4.63z" fill="#34A853"/>
            </svg>
            <div className="text-left">
              <p className="text-[10px] uppercase tracking-widest" style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.45)' }}>
                Get it on
              </p>
              <p className="text-lg uppercase" style={{ fontFamily: BRAND.font.heading, color: '#fff' }}>
                Google Play
              </p>
            </div>
          </button>
        </div>

        {/* Divider hint */}
        <p
          className="app-sub mt-10 text-xs uppercase tracking-widest"
          style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.25)' }}
        >
          Available soon on iOS &amp; Android
        </p>
      </div>
    </section>
  );
};

export default AppCTASection;
