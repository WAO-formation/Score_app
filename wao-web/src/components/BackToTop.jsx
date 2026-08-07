import { useEffect, useRef, useState } from 'react';
import gsap from 'gsap';
import { BRAND } from '../config/brand';

const BackToTop = () => {
  const [visible, setVisible] = useState(false);
  const btnRef = useRef(null);

  useEffect(() => {
    const onScroll = () => setVisible(window.scrollY > 400);
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  // Animate in/out
  useEffect(() => {
    if (!btnRef.current) return;
    gsap.to(btnRef.current, {
      opacity: visible ? 1 : 0,
      y: visible ? 0 : 16,
      pointerEvents: visible ? 'auto' : 'none',
      duration: 0.35,
      ease: 'power3.out',
    });
  }, [visible]);

  const handleClick = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  return (
    <button
      ref={btnRef}
      onClick={handleClick}
      aria-label="Back to top"
      className="fixed bottom-6 right-6 z-50 flex h-11 w-11 items-center justify-center rounded-full shadow-lg transition-transform duration-200 hover:scale-110 active:scale-95"
      style={{
        backgroundColor: BRAND.primary,
        opacity: 0,
        pointerEvents: 'none',
      }}
    >
      <svg
        viewBox="0 0 24 24"
        fill="none"
        stroke="white"
        strokeWidth="2.5"
        strokeLinecap="round"
        strokeLinejoin="round"
        className="h-5 w-5"
      >
        <path d="M18 15l-6-6-6 6" />
      </svg>
    </button>
  );
};

export default BackToTop;
