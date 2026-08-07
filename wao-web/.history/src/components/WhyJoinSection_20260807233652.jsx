import { useLayoutEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const REASONS = [
  {
    title: 'Every Skill Counts',
    desc: 'Four scoring zones mean speed, stamina, strategy, and showmanship all matter — there’s a role for every kind of athlete.',
  },
  {
    title: 'No Experience Required',
    desc: 'Clinics are built for first-timers. Show up, learn the basics, and you’re playing within your first session.',
  },
  {
    title: 'More Than A Match',
    desc: 'Sacrifice plays, Goal-Setting swings, Hi-Court appeals — every game is a story. You’re not just competing, you’re performing.',
  },
  {
    title: 'A Real Community',
    desc: 'Train and play alongside a growing circle of teams across Accra — not just a name on a scoreboard.',
  },
  {
    title: 'Be Part Of The Origin Story',
    desc: 'WAO! is still young. The players training today are shaping how the sport is played for the next generation.',
  },
  {
    title: 'Ghanaian-Born, World-Bound',
    desc: 'Join a sport built from scratch in Accra with a vision to go global — and say you were part of it from the start.',
  },
];

const WhyJoinSection = () => {
  const rootRef = useRef(null);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();

    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set(['.wj-eyebrow', '.wj-title', '.wj-sub'], { opacity: 0, y: 22 });
        gsap
          .timeline({
            defaults: { ease: 'power3.out' },
            scrollTrigger: { trigger: rootRef.current, start: 'top 70%' },
          })
          .to('.wj-eyebrow', { opacity: 1, y: 0, duration: 0.6 })
          .to('.wj-title', { opacity: 1, y: 0, duration: 0.7 }, '-=0.35')
          .to('.wj-sub', { opacity: 1, y: 0, duration: 0.6 }, '-=0.35');

        gsap.set('.wj-reason', { opacity: 0, y: 24 });
        gsap.to('.wj-reason', {
          opacity: 1,
          y: 0,
          duration: 0.6,
          stagger: 0.08,
          ease: 'power3.out',
          scrollTrigger: { trigger: '.wj-reasons', start: 'top 80%' },
        });

        gsap.set('.wj-cta', { opacity: 0, y: 22 });
        gsap.to('.wj-cta', {
          opacity: 1,
          y: 0,
          duration: 0.5,
          stagger: 0.1,
          ease: 'power3.out',
          scrollTrigger: { trigger: '.wj-cta', start: 'top 90%' },
        });
      }, rootRef);

      return () => ctx.revert();
    });

    return () => mm.revert();
  }, []);

  return (
    <section
      ref={rootRef}
      className="relative w-full overflow-hidden px-6 py-24 sm:py-32 text-center"
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
      {/* Glow */}
      <div
        className="absolute inset-0"
        style={{
          background: `radial-gradient(ellipse 55% 40% at 50% 10%, ${BRAND.primary}3d, transparent 70%)`,
        }}
      />

      <div className="relative z-10 mx-auto max-w-2xl">
        <p
          className="wj-eyebrow text-xs font-semibold uppercase tracking-[0.3em]"
          style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.5)' }}
        >
          Why Join WAO!
        </p>
        <h2
          className="wj-title mt-4 text-4xl uppercase leading-[1.05] text-white sm:text-5xl md:text-6xl"
          style={{ fontFamily: BRAND.font.heading }}
        >
          Not A Sport You Watch.
          <br />One You Join.
        </h2>
        <p
          className="wj-sub mx-auto mt-6 max-w-lg text-base leading-relaxed sm:text-lg"
          style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.65)' }}
        >
          WAO! clinics are open to anyone ready to compete, perform, and belong
          to something bigger than a scoreline.
        </p>
      </div>

      {/* Reasons grid */}
      <div className="wj-reasons relative z-10 mx-auto mt-16 grid max-w-5xl grid-cols-1 gap-4 text-left sm:grid-cols-2 lg:grid-cols-3">
        {REASONS.map((reason, i) => (
          <div
            key={reason.title}
            className="wj-reason rounded-2xl border p-6"
            style={{ borderColor: 'rgba(255,255,255,0.1)', backgroundColor: 'rgba(255,255,255,0.03)' }}
          >
            <span
              className="text-sm"
              style={{ fontFamily: BRAND.font.heading, color: BRAND.primary }}
            >
              {String(i + 1).padStart(2, '0')}
            </span>
            <h3
              className="mt-3 text-lg uppercase text-white"
              style={{ fontFamily: BRAND.font.heading }}
            >
              {reason.title}
            </h3>
            <p
              className="mt-2 text-sm leading-relaxed"
              style={{ fontFamily: BRAND.font.body, color: 'rgba(255,255,255,0.6)' }}
            >
              {reason.desc}
            </p>
          </div>
        ))}
      </div>

      <div className="relative z-10 mt-14 flex flex-wrap items-center justify-center gap-4">
        <Link
          to="/login"
          className="wj-cta inline-flex items-center justify-center rounded-sm px-8 py-4 text-sm font-semibold uppercase tracking-widest text-white transition"
          style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
          onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = BRAND.primaryHover)}
          onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = BRAND.primary)}
        >
          Join WAO
        </Link>
        
      </div>
    </section>
  );
};

export default WhyJoinSection;
