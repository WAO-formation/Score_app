import { useState } from 'react';
import { Lock } from 'lucide-react';
import { BRAND } from '../../../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const CATEGORIES = [
  { id: 'kingdom',     label: 'Kingdom',      pct: '30%', info: "Points scored by invading opponent's Kingdom and bouncing the ball" },
  { id: 'workout',     label: 'Workout',      pct: '30%', info: 'Points accrued for time spent in your own Workout area while displaying skills' },
  { id: 'goalSetting', label: 'Goal Setting', pct: '30%', info: 'Standard goals (1 pt) and specialized scores from Oval-Crown/Goalposts' },
  { id: 'judges',      label: 'Judges',       pct: '10%', info: 'Additional points awarded by judges — timer must be paused' },
];

const POINT_OPTIONS = [1, 2, 3, 5];

const TeamPanel = ({ team, teamName, score, onScore, isHome, locked }) => (
  <div className={`p-4 border ${isHome ? 'bg-amber-50 border-amber-200' : 'bg-red-50 border-red-200'} ${locked ? 'opacity-50' : ''}`}>
    <div className="flex items-center gap-3 mb-4">
      <div className={`w-10 h-10 flex items-center justify-center flex-shrink-0 ${isHome ? 'bg-amber-400' : 'bg-[#c81434]'}`}>
        <span className="text-white font-medium text-sm" style={{ fontFamily: H }}>{teamName.substring(0, 2).toUpperCase()}</span>
      </div>
      <div className="min-w-0">
        <p className="text-[#011B3B] text-sm truncate" style={{ fontFamily: B }}>{teamName}</p>
        <p className="text-xs text-gray-500" style={{ fontFamily: B }}>{score} pts this category</p>
      </div>
    </div>
    <div className="grid grid-cols-2 gap-2">
      {POINT_OPTIONS.map((pts) => (
        <button
          key={pts}
          onClick={() => !locked && onScore(team, pts)}
          disabled={locked}
          className={`py-2.5 font-bold text-sm text-[#011B3B] border-2 bg-white transition-all
            ${locked ? 'cursor-not-allowed opacity-40' : `active:scale-95 ${isHome ? 'border-amber-300 hover:bg-amber-100' : 'border-red-300 hover:bg-red-100'}`}`}
          style={{ fontFamily: B }}
        >
          +{pts} pt{pts > 1 ? 's' : ''}
        </button>
      ))}
    </div>
  </div>
);

const ScoreModal = ({ game, isPlaying, gameEnded, canScore, judgesCanScore, onScore, onClose }) => {
  const [activeTab, setActiveTab] = useState(gameEnded ? 'judges' : 'kingdom');
  const activeCat = CATEGORIES.find((c) => c.id === activeTab);

  const isTabLocked = (tabId) => {
    if (tabId === 'judges') return isPlaying;
    return !canScore;
  };

  const currentlyLocked = isTabLocked(activeTab);

  const getBanner = () => {
    if (gameEnded && activeTab !== 'judges')
      return { text: 'Game has ended — only Judges can still add points', color: 'bg-red-50 text-red-700 border-red-200' };
    if (activeTab === 'judges' && isPlaying)
      return { text: '⏸ Pause the timer before entering judge scores', color: 'bg-amber-50 text-amber-700 border-amber-200' };
    if (activeTab !== 'judges' && !isPlaying && !gameEnded)
      return { text: '▶ Start the timer to add live scores', color: 'bg-sky-50 text-sky-700 border-sky-200' };
    return null;
  };

  const banner = getBanner();

  return (
    <div className="fixed inset-0 bg-black/70 flex items-end sm:items-center justify-center z-50 p-0 sm:p-4">
      <div className="bg-white w-full sm:max-w-2xl max-h-[92vh] flex flex-col">

        {/* Header */}
        <div className="bg-[#011B3B] px-5 py-4 flex-shrink-0">
          <div className="flex items-center justify-between">
            <h3 className="text-lg text-white uppercase tracking-widest" style={{ fontFamily: H }}>Add Score</h3>
            <button onClick={onClose} className="text-white/60 hover:text-white text-xl leading-none">✕</button>
          </div>
        </div>

        {/* Tabs */}
        <div className="flex border-b border-gray-100 overflow-x-auto flex-shrink-0 bg-white">
          {CATEGORIES.map((cat) => {
            const locked = isTabLocked(cat.id);
            const disabled = gameEnded && cat.id !== 'judges';
            return (
              <button
                key={cat.id}
                onClick={() => !disabled && setActiveTab(cat.id)}
                disabled={disabled}
                className={`px-4 py-3 text-sm font-semibold whitespace-nowrap transition-colors flex-1 relative
                  ${activeTab === cat.id ? 'text-[#c81434] border-b-2 border-[#c81434]' : 'text-gray-500 hover:text-[#011B3B]'}
                  ${disabled ? 'opacity-30 cursor-not-allowed' : ''}`}
                style={{ fontFamily: B }}
              >
                {cat.label}
                <span className="text-xs opacity-60 ml-1">({cat.pct})</span>
                {locked && !disabled && <Lock className="w-3 h-3 inline-block ml-1 opacity-50" />}
              </button>
            );
          })}
        </div>

        {/* Banner */}
        {banner && (
          <div className={`mx-4 mt-3 px-3 py-2 border text-xs font-medium flex-shrink-0 ${banner.color}`} style={{ fontFamily: B }}>
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
          <p className="text-xs text-gray-400 bg-gray-50 px-3 py-2" style={{ fontFamily: B }}>{activeCat?.info}</p>
        </div>
      </div>
    </div>
  );
};

export default ScoreModal;
