import { useLayoutEffect, useRef, useState, useCallback } from 'react';
import { Link } from 'react-router-dom';
import { ChevronLeft, ChevronRight } from 'lucide-react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';
import { useUpcomingGames } from '../data/upcomingGames';

gsap.registerPlugin(ScrollTrigger);

const dateFormatter = new Intl.DateTimeFormat('en-US', {
  weekday: 'short', month: 'short', day: 'numeric',
});
const formatDate = (iso) => dateFormatter.format(new Date(`${iso}T00:00:00`));

const getInitials = (name) => {
  const words = name.split(' ').filter((w) => w.toLowerCase() !== 'team');
  const source = words.length > 0 ? words : name.split(' ');
  return source.slice(0, 2).map((w) => w[0]).join('').toUpperCase();
};

const CARD_W = 320 + 16; // w-80 (320px) + gap-4 (16px)

const GameCard = ({ game }) => (
  <div className="game-card flex-shrink-0 w-72 sm:w-80 flex flex-col rounded-2xl border border-gray-200 bg-white overflow-hidden hover:shadow-lg transition-all duration-300 hover:-translate-y-1">
    {/* Date + time */}
    <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-gray-100">
      <span className="text-xs font-medium text-zinc-400 uppercase tracking-widest" style={{ fontFamily: BRAND.font.body }}>
        {formatDate(game.date)}
      </span>
      <span className="text-xs font-medium px-2.5 py-1 rounded-full bg-gray-100 text-gray-500" style={{ fontFamily: BRAND.font.body }}>
        {game.time}
      </span>
    </div>

    {/* Teams */}
    <div className="flex items-center justify-between gap-3 px-5 py-5">
      <div className="flex flex-col items-center gap-2 flex-1">
        <div className="w-14 h-14 rounded-sm flex items-center justify-center" style={{ backgroundColor: BRAND.dark }}>
          <span className="text-white font-extrabold text-sm">{getInitials(game.homeTeam)}</span>
        </div>
        <p className="text-[#011B3B] text-xs font-medium text-center leading-tight line-clamp-2 max-w-[80px]" style={{ fontFamily: BRAND.font.body }}>
          {game.homeTeam}
        </p>
      </div>

      <div className="flex-shrink-0">
        <span className="text-lg font-medium text-gray-300" style={{ fontFamily: BRAND.font.heading }}>VS</span>
      </div>

      <div className="flex flex-col items-center gap-2 flex-1">
        <div className="w-14 h-14 rounded-sm bg-amber-400 flex items-center justify-center">
          <span className="font-extrabold text-sm" style={{ color: BRAND.dark }}>{getInitials(game.awayTeam)}</span>
        </div>
        <p className="text-[#011B3B] text-xs font-medium text-center leading-tight line-clamp-2 max-w-[80px]" style={{ fontFamily: BRAND.font.body }}>
          {game.awayTeam}
        </p>
      </div>
    </div>

    {/* Venue + CTA */}
    <div className="px-5 pb-5 mt-auto space-y-3">
      <p className="text-xs text-gray-400 font-normal flex items-center gap-1.5 truncate" style={{ fontFamily: BRAND.font.body }}>
        <svg className="w-3 h-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
        </svg>
        {game.venue}
      </p>
      <Link
        to="/games"
        className="flex items-center justify-center w-full py-3 rounded-sm text-xs font-semibold uppercase tracking-widest text-white transition hover:opacity-90"
        style={{ backgroundColor: BRAND.primary, fontFamily: BRAND.font.body }}
      >
        View Details
      </Link>
    </div>
  </div>
);

const EmptyState = () => (
  <div className="rounded-2xl border border-gray-200 bg-white px-6 py-12 text-center w-full">
    <p className="text-gray-400 font-normal" style={{ fontFamily: BRAND.font.body }}>
      No games on the schedule yet — check back soon.
    </p>
  </div>
);

const UpcomingGamesSection = () => {
  const rootRef = useRef(null);
  const rowRef  = useRef(null);
  const { games, loading } = useUpcomingGames();
  const [canPrev, setCanPrev] = useState(false);
  const [canNext, setCanNext] = useState(false);

  const syncArrows = useCallback(() => {
    const el = rowRef.current;
    if (!el) return;
    setCanPrev(el.scrollLeft > 8);
    setCanNext(el.scrollLeft + el.clientWidth < el.scrollWidth - 8);
  }, []);

  // init arrows after games load
  useLayoutEffect(() => {
    if (loading || !games.length) return;
    setTimeout(syncArrows, 100);
  }, [loading, games, syncArrows]);

  const scroll = (dir) => {
    rowRef.current?.scrollBy({ left: dir * CARD_W * 2, behavior: 'smooth' });
  };

  useLayoutEffect(() => {
    if (loading) return;
    const mm = gsap.matchMedia();
    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set('.games-heading', { clipPath: 'inset(100% 0% 0% 0%)' });
        gsap.to('.games-heading', {
          clipPath: 'inset(0% 0% 0% 0%)', duration: 0.8, ease: 'power4.out',
          scrollTrigger: { trigger: rootRef.current, start: 'top 78%' },
        });
        gsap.set('.game-card', { opacity: 0, y: 50 });
        gsap.to('.game-card', {
          opacity: 1, y: 0, duration: 0.7, stagger: 0.12, ease: 'power3.out',
          scrollTrigger: { trigger: rootRef.current, start: 'top 72%' },
        });
      }, rootRef);
      return () => ctx.revert();
    });
    return () => mm.revert();
  }, [loading, games]);

  const showControls = !loading && games.length > 0;

  return (
    <section id="games" ref={rootRef} className="w-full py-16 scroll-mt-20 overflow-hidden">
      <div className="mx-auto max-w-7xl px-6 sm:px-10">

        {/* Heading */}
        <div className="games-heading flex flex-col items-center text-center gap-2 mb-10">
          <p className="text-xs font-medium uppercase tracking-[0.3em]" style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}>
            Catch It Live
          </p>
          <h2 className="text-3xl uppercase text-[#011B3B] sm:text-4xl md:text-5xl" style={{ fontFamily: BRAND.font.heading }}>
            Upcoming Games
          </h2>
        </div>

        {/* Scroll row + controls */}
        {showControls && (
          <div className="relative">

            {/* Row */}
            <div
              ref={rowRef}
              onScroll={syncArrows}
              className="flex gap-4 overflow-x-auto pb-4 scrollbar-hide snap-x snap-mandatory px-2"
            >
              {games.map((game) => (
                <div key={game.id} className="snap-start">
                  <GameCard game={game} />
                </div>
              ))}
            </div>

            {/* Bottom controllers */}
            <div className="flex items-center justify-end gap-3 mt-6">
              <button
                onClick={() => scroll(-1)}
                disabled={!canPrev}
                className="w-10 h-10 flex items-center justify-center rounded-full border transition-all duration-200"
                style={{
                  backgroundColor: canPrev ? BRAND.dark : 'transparent',
                  borderColor: canPrev ? BRAND.dark : BRAND.border,
                }}
              >
                <ChevronLeft className="w-5 h-5" style={{ color: canPrev ? '#fff' : BRAND.muted }} />
              </button>
              <button
                onClick={() => scroll(1)}
                disabled={!canNext}
                className="w-10 h-10 flex items-center justify-center rounded-full border transition-all duration-200"
                style={{
                  backgroundColor: canNext ? BRAND.dark : 'transparent',
                  borderColor: canNext ? BRAND.dark : BRAND.border,
                }}
              >
                <ChevronRight className="w-5 h-5" style={{ color: canNext ? '#fff' : BRAND.muted }} />
              </button>
            </div>
          </div>
        )}

        {!loading && games.length === 0 && <EmptyState />}

      </div>
    </section>
  );
};

export default UpcomingGamesSection;
