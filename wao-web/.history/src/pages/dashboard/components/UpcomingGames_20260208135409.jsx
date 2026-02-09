import React from "react";
import { Calendar, MapPin, Trophy } from "lucide-react";

const UpcomingGames = ({ games = [] }) => {
  return (
    <div className="bg-white rounded-xl shadow-sm py-5 px-5">
      {/* Header */}
      <div className="flex items-center justify-between mb-4">
        <h3 className="font-bold text-[#011B3B] text-lg">Upcoming Games</h3>
        {games.length > 0 && (
          <span className="text-sm text-gray-500">{games.length} games</span>
        )}
      </div>

      {/* Scrollable Container - Fixed */}
      <div className="overflow-x-auto scrollbar-hide -mx-5 px-5">
        <div className="flex gap-4 pb-2 min-w-min">
          {games.length > 0 ? (
            // Game Cards
            games.map((game) => (
              <div
                key={game.id}
                className="min-w-[320px] bg-gradient-to-br from-gray-50 to-white rounded-xl p-4 relative overflow-hidden flex-shrink-0 shadow-sm border border-gray-100"
              >
                {/* Background Ball Image - Positioned behind everything */}
                <div className="absolute -right-12 -bottom-12 opacity-5 pointer-events-none">
                  <img
                    src="/assets/design/wao-ball.png"
                    alt="ball gradient"
                    className="w-40 h-40 object-contain"
                  />
                </div>

                {/* Teams Section */}
                <div className="flex items-center justify-between mb-4 relative z-10">
                  {/* Team 1 */}
                  <div className="flex flex-col items-center flex-1">
                    <div className="w-14 h-14 bg-yellow-400 rounded-full flex items-center justify-center mb-2 shadow-md">
                      <span className="text-white font-bold text-sm">
                        {game.team1.substring(0, 2).toUpperCase()}
                      </span>
                    </div>
                    <p className="text-gray-500 text-[12px] font-semibold text-center line-clamp-1">
                      {game.team1}
                    </p>
                  </div>

                  {/* VS Badge */}
                  <div className="flex flex-col items-center mx-3">
                    <div className="bg-gradient-to-br from-[#3a3a3a] to-[#2a2a2a] px-4 py-2 rounded-lg border border-gray-700 shadow-md">
                      <span className="text-white font-bold text-sm">VS</span>
                    </div>
                    <div className="mt-2 text-center">
                      <p className="text-gray-400 text-xs">Today</p>
                      <p className="text-[#FFC600] text-xs font-semibold">
                        {game.time}
                      </p>
                    </div>
                  </div>

                  {/* Team 2 - With overlapping ball */}
                  <div className="flex flex-col items-center flex-1">
                    <div className="w-14 h-14 bg-[#A50229] rounded-full flex items-center justify-center mb-2 relative shadow-md overflow-visible">
                      {/* Small ball image cutting into the team icon */}
                      <div className="absolute -right-1.5 -bottom-8 w-18 h-18 opacity-40 pointer-events-none">
                        <img
                          src="/assets/design/wao-ball.png"
                          alt="ball"
                          className="w-full h-full object-contain brightness-0 invert opacity-80"
                        />
                      </div>

                      <span className="text-white font-bold text-sm relative z-10">
                        {game.team2.substring(0, 2).toUpperCase()}
                      </span>
                    </div>
                    <p className="text-gray-500 text-[12px] font-semibold text-center line-clamp-1">
                      {game.team2}
                    </p>
                  </div>
                </div>

                {/* Championship */}
                <div className="text-center mb-3 relative z-10">
                  <p className="text-gray-400 text-xs uppercase tracking-wider font-medium">
                    {game.championship}
                  </p>
                </div>

                {/* Divider */}
                <div className="border-t border-gray-200 my-3"></div>

                {/* Additional Info */}
                <div className="flex items-center justify-between text-xs relative z-10">
                  <div className="flex items-center gap-1 text-gray-400">
                    <MapPin className="w-3.5 h-3.5" />
                    <span>{game.venue}</span>
                  </div>
                  <div className="flex items-center gap-1 text-gray-400">
                    <Calendar className="w-3.5 h-3.5" />
                    <span>{game.date}</span>
                  </div>
                </div>
              </div>
            ))
          ) : (
            // Empty State
            <div className="w-full min-h-[300px] flex flex-col items-center justify-center py-8">
              <div className="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                <Trophy className="w-10 h-10 text-gray-400" />
              </div>
              <h4 className="text-[#011B3B] font-semibold text-lg mb-2">
                No Upcoming Games
              </h4>
              <p className="text-gray-500 text-sm text-center mb-6 max-w-xs">
                There are no scheduled games at the moment. Create a new game
                to get started.
              </p>
              <button className="px-6 py-2.5 bg-gradient-to-r from-[#D30336] to-[#FF3366] text-white rounded-lg font-medium hover:shadow-lg transition-all duration-200 flex items-center gap-2">
                <Calendar className="w-4 h-4" />
                Schedule Game
              </button>
            </div>
          )}
        </div>
      </div>

      {/* Scrollbar hide styles */}
      <style jsx>{`
        .scrollbar-hide::-webkit-scrollbar {
          display: none;
        }
        .scrollbar-hide {
          -ms-overflow-style: none;
          scrollbar-width: none;
        }
      `}</style>
    </div>
  );
};

export default UpcomingGames;