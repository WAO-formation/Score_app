import React from 'react';
import { Calendar, MapPin, Trophy } from 'lucide-react';

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

      {/* Scrollable Container */}
      
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