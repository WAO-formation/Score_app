import { useLayoutEffect, useRef, useState } from 'react';
import { ChevronDown } from 'lucide-react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';

gsap.registerPlugin(ScrollTrigger);

const FAQS = [
  {
    q: 'What exactly is WAO!?',
    a: 'WAO! is a two-ball, hand-controlled contact sport played across every zone of the pitch the WaoSphere where both teams chase one score: 100%.',
  },
  {
    q: 'Do I need experience to play?',
    a: "No. WAO! clinics are built for first-timers you'll learn the basics and can be playing your first session.",
  },
  {
    q: 'How is a match scored?',
    a: 'Every match is split across four zones — Kingdom, Workout, Goalpost, and Hi-Court — each worth a share of 100%. Whoever is closest to full coverage when time runs out wins.',
  },
  {
    q: 'How long does a match last?',
    a: 'Matches run four quarters (17 / 17 / 13 / 13 minutes) for a total of 60 minutes, plus possible extra time.',
  },
  {
    q: 'Where can I play or watch WAO!?',
    a: 'Community games and clinics run across Accra, including Cornerstone Baptist Church Court in Dome and TBC Court in Tesano — check Upcoming Games for the next one.',
  },
  {
    q: 'Is there a WAO! app?',
    a: 'A companion app for live scores and match commentary is in development. See How To Play for what it will cover.',
  },
];

const FaqSection = () => {
  const rootRef = useRef(null);
  const [openIndex, setOpenIndex] = useState(0);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();
    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        // Heading: clip-path wipe
        gsap.set('.faq-heading', { clipPath: 'inset(100% 0% 0% 0%)' });
        gsap.to('.faq-heading', {
          clipPath: 'inset(0% 0% 0% 0%)', duration: 0.8, ease: 'power4.out',
          scrollTrigger: { trigger: rootRef.current, start: 'top 78%' },
        });

        // Items: slide up stagger
        gsap.set('.faq-item', { opacity: 0, y: 28 });
        gsap.to('.faq-item', {
          opacity: 1, y: 0, duration: 0.55, stagger: 0.09, ease: 'power3.out',
          scrollTrigger: { trigger: rootRef.current, start: 'top 72%' },
        });
      }, rootRef);
      return () => ctx.revert();
    });
    return () => mm.revert();
  }, []);

  return (
    <section ref={rootRef} id="faq" className="w-full bg-white px-6 py-20 scroll-mt-20">
      <div className="mx-auto max-w-3xl">
        <div className="faq-heading flex flex-col items-center text-center gap-2 mb-12">
          <p
            className="text-xs font-semibold uppercase tracking-[0.3em]"
            style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}
          >
            Got Questions?
          </p>
          <h2
            className="text-3xl uppercase text-[#011B3B] sm:text-4xl md:text-5xl"
            style={{ fontFamily: BRAND.font.heading }}
          >
            Frequently Asked Questions
          </h2>
        </div>

        <div className="flex flex-col">
          {FAQS.map((faq, i) => {
            const isOpen = openIndex === i;
            return (
              <div key={faq.q} className="faq-item border-b" style={{ borderColor: BRAND.border }}>
                <button
                  onClick={() => setOpenIndex(isOpen ? -1 : i)}
                  className="flex w-full items-center justify-between gap-4 py-5 text-left"
                  aria-expanded={isOpen}
                >
                  <span
                    className="text-base font-medium sm:text-lg"
                    style={{ fontFamily: BRAND.font.body, color: BRAND.dark }}
                  >
                    {faq.q}
                  </span>
                  <ChevronDown
                    className="h-5 w-5 shrink-0 transition-transform duration-300"
                    style={{ color: BRAND.primary, transform: isOpen ? 'rotate(180deg)' : 'rotate(0deg)' }}
                  />
                </button>
                <div
                  className="grid transition-all duration-300 ease-out"
                  style={{ gridTemplateRows: isOpen ? '1fr' : '0fr' }}
                >
                  <div className="overflow-hidden">
                    <p
                      className="pb-5 text-sm leading-relaxed sm:text-base"
                      style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}
                    >
                      {faq.a}
                    </p>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
};

export default FaqSection;
