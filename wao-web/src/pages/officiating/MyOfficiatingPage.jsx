import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Eye, Radio, MapPin, Calendar, Trophy, CheckCircle, AlertTriangle, Ban,
  Minus, Plus, Gavel,
} from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { useGames } from '../../context/GamesContext';
import { BRAND } from '../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const STATUS_CONFIG = {
  upcoming:  { style: 'bg-blue-100 text-blue-700',     icon: Calendar,      label: 'Upcoming' },
  live:      { style: 'bg-red-100 text-[#D30336]',     icon: Radio,         label: 'Live' },
  completed: { style: 'bg-green-100 text-green-700',   icon: CheckCircle,   label: 'Completed' },
  postponed: { style: 'bg-yellow-100 text-yellow-700', icon: Calendar,      label: 'Postponed' },
  suspended: { style: 'bg-orange-100 text-orange-700', icon: AlertTriangle, label: 'Suspended' },
  cancelled: { style: 'bg-gray-100 text-gray-600',     icon: Ban,           label: 'Cancelled' },
};

const TABS = [
  { key: 'upcoming', label: 'Upcoming' },
  { key: 'current',  label: 'Current' },
  { key: 'past',     label: 'Past Games' },
];

export default function MyOfficiatingPage() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { games, loading, submitJudgeScore } = useGames();
  const [tab, setTab] = useState('upcoming');

  const myGames = useMemo(
    () => games.filter((g) => (g.judges || []).some((j) => j.uid === user?.uid)),
    [games, user?.uid]
  );

  const upcomingGames = useMemo(
    () => myGames
      .filter((g) => ['upcoming', 'postponed'].includes(g.status))
      .sort((a, b) => (a.startTime?.getTime() ?? 0) - (b.startTime?.getTime() ?? 0)),
    [myGames]
  );

  const currentGames = useMemo(
    () => myGames
      .filter((g) => ['live', 'suspended'].includes(g.status))
      .sort((a, b) => (a.startTime?.getTime() ?? 0) - (b.startTime?.getTime() ?? 0)),
    [myGames]
  );

  const pastGames = useMemo(
    () => myGames
      .filter((g) => ['completed', 'cancelled'].includes(g.status))
      .sort((a, b) => (b.startTime?.getTime() ?? 0) - (a.startTime?.getTime() ?? 0)),
    [myGames]
  );

  if (user?.role !== 'official') {
    return (
      <section className="flex flex-col items-center justify-center gap-3 py-24">
        <p className="text-gray-500 text-sm" style={{ fontFamily: B }}>This page is for judge accounts.</p>
        <button onClick={() => navigate('/dashboard')} className="text-sm text-[#011B3B] underline" style={{ fontFamily: B }}>
          Back to Dashboard
        </button>
      </section>
    );
  }

  const GameMeta = ({ game }) => (
    <div className="flex-1 min-w-0">
      <p className="text-sm font-semibold text-[#011B3B] truncate" style={{ fontFamily: B }}>{game.homeTeam} vs {game.awayTeam}</p>
      <div className="flex flex-wrap items-center gap-x-3 gap-y-0.5 text-xs text-gray-400 mt-0.5" style={{ fontFamily: B }}>
        <span className="flex items-center gap-1"><MapPin className="w-3 h-3" />{game.venue}</span>
        <span className="flex items-center gap-1"><Calendar className="w-3 h-3" />{game.date} · {game.time}</span>
        {game.championship && <span className="flex items-center gap-1"><Trophy className="w-3 h-3" />{game.championship}</span>}
      </div>
      {game.statusReason && (game.status === 'postponed' || game.status === 'suspended') && (
        <p className="text-xs text-gray-500 mt-1" style={{ fontFamily: B }}>Reason: {game.statusReason}</p>
      )}
    </div>
  );

  const UpcomingRow = ({ game }) => {
    const { style, icon: Icon, label } = STATUS_CONFIG[game.status] ?? STATUS_CONFIG.upcoming;
    return (
      <div className="flex flex-col sm:flex-row sm:items-center gap-3 p-4 border border-gray-100 bg-white">
        <span className={`flex items-center gap-1 w-fit text-xs font-semibold px-2.5 py-1 rounded-full shrink-0 ${style}`}>
          <Icon className="w-3 h-3" />{label}
        </span>
        <GameMeta game={game} />
        <button
          onClick={() => navigate(`/games/${game.id}`)}
          className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold bg-gray-100 text-gray-700 hover:bg-gray-200 transition-colors shrink-0"
          style={{ fontFamily: B }}
        >
          <Eye className="w-3.5 h-3.5" /> View
        </button>
      </div>
    );
  };

  // Live games get a Judges (10%) score-granting control — the one category
  // an assigned judge can write to directly (see firestore.rules' judgeUids
  // branch); everything else on the scoreboard stays the moderator's job.
  const CurrentRow = ({ game }) => {
    const { style, icon: Icon, label } = STATUS_CONFIG[game.status] ?? STATUS_CONFIG.live;
    const judgesScore = game.scoring?.judges || { home: 0, away: 0 };
    const isLive = game.status === 'live';
    return (
      <div className="p-4 border border-gray-100 bg-white space-y-3">
        <div className="flex flex-col sm:flex-row sm:items-center gap-3">
          <span className={`flex items-center gap-1 w-fit text-xs font-semibold px-2.5 py-1 rounded-full shrink-0 ${style}`}>
            <Icon className="w-3 h-3" />{label}
          </span>
          <GameMeta game={game} />
          <button
            onClick={() => navigate(`/games/${game.id}`)}
            className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold bg-gray-100 text-gray-700 hover:bg-gray-200 transition-colors shrink-0"
            style={{ fontFamily: B }}
          >
            <Eye className="w-3.5 h-3.5" /> View
          </button>
        </div>

        {isLive ? (
          <div className="grid grid-cols-2 gap-3 pt-3 border-t border-gray-100">
            {[{ team: 'home', name: game.homeTeam }, { team: 'away', name: game.awayTeam }].map(({ team, name }) => (
              <div key={team} className="flex items-center justify-between gap-2 bg-amber-50 border border-amber-100 px-3 py-2">
                <div className="min-w-0">
                  <p className="text-[10px] text-amber-700 uppercase tracking-wide flex items-center gap-1" style={{ fontFamily: B }}>
                    <Gavel className="w-3 h-3" /> Judges Score
                  </p>
                  <p className="text-xs text-gray-600 truncate" style={{ fontFamily: B }}>{name}</p>
                </div>
                <div className="flex items-center gap-2 shrink-0">
                  <button
                    onClick={() => submitJudgeScore(game.id, team, -1)}
                    className="w-7 h-7 flex items-center justify-center bg-white border border-amber-200 text-amber-700 hover:bg-amber-100 transition-colors"
                  >
                    <Minus className="w-3.5 h-3.5" />
                  </button>
                  <span className="w-6 text-center text-sm font-bold text-[#011B3B]" style={{ fontFamily: H }}>{judgesScore[team] ?? 0}</span>
                  <button
                    onClick={() => submitJudgeScore(game.id, team, 1)}
                    className="w-7 h-7 flex items-center justify-center bg-amber-500 text-white hover:bg-amber-400 transition-colors"
                  >
                    <Plus className="w-3.5 h-3.5" />
                  </button>
                </div>
              </div>
            ))}
          </div>
        ) : (
          <p className="text-xs text-gray-400 pt-3 border-t border-gray-100" style={{ fontFamily: B }}>
            Suspended — scoring resumes once the moderator restarts this game.
          </p>
        )}
      </div>
    );
  };

  return (
    <section className="scrollbar-hide px-2 py-4 md:p-4 pb-12 space-y-4">
      <div>
        <h1 className="text-xl md:text-2xl font-semibold text-gray-900 uppercase tracking-widest" style={{ fontFamily: B }}>My Officiating</h1>
        <p className="text-xs text-gray-400 mt-0.5" style={{ fontFamily: B }}>Games you're assigned to as a judge — {myGames.length} total.</p>
      </div>

      <div className="flex gap-1 bg-white border border-gray-100 p-1 w-fit">
        {TABS.map((t) => (
          <button
            key={t.key}
            onClick={() => setTab(t.key)}
            className={`px-4 py-2 text-xs sm:text-sm font-semibold transition-all ${
              tab === t.key ? 'bg-[#011B3B] text-white' : 'text-gray-500 hover:text-[#011B3B]'
            }`}
            style={{ fontFamily: B }}
          >
            {t.label}
          </button>
        ))}
      </div>

      {tab === 'upcoming' && (
        <div className="space-y-3">
          {loading ? (
            <div className="py-16 text-center text-sm text-gray-400 bg-white border border-gray-100" style={{ fontFamily: B }}>Loading your games…</div>
          ) : upcomingGames.length === 0 ? (
            <div className="py-16 text-center text-sm text-gray-400 bg-white border border-gray-100" style={{ fontFamily: B }}>
              No upcoming games assigned to you right now.
            </div>
          ) : (
            upcomingGames.map((g) => <UpcomingRow key={g.id} game={g} />)
          )}
        </div>
      )}

      {tab === 'current' && (
        <div className="space-y-3">
          {loading ? (
            <div className="py-16 text-center text-sm text-gray-400 bg-white border border-gray-100" style={{ fontFamily: B }}>Loading your games…</div>
          ) : currentGames.length === 0 ? (
            <div className="py-16 text-center text-sm text-gray-400 bg-white border border-gray-100" style={{ fontFamily: B }}>
              None of your games are live right now.
            </div>
          ) : (
            currentGames.map((g) => <CurrentRow key={g.id} game={g} />)
          )}
        </div>
      )}

      {tab === 'past' && (
        <div className="bg-white border border-gray-100 divide-y divide-gray-50">
          {pastGames.length === 0 ? (
            <div className="py-16 text-center text-sm text-gray-400" style={{ fontFamily: B }}>No past games yet.</div>
          ) : (
            pastGames.map((g) => {
              const { style, icon: Icon, label } = STATUS_CONFIG[g.status] ?? STATUS_CONFIG.completed;
              return (
                <div
                  key={g.id}
                  className="flex items-center justify-between gap-3 p-4 hover:bg-gray-50 transition-colors cursor-pointer"
                  onClick={() => navigate(`/games/${g.id}`)}
                >
                  <div className="min-w-0">
                    <p className="text-sm font-semibold text-[#011B3B] truncate" style={{ fontFamily: B }}>{g.homeTeam} vs {g.awayTeam}</p>
                    <div className="flex items-center gap-3 text-xs text-gray-400 mt-0.5" style={{ fontFamily: B }}>
                      <span className="flex items-center gap-1"><Calendar className="w-3 h-3" />{g.date}</span>
                      <span className="flex items-center gap-1"><MapPin className="w-3 h-3" />{g.venue}</span>
                    </div>
                  </div>
                  <div className="flex items-center gap-3 shrink-0">
                    {g.status === 'completed' && (
                      <span className="text-sm font-bold text-[#011B3B]" style={{ fontFamily: H }}>{g.homeScore} - {g.awayScore}</span>
                    )}
                    <span className={`flex items-center gap-1 text-xs font-semibold px-2.5 py-1 rounded-full ${style}`}>
                      <Icon className="w-3 h-3" />{label}
                    </span>
                  </div>
                </div>
              );
            })
          )}
        </div>
      )}
    </section>
  );
}
