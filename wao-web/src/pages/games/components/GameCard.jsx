import React, { useState } from "react";
import { Calendar, MapPin, Clock, Play, Eye, Copy, Check, Radio } from "lucide-react";
import { useNavigate } from "react-router-dom";

const GameCard = ({ game, onStartGame }) => {
  const navigate = useNavigate();
  const [copied, setCopied] = useState(false);

  const handleCopyCode = (e) => {
    e.stopPropagation();
    navigator.clipboard.writeText(game.accessCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const isLive = game.status === "live";
  const isCompleted = game.status === "completed";

  return (
    <div className={`rounded-2xl border overflow-hidden transition-all hover:shadow-lg ${
      isLive
        ? "bg-gradient-to-br from-[#1a0a0e] to-[#2d0a14] border-[#D30336]/30"
        : "bg-white border-gray-100"
    }`}>

      {/* Card Top */}
      <div className="p-4">
        {/* Status + Championship */}
        <div className="flex items-center justify-between mb-4">
          <span className="text-xs text-gray-400 font-medium uppercase tracking-wide truncate max-w-[60%]">
            {isLive ? <span className="text-white/50">{game.championship}</span> : game.championship}
          </span>
          {isLive ? (
            <span className="flex items-center gap-1 bg-[#D30336] text-white text-xs font-bold px-2.5 py-1 rounded-full">
              <span className="w-1.5 h-1.5 bg-white rounded-full animate-pulse" /> LIVE
            </span>
          ) : isCompleted ? (
            <span className="text-xs bg-gray-100 text-gray-500 font-semibold px-2.5 py-1 rounded-full">FT</span>
          ) : (
            <span className="text-xs bg-blue-100 text-blue-700 font-semibold px-2.5 py-1 rounded-full">Upcoming</span>
          )}
        </div>

        {/* Teams + Score */}
        <div className="flex items-center justify-between gap-2">
          {/* Home */}
          <div className="flex flex-col items-center flex-1">
            <div className="w-12 h-12 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center shadow-md mb-1.5">
              <span className="text-white font-bold text-xs">{game.homeTeam.substring(0, 2).toUpperCase()}</span>
            </div>
            <p className={`text-xs font-semibold text-center line-clamp-1 ${isLive ? "text-white" : "text-[#011B3B]"}`}>
              {game.homeTeam}
            </p>
            {(isLive || isCompleted) && (
              <p className={`text-2xl font-bold mt-1 ${isLive ? "text-white" : "text-[#011B3B]"}`}>{game.homeScore}</p>
            )}
          </div>

          {/* Middle */}
          <div className="flex flex-col items-center">
            {isLive ? (
              <div className="flex flex-col items-center">
                <div className="flex items-center gap-2 bg-white/10 rounded-xl px-3 py-1.5">
                  <span className="text-xl font-bold text-white">{game.homeScore}</span>
                  <span className="text-white/40">:</span>
                  <span className="text-xl font-bold text-white">{game.awayScore}</span>
                </div>
                <p className="text-[#FFC600] text-xs font-semibold mt-1">{game.currentQuarter} · {game.timeRemaining}</p>
              </div>
            ) : (
              <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white text-xs font-bold px-3 py-1.5 rounded-lg">
                {isCompleted ? "FT" : "VS"}
              </div>
            )}
          </div>

          {/* Away */}
          <div className="flex flex-col items-center flex-1">
            <div className="w-12 h-12 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center shadow-md mb-1.5">
              <span className="text-white font-bold text-xs">{game.awayTeam.substring(0, 2).toUpperCase()}</span>
            </div>
            <p className={`text-xs font-semibold text-center line-clamp-1 ${isLive ? "text-white" : "text-[#011B3B]"}`}>
              {game.awayTeam}
            </p>
            {(isLive || isCompleted) && (
              <p className={`text-2xl font-bold mt-1 ${isLive ? "text-white" : "text-[#011B3B]"}`}>{game.awayScore}</p>
            )}
          </div>
        </div>
      </div>

      {/* Card Footer */}
      <div className={`px-4 pb-4 space-y-3 ${isLive ? "border-t border-white/10 pt-3" : "border-t border-gray-100 pt-3"}`}>
        {/* Meta info */}
        <div className="flex items-center justify-between text-xs">
          <span className={`flex items-center gap-1 ${isLive ? "text-white/50" : "text-gray-400"}`}>
            <MapPin className="w-3 h-3" />{game.venue}
          </span>
          <span className={`flex items-center gap-1 ${isLive ? "text-white/50" : "text-gray-400"}`}>
            <Calendar className="w-3 h-3" />{game.date}
          </span>
        </div>

        {/* Access code */}
        {game.status === "upcoming" && (
          <div className="flex items-center justify-between bg-yellow-50 border border-yellow-200 rounded-xl px-3 py-2">
            <div>
              <p className="text-xs text-gray-500">Access Code</p>
              <p className="text-sm font-bold text-[#011B3B] font-mono">{game.accessCode}</p>
            </div>
            <button onClick={handleCopyCode} className="p-1.5 hover:bg-yellow-100 rounded-lg transition-colors">
              {copied ? <Check className="w-4 h-4 text-green-600" /> : <Copy className="w-4 h-4 text-gray-500" />}
            </button>
          </div>
        )}

        {/* Actions */}
        <div className="flex gap-2">
          <button
            onClick={() => navigate(`/games/${game.id}`)}
            className={`flex-1 flex items-center justify-center gap-1.5 py-2 rounded-xl text-sm font-semibold transition-all ${
              isLive ? "bg-white/10 text-white hover:bg-white/20" : "bg-gray-100 text-gray-700 hover:bg-gray-200"
            }`}
          >
            <Eye className="w-3.5 h-3.5" /> Details
          </button>

          {game.status === "upcoming" && (
            <button
              onClick={() => onStartGame(game.id)}
              className="flex-1 flex items-center justify-center gap-1.5 py-2 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white rounded-xl text-sm font-semibold hover:shadow-lg transition-all"
            >
              <Play className="w-3.5 h-3.5" /> Start
            </button>
          )}

          {isLive && (
            <button
              onClick={() => navigate(`/games/${game.id}/simulate`)}
              className="flex-1 flex items-center justify-center gap-1.5 py-2 bg-[#D30336] text-white rounded-xl text-sm font-semibold hover:shadow-lg transition-all"
            >
              <Radio className="w-3.5 h-3.5" /> Continue
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default GameCard;
