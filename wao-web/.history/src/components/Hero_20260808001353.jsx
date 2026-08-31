import { useLayoutEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const Hero = () => {
  const rootRef = useRef(null);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();
    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        // BG parallax on scroll
        gsap.to('.hero-bg', {
          yPercent: 20,
          ease: 'none',
          scrollTrigger: { trigger: rootRef.current, start: 'top top', end: 'bottom top', scrub: true },
        });

        // Entrance timeline
        gsap.set(['.hero-line', '.hero-sub', '.hero-cta'], { opacity: 0, y: 32 });
        gsap.set('.hero-bg', { scale: 1.1 });
        gsap.set('.hero-overlay', { opacity: 0 });

        gsap
          .timeline({ defaults: { ease: 'power3.out' } })
          .to('.hero-bg',      { scale: 1, duration: 1.8, ease: 'power2.out' }, 0)
          .to('.hero-overlay', { opacity: 1, duration: 1.2 }, 0)
          .to('.hero-line',    { opacity: 1, y: 0, duration: 0.9, stagger: 0.15 }, 0.4)
          .to('.hero-sub',     { opacity: 1, y: 0, duration: 0.8 }, 0.85)
          .to('.hero-cta',     { opacity: 1, y: 0, duration: 0.7, stagger: 0.12 }, 1.1);

        // Scroll-fade the hero content out as user scrolls away
        gsap.to('.hero-content', {
          opacity: 0,
          y: -40,
          ease: 'none',
          scrollTrigger: { trigger: rootRef.current, start: 'center top', end: 'bottom top', scrub: true },
        });
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
      <div className="hero-overlay absolute inset-0 bg-black/60" />
      <div
        className="hero-overlay absolute inset-0"
        style={{ background: 'radial-gradient(ellipse at center, rgba(0,0,0,0.25) 0%, rgba(0,0,0,0.78) 75%)' }}
      />

      <div className="hero-content relative z-10 mx-auto flex w-full max-w-3xl flex-col items-center px-6 text-center">
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
            How To Play
          </a>
        </div>
      </div>
    </section>
  );
};

export default Hero;
