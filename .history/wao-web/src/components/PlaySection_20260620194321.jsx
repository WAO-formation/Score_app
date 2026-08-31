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

const CARD_W = 190;
const CARD_H = 270;
const GAP = 20;
const STEP = CARD_W + GAP;
const SPEED = 0.5;
const BASIN_DEPTH = 80; // how many px the centre sits lower than edges

const CurvedCarousel = () => {
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
    const TRACK = [...IMAGES, ...IMAGES, ...IMAGES];
    const totalW = IMAGES.length * STEP;

    const setSize = () => {
      canvas.width = canvas.parentElement.offsetWidth;
      canvas.height = CARD_H + BASIN_DEPTH + 20;
    };
    setSize();
    window.addEventListener('resize', setSize);

    const draw = () => {
      const W = canvas.width;
      const H = canvas.height;
      ctx.clearRect(0, 0, W, H);

      offset.current = (offset.current + SPEED) % totalW;

      // Collect visible cards
      const cards = [];
      for (let i = 0; i < TRACK.length; i++) {
        const x = i * STEP - offset.current;
        if (x + CARD_W < -STEP || x > W + STEP) continue;
        const cx = x + CARD_W / 2;
        // Parabola: t = 0 at centre, 1 at edges → y = BASIN_DEPTH * t²
        const t = (cx - W / 2) / (W / 2);
        const basinY = BASIN_DEPTH * t * t;
        // y=0 is the bottom of the basin (centre), edges rise up by BASIN_DEPTH
        const cardTop = (BASIN_DEPTH - basinY); // edges high, centre low
        cards.push({ x, cx, cardTop, idx: i % IMAGES.length, t });
      }

      // Draw edges first (highest t = furthest from centre), centre last (on top)
      cards.sort((a, b) => Math.abs(b.t) - Math.abs(a.t));

      for (const { x, cardTop, idx, t } of cards) {
        const img = imgs.current[idx];
        const ry = cardTop;
        const rx = x;
        const r = 14;

        // Scale: centre cards slightly larger
        const scale = 0.82 + 0.18 * (1 - Math.abs(t));
        const sw = CARD_W * scale;
        const sh = CARD_H * scale;
        const sx = rx + (CARD_W - sw) / 2;
        const sy = ry + (CARD_H - sh);

        // Fade edges
        const alpha = Math.max(0, 1 - Math.abs(t) * 0.6);
        ctx.globalAlpha = alpha;

        ctx.save();

        // Shadow
        ctx.shadowColor = 'rgba(0,0,0,0.3)';
        ctx.shadowBlur = 16;
        ctx.shadowOffsetY = 6;

        // Rounded clip
        ctx.beginPath();
        ctx.moveTo(sx + r, sy);
        ctx.lineTo(sx + sw - r, sy);
        ctx.arcTo(sx + sw, sy, sx + sw, sy + r, r);
        ctx.lineTo(sx + sw, sy + sh - r);
        ctx.arcTo(sx + sw, sy + sh, sx + sw - r, sy + sh, r);
        ctx.lineTo(sx + r, sy + sh);
        ctx.arcTo(sx, sy + sh, sx, sy + sh - r, r);
        ctx.lineTo(sx, sy + r);
        ctx.arcTo(sx, sy, sx + r, sy, r);
        ctx.closePath();
        ctx.clip();

        if (img) {
          const imgScale = Math.max(sw / img.width, sh / img.height);
          const dw = img.width * imgScale;
          const dh = img.height * imgScale;
          ctx.drawImage(img, sx + (sw - dw) / 2, sy + (sh - dh) / 2, dw, dh);
        } else {
          ctx.fillStyle = '#222';
          ctx.fillRect(sx, sy, sw, sh);
        }

        ctx.restore();
        ctx.globalAlpha = 1;
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
    <div className="w-full" style={{ height: CARD_H + BASIN_DEPTH + 20 }}>
      <canvas ref={canvasRef} style={{ width: '100%', height: '100%', display: 'block' }} />
    </div>
  );
};

const PlaySection = () => (
  <section className="w-full bg-white py-16 overflow-hidden">
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

    <CurvedCarousel />

    <p
      className="text-center text-stone-500 text-sm md:text-base mt-8"
      style={{ fontFamily: BRAND.font.body }}
    >
      Join thousands of people today to play WAO!
    </p>
  </section>
);

export default PlaySection;