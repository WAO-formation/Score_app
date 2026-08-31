import { ArrowRight } from 'lucide-react';
import { Link } from 'react-router-dom';

const LandingPage = () => {
  return (
    <main className="min-h-screen overflow-hidden text-white">
      <section
        className="relative isolate flex min-h-screen items-end bg-cover bg-center bg-no-repeat"
        style={{ backgroundImage: "url('/assets/Hero.png')" }}
      >
        <div className="absolute inset-0 bg-black/50" />
        <div className="absolute inset-0 bg-[radial-gradient(circle_at_top,rgba(0,0,0,0.18)_0%,rgba(0,0,0,0.42)_45%,rgba(0,0,0,0.78)_100%)]" />

        <div className="relative w-full px-6 py-6 sm:px-8 lg:px-10 lg:py-8">
          <div className="mx-auto flex w-full max-w-7xl items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="flex h-12 w-12 items-center justify-center rounded-2xl border border-white/15 bg-black/25 backdrop-blur-md">
                <img src="/assets/logo.png" alt="WAO" className="h-8 w-8 object-contain" />
              </div>
              <div className="hidden sm:block">
                <p className="text-xs font-semibold uppercase tracking-[0.35em] text-white/60">WAO</p>
                <p className="text-sm text-white/75">Game management platform</p>
              </div>
            </div>

            <Link
              to="/login"
              className="inline-flex items-center gap-2 rounded-full border border-white/15 bg-white/10 px-4 py-2 text-sm font-semibold text-white backdrop-blur-md transition hover:bg-white/15"
            >
              Sign in
              <ArrowRight className="h-4 w-4" />
            </Link>
          </div>

          <div className="mx-auto flex min-h-[calc(100vh-7rem)] w-full max-w-7xl items-end pb-6 pt-16 sm:pb-10 lg:pb-14">
            <div className="max-w-3xl rounded-[2rem] border border-white/10 bg-black/35 p-6 backdrop-blur-md sm:p-8 lg:p-10">
              <p className="text-sm font-semibold uppercase tracking-[0.35em] text-[#FFC600]">
                WAO Sports
              </p>
              <h1 className="mt-4 text-4xl font-black leading-[0.95] tracking-tight sm:text-6xl lg:text-7xl">
                The game starts here.
              </h1>
              <p className="mt-5 max-w-2xl text-base leading-7 text-white/80 sm:text-lg">
                A clean landing page powered by the hero image, with no extra sections or distractions.
              </p>

              <div className="mt-8 flex flex-wrap gap-3">
                <Link
                  to="/dashboard"
                  className="inline-flex items-center gap-2 rounded-full bg-[#FFC600] px-5 py-3 text-sm font-bold text-[#061426] transition hover:bg-[#ffd84d]"
                >
                  Open dashboard
                  <ArrowRight className="h-4 w-4" />
                </Link>
                <Link
                  to="/login"
                  className="inline-flex items-center gap-2 rounded-full border border-white/15 px-5 py-3 text-sm font-semibold text-white transition hover:bg-white/10"
                >
                  Go to login
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
