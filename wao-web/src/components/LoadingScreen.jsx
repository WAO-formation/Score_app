import { useEffect, useRef } from 'react';
import gsap from 'gsap';
import { BRAND } from '../config/brand';

const LoadingScreen = ({ onComplete }) => {
  const rootRef  = useRef(null);
  const logoRef  = useRef(null);
  const barRef   = useRef(null);
  const textRef  = useRef(null);

  useEffect(() => {
    const tl = gsap.timeline({
      onComplete: () => {
        // Wipe the whole screen upward then call onComplete
        gsap.to(rootRef.current, {
          clipPath: 'inset(0% 0% 100% 0%)',
          duration: 0.7,
          ease: 'power4.inOut',
          onComplete,
        });
      },
    });

    // Logo entrance
    tl.fromTo(logoRef.current,
      { opacity: 0, scale: 0.8, y: 16 },
      { opacity: 1, scale: 1, y: 0, duration: 0.7, ease: 'back.out(1.6)' }
    )
    // Progress bar fill
    .fromTo(barRef.current,
      { scaleX: 0 },
      { scaleX: 1, duration: 1.1, ease: 'power2.inOut', transformOrigin: 'left center' },
      '-=0.2'
    )
    // Tagline fade
    .fromTo(textRef.current,
      { opacity: 0, y: 8 },
      { opacity: 1, y: 0, duration: 0.5, ease: 'power3.out' },
      '-=0.6'
    )
    // Hold briefly then exit
    .to({}, { duration: 0.35 });
  }, [onComplete]);

  return (
    <div
      ref={rootRef}
      className="fixed inset-0 z-[9999] flex flex-col items-center justify-center gap-8"
      style={{
        backgroundColor: '#fff',
        clipPath: 'inset(0% 0% 0% 0%)',
      }}
    >
      {/* Logo */}
      <img
        ref={logoRef}
        src="/assets/logo.png"
        alt="WAO!"
        className="h-16 w-auto"
        style={{ opacity: 0 }}
      />

      {/* Progress bar */}
      <div
        className="w-40 h-[2px] rounded-full overflow-hidden"
        style={{ backgroundColor: 'rgba(0,0,0,0.08)' }}
      >
        <div
          ref={barRef}
          className="h-full w-full rounded-full"
          style={{ backgroundColor: BRAND.primary, transform: 'scaleX(0)' }}
        />
      </div>

      {/* Tagline */}
      <p
        ref={textRef}
        className="text-[10px] uppercase tracking-[0.4em]"
        style={{
          fontFamily: BRAND.font.body,
          color: 'rgba(0,0,0,0.35)',
          opacity: 0,
        }}
      >
        World Oneness Through Sport
      </p>
    </div>
  );
};

export default LoadingScreen;
