import { ArrowRight } from 'lucide-react';
import { Link } from 'react-router-dom';

const LandingPage = () => {
  return (
    <main className="min-h-screen overflow-hidden text-white">
      <section
        className="relative isolate flex h-screen items-center bg-cover bg-center bg-no-repeat"
        style={{ backgroundImage: "url('/assets/Hero.png')" }}
      >
        <div className="absolute inset-0 bg-[linear-gradient(90deg,rgba(0,0,0,0.64)_0%,rgba(0,0,0,0.42)_38%,rgba(0,0,0,0.56)_100%)]" />
        <div className="absolute inset-0 bg-black/25" />
        <div className="absolute inset-0 bg-[repeating-linear-gradient(90deg,rgba(255,255,255,0.06)_0,rgba(255,255,255,0.06)_18px,transparent_18px,transparent_88px)] opacity-35 mix-blend-soft-light" />
        <div className="absolute inset-0 bg-[linear-gradient(180deg,rgba(110,12,18,0.10)_0%,rgba(110,12,18,0.22)_100%)]" />

        <div className="relative flex h-full w-full items-center px-6 sm:px-8 lg:px-10">
          <div className="mx-auto flex w-full max-w-7xl justify-end">
            <div className="max-w-2xl lg:pr-6 xl:pr-10">
              <h1
                className="text-right text-2xl font-black uppercase leading-[0.88] tracking-tight text-white sm:text-6xl lg:text-[2.7rem]"
                style={{ fontFamily: 'Georgia, Cambria, "Times New Roman", serif' }}
              >
                <span className="block">A New Era of Competition</span>
                <span className="mt-2 block"></span>
              </h1>

              <div className="mt-7 flex flex-wrap justify-end gap-3">
                <Link
                  to="/login"
                  className="inline-flex min-w-28 items-center justify-center rounded-sm bg-[#c81434] px-5 py-3 text-sm font-medium text-white transition hover:bg-[#e21e43]"
                >
                  Join WAO
                </Link>
                <Link
                  to="/dashboard"
                  className="inline-flex min-w-28 items-center justify-center rounded-sm bg-[#f2e6e6] px-5 py-3 text-sm font-medium text-[#111111] transition hover:bg-white"
                >
                  Learn More
                </Link>
              </div>
            </div>
          </div>
        </div>
      </section>
    </main>
  );
};

export default LandingPage;
