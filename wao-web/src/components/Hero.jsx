import { useLayoutEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import gsap from 'gsap';
import { BRAND } from '../config/brand';

const Hero = () => {
  const rootRef = useRef(null);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();

    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set(['.hero-line', '.hero-sub', '.hero-cta'], {
          opacity: 0,
          y: 24,
        });
        gsap.set('.hero-bg', { scale: 1.12 });

        gsap
          .timeline({ defaults: { ease: 'power3.out' } })
          .to('.hero-bg', { scale: 1, duration: 1.8, ease: 'power2.out' }, 0)
          .to('.hero-line', { opacity: 1, y: 0, duration: 0.8, stagger: 0.12 }, 0.3)
          .to('.hero-sub', { opacity: 1, y: 0, duration: 0.7 }, 0.75)
          .to('.hero-cta', { opacity: 1, y: 0, duration: 0.6, stagger: 0.1 }, 1.0);
      }, rootRef);

      return () => ctx.revert();
    });

    return () => mm.revert();
  }, []);

  return (
    <section
      ref={rootRef}
      className="relative isolate flex min-h-dvh items-end justify-center overflow-hidden pb-16 sm:pb-20 md:pb-24"
    >
      <div
        className="hero-bg absolute inset-0 bg-cover bg-no-repeat bg-[position:25%_center] sm:bg-[position:38%_center] md:bg-center"
        style={{ backgroundImage: "url('/assets/Hero.png')" }}
      />
      <div className="absolute inset-0 bg-black/60" />
      <div
        className="absolute inset-0"
        style={{
          background:
            'radial-gradient(ellipse at center, rgba(0,0,0,0.25) 0%, rgba(0,0,0,0.78) 75%)',
        }}
      />

      <div className="relative z-10 mx-auto flex w-full max-w-3xl flex-col items-center px-6 text-center">
        <h1
          className="uppercase leading-[1.05] tracking-wide text-white text-3xl sm:text-5xl md:text-6xl lg:text-7xl drop-shadow-[0_2px_10px_rgba(0,0,0,0.85)]"
          style={{ fontFamily: BRAND.font.heading }}
        >
          <span className="hero-line block">One World. Two Balls.</span>
          <span className="hero-line block">Every Way To Score.</span>
        </h1>

        <p
          className="hero-sub mt-4 sm:mt-6 max-w-xl text-sm sm:text-base md:text-lg text-white/80 leading-relaxed"
          style={{ fontFamily: BRAND.font.body }}
        >
          WAO! is a hand-controlled contact sport played across every inch of the
          WaoSphere where every zone counts and both teams chase one score: 100%.
        </p>

        <div className="mt-6 sm:mt-8 md:mt-10 flex w-full flex-col gap-3 sm:w-auto sm:flex-row sm:justify-center">
          <Link
            to="/login"
            className="hero-cta inline-flex items-center justify-center rounded-sm px-6 py-3 text-sm font-semibold uppercase tracking-widest text-white transition"
            style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
            onMouseEnter={(e) => (e.currentTarget.style.backgroundColor = BRAND.primaryHover)}
            onMouseLeave={(e) => (e.currentTarget.style.backgroundColor = BRAND.primary)}
          >
            Join WAO
          </Link>
          <a
            href="#play"
            className="hero-cta inline-flex items-center justify-center rounded-sm border border-white/40 bg-white/10 px-6 py-3 text-sm font-semibold uppercase tracking-widest text-white backdrop-blur-sm transition hover:bg-white/20"
            style={{ fontFamily: BRAND.font.body }}
          >
            How WAO! Works
          </a>
        </div>
      </div>
    </section>
  );
};

export default Hero;
