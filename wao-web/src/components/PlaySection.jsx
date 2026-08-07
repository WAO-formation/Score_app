import { useLayoutEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const IMAGES = [
  '/assets/card-carosel.png',
  '/assets/card-carosel-1.png',
  '/assets/card-carosel2.png',
  '/assets/card-carosel3.png',
  '/assets/card-carosel4.png',
  '/assets/card-carosel5.png',
  '/assets/card-carosel6.png',
  '/assets/card-carosel7.png',
  '/assets/card-carosel8.png',
  '/assets/card-carosel9.png',
  '/assets/card-carosel10.png',
];

// Duplicate for seamless infinite loop
const TRACK = [...IMAGES, ...IMAGES];

const PlaySection = () => {
  const rootRef = useRef(null);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();

    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set(['.play-heading', '.play-strip', '.play-cta'], { opacity: 0, y: 24 });

        gsap
          .timeline({
            defaults: { ease: 'power3.out' },
            scrollTrigger: { trigger: rootRef.current, start: 'top 75%' },
          })
          .to('.play-heading', { opacity: 1, y: 0, duration: 0.7 })
          .to('.play-strip', { opacity: 1, y: 0, duration: 0.7 }, '-=0.4')
          .to('.play-cta', { opacity: 1, y: 0, duration: 0.5 }, '-=0.3');
      }, rootRef);

      return () => ctx.revert();
    });

    return () => mm.revert();
  }, []);

  return (
    <section
      id="play"
      ref={rootRef}
      className="w-full bg-white py-16 overflow-hidden scroll-mt-20"
    >
      <style>{`
        @keyframes scroll-left {
          0%   { transform: translateX(0); }
          100% { transform: translateX(-50%); }
        }
        .animate-scroll {
          animation: scroll-left 30s linear infinite;
        }
        .animate-scroll:hover {
          animation-play-state: paused;
        }
      `}</style>

      {/* Layered heading */}
      <div className="play-heading relative text-center mb-12 px-4">
        <h2
          aria-hidden="true"
          className="select-none pointer-events-none uppercase text-gray-100 text-4xl sm:text-6xl md:text-8xl tracking-wide leading-none"
          style={{ fontFamily: BRAND.font.heading }}
        >
          Let&apos;s Play WAO
        </h2>
        <div className="relative -mt-5 sm:-mt-9 md:-mt-14">
          <p
            className="font-semibold uppercase tracking-[0.2em] text-sm md:text-base"
            style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}
          >
            More than Sport
          </p>
          <p
            className="text-slate-900 text-2xl sm:text-3xl md:text-4xl mt-1"
            style={{ fontFamily: BRAND.font.heading }}
          >
            More than a Game
          </p>
        </div>
      </div>

      {/* Infinite scroll strip */}
      <div className="play-strip relative w-full">
        {/* Left fade */}
        <div className="absolute left-0 top-0 h-full w-24 bg-gradient-to-r from-white to-transparent z-10 pointer-events-none" />
        {/* Right fade */}
        <div className="absolute right-0 top-0 h-full w-24 bg-gradient-to-l from-white to-transparent z-10 pointer-events-none" />

        <div className="flex animate-scroll" style={{ width: 'max-content' }}>
          {TRACK.map((src, i) => (
            <div
              key={i}
              className="relative h-96 w-72 shrink-0 mx-2 rounded-xl overflow-hidden shadow-md"
            >
              <img
                src={src}
                alt={`WAO action ${(i % IMAGES.length) + 1}`}
                className="w-full h-full object-cover transition-transform duration-500 hover:scale-105"
              />
            </div>
          ))}
        </div>
      </div>

      {/* CTA line */}
      <p
        className="play-cta text-center text-stone-500 text-sm md:text-base mt-10"
        style={{ fontFamily: BRAND.font.body }}
      >
        Grab a ball. Find your court. Play WAO!
      </p>
    </section>
  );
};

export default PlaySection;
