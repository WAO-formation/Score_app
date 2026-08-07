import { useLayoutEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const CtaSection = () => {
  const rootRef = useRef(null);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();
    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        // Parallax bg
        gsap.to('.cta-bg', {
          yPercent: 15,
          ease: 'none',
          scrollTrigger: { trigger: rootRef.current, start: 'top bottom', end: 'bottom top', scrub: true },
        });

        // Clip-path wipe on eyebrow + heading
        gsap.set(['.cta-eyebrow', '.cta-heading'], { clipPath: 'inset(100% 0% 0% 0%)' });
        gsap.set('.cta-btn', { opacity: 0, scale: 0.9 });

        gsap
          .timeline({ defaults: { ease: 'power4.out' }, scrollTrigger: { trigger: rootRef.current, start: 'top 70%' } })
          .to('.cta-eyebrow', { clipPath: 'inset(0% 0% 0% 0%)', duration: 0.7 })
          .to('.cta-heading', { clipPath: 'inset(0% 0% 0% 0%)', duration: 0.9 }, '-=0.4')
          .to('.cta-btn',     { opacity: 1, scale: 1, duration: 0.6, ease: 'back.out(1.6)' }, '-=0.3');
      }, rootRef);
      return () => ctx.revert();
    });
    return () => mm.revert();
  }, []);

  return (
    <section
      ref={rootRef}
      className="relative w-full min-h-[60vh] flex items-center justify-center overflow-hidden bg-black"
    >
      <div
        className="cta-bg absolute inset-0 bg-cover bg-center bg-no-repeat"
        style={{ backgroundImage: "url('/assets/card-carosel8.png')" }}
      />
      <div className="absolute inset-0 bg-black/85" />
      <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-black/40" />

      <div className="relative z-10 text-center px-6 max-w-3xl mx-auto">
        <p
          className="cta-eyebrow text-xs font-semibold uppercase tracking-[0.3em] text-white/70"
          style={{ fontFamily: BRAND.font.body }}
        >
          Kingdom &middot; Workout &middot; Goalpost &middot; Hi-Court
        </p>

        <h2
          className="cta-heading mt-3 text-white uppercase leading-[1.05] text-3xl sm:text-4xl md:text-5xl drop-shadow-[0_2px_8px_rgba(0,0,0,0.8)]"
          style={{ fontFamily: BRAND.font.heading }}
        >
          Learn how WAO! is won.
        </h2>

        <a
          href="#how-to-play"
          onClick={(e) => { e.preventDefault(); document.getElementById('how-to-play')?.scrollIntoView({ behavior: 'smooth', block: 'start' }); }}
          className="cta-btn mt-10 inline-flex items-center justify-center px-8 py-4 text-sm rounded-sm font-semibold uppercase tracking-widest text-white transition cursor-pointer"
          style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
          onMouseEnter={e => e.currentTarget.style.backgroundColor = BRAND.primaryHover}
          onMouseLeave={e => e.currentTarget.style.backgroundColor = BRAND.primary}
        >
          See How It&apos;s Won
        </a>
      </div>
    </section>
  );
};

export default CtaSection;
