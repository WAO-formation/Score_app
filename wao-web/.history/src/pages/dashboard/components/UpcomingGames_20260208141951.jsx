import React, { useRef, useEffect } from "react";
import { Calendar, MapPin, Trophy } from "lucide-react";

const UpcomingGames = ({ games = [] }) => {
  const scrollContainerRef = useRef(null);

  useEffect(() => {
    const scrollContainer = scrollContainerRef.current;
    if (!scrollContainer || games.length === 0) return;

    let scrollInterval;
    let isScrolling = false;
    let scrollDirection = 1; // 1 for right, -1 for left

    const startAutoScroll = () => {
      scrollInterval = setInterval(() => {
        if (!scrollContainer) return;

        const maxScroll =
          scrollContainer.scrollWidth - scrollContainer.clientWidth;
        const currentScroll = scrollContainer.scrollLeft;

        // Check if we've reached the end or start
        if (currentScroll >= maxScroll) {
          scrollDirection = -1; // Scroll left
        } else if (currentScroll <= 0) {
          scrollDirection = 1; // Scroll right
        }

        // Scroll smoothly
        scrollContainer.scrollBy({
          left: scrollDirection * 2, // Adjust speed here (higher = faster)
          behavior: "smooth",
        });
      }, 30); // Adjust interval for smoother/faster scrolling
    };

    // Start auto-scrolling after a brief delay
    const timeoutId = setTimeout(() => {
      startAutoScroll();
    }, 2000);

    // Pause on hover
    const handleMouseEnter = () => {
      clearInterval(scrollInterval);
      isScrolling = false;
    };

    // Resume on mouse leave
    const handleMouseLeave = () => {
      if (!isScrolling) {
        startAutoScroll();
        isScrolling = true;
      }
    };

    scrollContainer.addEventListener("mouseenter", handleMouseEnter);
    scrollContainer.addEventListener("mouseleave", handleMouseLeave);

    // Cleanup
    return () => {
      clearTimeout(timeoutId);
      clearInterval(scrollInterval);
      if (scrollContainer) {
        scrollContainer.removeEventListener("mouseenter", handleMouseEnter);
        scrollContainer.removeEventListener("mouseleave", handleMouseLeave);
      }
    };
  }, [games]);

  return (
    <div className="w-full bg-gradient-to-br from-gray-900 via-gray-800 to-gray-900 rounded-2xl shadow-2xl p-6 border border-gray-700">
      {/* Header */}
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-3xl font-bold text-white flex items-center gap-3">
          <Trophy className="text-yellow-400" size={32} />
          Upcoming Games
        </h2>
        {games.length > 0 && (
          <span className="bg-blue-500/20 text-blue-400 px-4 py-2 rounded-full text-sm font-semibold border border-blue-500/30">
            {games.length} games
          </span>
        )}
      </div>

      {/* Scrollable Container */}
      <div
        ref={scrollContainerRef}
        className="flex gap-6 overflow-x-auto pb-4 scroll-smooth"
        style={{
          scrollbarWidth: "none",
          msOverflowStyle: "none",
        }}
      >
        {games.length > 0 ? (
          // Game Cards
          games.map((game, index) => (
            <div
              key={index}
              className="min-w-[380px] bg-gradient-to-br from-gray-800 to-gray-900 rounded-xl p-6 border border-gray-700 hover:border-blue-500/50 transition-all duration-300 hover:shadow-xl hover:shadow-blue-500/20 relative overflow-hidden"
            >
              {/* Background Ball Image */}
              <div className="absolute top-0 right-0 w-40 h-40 opacity-5">
                <img
                  src="/api/placeholder/160/160"
                  alt="Ball"
                  className="w-full h-full object-contain"
                />
              </div>

              {/* Teams Section */}
              <div className="relative z-10 flex items-center justify-between mb-4">
                {/* Team 1 */}
                <div className="flex flex-col items-center gap-2 relative">
                  <div className="w-20 h-20 bg-gradient-to-br from-blue-500 to-blue-600 rounded-full flex items-center justify-center text-white font-bold text-xl shadow-lg relative">
                    {/* Small ball image */}
                    <div className="absolute -bottom-2 -right-2 w-8 h-8 bg-white rounded-full shadow-md overflow-hidden">
                      <img
                        src="/api/placeholder/32/32"
                        alt="Ball"
                        className="w-full h-full object-cover"
                      />
                    </div>
                    {game.team1.substring(0, 2).toUpperCase()}
                  </div>
                  <span className="text-white font-semibold text-sm">
                    {game.team1}
                  </span>
                </div>

                {/* VS Badge */}
                <div className="flex flex-col items-center gap-1 mx-4">
                  <div className="bg-gradient-to-r from-red-500 to-orange-500 px-4 py-2 rounded-lg text-white font-bold shadow-lg">
                    VS
                  </div>
                  <div className="bg-green-500/20 text-green-400 px-3 py-1 rounded-full text-xs font-semibold border border-green-500/30">
                    Today
                  </div>
                  <span className="text-gray-400 text-xs font-medium">
                    {game.time}
                  </span>
                </div>

                {/* Team 2 */}
                <div className="flex flex-col items-center gap-2 relative">
                  <div className="w-20 h-20 bg-gradient-to-br from-purple-500 to-purple-600 rounded-full flex items-center justify-center text-white font-bold text-xl shadow-lg relative">
                    {/* Small ball image */}
                    <div className="absolute -bottom-2 -left-2 w-8 h-8 bg-white rounded-full shadow-md overflow-hidden">
                      <img
                        src="/api/placeholder/32/32"
                        alt="Ball"
                        className="w-full h-full object-cover"
                      />
                    </div>
                    {game.team2.substring(0, 2).toUpperCase()}
                  </div>
                  <span className="text-white font-semibold text-sm">
                    {game.team2}
                  </span>
                </div>
              </div>

              {/* Championship */}
              <div className="bg-yellow-500/10 border border-yellow-500/30 rounded-lg p-2 mb-3 text-center">
                <span className="text-yellow-400 font-semibold text-sm">
                  {game.championship}
                </span>
              </div>

              {/* Divider */}
              <div className="h-px bg-gradient-to-r from-transparent via-gray-600 to-transparent mb-3" />

              {/* Additional Info */}
              <div className="space-y-2">
                <div className="flex items-center gap-2 text-gray-300 text-sm">
                  <MapPin size={16} className="text-red-400" />
                  <span>{game.venue}</span>
                </div>
                <div className="flex items-center gap-2 text-gray-300 text-sm">
                  <Calendar size={16} className="text-blue-400" />
                  <span>{game.date}</span>
                </div>
              </div>
            </div>
          ))
        ) : (
          // Empty State
          <div className="w-full flex flex-col items-center justify-center py-16 px-4">
            <div className="bg-gray-800/50 rounded-full p-6 mb-4">
              <Trophy className="text-gray-600" size={48} />
            </div>
            <h3 className="text-xl font-bold text-gray-400 mb-2">
              No Upcoming Games
            </h3>
            <p className="text-gray-500 text-center mb-6 max-w-md">
              There are no scheduled games at the moment. Create a new game to
              get started.
            </p>
            <button className="bg-blue-500 hover:bg-blue-600 text-white px-6 py-3 rounded-lg font-semibold transition-colors duration-200 shadow-lg hover:shadow-xl">
              Schedule Game
            </button>
          </div>
        )}
      </div>

      {/* Scrollbar hide styles */}
      <style jsx>{`
        div::-webkit-scrollbar {
          display: none;
        }
      `}</style>
    </div>
  );
};

export default UpcomingGames;