import { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import {
  ArrowLeft, Calendar, MapPin, Clock, Trophy, Play,
  AlertCircle, TrendingUp, Copy, Check,
} from 'lucide-react';
import { useGames } from '../../context/GamesContext';

// ── Static sample stats (would come from backend in production) ──────────────
const buildTeamStats = (teamName, isHome) => ({
  name: teamName,
  form: isHome ? ['W', 'W', 'D', 'L', 'W'] : ['L', 'W', 'W', 'D', 'W'],
  stats: isHome
    ? { wins: 8, losses: 2, draws: 2, goalsFor: 96, goalsAgainst: 54, avgScore: 48 }
    : { wins: 7, losses: 3, draws: 2, goalsFor: 84, goalsAgainst: 62, avgScore: 42 },
  lastFiveGames: isHome
    ? [
        { opponent: 'Storm Eagles', result: 'W', score: '45-42', date: 'Feb 5' },
        { opponent: 'Dragon Force', result: 'W', score: '48-44', date: 'Feb 1' },
        { opponent: 'Blazing Tigers', result: 'D', score: '43-43', date: 'Jan 28' },
        { opponent: 'Ice Wolves', result: 'L', score: '40-47', date: 'Jan 22' },
        { opponent: 'Golden Hawks', result: 'W', score: '51-38', date: 'Jan 18' },
      ]
    : [
        { opponent: 'Royal Falcons', result: 'L', score: '39-44', date: 'Feb 6' },
        { opponent: 'Wild Mustangs', result: 'W', score: '46-41', date: 'Feb 2' },
        { opponent: 'Steel Panthers', result: 'W', score: '43-38', date: 'Jan 29' },
        { opponent: 'Mighty Sharks', result: 'D', score: '42-42', date: 'Jan 24' },
        { opponent: 'Blazing Comets', result: 'W', score: '48-40', date: 'Jan 20' },
      ],
  scoringBreakdown: isHome
    ? { kingdom: 28, workout: 29, goalSetting: 28, judges: 11 }
    : { kingdom: 26, workout: 27, goalSetting: 30, judges: 10 },
});

const FORM_COLORS = { W: 'bg-green-500', L: 'bg-red-500', D: 'bg-yellow-500' };

const SCORING_BARS = [
  { key: 'kingdom', label: 'Kingdom', bar: 'from-purple-500 to-purple-600' },
  { key: 'workout', label: 'Workout', bar: 'from-blue-500 to-blue-600' },
  { key: 'goalSetting', label: 'Goal Setting', bar: 'from-green-500 to-green-600' },
  { key: 'judges', label: 'Judges', bar: 'from-orange-500 to-orange-600' },
];

const SCORING_CARDS = [
  { key: 'kingdom', label: 'Kingdom (30%)', bg: 'bg-purple-50', text: 'text-purple-900' },
  { key: 'workout', label: 'Workout (30%)', bg: 'bg-blue-50', text: 'text-blue-900' },
  { key: 'goalSetting', label: 'Goal Setting (30%)', bg: 'bg-green-50', text: 'text-green-900' },
  { key: 'judges', label: 'Judges (10%)', bg: 'bg-orange-50', text: 'text-orange-900' },
];

// ── Small reusable avatar ─────────────────────────────────────────────────────
const Avatar = ({ name, isHome, size = 'md' }) => {
  const dim = size === 'lg' ? 'w-24 h-24 text-3xl' : size === 'md' ? 'w-14 h-14 text-sm' : 'w-10 h-10 text-xs';
  const bg = isHome ? 'bg-yellow-400' : 'bg-gradient-to-br from-[#D30336] to-[#a8022b]';
  return (
    <div className={`${dim} ${bg} rounded-full flex items-center justify-center shadow-md flex-shrink-0`}>
      <span className="text-white font-bold">{name.substring(0, 2).toUpperCase()}</span>
    </div>
  );
};

// ── Tabs ──────────────────────────────────────────────────────────────────────
const TABS = ['overview', 'team-stats', 'past-games'];

const GameDetails = () => {
  const { gameId } = useParams();
  const navigate = useNavigate();
  const { getGame } = useGames();

  const [activeTab, setActiveTab] = useState('overview');
  const [copied, setCopied] = useState(false);

  const game = getGame(gameId);

  if (!game) {
    return (
      <div className="p-8 text-center">
        <h2 className="text-2xl font-bold text-[#011B3B] mb-4">Game not found</h2>
        <button onClick={() => navigate('/games')} className="px-6 py-3 bg-[#011B3B] text-white rounded-lg">
          Back to Games
        </button>
      </div>
    );
  }

  const homeStats = buildTeamStats(game.homeTeam, true);
  const awayStats = buildTeamStats(game.awayTeam, false);

  const allTabs = [...TABS, ...(game.status === 'live' || game.status === 'completed' ? ['game-details'] : [])];

  const handleCopy = () => {
    navigator.clipboard.writeText(game.accessCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  // ── Header ──────────────────────────────────────────────────────────────────
  return (
    <section className="p-2 pb-8">
      <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-xl shadow-lg p-5 mb-5 relative overflow-hidden">
        <img src="/assets/design/wao-ball.png" alt="" aria-hidden
          className="absolute -right-16 -top-16 w-64 h-64 object-contain opacity-10 pointer-events-none" />

        <div className="relative z-10">
          <button onClick={() => navigate('/games')} className="flex items-center gap-1.5 text-white/70 hover:text-white mb-4 text-sm transition-colors">
            <ArrowLeft className="w-4 h-4" /> Back to Games
          </button>

          {/* Status badge */}
          <div className="absolute top-0 right-0">
            <span className={`px-3 py-1.5 rounded-full text-xs font-bold text-white ${
              game.status === 'live' ? 'bg-red-500 animate-pulse' :
              game.status === 'upcoming' ? 'bg-blue-500' : 'bg-gray-500'
            }`}>
              {game.status === 'live' ? 'LIVE' : game.status.toUpperCase()}
            </span>
          </div>

          {/* Teams matchup */}
          <div className="flex items-center justify-center gap-4 sm:gap-8 mb-5">
            <div className="flex flex-col items-center gap-1.5">
              <Avatar name={game.homeTeam} isHome size="lg" />
              <p className="text-white font-bold text-sm sm:text-base text-center">{game.homeTeam}</p>
              {game.status === 'completed' && <p className="text-white text-3xl font-black">{game.homeScore}</p>}
            </div>

            <div className="flex flex-col items-center">
              {game.status === 'live' ? (
                <div className="bg-white/15 backdrop-blur-sm px-5 py-3 rounded-xl text-center border border-white/20">
                  <p className="text-white/70 text-xs mb-1">{game.currentQuarter}</p>
                  <p className="text-white text-2xl  l font-black">{game.homeScore} – {game.awayScore}</p>
                  <p className="text-white/60 text-xs mt-1">{game.timeRemaining}</p>
                </div>
              ) : (
                <div className="bg-white/15 px-6 py-3 rounded-xl border border-white/20">
                  <span className="text-white font-black text-xl">VS</span>
                </div>
              )}
            </div>

            <div className="flex flex-col items-center gap-1.5">
              <Avatar name={game.awayTeam} isHome={false} size="lg" />
              <p className="text-white font-bold text-sm sm:text-base text-center">{game.awayTeam}</p>
              {game.status === 'completed' && <p className="text-white text-3xl font-black">{game.awayScore}</p>}
            </div>
          </div>

          {/* Meta info */}
          <div className="flex flex-wrap justify-center gap-4 text-white/70 text-xs mb-5">
            <span className="flex items-center gap-1.5"><Calendar className="w-3.5 h-3.5" />
              {new Date(game.date).toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric', year: 'numeric' })}
            </span>
            <span className="flex items-center gap-1.5"><Clock className="w-3.5 h-3.5" />{game.time}</span>
            <span className="flex items-center gap-1.5"><MapPin className="w-3.5 h-3.5" />{game.venue}</span>
            {game.championship && <span className="flex items-center gap-1.5"><Trophy className="w-3.5 h-3.5" />{game.championship}</span>}
          </div>

          {/* CTA */}
          <div className="flex flex-wrap items-center justify-center gap-3">
            {game.status === 'upcoming' && (
              <>
                <div className="bg-white/10 border border-white/20 px-4 py-2.5 rounded-lg flex items-center gap-3">
                  <div>
                    <p className="text-white/60 text-xs">Access Code</p>
                    <p className="text-white font-bold font-mono">{game.accessCode}</p>
                  </div>
                  <button onClick={handleCopy} className="p-1.5 hover:bg-white/10 rounded-lg transition-colors">
                    {copied ? <Check className="w-4 h-4 text-green-400" /> : <Copy className="w-4 h-4 text-white/70" />}
                  </button>
                </div>
                <button
                  onClick={() => navigate(`/games/${game.id}/simulate`)}
                  className="flex items-center gap-2 px-6 py-2.5 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] text-white font-bold rounded-lg hover:shadow-xl transition-all"
                >
                  <Play className="w-4 h-4" /> Start Game
                </button>
              </>
            )}
            {game.status === 'live' && (
              <button
                onClick={() => navigate(`/games/${game.id}/simulate`)}
                className="flex items-center gap-2 px-6 py-2.5 bg-gradient-to-br from-green-500 to-green-600 text-white font-bold rounded-lg hover:shadow-xl transition-all animate-pulse"
              >
                <Play className="w-4 h-4" /> Resume Game
              </button>
            )}
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white rounded-xl shadow-sm border border-gray-100 mb-5">
        <div className="flex overflow-x-auto border-b border-gray-100">
          {allTabs.map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-5 py-3.5 text-sm font-semibold whitespace-nowrap capitalize transition-colors border-b-2 ${
                activeTab === tab ? 'text-[#D30336] border-[#D30336]' : 'text-gray-500 border-transparent hover:text-[#011B3B]'
              }`}
            >
              {tab.replace('-', ' ')}
            </button>
          ))}
        </div>
      </div>

      {/* ── Overview ── */}
      {activeTab === 'overview' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
          {[{ stats: homeStats, isHome: true }, { stats: awayStats, isHome: false }].map(({ stats, isHome }) => (
            <div key={stats.name} className="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
              <div className="flex items-center gap-3 mb-5">
                <Avatar name={stats.name} isHome={isHome} />
                <div>
                  <h3 className="font-bold text-[#011B3B]">{stats.name}</h3>
                  <p className="text-xs text-gray-500">{isHome ? 'Home' : 'Away'} Team</p>
                </div>
              </div>
              <div className="mb-4">
                <p className="text-xs font-semibold text-gray-500 mb-2">Recent Form</p>
                <div className="flex gap-1.5">
                  {stats.form.map((r, i) => (
                    <div key={i} className={`w-8 h-8 rounded-full flex items-center justify-center text-xs font-bold text-white ${FORM_COLORS[r] || 'bg-gray-400'}`}>{r}</div>
                  ))}
                </div>
              </div>
              <div className="grid grid-cols-2 gap-3 mb-3">
                {[
                  { label: 'Wins', val: stats.stats.wins, bg: 'bg-green-50', color: 'text-green-600' },
                  { label: 'Losses', val: stats.stats.losses, bg: 'bg-red-50', color: 'text-red-600' },
                  { label: 'Draws', val: stats.stats.draws, bg: 'bg-yellow-50', color: 'text-yellow-600' },
                  { label: 'Avg Score', val: stats.stats.avgScore, bg: 'bg-blue-50', color: 'text-blue-600' },
                ].map(({ label, val, bg, color }) => (
                  <div key={label} className={`${bg} rounded-lg p-3 text-center`}>
                    <p className={`text-xl font-bold ${color}`}>{val}</p>
                    <p className="text-xs text-gray-500">{label}</p>
                  </div>
                ))}
              </div>
              <div className="grid grid-cols-2 gap-3">
                <div className="text-center"><p className="font-bold text-[#011B3B]">{stats.stats.goalsFor}</p><p className="text-xs text-gray-500">Goals For</p></div>
                <div className="text-center"><p className="font-bold text-[#011B3B]">{stats.stats.goalsAgainst}</p><p className="text-xs text-gray-500">Goals Against</p></div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* ── Team Stats ── */}
      {activeTab === 'team-stats' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
          {[{ stats: homeStats, isHome: true }, { stats: awayStats, isHome: false }].map(({ stats, isHome }) => (
            <div key={stats.name} className="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
              <div className="flex items-center gap-3 mb-5">
                <Avatar name={stats.name} isHome={isHome} />
                <h3 className="font-bold text-[#011B3B]">{stats.name}</h3>
              </div>
              <p className="text-xs font-semibold text-gray-500 mb-4">Scoring Breakdown (%)</p>
              <div className="space-y-4">
                {SCORING_BARS.map(({ key, label, bar }) => (
                  <div key={key}>
                    <div className="flex justify-between text-sm mb-1">
                      <span className="text-gray-600">{label}</span>
                      <span className="font-bold text-[#011B3B]">{stats.scoringBreakdown[key]}%</span>
                    </div>
                    <div className="w-full bg-gray-100 rounded-full h-2.5">
                      <div className={`bg-gradient-to-r ${bar} h-2.5 rounded-full transition-all duration-500`} style={{ width: `${stats.scoringBreakdown[key]}%` }} />
                    </div>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* ── Past Games ── */}
      {activeTab === 'past-games' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
          {[{ stats: homeStats, isHome: true }, { stats: awayStats, isHome: false }].map(({ stats, isHome }) => (
            <div key={stats.name} className="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
              <div className="flex items-center gap-3 mb-5">
                <Avatar name={stats.name} isHome={isHome} />
                <h3 className="font-bold text-[#011B3B]">{stats.name}</h3>
              </div>
              <p className="text-xs font-semibold text-gray-500 mb-3">Last 5 Games</p>
              <div className="space-y-2">
                {stats.lastFiveGames.map((g, i) => (
                  <div key={i} className="flex items-center justify-between bg-gray-50 rounded-lg px-3 py-2.5">
                    <div className="flex items-center gap-2.5">
                      <div className={`w-7 h-7 rounded-full flex items-center justify-center text-xs font-bold text-white ${FORM_COLORS[g.result] || 'bg-gray-400'}`}>{g.result}</div>
                      <div>
                        <p className="text-sm font-semibold text-[#011B3B]">vs {g.opponent}</p>
                        <p className="text-xs text-gray-400">{g.date}</p>
                      </div>
                    </div>
                    <span className="font-bold text-sm text-[#011B3B]">{g.score}</span>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* ── Game Details (live/completed) ── */}
      {activeTab === 'game-details' && (game.status === 'live' || game.status === 'completed') && (
        <div className="space-y-5">
          {/* Quarter breakdown table */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <h3 className="font-bold text-[#011B3B] mb-4">Quarter by Quarter</h3>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-gray-100">
                    <th className="text-left py-2 px-3 text-gray-500 font-semibold">Team</th>
                    {['Q1', 'Q2', 'Q3', 'Q4'].map((q) => (
                      <th key={q} className="text-center py-2 px-3 text-gray-500 font-semibold">{q}</th>
                    ))}
                    <th className="text-center py-2 px-3 text-gray-500 font-semibold bg-gray-50">Total</th>
                  </tr>
                </thead>
                <tbody>
                  {[
                    { label: game.homeTeam, isHome: true, score: game.homeScore, quarters: [game.quarters.q1.home, game.quarters.q2.home, game.quarters.q3.home, game.quarters.q4.home] },
                    { label: game.awayTeam, isHome: false, score: game.awayScore, quarters: [game.quarters.q1.away, game.quarters.q2.away, game.quarters.q3.away, game.quarters.q4.away] },
                  ].map(({ label, isHome, score, quarters }) => (
                    <tr key={label} className="border-b border-gray-50 last:border-0">
                      <td className="py-3 px-3">
                        <div className="flex items-center gap-2">
                          <Avatar name={label} isHome={isHome} size="sm" />
                          <span className="font-semibold text-[#011B3B]">{label}</span>
                        </div>
                      </td>
                      {quarters.map((v, i) => (
                        <td key={i} className="text-center py-3 px-3 font-bold text-[#011B3B]">{v}</td>
                      ))}
                      <td className="text-center py-3 px-3 font-black text-lg text-[#011B3B] bg-gray-50">{score}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Scoring breakdown */}
          <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
            <h3 className="font-bold text-[#011B3B] mb-4">Scoring Breakdown</h3>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
              {SCORING_CARDS.map(({ key, label, bg, text }) => (
                <div key={key} className={`${bg} rounded-xl p-4`}>
                  <p className={`text-xs font-semibold ${text} mb-3`}>{label}</p>
                  <div className="space-y-1.5">
                    {[{ team: game.homeTeam, val: game.scoring[key].home }, { team: game.awayTeam, val: game.scoring[key].away }].map(({ team, val }) => (
                      <div key={team} className="flex justify-between items-center">
                        <span className="text-xs text-gray-600 truncate mr-2">{team}</span>
                        <span className={`font-bold ${text}`}>{val}</span>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Fouls */}
          {(game.fouls.home.length > 0 || game.fouls.away.length > 0) && (
            <div className="bg-white rounded-xl shadow-sm border border-gray-100 p-5">
              <h3 className="font-bold text-[#011B3B] mb-4">Fouls</h3>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
                {[{ team: game.homeTeam, fouls: game.fouls.home }, { team: game.awayTeam, fouls: game.fouls.away }].map(({ team, fouls }) => (
                  <div key={team}>
                    <p className="text-xs font-semibold text-gray-500 mb-2">{team}</p>
                    {fouls.length > 0 ? (
                      <div className="space-y-2">
                        {fouls.map((f, i) => (
                          <div key={i} className="flex items-center justify-between bg-red-50 rounded-lg px-3 py-2.5">
                            <div>
                              <p className="text-sm font-semibold text-[#011B3B]">{f.player}</p>
                              <p className="text-xs text-gray-400">{f.quarter} · {f.minute}</p>
                            </div>
                            <AlertCircle className="w-4 h-4 text-red-500 flex-shrink-0" />
                          </div>
                        ))}
                      </div>
                    ) : (
                      <p className="text-xs text-gray-400 italic">No fouls recorded</p>
                    )}
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      )}
    </section>
  );
};

export default GameDetails;
