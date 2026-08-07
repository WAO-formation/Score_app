import { useRef, useEffect } from 'react';
import { BRAND } from '../config/brand';

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

const CARD_W = 220;
const CARD_H = 340;
const GAP = 16;
const STEP = CARD_W + GAP;
const SPEED = 0.6;
const TRACK = [...IMAGES, ...IMAGES, ...IMAGES];

const ScrollStrip = () => {
  const canvasRef = useRef(null);
  const offset = useRef(0);
  const imgs = useRef(new Array(IMAGES.length).fill(null));
  const raf = useRef(null);

  useEffect(() => {
    IMAGES.forEach((src, i) => {
      const img = new Image();
      img.onload = () => { imgs.current[i] = img; };
      img.src = src;
    });

    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');
    const totalW = IMAGES.length * STEP;

    const setSize = () => {
      canvas.width = canvas.parentElement.offsetWidth;
      canvas.height = CARD_H;
    };
    setSize();
    window.addEventListener('resize', setSize);

    const draw = () => {
      const W = canvas.width;
      ctx.clearRect(0, 0, W, CARD_H);
      offset.current = (offset.current + SPEED) % totalW;

      for (let i = 0; i < TRACK.length; i++) {
        const x = i * STEP - offset.current;
        if (x + CARD_W < 0 || x > W) continue;

        const img = imgs.current[i % IMAGES.length];
        const r = 14;

        ctx.save();
        ctx.beginPath();
        ctx.moveTo(x + r, 0);
        ctx.lineTo(x + CARD_W - r, 0);
        ctx.arcTo(x + CARD_W, 0, x + CARD_W, r, r);
        ctx.lineTo(x + CARD_W, CARD_H - r);
        ctx.arcTo(x + CARD_W, CARD_H, x + CARD_W - r, CARD_H, r);
        ctx.lineTo(x + r, CARD_H);
        ctx.arcTo(x, CARD_H, x, CARD_H - r, r);
        ctx.lineTo(x, r);
        ctx.arcTo(x, 0, x + r, 0, r);
        ctx.closePath();
        ctx.clip();

        if (img) {
          const scale = Math.max(CARD_W / img.width, CARD_H / img.height);
          const dw = img.width * scale;
          const dh = img.height * scale;
          ctx.drawImage(img, x + (CARD_W - dw) / 2, (CARD_H - dh) / 2, dw, dh);
        } else {
          ctx.fillStyle = '#1a1a1a';
          ctx.fillRect(x, 0, CARD_W, CARD_H);
        }

        ctx.restore();
      }

      raf.current = requestAnimationFrame(draw);
    };

    raf.current = requestAnimationFrame(draw);
    return () => {
      cancelAnimationFrame(raf.current);
      window.removeEventListener('resize', setSize);
    };
  }, []);

  return (
    <div className="w-full" style={{ height: CARD_H }}>
      <canvas ref={canvasRef} style={{ width: '100%', height: '100%', display: 'block' }} />
    </div>
  );
};

const PlaySection = () => (
  <section className="relative w-full overflow-hidden  px-4 py-12 text-center text-white sm:px-6 sm:py-16 lg:py-20">
    {/* Heading */}
    <div className="relative mx-auto max-w-6xl">
      <h2
        aria-hidden="true"
        className="select-none whitespace-nowrap text-[clamp(3.8rem,10vw,7.9rem)] font-black uppercase leading-none tracking-[-0.06em] text-[#ded9cf]"
        style={{ fontFamily: BRAND.font.heading }}
      >
        Lets Play WAO
      </h2>
      <p
        className="relative -mt-6 text-[0.7rem] font-semibold uppercase tracking-[0.42em] text-[#ff8f94] sm:-mt-8 sm:text-xs"
        style={{ fontFamily: BRAND.font.body }}
      >
        More than Sport
      </p>
      <p
        className="mt-2 text-[clamp(2.5rem,5vw,4.5rem)] font-black leading-none text-white"
        style={{ fontFamily: BRAND.font.heading }}
      >
        More than a Game
      </p>
    </div>

    {/* Carousel with concave SVG masks */}
    <div className="relative mx-auto mt-10 w-[min(100%,1200px)] sm:mt-12 lg:mt-14" style={{ height: CARD_H + 120 }}>

      {/* Top concave mask */}
      <div className="pointer-events-none absolute inset-x-0 top-0 z-20" style={{ height: 100 }}>
        <svg className="h-full w-full" viewBox="0 0 1440 100" preserveAspectRatio="none" aria-hidden="true">
          <path d="M0,0 H1440 V40 C1080,100 360,100 0,40 Z" fill="#000000" />
        </svg>
      </div>

      {/* Bottom concave mask */}
      <div className="pointer-events-none absolute inset-x-0 bottom-0 z-20" style={{ height: 100 }}>
        <svg className="h-full w-full" viewBox="0 0 1440 100" preserveAspectRatio="none" aria-hidden="true">
          <path d="M0,60 C360,0 1080,0 1440,60 V100 H0 Z" fill="#000000" />
        </svg>
      </div>

      {/* Scrolling strip sits between the masks */}
      <div className="absolute inset-x-0 z-10" style={{ top: 60, bottom: 60 }}>
        <ScrollStrip />
      </div>
    </div>

    <p
      className="mt-10 text-sm font-medium text-[#a9a29a] sm:text-base"
      style={{ fontFamily: BRAND.font.body }}
    >
      Join thousands of people today to play WAO!
    </p>
  </section>
);

export default PlaySection;
