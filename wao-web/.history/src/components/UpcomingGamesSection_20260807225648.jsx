import { useLayoutEffect, useRef } from 'react';
import { Link } from 'react-router-dom';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../config/brand';
import { useUpcomingGames } from '../data/upcomingGames';

gsap.registerPlugin(ScrollTrigger);

const CARD_ACCENTS = [
  { team1: 'from-[#FFC600] to-[#FF6B35]', team2: 'from-[#c81434] to-[#8b0e24]', border: 'border-[#FFC600]/20' },
  { team1: 'from-[#3b82f6] to-[#1d4ed8]', team2: 'from-[#c81434] to-[#8b0e24]', border: 'border-blue-500/20' },
  { team1: 'from-[#10b981] to-[#065f46]', team2: 'from-[#c81434] to-[#8b0e24]', border: 'border-emerald-500/20' },
  { team1: 'from-[#a855f7] to-[#6b21a8]', team2: 'from-[#c81434] to-[#8b0e24]', border: 'border-purple-500/20' },
  { team1: 'from-[#f97316] to-[#c2410c]', team2: 'from-[#c81434] to-[#8b0e24]', border: 'border-orange-500/20' },
];

const dateFormatter = new Intl.DateTimeFormat('en-US', {
  weekday: 'short', month: 'short', day: 'numeric',
});
const formatDate = (iso) => dateFormatter.format(new Date(`${iso}T00:00:00`));

const GameCard = ({ game, index }) => {
  const accent = CARD_ACCENTS[index % CARD_ACCENTS.length];

  return (
    <div
      className={`game-card flex-shrink-0 w-72 sm:w-80 flex flex-col rounded-2xl border border-gray-300 overflow-hidden hover:shadow-xl transition-all duration-300 hover:-translate-y-1`}
    >
      {/* Date + time */}
      <div className="flex items-center justify-between px-5 pt-4 pb-3 border-b border-gray-100">
        <span
          className="text-xs font-medium text-zinc-400 uppercase tracking-widest"
          style={{ fontFamily: BRAND.font.body }}
        >
          {formatDate(game.date)}
        </span>
        <span
          className="text-xs font-medium px-2.5 py-1 rounded-full bg-gray-100 text-gray-500"
          style={{ fontFamily: BRAND.font.body }}
        >
          {game.time}
        </span>
      </div>

      {/* Teams */}
      <div className="flex items-center justify-between gap-3 px-5 py-5">
        {/* Home */}
        <div className="flex flex-col items-center gap-2 flex-1">
          <div className={`w-14 h-14 bg-gradient-to-br ${accent.team1} rounded-2xl flex items-center justify-center shadow-sm`}>
            <span className="text-white font-semibold text-sm">
              {game.homeTeam.substring(0, 2).toUpperCase()}
            </span>
          </div>
          <p
            className="text-[#011B3B] text-xs font-extrabold text-center leading-tight line-clamp-2 max-w-[80px]"
            style={{ fontFamily: BRAND.font.body }}
          >
            {game.homeTeam}
          </p>
        </div>

        {/* VS */}
        <div className="flex-shrink-0">
          <span
            className="text-lg font-medium text-gray-300"
            style={{ fontFamily: BRAND.font.heading }}
          >
            VS
          </span>
        </div>

        {/* Away */}
        <div className="flex flex-col items-center gap-2 flex-1">
          <div className={`w-14 h-14 bg-gradient-to-br ${accent.team2} rounded-2xl flex items-center justify-center shadow-sm`}>
            <span className="text-white font-extrabold text-sm">
              {game.awayTeam.substring(0, 2).toUpperCase()}
            </span>
          </div>
          <p
            className="text-[#011B3B] text-xs font-medium text-center leading-tight line-clamp-2 max-w-[80px]"
            style={{ fontFamily: BRAND.font.body }}
          >
            {game.awayTeam}
          </p>
        </div>
      </div>

      {/* Venue + CTA */}
      <div className="px-5 pb-5 mt-auto space-y-3">
        <p
          className="text-xs text-gray-400 font-normal flex items-center gap-1.5 truncate"
          style={{ fontFamily: BRAND.font.body }}
        >
          <svg className="w-3 h-3 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
          </svg>
          {game.venue}
        </p>
        <Link
          to="/games"
          className="flex items-center justify-center w-full py-2.5 rounded-xl text-xs font-semibold uppercase tracking-widest text-white transition hover:opacity-90"
          style={{ backgroundColor: BRAND.primary, fontFamily: BRAND.font.body }}
        >
          View Details
        </Link>
      </div>
    </div>
  );
};

const EmptyState = () => (
  <div className="rounded-2xl border border-gray-200 bg-white px-6 py-12 text-center w-full">
    <p className="text-gray-400 font-normal" style={{ fontFamily: BRAND.font.body }}>
      No games on the schedule yet — check back soon.
    </p>
  </div>
);

const UpcomingGamesSection = () => {
  const rootRef  = useRef(null);
  const rowRef   = useRef(null);
  const { games, loading } = useUpcomingGames();

  useLayoutEffect(() => {
    if (loading) return;

    const mm = gsap.matchMedia();
    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set(['.games-heading', '.game-card'], { opacity: 0, y: 24 });
        gsap
          .timeline({
            defaults: { ease: 'power3.out' },
            scrollTrigger: { trigger: rootRef.current, start: 'top 75%' },
          })
          .to('.games-heading', { opacity: 1, y: 0, duration: 0.7 })
          .to('.game-card', { opacity: 1, y: 0, duration: 0.6, stagger: 0.1 }, '-=0.35');
      }, rootRef);
      return () => ctx.revert();
    });
    return () => mm.revert();
  }, [loading, games]);

  return (
    <section
      id="games"
      ref={rootRef}
      className="w-full px-6 py-10 scroll-mt-20 overflow-hidden"
    >
      <div className="mx-auto  max-w-7xl">

        {/* Heading */}
        <div className="games-heading flex flex-col items-center text-center gap-2 mb-10">
          <p
            className="text-xs font-medium uppercase tracking-[0.3em]"
            style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}
          >
            Catch It Live
          </p>
          <h2
            className="text-3xl uppercase text-[#011B3B] sm:text-4xl md:text-5xl"
            style={{ fontFamily: BRAND.font.heading }}
          >
            Upcoming Games
          </h2>
        </div>

        {/* Horizontal scroll row */}
        {loading ? null : games.length > 0 ? (
          <div
            ref={rowRef}
            className="flex justify-center gap-4 overflow-x-auto pb-4 scrollbar-hide snap-x snap-mandatory"
          >
            {games.map((game, i) => (
              <div key={game.id} className="snap-start">
                <GameCard game={game} index={i} />
              </div>
            ))}
          </div>
        ) : (
          <EmptyState />
        )}


      </div>
    </section>
  );
};

export default UpcomingGamesSection;
