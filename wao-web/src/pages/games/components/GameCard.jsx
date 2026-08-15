import React, { useState, useEffect } from "react";
import { Calendar, MapPin, Play, Eye, Copy, Check, Radio, Clock, CalendarClock, Ban } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { useAuth } from "../../../context/AuthContext";
import { useGames } from "../../../context/GamesContext";
import { subscribeToAccessCode, canStartGame, isPastDue } from "../../../services/matchesService";
import RescheduleModal from "./RescheduleModal";
import CancelGameModal from "./CancelGameModal";
import { BRAND } from "../../../config/brand";
const B = BRAND.font.body;
const H = BRAND.font.heading;

const GameCard = ({ game, onStartGame }) => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { getFormattedTimer, updateGame } = useGames();
  const [copied, setCopied] = useState(false);
  const [accessCode, setAccessCode] = useState(null);
  const [showReschedule, setShowReschedule] = useState(false);
  const [showCancel, setShowCancel] = useState(false);

  const { timeRemaining, currentQuarter } = getFormattedTimer(game.id);

  // The access code is how a game gets started/simulated — admins see every
  // code for oversight, but a moderator only sees the code for the game
  // they were actually assigned (set at creation, Management > Games). It
  // lives in a private subcollection (see firestore.rules) so this is the
  // real security boundary, not just a UI hide. The same admin-or-assigned
  // check gates who can actually write a reschedule/cancel — reuse it here
  // so the buttons aren't offered to someone whose write firestore.rules
  // would reject anyway.
  const canSeeAccessCode = user?.role === "admin" || (!!user?.uid && game.moderatorUid === user.uid);
  const canManage = canSeeAccessCode;
  const canStart = canStartGame(game);
  const pastDue = isPastDue(game);

  useEffect(() => {
    if (!canSeeAccessCode || game.status !== "upcoming") return;
    return subscribeToAccessCode(game.id, setAccessCode, () => setAccessCode(null));
  }, [canSeeAccessCode, game.id, game.status]);

  const handleCopyCode = (e) => {
    e.stopPropagation();
    navigator.clipboard.writeText(accessCode || "");
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleReschedule = (newDate) => updateGame(game.id, { startTime: newDate });
  const handleCancelGame = (reason) => updateGame(game.id, { status: "cancelled", statusReason: reason });

  const isLive      = game.status === "live";
  const isCompleted = game.status === "completed";

  return (
    <div className="bg-white border border-gray-100 overflow-hidden transition-all hover:shadow-md">

      {/* ── Top ── */}
      <div className="p-4">

        {/* Championship + status badge */}
        <div className="flex items-center justify-between mb-4">
          <span className="text-xs font-medium uppercase tracking-wide truncate max-w-[60%] text-gray-400" style={{ fontFamily: B }}>
            {game.championship}
          </span>
          {isLive ? (
            <span className="flex items-center gap-1 bg-emerald-500 text-white text-xs font-bold px-2.5 py-1" style={{ fontFamily: B }}>
              <span className="w-1.5 h-1.5 bg-white rounded-full animate-pulse" /> LIVE
            </span>
          ) : isCompleted ? (
            <span className="text-xs font-semibold px-2.5 py-1 bg-gray-100 text-gray-500" style={{ fontFamily: B }}>FT</span>
          ) : (
            <span className="text-xs font-semibold px-2.5 py-1 bg-blue-100 text-blue-700" style={{ fontFamily: B }}>Upcoming</span>
          )}
        </div>

        {/* Teams + score */}
        <div className="flex items-center justify-between gap-2">

          {/* Home */}
          <div className="flex flex-col items-center flex-1 gap-1">
            <div className="w-12 h-12 bg-amber-400 flex items-center justify-center mb-0.5">
              <span className="text-white font-medium text-xs" style={{ fontFamily: H }}>{game.homeTeam.substring(0, 2).toUpperCase()}</span>
            </div>
            <p className="text-xs font-semibold text-center line-clamp-1 text-[#011B3B]" style={{ fontFamily: B }}>{game.homeTeam}</p>
            {(isLive || isCompleted) && (
              <p className="text-2xl mt-0.5 text-[#011B3B]" style={{ fontFamily: H }}>{game.homeScore}</p>
            )}
          </div>

          {/* Middle */}
          <div className="flex flex-col items-center gap-1">
            {isLive ? (
              <>
                {/* show time instead of away score in the middle */}
                <div className="flex flex-col items-center bg-emerald-50 border border-emerald-200 px-3 py-2 gap-0.5">
                  <span className="text-emerald-600 text-[10px] font-bold uppercase tracking-widest" style={{ fontFamily: B }}>{currentQuarter}</span>
                  <span className="text-emerald-700 text-base font-bold tabular-nums flex items-center gap-1" style={{ fontFamily: H }}>
                    <Clock className="w-3 h-3" />{timeRemaining}
                  </span>
                </div>
              </>
            ) : (
              <div className="bg-[#011B3B] text-white text-xs font-bold px-3 py-1.5" style={{ fontFamily: B }}>
                {isCompleted ? "FT" : "VS"}
              </div>
            )}
          </div>

          {/* Away */}
          <div className="flex flex-col items-center flex-1 gap-1">
            <div className="w-12 h-12 bg-[#c81434] flex items-center justify-center mb-0.5">
              <span className="text-white font-medium text-xs" style={{ fontFamily: H }}>{game.awayTeam.substring(0, 2).toUpperCase()}</span>
            </div>
            <p className="text-xs font-semibold text-center line-clamp-1 text-[#011B3B]" style={{ fontFamily: B }}>{game.awayTeam}</p>
            {(isLive || isCompleted) && (
              <p className="text-2xl mt-0.5 text-[#011B3B]" style={{ fontFamily: H }}>{game.awayScore}</p>
            )}
          </div>
        </div>
      </div>

      {/* ── Footer ── */}
      <div className="px-4 pb-4 pt-3 space-y-3 border-t border-gray-100">

        {/* Meta */}
        <div className="flex items-center justify-between text-xs text-gray-400" style={{ fontFamily: B }}>
          <span className="flex items-center gap-1"><MapPin className="w-3 h-3" />{game.venue}</span>
          <span className="flex items-center gap-1"><Calendar className="w-3 h-3" />{game.date}</span>
        </div>

        {/* Access code — upcoming games only, and only to admins / the assigned moderator */}
        {game.status === "upcoming" && canSeeAccessCode && accessCode && (
          <div className="flex items-center justify-between bg-amber-50 border border-amber-200 px-3 py-2">
            <div>
              <p className="text-xs text-gray-500" style={{ fontFamily: B }}>Access Code</p>
              <p className="text-sm font-bold text-[#011B3B] font-mono">{accessCode}</p>
            </div>
            <button onClick={handleCopyCode} className="p-1.5 hover:bg-amber-100 transition-colors">
              {copied ? <Check className="w-4 h-4 text-emerald-600" /> : <Copy className="w-4 h-4 text-gray-400" />}
            </button>
          </div>
        )}

        {/* Can't start before the scheduled date/time */}
        {game.status === "upcoming" && !pastDue && !canStart && (
          <p className="text-xs text-amber-600 text-center" style={{ fontFamily: B }}>
            Starts {game.date} at {game.time}
          </p>
        )}

        {/* Scheduled day passed with nobody starting it */}
        {pastDue && (
          <p className="text-xs text-red-500 text-center font-medium" style={{ fontFamily: B }}>
            Missed — was scheduled {game.date} at {game.time}
          </p>
        )}

        {/* Actions */}
        <div className="flex flex-wrap gap-2">
          <button
            onClick={() => navigate(`/games/${game.id}`)}
            className="flex-1 flex items-center justify-center gap-1.5 py-2 text-sm font-semibold transition-all bg-gray-100 text-gray-700 hover:bg-gray-200"
            style={{ fontFamily: B }}
          >
            <Eye className="w-3.5 h-3.5" /> Details
          </button>

          {game.status === "upcoming" && !pastDue && (
            <button
              onClick={() => canStart && onStartGame(game.id)}
              disabled={!canStart}
              title={canStart ? undefined : `Available from ${game.date} ${game.time}`}
              className={`flex-1 flex items-center justify-center gap-1.5 py-2 text-sm font-semibold transition-all ${
                canStart ? "bg-[#c81434] text-white hover:bg-[#e21e43]" : "bg-gray-100 text-gray-400 cursor-not-allowed"
              }`}
              style={{ fontFamily: B }}
            >
              <Play className="w-3.5 h-3.5" /> Start
            </button>
          )}

          {pastDue && canManage && (
            <>
              <button
                onClick={() => setShowReschedule(true)}
                className="flex-1 flex items-center justify-center gap-1.5 py-2 bg-sky-500 text-white text-sm font-semibold hover:bg-sky-400 transition-all"
                style={{ fontFamily: B }}
              >
                <CalendarClock className="w-3.5 h-3.5" /> Reschedule
              </button>
              <button
                onClick={() => setShowCancel(true)}
                className="flex-1 flex items-center justify-center gap-1.5 py-2 bg-white text-[#c81434] border border-[#c81434]/30 text-sm font-semibold hover:bg-red-50 transition-all"
                style={{ fontFamily: B }}
              >
                <Ban className="w-3.5 h-3.5" /> Cancel
              </button>
            </>
          )}

          {isLive && (
            <button
              onClick={() => navigate(`/games/${game.id}/simulate`)}
              className="flex-1 flex items-center justify-center gap-1.5 py-2 bg-emerald-500 text-white text-sm font-semibold hover:bg-emerald-400 transition-all"
              style={{ fontFamily: B }}
            >
              <Radio className="w-3.5 h-3.5" /> Continue
            </button>
          )}
        </div>
      </div>

      {showReschedule && (
        <RescheduleModal game={game} onSave={handleReschedule} onClose={() => setShowReschedule(false)} />
      )}
      {showCancel && (
        <CancelGameModal game={game} onConfirm={handleCancelGame} onClose={() => setShowCancel(false)} />
      )}
    </div>
  );
};

export default GameCard;
