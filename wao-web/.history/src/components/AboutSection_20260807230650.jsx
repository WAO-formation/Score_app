import { useLayoutEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const FACTS = ['Est. 2012', 'Accra, Ghana', 'Copyright Ghana 2014'];

const AboutSection = () => {
  const rootRef = useRef(null);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();

    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set('.about-image', { opacity: 0, x: -32 });
        gsap.set('.about-copy', { opacity: 0, y: 24 });

        gsap
          .timeline({
            defaults: { ease: 'power3.out' },
            scrollTrigger: { trigger: rootRef.current, start: 'top 70%' },
          })
          .to('.about-image', { opacity: 1, x: 0, duration: 0.8 })
          .to('.about-copy', { opacity: 1, y: 0, duration: 0.7, stagger: 0.1 }, '-=0.5');
      }, rootRef);

      return () => ctx.revert();
    });

    return () => mm.revert();
  }, []);

  return (
    <section
      id="about"
      ref={rootRef}
      className="w-full bg-white px-6 py-20 scroll-mt-20"
    >
      <div className="mx-auto grid max-w-6xl items-center gap-12 md:grid-cols-2 md:gap-16">
        <div className="about-image overflow-hidden rounded-2xl shadow-sm">
          <img
            src="/assets/card-carosel4.png"
            alt="WAO! team gathered on court in Accra"
            className="h-full w-full aspect-[4/5] object-cover md:aspect-auto md:h-[520px]"
          />
        </div>

        <div>
          <h2
            className="about-copy mt-3 text-3xl uppercase leading-[1.05] sm:text-4xl md:text-5xl"
            style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}
          >
            Creating the World's
            <br />Next Great <span className='text-'>Sport</span>.
          </h2>

          <p
            className="about-copy mt-6 text-base leading-relaxed text-gray-600 md:text-lg"
            style={{ fontFamily: BRAND.font.body }}
          >
            WAO! was founded in 2012 by Solomon Kyei in Accra, Ghana — a two-ball,
            hand-controlled contact sport built from scratch and registered with
            Copyright Ghana in 2014. What started with a small group playing at a
            church car park in Dome has grown into clinics and community games
            across the city.
          </p>

          <p
            className="about-copy mt-4 text-base leading-relaxed text-gray-600 md:text-lg"
            style={{ fontFamily: BRAND.font.body }}
          >
            Waoherds Limited's mission is to empower individuals through
            world-class edutainment and sports development — and the vision goes
            further still: to champion world oneness through innovative sports
            experiences that blend technology with traditional gameplay.
          </p>

          <div className="about-copy mt-8 flex flex-wrap gap-2">
            {FACTS.map((fact) => (
              <span
                key={fact}
                className="inline-flex items-center rounded-full px-3.5 py-1.5 text-[11px] font-medium uppercase tracking-[0.12em]"
                style={{
                  fontFamily: BRAND.font.body,
                  color: BRAND.dark,
                  backgroundColor: '#F0F4F9',
                }}
              >
                {fact}
              </span>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
};

export default AboutSection;
