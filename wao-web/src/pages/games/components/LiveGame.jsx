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
import { BRAND } from '../../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const SCORE_CATEGORIES = [
  { key: 'kingdom',     label: 'Kingdom',      pct: '30%' },
  { key: 'workout',     label: 'Workout',      pct: '30%' },
  { key: 'goalSetting', label: 'Goal Setting', pct: '30%' },
  { key: 'judges',      label: 'Judges',       pct: '10%' },
];

const Avatar = ({ name, isHome, size }) => {
  const cls = size === 'sm' ? 'w-9 h-9 text-xs' : 'w-16 h-16 sm:w-20 sm:h-20 text-lg sm:text-xl';
  const bg  = isHome ? 'bg-amber-400' : 'bg-[#c81434]';
  return (
    <div className={`${cls} ${bg} flex items-center justify-center flex-shrink-0`}>
      <span className="text-white font-medium" style={{ fontFamily: H }}>{name.substring(0, 2).toUpperCase()}</span>
    </div>
  );
};

const GameSimulation = () => {
  const {
    game, isPlaying, setIsPlaying, currentQuarter, timeRemaining,
    setTime, resetQuarterTime, advanceQuarter, handleEndGame,
    addScore, addFoul, formatTime, showQuarterTransition, navigate,
  } = useGameSimulation();

  const [showScoreModal, setShowScoreModal]   = useState(false);
  const [showFoulModal, setShowFoulModal]     = useState(false);
  const [showTimeAdjust, setShowTimeAdjust]   = useState(false);

  const gameEnded      = game?.status === 'completed';
  const canScore       = isPlaying && !gameEnded;
  const judgesCanScore = !isPlaying;

  if (!game) {
    return (
      <div className="flex items-center justify-center h-screen bg-gray-50">
        <div className="text-center">
          <div className="w-10 h-10 border-2 border-[#c81434] border-t-transparent rounded-full animate-spin mx-auto mb-3" />
          <p className="text-gray-400 text-sm" style={{ fontFamily: B }}>Loading game...</p>
        </div>
      </div>
    );
  }

  return (
    <section className="min-h-screen bg-gray-50 pb-10">
      {showQuarterTransition && <QuarterTransition currentQuarter={currentQuarter} />}

      {/* ── Scoreboard Header ── */}
      <div className="bg-[#011B3B] px-4 pt-10 sm:pt-12 pb-6 relative overflow-hidden">
        <img src="/assets/design/wao-ball.png" alt="" aria-hidden
          className="absolute -right-16 -top-16 w-48 h-48 object-contain opacity-5 pointer-events-none" />

        {/* top bar */}
        <div className="relative flex items-center justify-between mb-6">
          <button
            onClick={() => navigate('/games')}
            className="flex items-center gap-1.5 text-white/60 hover:text-white transition-colors text-sm"
            style={{ fontFamily: B }}
          >
            <ArrowLeft className="w-4 h-4" /> Back
          </button>
          <div className="flex items-center gap-1.5 bg-emerald-500 px-3 py-1">
            <span className="w-2 h-2 bg-white rounded-full animate-ping" />
            <span className="text-white font-bold text-xs tracking-widest" style={{ fontFamily: B }}>LIVE</span>
          </div>
        </div>

        {/* scores row */}
        <div className="relative grid grid-cols-3 items-center gap-2">

          {/* Home */}
          <div className="flex flex-col items-center gap-1.5">
            <Avatar name={game.homeTeam} isHome size="lg" />
            <p className="text-white/70 text-xs text-center leading-tight line-clamp-2 max-w-[80px]" style={{ fontFamily: B }}>
              {game.homeTeam}
            </p>
            <span className="text-white text-4xl sm:text-5xl tabular-nums" style={{ fontFamily: H }}>{game.homeScore}</span>
          </div>

          {/* Timer */}
          <div className="flex flex-col items-center gap-2">
            <span className="text-emerald-400 text-xs font-bold tracking-widest" style={{ fontFamily: B }}>Q{currentQuarter}</span>
            <button
              onClick={() => setShowTimeAdjust(true)}
              className="text-white text-3xl sm:text-4xl tabular-nums hover:text-emerald-400 transition-colors leading-none"
              style={{ fontFamily: H }}
              title="Tap to adjust time"
            >
              {formatTime(timeRemaining)}
            </button>
            <div className="flex gap-2 mt-1">
              <button
                onClick={() => setIsPlaying(!isPlaying)}
                className="bg-white/10 hover:bg-white/20 active:bg-white/30 p-2.5 transition-colors"
              >
                {isPlaying
                  ? <Pause className="w-5 h-5 text-white" />
                  : <Play className="w-5 h-5 text-white" />}
              </button>
              <button
                onClick={resetQuarterTime}
                className="bg-white/10 hover:bg-white/20 active:bg-white/30 p-2.5 transition-colors"
                title="Reset time"
              >
                <RotateCcw className="w-5 h-5 text-white" />
              </button>
              <button
                onClick={() => setShowTimeAdjust(true)}
                className="bg-white/10 hover:bg-white/20 active:bg-white/30 p-2.5 transition-colors"
                title="Set time"
              >
                <Clock className="w-5 h-5 text-white" />
              </button>
            </div>
          </div>

          {/* Away */}
          <div className="flex flex-col items-center gap-1.5">
            <Avatar name={game.awayTeam} isHome={false} size="lg" />
            <p className="text-white/70 text-xs text-center leading-tight line-clamp-2 max-w-[80px]" style={{ fontFamily: B }}>
              {game.awayTeam}
            </p>
            <span className="text-white text-4xl sm:text-5xl tabular-nums" style={{ fontFamily: H }}>{game.awayScore}</span>
          </div>
        </div>
      </div>

      <div className="px-3 sm:px-4 mt-4 space-y-4">

        {/* ── Action Buttons ── */}
        <div className="grid grid-cols-2 sm:grid-cols-4 gap-2.5">
          {[
            { label: 'Add Score',    icon: Plus,         bg: 'bg-emerald-500 hover:bg-emerald-400', onClick: () => setShowScoreModal(true),  disabled: gameEnded && !judgesCanScore },
            { label: 'Add Foul',     icon: AlertCircle,  bg: 'bg-[#c81434] hover:bg-[#e21e43]',    onClick: () => setShowFoulModal(true) },
            { label: 'Next Quarter', icon: Flag,         bg: 'bg-sky-500 hover:bg-sky-400',         onClick: advanceQuarter,                 disabled: currentQuarter >= 4 },
            { label: 'End Game',     icon: Trophy,       bg: 'bg-[#011B3B] hover:bg-[#022d5f]',    onClick: handleEndGame },
          ].map(({ label, icon: Icon, bg, onClick, disabled }) => (
            <button
              key={label}
              onClick={onClick}
              disabled={disabled}
              className={`${bg} text-white font-semibold py-3 px-3 active:scale-95 transition-all flex items-center justify-center gap-2 text-sm disabled:opacity-40 disabled:cursor-not-allowed`}
              style={{ fontFamily: B }}
            >
              <Icon className="w-4 h-4 flex-shrink-0" />
              <span className="truncate">{label}</span>
            </button>
          ))}
        </div>

        {/* ── Stats Grid ── */}
        <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">

          {/* Quarter Breakdown */}
          <div className="bg-white border border-gray-100 p-4">
            <h3 className="text-xs text-[#011B3B] mb-3 flex items-center gap-2 uppercase tracking-widest" style={{ fontFamily: B }}>
              <Activity className="w-4 h-4 text-[#c81434]" /> Quarter Breakdown
            </h3>
            <div className="flex justify-between text-xs text-gray-400 px-1 mb-1" style={{ fontFamily: B }}>
              <span>Quarter</span>
              <div className="flex gap-6">
                <span className="text-amber-500">{game.homeTeam.split(' ')[0]}</span>
                <span className="text-[#c81434]">{game.awayTeam.split(' ')[0]}</span>
              </div>
            </div>
            <div className="space-y-1.5">
              {[1, 2, 3, 4].map((q) => (
                <div
                  key={q}
                  className={`flex items-center justify-between px-3 py-2.5 text-sm transition-all ${
                    currentQuarter === q
                      ? 'bg-emerald-50 border border-emerald-200'
                      : 'bg-gray-50'
                  }`}
                >
                  <span className={`font-semibold ${currentQuarter === q ? 'text-emerald-700' : 'text-gray-500'}`} style={{ fontFamily: B }}>
                    Q{q} {currentQuarter === q && <span className="text-[10px] text-emerald-500 ml-1" style={{ fontFamily: B }}>LIVE</span>}
                  </span>
                  <div className="flex gap-6">
                    <span className="font-bold text-amber-500 tabular-nums w-6 text-right" style={{ fontFamily: H }}>{game.quarters[`q${q}`]?.home ?? 0}</span>
                    <span className="font-bold text-[#c81434] tabular-nums w-6 text-right" style={{ fontFamily: H }}>{game.quarters[`q${q}`]?.away ?? 0}</span>
                  </div>
                </div>
              ))}
              <div className="flex items-center justify-between px-3 py-2.5 bg-[#011B3B] mt-1">
                <span className="text-white text-sm" style={{ fontFamily: B }}>Total</span>
                <div className="flex gap-6">
                  <span className="text-amber-400 tabular-nums w-6 text-right" style={{ fontFamily: H }}>{game.homeScore}</span>
                  <span className="text-[#c81434] tabular-nums w-6 text-right" style={{ fontFamily: H }}>{game.awayScore}</span>
                </div>
              </div>
            </div>
          </div>

          {/* Scoring Breakdown */}
          <div className="bg-white border border-gray-100 p-4">
            <h3 className="text-xs text-[#011B3B] mb-3 flex items-center gap-2 uppercase tracking-widest" style={{ fontFamily: B }}>
              <Target className="w-4 h-4 text-[#c81434]" /> Scoring Breakdown
            </h3>
            <div className="space-y-2">
              {SCORE_CATEGORIES.map(({ key, label, pct }) => (
                <div key={key} className="bg-gray-50 border border-gray-100 px-3 py-2.5">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-1.5">
                      <span className="text-sm text-[#011B3B]" style={{ fontFamily: B }}>{label}</span>
                      <span className="text-[10px] text-gray-400 bg-gray-200 px-1.5 py-0.5" style={{ fontFamily: B }}>{pct}</span>
                    </div>
                    <div className="flex items-center gap-3">
                      <div className="flex items-center gap-1">
                        <span className="w-2 h-2 bg-amber-400 flex-shrink-0" />
                        <span className="text-sm tabular-nums text-[#011B3B]" style={{ fontFamily: H }}>{game.scoring[key]?.home ?? 0}</span>
                      </div>
                      <span className="text-gray-200">|</span>
                      <div className="flex items-center gap-1">
                        <span className="text-sm tabular-nums text-[#011B3B]" style={{ fontFamily: H }}>{game.scoring[key]?.away ?? 0}</span>
                        <span className="w-2 h-2 bg-[#c81434] flex-shrink-0" />
                      </div>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* ── Live Events ── */}
        <div className="bg-white border border-gray-100 p-4">
          <h3 className="text-xs text-[#011B3B] mb-3 flex items-center gap-2 uppercase tracking-widest" style={{ fontFamily: B }}>
            <Zap className="w-4 h-4 text-[#c81434]" /> Live Events
          </h3>
          <div className="space-y-1.5 max-h-72 overflow-y-auto scrollbar-hide">
            {game.events.length > 0 ? (
              game.events.map((event) => (
                <div
                  key={event.id}
                  className={`flex items-center justify-between px-3 py-2.5 border-l-4 text-sm ${
                    event.type === 'score' ? 'bg-emerald-50 border-emerald-400' : 'bg-red-50 border-red-400'
                  }`}
                >
                  <div className="flex items-center gap-2 min-w-0">
                    <span className="bg-[#011B3B] text-white text-[10px] font-bold px-1.5 py-0.5 flex-shrink-0" style={{ fontFamily: B }}>
                      Q{event.quarter}
                    </span>
                    <span className="font-mono text-xs text-gray-400 flex-shrink-0">{event.time}</span>
                    <span className="text-[#011B3B] truncate" style={{ fontFamily: B }}>
                      {event.team === 'home' ? game.homeTeam : game.awayTeam}
                    </span>
                  </div>
                  <span className="text-xs text-gray-500 flex-shrink-0 ml-2" style={{ fontFamily: B }}>{event.description}</span>
                </div>
              ))
            ) : (
              <p className="text-center text-gray-400 text-sm py-6" style={{ fontFamily: B }}>No events yet — start the game!</p>
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
          onScore={(team, cat, pts) => { addScore(team, cat, pts, formatTime(timeRemaining)); setShowScoreModal(false); }}
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
