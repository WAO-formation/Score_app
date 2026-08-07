import { Link } from 'react-router-dom';
import { BRAND } from '../config/brand';

const CtaSection = () => (
  <section
    className="relative w-full min-h-[60vh] flex items-center justify-center overflow-hidden bg-black"
    style={{ backgroundImage: "url('/assets/card-carosel8.png')", backgroundSize: 'cover', backgroundPosition: 'center' }}
  >
    {/* Overlay */}
    <div className="absolute inset-0 bg-black/65" />
    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-black/40" />

    {/* Content */}
    <div className="relative z-10 text-center px-6 max-w-3xl mx-auto">
    

      <h2
        className="text-white uppercase leading-[1.05] text-3xl sm:text-4xl md:text-5xl drop-shadow-[0_2px_8px_rgba(0,0,0,0.8)]"
        style={{ fontFamily: BRAND.font.heading }}
      >
        There's more than one way to play. <br /> WAO shows you how.
      </h2>

      <Link
        to="/login"
        className="mt-10 inline-flex items-center justify-center px-8 py-4 text-sm font-semibold uppercase tracking-widest text-white transition"
        style={{
          fontFamily: BRAND.font.body,
          backgroundColor: BRAND.primary,
        }}
        onMouseEnter={e => e.currentTarget.style.backgroundColor = BRAND.primaryHover}
        onMouseLeave={e => e.currentTarget.style.backgroundColor = BRAND.primary}
      >
        Let's Play WAO
      </Link>
    </div>
  </section>
);

export default CtaSection;
