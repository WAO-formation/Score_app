// src/pages/Games/components/GameCard.jsx
import React from "react";
import { Calendar, MapPin, Clock, Play, Eye, Copy, Check } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useState } from "react";

const GameCard = ({ game, onStartGame }) => {
  const navigate = useNavigate();
  const [copied, setCopied] = useState(false);

  const handleCopyCode = () => {
    navigator.clipboard.writeText(game.accessCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleViewDetails = () => {
    navigate(`/games/${game.id}`);
  };

  return (
    <div className="bg-gradient-to-br from-gray-50 to-white rounded-xl p-4 border border-gray-200 hover:shadow-lg transition-all relative overflow-hidden">
      {/* Status Badge */}
      <div className="absolute top-4  right-4 z-10">
        <div
          className={`px-3 py-1 rounded-full text-xs font-bold text-white ${
            game.status === "live"
              ? "bg-red-500 animate-pulse"
              : game.status === "upcoming"
                ? "bg-blue-500"
                : "bg-gray-500"
          }`}
        >
          {game.status === "live" ? "LIVE" : game.status.toUpperCase()}
        </div>
      </div>

      {/* Teams Section */}
      <div className="flex items-center justify-between mb-4 relative z-10 mt-2">
        {/* Home Team */}
        <div className="flex flex-col items-center flex-1">
          <div className="w-14 h-14 bg-yellow-400 rounded-full flex items-center justify-center mb-2 relative shadow-md overflow-visible">
            {/* Small ball image cutting into the team icon */}
            <div className="absolute -left-15 -top-18 w-30 h-30 opacity-40 pointer-events-none">
              <img
                src="/assets/design/wao-ball.png"
                alt="ball"
                className="w-full h-full object-contain brightness-0 invert opacity-80"
              />
            </div>

            <span className="text-white font-bold text-sm relative z-10">
              {game.homeTeam.substring(0, 2).toUpperCase()}
            </span>
          </div>

          <p className="text-gray-700 text-xs font-semibold text-center line-clamp-1">
            {game.homeTeam}
          </p>
          {game.status === "completed" && (
            <p className="text-2xl font-bold text-[#011B3B] mt-1">
              {game.homeScore}
            </p>
          )}
        </div>

        {/* VS Badge */}
        <div className="flex flex-col items-center mx-3">
          <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] px-4 py-2 rounded-lg shadow-md">
            <span className="text-white font-bold text-sm">VS</span>
          </div>
          {game.status === "live" && (
            <div className="mt-2 text-center">
              <p className="text-green-600 text-xs font-bold">
                {game.currentQuarter}
              </p>
              <p className="text-gray-600 text-xs">{game.timeRemaining}</p>
            </div>
          )}
        </div>

        {/* Away Team */}
        <div className="flex flex-col items-center flex-1">
          <div className="w-14 h-14 bg-[#A50229] rounded-full flex items-center justify-center mb-2 relative shadow-md overflow-visible">
            {/* Small ball image cutting into the team icon */}
            <div className="absolute -right-15 -bottom-18 w-30 h-30 opacity-40 pointer-events-none">
              <img
                src="/assets/design/wao-ball.png"
                alt="ball"
                className="w-full h-full object-contain brightness-0 invert opacity-80"
              />
            </div>

            <span className="text-white font-bold text-sm relative z-10">
              {game.awayTeam.substring(0, 2).toUpperCase()}
            </span>
          </div>
          <p className="text-gray-700 text-xs font-semibold text-center line-clamp-1">
            {game.awayTeam}
          </p>
          {game.status === "completed" && (
            <p className="text-2xl font-bold text-[#011B3B] mt-1">
              {game.awayScore}
            </p>
          )}
        </div>
      </div>

      {/* Game Info */}
      <div className="space-y-2 mb-4 relative z-10">
        <div className="flex items-center gap-2 text-xs text-gray-600">
          <Calendar className="w-3.5 h-3.5" />
          <span>{game.date}</span>
        </div>
        <div className="flex items-center gap-2 text-xs text-gray-600">
          <Clock className="w-3.5 h-3.5" />
          <span>{game.time}</span>
        </div>
        <div className="flex items-center gap-2 text-xs text-gray-600">
          <MapPin className="w-3.5 h-3.5" />
          <span>{game.venue}</span>
        </div>
      </div>

      {/* Access Code (for upcoming games) */}
      {game.status === "upcoming" && (
        <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-3 mb-4 relative z-10">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-xs text-gray-600 mb-1">Access Code</p>
              <p className="text-sm font-bold text-[#011B3B] font-mono">
                {game.accessCode}
              </p>
            </div>
            <button
              onClick={handleCopyCode}
              className="p-2 hover:bg-yellow-100 rounded-lg transition-colors"
            >
              {copied ? (
                <Check className="w-4 h-4 text-green-600" />
              ) : (
                <Copy className="w-4 h-4 text-gray-600" />
              )}
            </button>
          </div>
        </div>
      )}

      {/* Divider */}
      <div className="border-t border-gray-200 my-4"></div>

      {/* Action Buttons */}
      <div className="flex gap-2 relative z-10">
        <button
          onClick={handleViewDetails}
          className="flex-1 flex items-center justify-center gap-2 px-4 py-2 bg-gray-100 text-gray-700 font-medium rounded-lg hover:bg-gray-200 transition-all"
        >
          <Eye className="w-4 h-4" />
          <span className="text-sm">Details</span>
        </button>

        {game.status === "upcoming" && (
          <button
            onClick={() => onStartGame(game.id)}
            className="flex-1 flex items-center justify-center gap-2 px-4 py-2 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-medium rounded-lg hover:shadow-lg transition-all"
          >
            <Play className="w-4 h-4" />
            <span className="text-sm">Start</span>
          </button>
        )}

        {game.status === "live" && (
          <button
            onClick={() => navigate(`/games/${game.id}/simulate`)}
            className="flex-1 flex items-center justify-center gap-2 px-4 py-2 bg-gradient-to-br from-green-500 to-green-600 text-white font-medium rounded-lg hover:shadow-lg transition-all animate-pulse"
          >
            <Play className="w-4 h-4" />
            <span className="text-sm">Resume</span>
          </button>
        )}
      </div>
    </div>
  );
};

export default GameCard;
