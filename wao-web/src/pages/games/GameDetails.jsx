import { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { ArrowLeft, Calendar, MapPin, Clock, Trophy, Play, AlertCircle, Copy, Check } from 'lucide-react';
import { useGames } from '../../context/GamesContext';
import { BRAND } from '../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const buildTeamStats = (teamName, isHome) => ({
  name: teamName,
  form: isHome ? ['W', 'W', 'D', 'L', 'W'] : ['L', 'W', 'W', 'D', 'W'],
  stats: isHome
    ? { wins: 8, losses: 2, draws: 2, goalsFor: 96, goalsAgainst: 54, avgScore: 48 }
    : { wins: 7, losses: 3, draws: 2, goalsFor: 84, goalsAgainst: 62, avgScore: 42 },
  lastFiveGames: isHome
    ? [
        { opponent: 'Storm Eagles',   result: 'W', score: '45-42', date: 'Feb 5' },
        { opponent: 'Dragon Force',   result: 'W', score: '48-44', date: 'Feb 1' },
        { opponent: 'Blazing Tigers', result: 'D', score: '43-43', date: 'Jan 28' },
        { opponent: 'Ice Wolves',     result: 'L', score: '40-47', date: 'Jan 22' },
        { opponent: 'Golden Hawks',   result: 'W', score: '51-38', date: 'Jan 18' },
      ]
    : [
        { opponent: 'Royal Falcons',  result: 'L', score: '39-44', date: 'Feb 6' },
        { opponent: 'Wild Mustangs',  result: 'W', score: '46-41', date: 'Feb 2' },
        { opponent: 'Steel Panthers', result: 'W', score: '43-38', date: 'Jan 29' },
        { opponent: 'Mighty Sharks',  result: 'D', score: '42-42', date: 'Jan 24' },
        { opponent: 'Blazing Comets', result: 'W', score: '48-40', date: 'Jan 20' },
      ],
  scoringBreakdown: isHome
    ? { kingdom: 28, workout: 29, goalSetting: 28, judges: 11 }
    : { kingdom: 26, workout: 27, goalSetting: 30, judges: 10 },
});

const FORM_COLORS = { W: 'bg-emerald-500', L: 'bg-red-400', D: 'bg-amber-400' };

const SCORING_BARS = [
  { key: 'kingdom',    label: 'Kingdom',     bar: 'bg-violet-500' },
  { key: 'workout',    label: 'Workout',     bar: 'bg-sky-500' },
  { key: 'goalSetting',label: 'Goal Setting',bar: 'bg-emerald-500' },
  { key: 'judges',     label: 'Judges',      bar: 'bg-amber-500' },
];

const SCORING_CARDS = [
  { key: 'kingdom',    label: 'Kingdom (30%)',     bg: 'bg-violet-50', text: 'text-violet-700', border: 'border-violet-100' },
  { key: 'workout',    label: 'Workout (30%)',     bg: 'bg-sky-50',    text: 'text-sky-700',    border: 'border-sky-100' },
  { key: 'goalSetting',label: 'Goal Setting (30%)',bg: 'bg-emerald-50',text: 'text-emerald-700',border: 'border-emerald-100' },
  { key: 'judges',     label: 'Judges (10%)',      bg: 'bg-amber-50',  text: 'text-amber-700',  border: 'border-amber-100' },
];

const Avatar = ({ name, isHome, size = 'md' }) => {
  const dim = size === 'lg' ? 'w-20 h-20 text-2xl' : size === 'md' ? 'w-12 h-12 text-sm' : 'w-9 h-9 text-xs';
  const bg  = isHome ? 'bg-amber-400' : 'bg-[#c81434]';
  return (
    <div className={`${dim} ${bg} flex items-center justify-center flex-shrink-0`}>
      <span className="text-white font-medium" style={{ fontFamily: H }}>{name.substring(0, 2).toUpperCase()}</span>
    </div>
  );
};

const TABS = ['overview', 'team-stats', 'past-games'];

const GameDetails = () => {
  const { gameId }  = useParams();
  const navigate    = useNavigate();
  const { getGame } = useGames();

  const [activeTab, setActiveTab] = useState('overview');
  const [copied, setCopied]       = useState(false);

  const game = getGame(gameId);

  if (!game) {
    return (
      <div className="p-8 text-center">
        <h2 className="text-2xl text-[#011B3B] mb-4" style={{ fontFamily: H }}>Game not found</h2>
        <button onClick={() => navigate('/games')} className="px-6 py-3 bg-[#011B3B] text-white" style={{ fontFamily: B }}>
          Back to Games
        </button>
      </div>
    );
  }

  const homeStats = buildTeamStats(game.homeTeam, true);
  const awayStats = buildTeamStats(game.awayTeam, false);
  const allTabs   = [...TABS, ...(game.status === 'live' || game.status === 'completed' ? ['game-details'] : [])];

  const handleCopy = () => {
    navigator.clipboard.writeText(game.accessCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const isLive      = game.status === 'live';
  const isCompleted = game.status === 'completed';
  const isUpcoming  = game.status === 'upcoming';

  // Header bg: live = teal, completed = slate, upcoming = dark navy
  const headerBg = isLive
    ? 'bg-gradient-to-br from-[#0d4f4f] via-[#0a6b6b] to-[#0d4f4f]'
    : isCompleted
    ? 'bg-gradient-to-br from-[#1e293b] to-[#334155]'
    : 'bg-gradient-to-br from-[#011B3B] to-[#022d5f]';

  return (
    <section className="p-2 pb-8">

      {/* ── Hero Header ── */}
      <div className={`${headerBg} shadow-lg p-5 mb-5 relative overflow-hidden`}>
        <img src="/assets/design/wao-ball.png" alt="" aria-hidden
          className="absolute -right-16 -top-16 w-64 h-64 object-contain opacity-10 pointer-events-none" />

        <div className="relative z-10">
          <button
            onClick={() => navigate('/games')}
            className="flex items-center gap-1.5 text-white/70 hover:text-white mb-4 text-sm transition-colors"
            style={{ fontFamily: B }}
          >
            <ArrowLeft className="w-4 h-4" /> Back to Games
          </button>

          {/* Status badge */}
          <div className="absolute top-0 right-0">
            {isLive ? (
              <span className="flex items-center gap-1.5 px-3 py-1.5 bg-emerald-500 text-white text-xs font-bold" style={{ fontFamily: B }}>
                <span className="w-1.5 h-1.5 bg-white rounded-full animate-pulse" /> LIVE
              </span>
            ) : (
              <span className={`px-3 py-1.5 text-xs font-bold text-white ${isCompleted ? 'bg-slate-500' : 'bg-blue-500'}`} style={{ fontFamily: B }}>
                {game.status.toUpperCase()}
              </span>
            )}
          </div>

          {/* Teams matchup */}
          <div className="flex items-center justify-center gap-4 sm:gap-10 mb-5">
            <div className="flex flex-col items-center gap-2">
              <Avatar name={game.homeTeam} isHome size="lg" />
              <p className="text-white font-medium text-sm sm:text-base text-center" style={{ fontFamily: B }}>{game.homeTeam}</p>
              {isCompleted && <p className="text-white text-3xl" style={{ fontFamily: H }}>{game.homeScore}</p>}
            </div>

            <div className="flex flex-col items-center">
              {isLive ? (
                <div className="bg-white/15 backdrop-blur-sm px-5 py-3 text-center border border-white/20">
                  <p className="text-white/70 text-xs mb-1" style={{ fontFamily: B }}>{game.currentQuarter}</p>
                  <p className="text-white text-2xl md:text-3xl" style={{ fontFamily: H }}>{game.homeScore} – {game.awayScore}</p>
                  <p className="text-emerald-300 text-xs mt-1 font-medium" style={{ fontFamily: B }}>{game.timeRemaining}</p>
                </div>
              ) : (
                <div className="bg-white/15 px-6 py-3 border border-white/20">
                  <span className="text-white text-xl" style={{ fontFamily: H }}>VS</span>
                </div>
              )}
            </div>

            <div className="flex flex-col items-center gap-2">
              <Avatar name={game.awayTeam} isHome={false} size="lg" />
              <p className="text-white font-medium text-sm sm:text-base text-center" style={{ fontFamily: B }}>{game.awayTeam}</p>
              {isCompleted && <p className="text-white text-3xl" style={{ fontFamily: H }}>{game.awayScore}</p>}
            </div>
          </div>

          {/* Meta */}
          <div className="flex flex-wrap justify-center gap-4 text-white/60 text-xs mb-5" style={{ fontFamily: B }}>
            <span className="flex items-center gap-1.5">
              <Calendar className="w-3.5 h-3.5" />
              {new Date(game.date).toLocaleDateString('en-US', { weekday: 'short', month: 'short', day: 'numeric', year: 'numeric' })}
            </span>
            <span className="flex items-center gap-1.5"><Clock className="w-3.5 h-3.5" />{game.time}</span>
            <span className="flex items-center gap-1.5"><MapPin className="w-3.5 h-3.5" />{game.venue}</span>
            {game.championship && <span className="flex items-center gap-1.5"><Trophy className="w-3.5 h-3.5" />{game.championship}</span>}
          </div>

          {/* CTA */}
          <div className="flex flex-wrap items-center justify-center gap-3">
            {isUpcoming && (
              <>
                <div className="bg-white/10 border border-white/20 px-4 py-2.5 flex items-center gap-3">
                  <div>
                    <p className="text-white/60 text-xs" style={{ fontFamily: B }}>Access Code</p>
                    <p className="text-white font-bold font-mono">{game.accessCode}</p>
                  </div>
                  <button onClick={handleCopy} className="p-1.5 hover:bg-white/10 transition-colors">
                    {copied ? <Check className="w-4 h-4 text-emerald-400" /> : <Copy className="w-4 h-4 text-white/70" />}
                  </button>
                </div>
                <button
                  onClick={() => navigate(`/games/${game.id}/simulate`)}
                  className="flex items-center gap-2 px-6 py-2.5 bg-amber-400 text-[#011B3B] font-bold hover:bg-amber-300 transition-all"
                  style={{ fontFamily: B }}
                >
                  <Play className="w-4 h-4" /> Start Game
                </button>
              </>
            )}
            {isLive && (
              <button
                onClick={() => navigate(`/games/${game.id}/simulate`)}
                className="flex items-center gap-2 px-6 py-2.5 bg-emerald-500 text-white font-bold hover:bg-emerald-400 transition-all"
                style={{ fontFamily: B }}
              >
                <Play className="w-4 h-4" /> Resume Game
              </button>
            )}
          </div>
        </div>
      </div>

      {/* ── Tabs ── */}
      <div className="bg-white border border-gray-100 mb-5">
        <div className="flex overflow-x-auto border-b border-gray-100">
          {allTabs.map((tab) => (
            <button
              key={tab}
              onClick={() => setActiveTab(tab)}
              className={`px-5 py-3.5 text-sm font-semibold whitespace-nowrap capitalize transition-colors border-b-2 ${
                activeTab === tab ? 'text-[#c81434] border-[#c81434]' : 'text-gray-500 border-transparent hover:text-[#011B3B]'
              }`}
              style={{ fontFamily: B }}
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
            <div key={stats.name} className="bg-white border border-gray-100 p-5">
              <div className="flex items-center gap-3 mb-5">
                <Avatar name={stats.name} isHome={isHome} />
                <div>
                  <h3 className="text-[#011B3B]" style={{ fontFamily: H }}>{stats.name}</h3>
                  <p className="text-xs text-gray-500" style={{ fontFamily: B }}>{isHome ? 'Home' : 'Away'} Team</p>
                </div>
              </div>

              <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2" style={{ fontFamily: B }}>Recent Form</p>
              <div className="flex gap-1.5 mb-5">
                {stats.form.map((r, i) => (
                  <div key={i} className={`w-8 h-8 flex items-center justify-center text-xs font-bold text-white ${FORM_COLORS[r] || 'bg-gray-400'}`} style={{ fontFamily: B }}>{r}</div>
                ))}
              </div>

              <div className="grid grid-cols-2 gap-3 mb-4">
                {[
                  { label: 'Wins',      val: stats.stats.wins,      bg: 'bg-emerald-50', color: 'text-emerald-600' },
                  { label: 'Losses',    val: stats.stats.losses,    bg: 'bg-red-50',     color: 'text-red-500' },
                  { label: 'Draws',     val: stats.stats.draws,     bg: 'bg-amber-50',   color: 'text-amber-600' },
                  { label: 'Avg Score', val: stats.stats.avgScore,  bg: 'bg-sky-50',     color: 'text-sky-600' },
                ].map(({ label, val, bg, color }) => (
                  <div key={label} className={`${bg} p-3 text-center`}>
                    <p className={`text-xl ${color}`} style={{ fontFamily: H }}>{val}</p>
                    <p className="text-xs text-gray-500" style={{ fontFamily: B }}>{label}</p>
                  </div>
                ))}
              </div>

              <div className="grid grid-cols-2 gap-3 border-t border-gray-100 pt-4">
                <div className="text-center">
                  <p className="text-[#011B3B]" style={{ fontFamily: H }}>{stats.stats.goalsFor}</p>
                  <p className="text-xs text-gray-500" style={{ fontFamily: B }}>Goals For</p>
                </div>
                <div className="text-center">
                  <p className="text-[#011B3B]" style={{ fontFamily: H }}>{stats.stats.goalsAgainst}</p>
                  <p className="text-xs text-gray-500" style={{ fontFamily: B }}>Goals Against</p>
                </div>
              </div>
            </div>
          ))}
        </div>
      )}

      {/* ── Team Stats ── */}
      {activeTab === 'team-stats' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-5">
          {[{ stats: homeStats, isHome: true }, { stats: awayStats, isHome: false }].map(({ stats, isHome }) => (
            <div key={stats.name} className="bg-white border border-gray-100 p-5">
              <div className="flex items-center gap-3 mb-5">
                <Avatar name={stats.name} isHome={isHome} />
                <h3 className="text-[#011B3B]" style={{ fontFamily: H }}>{stats.name}</h3>
              </div>
              <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4" style={{ fontFamily: B }}>Scoring Breakdown</p>
              <div className="space-y-4">
                {SCORING_BARS.map(({ key, label, bar }) => (
                  <div key={key}>
                    <div className="flex justify-between text-sm mb-1.5">
                      <span className="text-gray-600" style={{ fontFamily: B }}>{label}</span>
                      <span className="text-[#011B3B]" style={{ fontFamily: H }}>{stats.scoringBreakdown[key]}%</span>
                    </div>
                    <div className="w-full bg-gray-100 h-2">
                      <div className={`${bar} h-2 transition-all duration-500`} style={{ width: `${stats.scoringBreakdown[key]}%` }} />
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
            <div key={stats.name} className="bg-white border border-gray-100 p-5">
              <div className="flex items-center gap-3 mb-5">
                <Avatar name={stats.name} isHome={isHome} />
                <h3 className="text-[#011B3B]" style={{ fontFamily: H }}>{stats.name}</h3>
              </div>
              <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3" style={{ fontFamily: B }}>Last 5 Games</p>
              <div className="space-y-2">
                {stats.lastFiveGames.map((g, i) => (
                  <div key={i} className="flex items-center justify-between bg-gray-50 px-3 py-2.5">
                    <div className="flex items-center gap-2.5">
                      <div className={`w-7 h-7 flex items-center justify-center text-xs font-bold text-white ${FORM_COLORS[g.result] || 'bg-gray-400'}`} style={{ fontFamily: B }}>{g.result}</div>
                      <div>
                        <p className="text-sm text-[#011B3B]" style={{ fontFamily: B }}>vs {g.opponent}</p>
                        <p className="text-xs text-gray-400" style={{ fontFamily: B }}>{g.date}</p>
                      </div>
                    </div>
                    <span className="text-sm text-[#011B3B]" style={{ fontFamily: H }}>{g.score}</span>
                  </div>
                ))}
              </div>
            </div>
          ))}
        </div>
      )}

      {/* ── Game Details (live / completed) ── */}
      {activeTab === 'game-details' && (isLive || isCompleted) && (
        <div className="space-y-5">

          {/* Quarter breakdown */}
          <div className="bg-white border border-gray-100 p-5">
            <h3 className="text-[#011B3B] mb-4 uppercase tracking-widest text-sm" style={{ fontFamily: B }}>Quarter by Quarter</h3>

            {/* Mobile */}
            <div className="md:hidden space-y-3">
              {[
                { label: game.homeTeam, isHome: true,  score: game.homeScore, quarters: [game.quarters.q1.home, game.quarters.q2.home, game.quarters.q3.home, game.quarters.q4.home] },
                { label: game.awayTeam, isHome: false, score: game.awayScore, quarters: [game.quarters.q1.away, game.quarters.q2.away, game.quarters.q3.away, game.quarters.q4.away] },
              ].map(({ label, isHome, score, quarters }) => (
                <div key={label} className="bg-gray-50 p-4 border border-gray-100">
                  <div className="flex items-center gap-2 mb-3">
                    <Avatar name={label} isHome={isHome} size="sm" />
                    <span className="text-[#011B3B]" style={{ fontFamily: B }}>{label}</span>
                  </div>
                  <div className="grid grid-cols-5 gap-2 text-center">
                    {['Q1','Q2','Q3','Q4'].map((q, i) => (
                      <div key={q} className="bg-white py-2">
                        <p className="text-xs text-gray-400 mb-0.5" style={{ fontFamily: B }}>{q}</p>
                        <p className="text-[#011B3B]" style={{ fontFamily: H }}>{quarters[i]}</p>
                      </div>
                    ))}
                    <div className="bg-[#011B3B] py-2">
                      <p className="text-xs text-white/60 mb-0.5" style={{ fontFamily: B }}>Total</p>
                      <p className="text-white" style={{ fontFamily: H }}>{score}</p>
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Desktop */}
            <div className="hidden md:block overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b border-gray-100">
                    <th className="text-left py-2 px-3 text-gray-400 font-semibold uppercase tracking-wide text-xs" style={{ fontFamily: B }}>Team</th>
                    {['Q1','Q2','Q3','Q4'].map((q) => (
                      <th key={q} className="text-center py-2 px-3 text-gray-400 font-semibold uppercase tracking-wide text-xs" style={{ fontFamily: B }}>{q}</th>
                    ))}
                    <th className="text-center py-2 px-3 text-gray-400 font-semibold uppercase tracking-wide text-xs bg-gray-50" style={{ fontFamily: B }}>Total</th>
                  </tr>
                </thead>
                <tbody>
                  {[
                    { label: game.homeTeam, isHome: true,  score: game.homeScore, quarters: [game.quarters.q1.home, game.quarters.q2.home, game.quarters.q3.home, game.quarters.q4.home] },
                    { label: game.awayTeam, isHome: false, score: game.awayScore, quarters: [game.quarters.q1.away, game.quarters.q2.away, game.quarters.q3.away, game.quarters.q4.away] },
                  ].map(({ label, isHome, score, quarters }) => (
                    <tr key={label} className="border-b border-gray-50 last:border-0">
                      <td className="py-3 px-3">
                        <div className="flex items-center gap-2">
                          <Avatar name={label} isHome={isHome} size="sm" />
                          <span className="text-[#011B3B]" style={{ fontFamily: B }}>{label}</span>
                        </div>
                      </td>
                      {quarters.map((v, i) => (
                        <td key={i} className="text-center py-3 px-3 text-[#011B3B]" style={{ fontFamily: H }}>{v}</td>
                      ))}
                      <td className="text-center py-3 px-3 text-[#011B3B] bg-gray-50 text-lg" style={{ fontFamily: H }}>{score}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          </div>

          {/* Scoring breakdown */}
          <div className="bg-white border border-gray-100 p-5">
            <h3 className="text-[#011B3B] mb-4 uppercase tracking-widest text-sm" style={{ fontFamily: B }}>Scoring Breakdown</h3>
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3">
              {SCORING_CARDS.map(({ key, label, bg, text, border }) => (
                <div key={key} className={`${bg} border ${border} p-4`}>
                  <p className={`text-xs font-semibold ${text} mb-3 uppercase tracking-wide`} style={{ fontFamily: B }}>{label}</p>
                  <div className="space-y-2">
                    {[{ team: game.homeTeam, val: game.scoring[key].home }, { team: game.awayTeam, val: game.scoring[key].away }].map(({ team, val }) => (
                      <div key={team} className="flex justify-between items-center">
                        <span className="text-xs text-gray-500 truncate mr-2" style={{ fontFamily: B }}>{team}</span>
                        <span className={`${text}`} style={{ fontFamily: H }}>{val}</span>
                      </div>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Fouls */}
          {(game.fouls.home.length > 0 || game.fouls.away.length > 0) && (
            <div className="bg-white border border-gray-100 p-5">
              <h3 className="text-[#011B3B] mb-4 uppercase tracking-widest text-sm" style={{ fontFamily: B }}>Fouls</h3>
              <div className="grid grid-cols-1 sm:grid-cols-2 gap-5">
                {[{ team: game.homeTeam, fouls: game.fouls.home }, { team: game.awayTeam, fouls: game.fouls.away }].map(({ team, fouls }) => (
                  <div key={team}>
                    <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-2" style={{ fontFamily: B }}>{team}</p>
                    {fouls.length > 0 ? (
                      <div className="space-y-2">
                        {fouls.map((f, i) => (
                          <div key={i} className="flex items-center justify-between bg-red-50 px-3 py-2.5">
                            <div>
                              <p className="text-sm text-[#011B3B]" style={{ fontFamily: B }}>{f.player}</p>
                              <p className="text-xs text-gray-400" style={{ fontFamily: B }}>{f.quarter} · {f.minute}</p>
                            </div>
                            <AlertCircle className="w-4 h-4 text-red-400 flex-shrink-0" />
                          </div>
                        ))}
                      </div>
                    ) : (
                      <p className="text-xs text-gray-400 italic" style={{ fontFamily: B }}>No fouls recorded</p>
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
