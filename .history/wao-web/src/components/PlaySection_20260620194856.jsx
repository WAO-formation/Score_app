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

const CARD_W = 200;
const CARD_H = 280;
const SPEED = 0.003; // radians per frame

const CurvedCarousel = () => {
  const canvasRef = useRef(null);
  const angleOffset = useRef(0);
  const images = useRef([]);
  const rafId = useRef(null);

  useEffect(() => {
    let loadedCount = 0;
    const loaded = new Array(IMAGES.length).fill(null);
    IMAGES.forEach((src, i) => {
      const img = new Image();
      img.src = src;
      img.onload = () => { loaded[i] = img; loadedCount++; };
      img.onerror = () => { loadedCount++; };
    });
    images.current = loaded;

    const canvas = canvasRef.current;
    const ctx = canvas.getContext('2d');

    const resize = () => {
      canvas.width = canvas.offsetWidth;
      canvas.height = canvas.offsetWidth * 0.38;
    };
    resize();
    window.addEventListener('resize', resize);

    const draw = () => {
      const W = canvas.width;
      const H = canvas.height;
      ctx.clearRect(0, 0, W, H);

      // Circle parameters — large radius so the arc feels subtle
      const R = W * 0.75;
      const cx = W / 2;
      // Push centre up so only the bottom arc is visible
      const cy = -R + H * 0.92;

      const count = IMAGES.length;
      const angleSpread = Math.PI * 0.72; // visible arc span in radians
      const angleStep = angleSpread / (count - 1);

      angleOffset.current -= SPEED;

      // Sort by y so further cards render behind closer ones
      const cards = [];
      for (let i = 0; i < count; i++) {
        const angle = -Math.PI / 2 + (i * angleStep - angleSpread / 2) + angleOffset.current;
        const x = cx + R * Math.cos(angle);
        const y = cy + R * Math.sin(angle);
        // Only draw cards in the visible bottom arc
        if (y < -CARD_H) continue;
        cards.push({ i, x, y, angle });
      }

      // Sort back-to-front by y
      cards.sort((a, b) => a.y - b.y);

      for (const { i, x, y } of cards) {
        const idx = ((i % count) + count) % count;
        const img = images.current[idx];
        const cx2 = x - CARD_W / 2;
        const cy2 = y - CARD_H / 2;
        const r = 14;

        // Fade out cards near the edges
        const edgeFade = Math.min(
          Math.max(0, (x - CARD_W) / (W * 0.18)),
          Math.max(0, (W - CARD_W - x) / (W * 0.18)),
          1
        );
        ctx.globalAlpha = Math.min(edgeFade, 1);

        ctx.save();
        ctx.shadowColor = 'rgba(0,0,0,0.4)';
        ctx.shadowBlur = 20;
        ctx.shadowOffsetY = 8;

        // Rounded clip
        ctx.beginPath();
        ctx.moveTo(cx2 + r, cy2);
        ctx.lineTo(cx2 + CARD_W - r, cy2);
        ctx.quadraticCurveTo(cx2 + CARD_W, cy2, cx2 + CARD_W, cy2 + r);
        ctx.lineTo(cx2 + CARD_W, cy2 + CARD_H - r);
        ctx.quadraticCurveTo(cx2 + CARD_W, cy2 + CARD_H, cx2 + CARD_W - r, cy2 + CARD_H);
        ctx.lineTo(cx2 + r, cy2 + CARD_H);
        ctx.quadraticCurveTo(cx2, cy2 + CARD_H, cx2, cy2 + CARD_H - r);
        ctx.lineTo(cx2, cy2 + r);
        ctx.quadraticCurveTo(cx2, cy2, cx2 + r, cy2);
        ctx.closePath();
        ctx.clip();

        if (img) {
          const scale = Math.max(CARD_W / img.width, CARD_H / img.height);
          const dw = img.width * scale;
          const dh = img.height * scale;
          ctx.drawImage(img, cx2 + (CARD_W - dw) / 2, cy2 + (CARD_H - dh) / 2, dw, dh);
        } else {
          ctx.fillStyle = '#1a1a1a';
          ctx.fillRect(cx2, cy2, CARD_W, CARD_H);
        }

        ctx.restore();
        ctx.globalAlpha = 1;
      }

      rafId.current = requestAnimationFrame(draw);
    };

    rafId.current = requestAnimationFrame(draw);
    return () => {
      cancelAnimationFrame(rafId.current);
      window.removeEventListener('resize', resize);
    };
  }, []);

  return <canvas ref={canvasRef} className="w-full" style={{ display: 'block' }} />;
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
      className="text-center text-stone-500 text-sm md:text-base mt-6"
      style={{ fontFamily: BRAND.font.body }}
    >
      Join thousands of people today to play WAO!
    </p>
  </section>
);

export default PlaySection;
