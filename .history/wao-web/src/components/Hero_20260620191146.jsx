import { Link } from 'react-router-dom';

const Hero = () => (
  <section
    className="relative isolate flex h-screen items-center bg-cover bg-center bg-no-repeat"
    style={{ backgroundImage: "url('/assets/Hero.png')" }}
  >
    <div className="absolute inset-0 bg-gradient-to-r from-black/80 via-black/50 to-black/70" />
    <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent to-black/30" />

    <div className="relative z-10 flex h-full w-full items-end pb-16 px-6 sm:px-10 lg:px-16">
      <div className="mx-auto w-full max-w-7xl flex justify-end">
        <div className="max-w-2xl text-right">

          <span
            className="inline-block mb-3 text-xs font-semibold tracking-[0.3em] text-red-400 uppercase"
            style={{ fontFamily: "'Oswald', sans-serif" }}
          >
            WAO
          </span>

          <h1
            className="uppercase leading-[1.05] tracking-wide text-white text-4xl sm:text-5xl md:text-6xl drop-shadow-[0_2px_8px_rgba(0,0,0,0.8)]"
            style={{ fontFamily: "'Anton', sans-serif" }}
          >
            <span className="block">A New Era of Competition</span>
            <span className="block">Without Boundaries</span>
          </h1>

          <p
            className="mt-5 text-sm md:text-base text-white/75 leading-relaxed ml-auto max-w-md"
            style={{ fontFamily: "'Oswald', sans-serif" }}
          >
            From the blacktop to the big stage — WAO brings together athletes,
            teams, and fans who refuse to play by the old rules.
          </p>

          <div className="mt-8 flex flex-wrap justify-end gap-3">
            <Link
              to="/dashboard"
              className="inline-flex items-center justify-center rounded-sm border border-white/40 bg-white/10 px-6 py-3 text-sm font-semibold uppercase tracking-widest text-white backdrop-blur-sm transition hover:bg-white/20"
              style={{ fontFamily: "'Oswald', sans-serif" }}
            >
              Learn More
            </Link>
            <Link
              to="/login"
              className="inline-flex items-center justify-center rounded-sm bg-[#c81434] px-6 py-3 text-sm font-semibold uppercase tracking-widest text-white transition hover:bg-[#e21e43]"
              style={{ fontFamily: "'Oswald', sans-serif" }}
            >
              Join WAO
            </Link>
          </div>
        </div>
      </div>
    </div>
  </section>
);

export default Hero;
