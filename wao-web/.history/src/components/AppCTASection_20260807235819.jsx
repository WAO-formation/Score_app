import { useLayoutEffect, useRef } from 'react';
import { Apple, Play } from 'lucide-react';
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
          Live scores, match commentary, player stats, and your own scoreboard — all in the WAO! app. Be first to know when it drops.
        </p>

        <div className="mt-12 flex flex-col sm:flex-row items-center justify-center gap-4">
          {/* Apple */}
          <button
            className="app-badge group flex items-center gap-4 rounded-2xl px-7 py-4 w-full sm:w-auto transition-all duration-300 hover:scale-105"
            style={{ background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.15)', backdropFilter: 'blur(8px)' }}
          >
            <Apple className="h-8 w-8 text-white shrink-0" strokeWidth={1.5} />
            <div className="text-left">
              <p className="text-[10px] uppercase tracking-widest" style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.45)' }}>
                Download on the
              </p>
              <p className="text-lg uppercase" style={{ fontFamily: BRAND.font.heading, color: '#fff' }}>
                App Store
              </p>
            </div>
          </button>

          {/* Android */}
          <button
            className="app-badge group flex items-center gap-4 rounded-2xl px-7 py-4 w-full sm:w-auto transition-all duration-300 hover:scale-105"
            style={{ background: 'rgba(255,255,255,0.07)', border: '1px solid rgba(255,255,255,0.15)', backdropFilter: 'blur(8px)' }}
          >
            <Play className="h-8 w-8 text-white shrink-0" strokeWidth={1.5} />
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
