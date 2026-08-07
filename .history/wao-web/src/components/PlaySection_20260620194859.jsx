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
const CARD_H = 300;
const GAP = 16;
const ARC_DEPTH = 60;      // how deep the arc dips in px
const SPEED = 0.4;          // px per frame
const TOTAL = IMAGES.length;
const STEP = CARD_W + GAP;

const CurvedCarousel = () => {
  const canvasRef = useRef(null);
  const offset = useRef(0);
  const images = useRef([]);
  const rafId = useRef(null);

  useEffect(() => {
    // Preload images
    const loaded = [];
    let done = 0;
    IMAGES.forEach((src, i) => {
      const img = new Image();
      img.src = src;
      img.onload = () => {
        loaded[i] = img;
        done++;
        if (done === TOTAL) images.current = loaded;
      };
      img.onerror = () => { done++; };
    });

    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');

    const resize = () => {
      canvas.width = canvas.offsetWidth;
      canvas.height = CARD_H + ARC_DEPTH + 40;
    };
    resize();
    window.addEventListener('resize', resize);

    const draw = () => {
      const W = canvas.width;
      const H = canvas.height;
      ctx.clearRect(0, 0, W, H);

      const trackWidth = TOTAL * STEP;
      offset.current = (offset.current + SPEED) % trackWidth;

      for (let i = 0; i < TOTAL * 3; i++) {
        const idx = i % TOTAL;
        const rawX = i * STEP - offset.current;

        // Only draw cards visible on screen (with buffer)
        if (rawX < -CARD_W - GAP || rawX > W + CARD_W) continue;

        // Sine arc — centre of the arc is the middle of the screen
        const progress = (rawX + CARD_W / 2) / W; // 0..1 across screen
        const arcY = Math.sin(progress * Math.PI) * ARC_DEPTH;
        const y = ARC_DEPTH - arcY + 20;

        const img = images.current[idx];
        const radius = 16;

        ctx.save();

        // Rounded rect clip
        ctx.beginPath();
        ctx.moveTo(rawX + radius, y);
        ctx.lineTo(rawX + CARD_W - radius, y);
        ctx.quadraticCurveTo(rawX + CARD_W, y, rawX + CARD_W, y + radius);
        ctx.lineTo(rawX + CARD_W, y + CARD_H - radius);
        ctx.quadraticCurveTo(rawX + CARD_W, y + CARD_H, rawX + CARD_W - radius, y + CARD_H);
        ctx.lineTo(rawX + radius, y + CARD_H);
        ctx.quadraticCurveTo(rawX, y + CARD_H, rawX, y + CARD_H - radius);
        ctx.lineTo(rawX, y + radius);
        ctx.quadraticCurveTo(rawX, y, rawX + radius, y);
        ctx.closePath();
        ctx.clip();

        if (img) {
          // Cover-fit the image
          const scale = Math.max(CARD_W / img.width, CARD_H / img.height);
          const dw = img.width * scale;
          const dh = img.height * scale;
          const dx = rawX + (CARD_W - dw) / 2;
          const dy = y + (CARD_H - dh) / 2;
          ctx.drawImage(img, dx, dy, dw, dh);
        } else {
          ctx.fillStyle = '#222';
          ctx.fillRect(rawX, y, CARD_W, CARD_H);
        }

        ctx.restore();

        // Subtle shadow
        ctx.save();
        ctx.shadowColor = 'rgba(0,0,0,0.35)';
        ctx.shadowBlur = 18;
        ctx.shadowOffsetY = 6;
        ctx.beginPath();
        ctx.roundRect(rawX, y, CARD_W, CARD_H, radius);
        ctx.fillStyle = 'transparent';
        ctx.fill();
        ctx.restore();
      }

      rafId.current = requestAnimationFrame(draw);
    };

    rafId.current = requestAnimationFrame(draw);
    return () => {
      cancelAnimationFrame(rafId.current);
      window.removeEventListener('resize', resize);
    };
  }, []);

  return (
    <canvas
      ref={canvasRef}
      className="w-full"
      style={{ height: CARD_H + ARC_DEPTH + 40 }}
    />
  );
};

const PlaySection = () => (
  <section className="w-full bg-white py-16 overflow-hidden">
    {/* Layered heading */}
    <div className="relative text-center mb-12">
      <h2
        aria-hidden="true"
        className="select-none pointer-events-none uppercase text-gray-100 text-6xl sm:text-7xl md:text-8xl tracking-wide leading-none"
        style={{ fontFamily: BRAND.font.heading }}
      >
        Lets Play WAO
      </h2>
      <div className="relative -mt-8 sm:-mt-10 md:-mt-14">
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

    {/* Curved canvas carousel */}
    <CurvedCarousel />

    {/* CTA line */}
    <p
      className="text-center text-stone-500 text-sm md:text-base mt-10"
      style={{ fontFamily: BRAND.font.body }}
    >
      Join thousands of people today to play WAO!
    </p>
  </section>
);

export default PlaySection;
