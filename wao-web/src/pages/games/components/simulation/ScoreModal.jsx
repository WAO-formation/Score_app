import { useState } from 'react';
import { Lock } from 'lucide-react';

const CATEGORIES = [
  { id: 'kingdom',    label: 'Kingdom',      pct: '30%', info: "Points scored by invading opponent's Kingdom and bouncing the ball" },
  { id: 'workout',    label: 'Workout',      pct: '30%', info: 'Points accrued for time spent in your own Workout area while displaying skills' },
  { id: 'goalSetting',label: 'Goal Setting', pct: '30%', info: 'Standard goals (1 pt) and specialized scores from Oval-Crown/Goalposts' },
  { id: 'judges',     label: 'Judges',       pct: '10%', info: 'Additional points awarded by judges — timer must be paused' },
];

const POINT_OPTIONS = [1, 2, 3, 5];

const TeamPanel = ({ team, teamName, score, onScore, isHome, locked }) => (
  <div className={`rounded-xl p-4 border-2 ${isHome ? 'bg-yellow-50 border-yellow-200' : 'bg-red-50 border-red-200'} ${locked ? 'opacity-50' : ''}`}>
    <div className="flex items-center gap-3 mb-4">
      <div className={`w-10 h-10 rounded-full flex items-center justify-center shadow-md flex-shrink-0 ${isHome ? 'bg-gradient-to-br from-[#FFC600] to-[#FF6B35]' : 'bg-gradient-to-br from-[#D30336] to-[#a8022b]'}`}>
        <span className="text-white font-bold text-sm">{teamName.substring(0, 2).toUpperCase()}</span>
      </div>
      <div className="min-w-0">
        <p className="font-bold text-[#011B3B] text-sm truncate">{teamName}</p>
        <p className="text-xs text-gray-500">{score} pts this category</p>
      </div>
    </div>
    <div className="grid grid-cols-2 gap-2">
      {POINT_OPTIONS.map((pts) => (
        <button
          key={pts}
          onClick={() => !locked && onScore(team, pts)}
          disabled={locked}
          className={`py-2.5 rounded-lg font-bold text-sm text-[#011B3B] border-2 bg-white transition-all
            ${locked ? 'cursor-not-allowed opacity-40' : `active:scale-95 ${isHome ? 'border-yellow-300 hover:bg-yellow-100' : 'border-red-300 hover:bg-red-100'}`}`}
        >
          +{pts} pt{pts > 1 ? 's' : ''}
        </button>
      ))}
    </div>
  </div>
);

const ScoreModal = ({ game, isPlaying, gameEnded, canScore, judgesCanScore, onScore, onClose }) => {
  // If game ended, force judges tab since that's the only one available
  const [activeTab, setActiveTab] = useState(gameEnded ? 'judges' : 'kingdom');
  const activeCat = CATEGORIES.find((c) => c.id === activeTab);

  // Per-tab lock logic:
  // - judges tab: locked when timer is running (must be paused)
  // - all other tabs: locked when timer is NOT running OR game ended
  const isTabLocked = (tabId) => {
    if (tabId === 'judges') return isPlaying; // judges need timer paused
    return !canScore; // others need timer running
  };

  const currentlyLocked = isTabLocked(activeTab);

  // Banner message shown below tabs
  const getBanner = () => {
    if (gameEnded && activeTab !== 'judges') {
      return { text: 'Game has ended — only Judges can still add points', color: 'bg-red-50 text-red-700 border-red-200' };
    }
    if (activeTab === 'judges' && isPlaying) {
      return { text: '⏸ Pause the timer before entering judge scores', color: 'bg-yellow-50 text-yellow-700 border-yellow-200' };
    }
    if (activeTab !== 'judges' && !isPlaying && !gameEnded) {
      return { text: '▶ Start the timer to add live scores', color: 'bg-blue-50 text-blue-700 border-blue-200' };
    }
    return null;
  };

  const banner = getBanner();

  return (
    <div className="fixed inset-0 bg-black/70 flex items-end sm:items-center justify-center z-50 p-0 sm:p-4">
      <div className="bg-white rounded-t-2xl sm:rounded-2xl shadow-2xl w-full sm:max-w-2xl max-h-[92vh] flex flex-col">

        {/* Header */}
        <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] px-5 py-4 rounded-t-2xl flex-shrink-0">
          <div className="flex items-center justify-between">
            <h3 className="text-lg font-bold text-white">Add Score</h3>
            <button onClick={onClose} className="text-white/70 hover:text-white text-xl leading-none">✕</button>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex border-b border-gray-100 overflow-x-auto flex-shrink-0 bg-white">
          {CATEGORIES.map((cat) => {
            const locked = isTabLocked(cat.id);
            const isGameEndedNonJudge = gameEnded && cat.id !== 'judges';
            return (
              <button
                key={cat.id}
                onClick={() => !isGameEndedNonJudge && setActiveTab(cat.id)}
                disabled={isGameEndedNonJudge}
                className={`px-4 py-3 text-sm font-semibold whitespace-nowrap transition-colors flex-1 relative
                  ${activeTab === cat.id ? 'text-[#D30336] border-b-2 border-[#D30336]' : 'text-gray-500 hover:text-[#011B3B]'}
                  ${isGameEndedNonJudge ? 'opacity-30 cursor-not-allowed' : ''}`}
              >
                {cat.label}
                <span className="text-xs opacity-60 ml-1">({cat.pct})</span>
                {locked && !isGameEndedNonJudge && (
                  <Lock className="w-3 h-3 inline-block ml-1 opacity-50" />
                )}
              </button>
            );
          })}
        </div>

        {/* Banner */}
        {banner && (
          <div className={`mx-4 mt-3 px-3 py-2 rounded-lg border text-xs font-medium flex-shrink-0 ${banner.color}`}>
            {banner.text}
          </div>
        )}

        {/* Body */}
        <div className="p-4 overflow-y-auto">
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-3 mb-4">
            <TeamPanel
              team="home" teamName={game.homeTeam} isHome locked={currentlyLocked}
              score={game.scoring[activeTab]?.home || 0}
              onScore={(team, pts) => onScore(team, activeTab, pts)}
            />
            <TeamPanel
              team="away" teamName={game.awayTeam} isHome={false} locked={currentlyLocked}
              score={game.scoring[activeTab]?.away || 0}
              onScore={(team, pts) => onScore(team, activeTab, pts)}
            />
          </div>
          <p className="text-xs text-gray-400 bg-gray-50 rounded-lg px-3 py-2">{activeCat?.info}</p>
        </div>
      </div>
    </div>
  );
};

export default ScoreModal;
