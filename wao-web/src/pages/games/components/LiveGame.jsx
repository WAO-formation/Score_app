import { useState } from 'react';
import {
  ArrowLeft, Play, Pause, RotateCcw, Plus, Clock,
  Trophy, AlertCircle, Flag, Zap, Activity, Target,
} from 'lucide-react';
import { useGameSimulation } from '../hooks/useGameSimulation';
import ScoreModal from './simulation/ScoreModal';
import FoulModal from './simulation/FoulModal';
import TimeAdjustModal from './simulation/TimeAdjustModal';
import QuarterTransition from './simulation/QuarterTransition';

const SCORE_CATEGORIES = [
  { key: 'kingdom', label: 'Kingdom', pct: '30%' },
  { key: 'workout', label: 'Workout', pct: '30%' },
  { key: 'goalSetting', label: 'Goal Setting', pct: '30%' },
  { key: 'judges', label: 'Judges', pct: '10%' },
];

const Avatar = ({ name, gradient, size }) => {
  const cls = size === 'sm'
    ? 'w-10 h-10 text-xs'
    : 'w-16 h-16 sm:w-20 sm:h-20 text-lg sm:text-xl';
  return (
    <div className={`${cls} bg-gradient-to-br ${gradient} rounded-full flex items-center justify-center shadow-lg flex-shrink-0`}>
      <span className="text-white font-black">{name.substring(0, 2).toUpperCase()}</span>
    </div>
  );
};

const GameSimulation = () => {
  const {
    game, isPlaying, setIsPlaying, currentQuarter, timeRemaining,
    setTime, resetQuarterTime, advanceQuarter, handleEndGame,
    addScore, addFoul, formatTime, showQuarterTransition, gameId, navigate,
  } = useGameSimulation();

  const [showScoreModal, setShowScoreModal] = useState(false);
  const [showFoulModal, setShowFoulModal] = useState(false);
  const [showTimeAdjust, setShowTimeAdjust] = useState(false);

  const gameEnded = game?.status === 'completed';
  // Non-judge scoring only allowed while timer is actively running
  const canScore = isPlaying && !gameEnded;
  // Judges can score only when timer is paused AND game is not pre-started (at least Q1 has begun)
  const judgesCanScore = !isPlaying;

  if (!game) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-[#D30336] mx-auto mb-3" />
          <p className="text-gray-500 text-sm">Loading game...</p>
        </div>
      </div>
    );
  }

  return (
    <section className="min-h-screen bg-gray-50 pb-10">
      {showQuarterTransition && <QuarterTransition currentQuarter={currentQuarter} />}

      {/* ── Scoreboard Header ── */}
      <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] px-4 pt-10 sm:pt-12 pb-6 relative overflow-hidden">
        {/* decorative ball */}
        <img src="/assets/design/wao-ball.png" alt="" aria-hidden
          className="absolute -right-16 -top-16 w-48 h-48 object-contain opacity-5 pointer-events-none" />

        {/* top bar */}
        <div className="relative flex items-center justify-between mb-4">
          <button
            onClick={() => navigate('/games')}
            className="flex items-center gap-1.5 text-white/70 hover:text-white transition-colors text-sm"
          >
            <ArrowLeft className="w-4 h-4" />
            Back
          </button>
          <div className="flex items-center gap-1.5 bg-red-500 px-3 py-1 rounded-full">
            <span className="w-2 h-2 bg-white rounded-full animate-ping" />
            <span className="text-white font-bold text-xs tracking-wide">LIVE</span>
          </div>
        </div>

        {/* scores row */}
        <div className="relative grid grid-cols-3 items-center gap-2">
          {/* Home */}
          <div className="flex flex-col items-center gap-1.5">
            <Avatar name={game.homeTeam} gradient="from-[#FFC600] to-[#FF6B35]" />
            <p className="text-white/80 text-xs font-medium text-center leading-tight line-clamp-2 max-w-[80px]">
              {game.homeTeam}
            </p>
            <span className="text-white text-4xl sm:text-5xl font-black tabular-nums">{game.homeScore}</span>
          </div>

          {/* Timer */}
          <div className="flex flex-col items-center gap-2">
            <span className="text-[#FFC600] text-xs font-bold tracking-widest">Q{currentQuarter}</span>
            <button
              onClick={() => setShowTimeAdjust(true)}
              className="text-white text-3xl sm:text-4xl font-black tabular-nums hover:text-[#FFC600] transition-colors leading-none"
              title="Tap to adjust time"
            >
              {formatTime(timeRemaining)}
            </button>
            <div className="flex gap-2 mt-1">
              <button
                onClick={() => setIsPlaying(!isPlaying)}
                className="bg-white/15 hover:bg-white/25 active:bg-white/35 p-2.5 rounded-xl transition-colors"
              >
                {isPlaying
                  ? <Pause className="w-5 h-5 text-white" />
                  : <Play className="w-5 h-5 text-white" />}
              </button>
              <button
                onClick={resetQuarterTime}
                className="bg-white/15 hover:bg-white/25 active:bg-white/35 p-2.5 rounded-xl transition-colors"
                title="Reset time"
              >
                <RotateCcw className="w-5 h-5 text-white" />
              </button>
              <button
                onClick={() => setShowTimeAdjust(true)}
                className="bg-white/15 hover:bg-white/25 active:bg-white/35 p-2.5 rounded-xl transition-colors"
                title="Set time"
              >
                <Clock className="w-5 h-5 text-white" />
              </button>
            </div>
          </div>

          {/* Away */}
          <div className="flex flex-col items-center gap-1.5">
            <Avatar name={game.awayTeam} gradient="from-[#D30336] to-[#a8022b]" />
            <p className="text-white/80 text-xs font-medium text-center leading-tight line-clamp-2 max-w-[80px]">
              {game.awayTeam}
            </p>
            <span className="text-white text-4xl sm:text-5xl font-black tabular-nums">{game.awayScore}</span>
          </div>
        </div>
      </div>

      <div className="px-3 sm:px-4 mt-4 space-y-4">
        {/* ── Action Buttons ── */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5">
          {[
            { label: 'Add Score', icon: Plus, color: 'from-emerald-500 to-emerald-600', onClick: () => setShowScoreModal(true), disabled: gameEnded && !judgesCanScore },
            { label: 'Add Foul', icon: AlertCircle, color: 'from-red-500 to-red-600', onClick: () => setShowFoulModal(true) },
            { label: 'Next Quarter', icon: Flag, color: 'from-blue-500 to-blue-600', onClick: advanceQuarter, disabled: currentQuarter >= 4 },
            { label: 'End Game', icon: Trophy, color: 'from-purple-500 to-purple-600', onClick: handleEndGame },
          ].map(({ label, icon: Icon, color, onClick, disabled }) => (
            <button
              key={label}
              onClick={onClick}
              disabled={disabled}
              className={`bg-gradient-to-br ${color} text-white font-semibold py-3 px-3 rounded-xl hover:shadow-lg active:scale-95 transition-all flex items-center justify-center gap-2 text-sm disabled:opacity-40 disabled:cursor-not-allowed`}
            >
              <Icon className="w-4 h-4 flex-shrink-0" />
              <span className="truncate">{label}</span>
            </button>
          ))}
        </div>

        {/* ── Stats Grid ── */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
          {/* Quarter Breakdown */}
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-4">
            <h3 className="text-sm font-bold text-[#011B3B] mb-3 flex items-center gap-2">
              <Activity className="w-4 h-4 text-[#D30336]" /> Quarter Breakdown
            </h3>
            {/* legend */}
            <div className="flex justify-between text-xs text-gray-400 font-medium px-1 mb-1">
              <span>Quarter</span>
              <div className="flex gap-6">
                <span className="text-yellow-500">{game.homeTeam.split(' ')[0]}</span>
                <span className="text-red-500">{game.awayTeam.split(' ')[0]}</span>
              </div>
            </div>
            <div className="space-y-1.5">
              {[1, 2, 3, 4].map((q) => (
                <div
                  key={q}
                  className={`flex items-center justify-between px-3 py-2.5 rounded-xl text-sm transition-all ${
                    currentQuarter === q
                      ? 'bg-yellow-50 border border-yellow-300 font-bold'
                      : 'bg-gray-50'
                  }`}
                >
                  <span className={`font-bold ${currentQuarter === q ? 'text-[#011B3B]' : 'text-gray-500'}`}>
                    Q{q} {currentQuarter === q && <span className="text-[10px] text-yellow-600 ml-1">LIVE</span>}
                  </span>
                  <div className="flex gap-6">
                    <span className="font-bold text-yellow-600 tabular-nums w-6 text-right">{game.quarters[`q${q}`]?.home ?? 0}</span>
                    <span className="font-bold text-red-500 tabular-nums w-6 text-right">{game.quarters[`q${q}`]?.away ?? 0}</span>
                  </div>
                </div>
              ))}
              {/* totals */}
              <div className="flex items-center justify-between px-3 py-2.5 rounded-xl bg-[#011B3B] mt-2">
                <span className="text-white font-bold text-sm">Total</span>
                <div className="flex gap-6">
                  <span className="font-black text-[#FFC600] tabular-nums w-6 text-right">{game.homeScore}</span>
                  <span className="font-black text-red-400 tabular-nums w-6 text-right">{game.awayScore}</span>
                </div>
              </div>
            </div>
          </div>

          {/* Scoring Breakdown */}
          <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-4">
            <h3 className="text-sm font-bold text-[#011B3B] mb-3 flex items-center gap-2">
              <Target className="w-4 h-4 text-[#D30336]" /> Scoring Breakdown
            </h3>
            <div className="space-y-2">
              {SCORE_CATEGORIES.map(({ key, label, pct }) => (
                <div key={key} className="bg-gray-50 rounded-xl px-3 py-2.5 border border-gray-100">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-1.5">
                      <span className="text-sm font-semibold text-[#011B3B]">{label}</span>
                      <span className="text-[10px] text-gray-400 bg-gray-200 px-1.5 py-0.5 rounded-full">{pct}</span>
                    </div>
                    <div className="flex items-center gap-3">
                      <div className="flex items-center gap-1">
                        <span className="w-2 h-2 rounded-full bg-yellow-400 flex-shrink-0" />
                        <span className="font-bold text-sm tabular-nums">{game.scoring[key]?.home ?? 0}</span>
                      </div>
                      <span className="text-gray-300">|</span>
                      <div className="flex items-center gap-1">
                        <span className="font-bold text-sm tabular-nums">{game.scoring[key]?.away ?? 0}</span>
                        <span className="w-2 h-2 rounded-full bg-red-500 flex-shrink-0" />
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* ── Live Events ── */}
        <div className="bg-white rounded-2xl shadow-sm border border-gray-100 p-4">
          <h3 className="text-sm font-bold text-[#011B3B] mb-3 flex items-center gap-2">
            <Zap className="w-4 h-4 text-[#D30336]" /> Live Events
          </h3>
          <div className="space-y-1.5 max-h-72 overflow-y-auto">
            {game.events.length > 0 ? (
              game.events.map((event) => (
                <div
                  key={event.id}
                  className={`flex items-center justify-between px-3 py-2.5 rounded-xl border-l-4 text-sm ${
                    event.type === 'score' ? 'bg-emerald-50 border-emerald-400' : 'bg-red-50 border-red-400'
                  }`}
                >
                  <div className="flex items-center gap-2 min-w-0">
                    <span className="bg-[#011B3B] text-white text-[10px] font-bold px-1.5 py-0.5 rounded flex-shrink-0">
                      Q{event.quarter}
                    </span>
                    <span className="font-mono text-xs text-gray-400 flex-shrink-0">{event.time}</span>
                    <span className="font-semibold text-[#011B3B] truncate">
                      {event.team === 'home' ? game.homeTeam : game.awayTeam}
                    </span>
                  </div>
                  <span className="text-xs text-gray-500 flex-shrink-0 ml-2">{event.description}</span>
                </div>
              ))
            ) : (
              <p className="text-center text-gray-400 text-sm py-6">No events yet — start the game!</p>
            )}
          </div>
        </div>
      </div>

      {/* ── Modals ── */}
      {showScoreModal && (
        <ScoreModal
          game={game}
          isPlaying={isPlaying}
          gameEnded={gameEnded}
          canScore={canScore}
          judgesCanScore={judgesCanScore}
          onScore={(team, cat, pts) => {
            addScore(team, cat, pts, formatTime(timeRemaining));
            setShowScoreModal(false);
          }}
          onClose={() => setShowScoreModal(false)}
        />
      )}
      {showFoulModal && (
        <FoulModal
          game={game}
          onFoul={(team, player) => addFoul(team, player, formatTime(timeRemaining))}
          onClose={() => setShowFoulModal(false)}
        />
      )}
      {showTimeAdjust && (
        <TimeAdjustModal
          timeRemaining={timeRemaining}
          currentQuarter={currentQuarter}
          onSave={setTime}
          onClose={() => setShowTimeAdjust(false)}
        />
      )}
    </section>
  );
};

export default GameSimulation;
