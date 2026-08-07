import { useLayoutEffect, useRef } from 'react';
import { Apple, Play } from 'lucide-react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const STORE_BADGES = [
  { key: 'ios', Icon: Apple, eyebrow: 'Coming soon to the', label: 'App Store' },
  { key: 'android', Icon: Play, eyebrow: 'Coming soon on', label: 'Google Play' },
];

const AppDownloadSection = () => {
  const rootRef = useRef(null);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();

    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set(['.app-copy', '.app-badge'], { opacity: 0, y: 24 });

        gsap
          .timeline({
            defaults: { ease: 'power3.out' },
            scrollTrigger: { trigger: rootRef.current, start: 'top 75%' },
          })
          .to('.app-copy', { opacity: 1, y: 0, duration: 0.7, stagger: 0.1 })
          .to('.app-badge', { opacity: 1, y: 0, duration: 0.5, stagger: 0.12 }, '-=0.3');
      }, rootRef);

      return () => ctx.revert();
    });

    return () => mm.revert();
  }, []);

  return (
    <section
      ref={rootRef}
      className="w-full px-6 py-20 text-center"
      style={{ backgroundColor: BRAND.dark }}
    >
      <p
        className="app-copy text-xs font-semibold uppercase tracking-[0.3em]"
        style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}
      >
        Coming Soon
      </p>

      <h2
        className="app-copy mx-auto mt-3 max-w-xl text-3xl uppercase leading-[1.05] text-white sm:text-4xl md:text-5xl"
        style={{ fontFamily: BRAND.font.heading }}
      >
        WAO! In Your Pocket
      </h2>

      <p
        className="app-copy mx-auto mt-5 max-w-md text-base text-white/65"
        style={{ fontFamily: BRAND.font.body }}
      >
        Follow scores, teams, and schedules on the go. The WAO! app is on its
        way to iOS and Android.
      </p>

      <div className="mt-10 flex flex-wrap items-center justify-center gap-4">
        {STORE_BADGES.map(({ key, Icon, eyebrow, label }) => (
          <div
            key={key}
            className="app-badge flex items-center gap-3 rounded-xl border border-white/15 bg-white/5 px-5 py-3 text-left"
          >
            <Icon className="h-7 w-7 text-white/80" strokeWidth={1.5} />
            <div>
              <p
                className="text-[10px] uppercase tracking-wide text-white/50"
                style={{ fontFamily: BRAND.font.body }}
              >
                {eyebrow}
              </p>
              <p
                className="text-sm font-semibold text-white"
                style={{ fontFamily: BRAND.font.body }}
              >
                {label}
              </p>
            </div>
          </div>
        ))}
      </div>
    </section>
  );
};

export default AppDownloadSection;
