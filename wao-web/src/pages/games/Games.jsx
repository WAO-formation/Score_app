import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Trophy, Plus, Search, Radio, Calendar, CheckCircle, History } from 'lucide-react';
import { useGames } from '../../context/GamesContext';
import { useAuth } from '../../context/AuthContext';
import { isRecentOrActive, isPastDue } from '../../services/matchesService';
import GameCard from './components/GameCard';
import { BRAND } from '../../config/brand';
const B = BRAND.font.body;
const H = BRAND.font.heading;

const TABS = ['upcoming', 'live', 'completed', 'past'];

const TAB_CONFIG = {
  upcoming: { icon: Calendar, color: 'text-blue-500' },
  live:     { icon: Radio,    color: 'text-[#D30336]' },
  completed:{ icon: CheckCircle, color: 'text-green-500' },
  past:     { icon: History,  color: 'text-gray-400' },
};

function Games() {
  const navigate = useNavigate();
  const { games: allGames, loading } = useGames();
  const { user } = useAuth();
  const isAdmin = user?.role === 'admin';
  const [activeTab, setActiveTab] = useState('upcoming');
  const [searchQuery, setSearchQuery] = useState('');

  // Completed games drop off this list 7 days after they finished — the
  // full history stays available under Management > Games, never deleted.
  const games = allGames.filter(isRecentOrActive);

  // "Upcoming" never includes a game whose scheduled day has already
  // passed with nobody starting it — that goes to "Past" instead so stale
  // fixtures don't sit at the top of the list forever.
  const gamesByTab = {
    upcoming: games.filter((g) => g.status === 'upcoming' && !isPastDue(g)),
    live: games.filter((g) => g.status === 'live'),
    completed: games.filter((g) => g.status === 'completed'),
    past: games.filter(isPastDue),
  };

  const filteredGames = gamesByTab[activeTab].filter((g) => {
    const q = searchQuery.toLowerCase();
    return !q ||
      g.homeTeam.toLowerCase().includes(q) ||
      g.awayTeam.toLowerCase().includes(q) ||
      g.venue.toLowerCase().includes(q);
  });

  return (
    <section className="scrollbar-hide px-2 py-4 md:p-4 pb-12 space-y-5">

      {/* ── Hero Banner ── */}
      <div className="relative bg-gradient-to-br from-[#011B3B] via-[#022d5f] to-[#011B3B] rounded-2xl overflow-hidden p-5 md:p-8">
        <div className="absolute -right-16 -top-16 opacity-10 pointer-events-none">
          <img src="/assets/design/wao-ball.png" alt="" className="w-64 h-64 object-contain" />
        </div>
        <div className="absolute -left-10 -bottom-10 opacity-5 pointer-events-none">
          <img src="/assets/design/wao-ball.png" alt="" className="w-48 h-48 object-contain" />
        </div>

        <div className="relative z-10 flex flex-col md:flex-row md:items-center md:justify-between gap-5">
          <div>
            <p className="text-white/60 text-sm font-medium mb-1" style={{ fontFamily: B }}>Manage & Track</p>
            <h1 className="text-2xl md:text-4xl text-white mb-2" style={{ fontFamily: H }}>Games</h1>
            <p className="text-white/70 text-sm max-w-md" style={{ fontFamily: B }}>Schedule, simulate and review all your games in one place.</p>
          </div>

          <div className="flex gap-3 flex-wrap">
            {[
              { label: 'Upcoming', value: gamesByTab.upcoming.length, color: 'bg-white/10' },
              { label: 'Live Now', value: gamesByTab.live.length,     color: 'bg-[#D30336]/80' },
              { label: 'Completed', value: gamesByTab.completed.length, color: 'bg-white/10' },
            ].map((s) => (
              <div key={s.label} className={`${s.color} backdrop-blur-sm rounded-xl px-4 py-3 text-center min-w-[80px]`}>
                <p className="text-2xl font-bold text-white" style={{ fontFamily: H }}>{s.value}</p>
                <p className="text-white/70 text-xs mt-0.5" style={{ fontFamily: B }}>{s.label}</p>
              </div>
            ))}
          </div>
        </div>

        {isAdmin && (
          <div className="relative z-10 mt-5">
            <button
              onClick={() => navigate('/games/create')}
              className="flex items-center gap-1.5 px-4 py-2 bg-[#c81434] text-white font-semibold text-sm hover:bg-[#e21e43] transition-all"
              style={{ fontFamily: B }}
            >
              <Plus className="w-4 h-4" /> Create Game
            </button>
          </div>
        )}
      </div>

      {/* ── Tabs + Search + Grid ── */}
      <div className="bg-white rounded-2xl shadow-sm border border-gray-100">
        <div className="flex flex-col sm:flex-row items-start sm:items-center justify-between px-4 pt-4 gap-3 border-b border-gray-100">
          <div className="flex">
            {TABS.map((tab) => {
              const Icon = TAB_CONFIG[tab].icon;
              return (
                <button
                  key={tab}
                  onClick={() => setActiveTab(tab)}
                  className={`flex items-center gap-1.5 px-4 py-3 text-sm font-semibold capitalize whitespace-nowrap transition-colors border-b-2 ${
                    activeTab === tab
                      ? 'text-[#c81434] border-[#c81434]'
                      : 'text-gray-500 border-transparent hover:text-[#011B3B]'
                  }`}
                  style={{ fontFamily: B }}
                >
                  <Icon className={`w-3.5 h-3.5 ${activeTab === tab ? 'text-[#c81434]' : 'text-gray-400'}`} />
                  {tab} <span className="text-xs opacity-60">({gamesByTab[tab].length})</span>
                </button>
              );
            })}
          </div>
          <div className="relative w-full sm:w-56 pb-3 sm:pb-0">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search games..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full pl-9 pr-4 py-2 text-sm border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-200"
            />
          </div>
        </div>

        <div className="p-4 sm:p-5">
          {loading ? (
            <div className="text-center py-14 text-gray-400 text-sm" style={{ fontFamily: B }}>Loading games…</div>
          ) : filteredGames.length > 0 ? (
            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
              {filteredGames.map((game) => (
                <GameCard key={game.id} game={game} onStartGame={(id) => navigate(`/games/${id}/simulate`)} />
              ))}
            </div>
          ) : (
            <div className="text-center py-14">
              <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Trophy className="w-8 h-8 text-gray-300" />
              </div>
              <h3 className="text-lg text-[#011B3B] mb-1" style={{ fontFamily: H }}>No {activeTab} games</h3>
              <p className="text-sm text-gray-500 mb-5" style={{ fontFamily: B }}>
                {activeTab === 'upcoming' && isAdmin ? 'Create a new game to get started.' : `No ${activeTab} games at the moment.`}
              </p>
              {activeTab === 'upcoming' && isAdmin && (
                <button
                  onClick={() => navigate('/games/create')}
                  className="inline-flex items-center gap-2 px-5 py-2.5 bg-[#c81434] text-white font-semibold hover:bg-[#e21e43] transition-all"
                  style={{ fontFamily: B }}
                >
                  <Plus className="w-4 h-4" /> Create Game
                </button>
              )}
            </div>
          )}
        </div>
      </div>
    </section>
  );
}

export default Games;
