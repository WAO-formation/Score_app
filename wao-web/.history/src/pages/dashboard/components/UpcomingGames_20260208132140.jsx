import React from 'react';
import { Calendar, MapPin, Clock, Trophy } from 'lucide-react';

const UpcomingGamesSection = ({ games = [] }) => {
  return (
    <div className="bg-white rounded-xl shadow-sm py-5 px-5 relative overflow-hidden">
      <div className="flex items-center justify-between mb-4">
        <h3 className="font-bold text-[#011B3B] text-lg">Upcoming Games</h3>
        {games.length > 0 && (
          <span className="text-sm text-gray-500">{games.length} games</span>
        )}
      </div>

      {/* Scrollable Games Container */}
      <div className="overflow-x-auto scrollbar-hide -mx-5 px-5">
        <div className="flex gap-4 pb-2">
          {games.length > 0 ? (
            games.map((game) => (
              <GameCard key={game.id} game={game} />
            ))
          ) : (
            <EmptyState />
          )}
        </div>
      </div>
    </div>
  );
};

// Individual Game Card Component
const GameCard = ({ game }) => {
  return (
    <div className="min-w-[280px] bg-gradient-to-br from-[#1a1a1a] to-[#2d2d2d] rounded-xl p-4 relative overflow-hidden flex-shrink-0">
      {/* Background pattern/decoration */}
      <div className="absolute inset-0 opacity-5">
        <div className="absolute top-0 right-0 w-32 h-32 bg-white rounded-full blur-3xl"></div>
      </div>

      {/* Status Badge */}
      <div className="flex justify-between items-start mb-4 relative z-10">
        <div className="flex items-center gap-2 bg-[#FFC600]/20 px-3 py-1.5 rounded-full">
          <div className="w-2 h-2 bg-[#FFC600] rounded-full animate-pulse"></div>
          <span className="text-[#FFC600] text-xs font-semibold uppercase">
            {game.status || 'Upcoming'}
          </span>
        </div>
      </div>

      {/* Teams Section */}
      <div className="flex items-center justify-between mb-4 relative z-10">
        {/* Team 1 */}
        <div className="flex flex-col items-center flex-1">
          <div className="w-14 h-14 bg-gradient-to-br from-gray-700 to-gray-800 rounded-full flex items-center justify-center mb-2 border-2 border-gray-600">
            {game.team1Logo ? (
              <img src={game.team1Logo} alt={game.team1} className="w-10 h-10" />
            ) : (
              <span className="text-white font-bold text-sm">
                {game.team1.substring(0, 2).toUpperCase()}
              </span>
            )}
          </div>
          <p className="text-white text-sm font-semibold text-center line-clamp-1">
            {game.team1}
          </p>
        </div>

        {/* VS Badge */}
        <div className="flex flex-col items-center mx-3">
          <div className="bg-gradient-to-br from-[#3a3a3a] to-[#2a2a2a] px-4 py-2 rounded-lg border border-gray-700">
            <span className="text-white font-bold text-sm">VS</span>
          </div>
          <div className="mt-2 text-center">
            <p className="text-gray-400 text-xs">Today</p>
            <p className="text-[#FFC600] text-xs font-semibold">{game.time}</p>
          </div>
        </div>

        {/* Team 2 */}
        <div className="flex flex-col items-center flex-1">
          <div className="w-14 h-14 bg-gradient-to-br from-gray-700 to-gray-800 rounded-full flex items-center justify-center mb-2 border-2 border-gray-600">
            {game.team2Logo ? (
              <img src={game.team2Logo} alt={game.team2} className="w-10 h-10" />
            ) : (
              <span className="text-white font-bold text-sm">
                {game.team2.substring(0, 2).toUpperCase()}
              </span>
            )}
          </div>
          <p className="text-white text-sm font-semibold text-center line-clamp-1">
            {game.team2}
          </p>
        </div>
      </div>

      {/* Championship/League Info */}
      <div className="text-center mb-3 relative z-10">
        <p className="text-gray-400 text-xs uppercase tracking-wider">
          {game.championship || 'Championship'}
        </p>
      </div>

      {/* Divider */}
      <div className="border-t border-gray-700 my-3"></div>

      {/* Additional Info */}
      <div className="flex items-center justify-between text-xs relative z-10">
        <div className="flex items-center gap-1 text-gray-400">
          <MapPin className="w-3.5 h-3.5" />
          <span>{game.venue || 'Stadium'}</span>
        </div>
        <div className="flex items-center gap-1 text-gray-400">
          <Calendar className="w-3.5 h-3.5" />
          <span>{game.date || 'Feb 10'}</span>
        </div>
      </div>
    </div>
  );
};

// Empty State Component
const EmptyState = () => {
  return (
    <div className="w-full min-h-[300px] flex flex-col items-center justify-center py-8">
      <div className="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mb-4">
        <Trophy className="w-10 h-10 text-gray-400" />
      </div>
      <h4 className="text-[#011B3B] font-semibold text-lg mb-2">
        No Upcoming Games
      </h4>
      <p className="text-gray-500 text-sm text-center mb-6 max-w-xs">
        There are no scheduled games at the moment. Create a new game to get started.
      </p>
      <button className="px-6 py-2.5 bg-gradient-to-r from-[#D30336] to-[#FF3366] text-white rounded-lg font-medium hover:shadow-lg transition-all duration-200 flex items-center gap-2">
        <Calendar className="w-4 h-4" />
        Schedule Game
      </button>
    </div>
  );
};

export default {up}