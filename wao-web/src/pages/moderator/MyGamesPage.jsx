import { useState, useMemo } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  Eye, Play, Radio, CalendarClock, Ban, RotateCcw, MapPin, Calendar, Trophy,
  CheckCircle, AlertTriangle, PauseCircle,
} from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { useGames } from '../../context/GamesContext';
import { canStartGame, isPastDue } from '../../services/matchesService';
import RescheduleModal from '../games/components/RescheduleModal';
import CancelGameModal from '../games/components/CancelGameModal';
import { BRAND } from '../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const STATUS_CONFIG = {
  upcoming:  { style: 'bg-blue-100 text-blue-700',     icon: Calendar,      label: 'Upcoming' },
  live:      { style: 'bg-red-100 text-[#D30336]',     icon: Radio,         label: 'Live' },
  completed: { style: 'bg-green-100 text-green-700',   icon: CheckCircle,   label: 'Completed' },
  postponed: { style: 'bg-yellow-100 text-yellow-700', icon: PauseCircle,   label: 'Postponed' },
  suspended: { style: 'bg-orange-100 text-orange-700', icon: AlertTriangle, label: 'Suspended' },
  cancelled: { style: 'bg-gray-100 text-gray-600',     icon: Ban,           label: 'Cancelled' },
};

const TABS = [
  { key: 'active',      label: 'My Games' },
  { key: 'performance',  label: 'Performance' },
  { key: 'past',         label: 'Past Games' },
];

export default function MyGamesPage() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { games, loading, updateGame } = useGames();
  const [tab, setTab] = useState('active');
  const [rescheduleGame, setRescheduleGame] = useState(null);
  const [cancelGame, setCancelGame] = useState(null);

  const myGames = useMemo(
    () => games.filter((g) => g.moderatorUid === user?.uid),
    [games, user?.uid]
  );

  const activeGames = useMemo(
    () => myGames
      .filter((g) => ['upcoming', 'live', 'postponed', 'suspended'].includes(g.status))
      .sort((a, b) => (a.startTime?.getTime() ?? 0) - (b.startTime?.getTime() ?? 0)),
    [myGames]
  );

  const pastGames = useMemo(
    () => myGames
      .filter((g) => ['completed', 'cancelled'].includes(g.status))
      .sort((a, b) => (b.startTime?.getTime() ?? 0) - (a.startTime?.getTime() ?? 0)),
    [myGames]
  );

  const stats = useMemo(() => {
    const count = (pred) => myGames.filter(pred).length;
    const completed = count((g) => g.status === 'completed');
    const cancelled = count((g) => g.status === 'cancelled');
    const postponed = count((g) => g.status === 'postponed');
    const suspended = count((g) => g.status === 'suspended');
    const resolved = completed + cancelled + postponed + suspended;
    return {
      total: myGames.length,
      upcoming: count((g) => g.status === 'upcoming'),
      live: count((g) => g.status === 'live'),
      completed, cancelled, postponed, suspended,
      completionRate: resolved ? Math.round((completed / resolved) * 100) : null,
    };
  }, [myGames]);

  const handleUnsuspend = (g) =>
    updateGame(g.id, { status: g.previousStatus || 'upcoming', statusReason: '', previousStatus: '' });

  // Same modal serves two different repairs: a plain past-due reschedule
  // (game stays 'upcoming', just gets a new startTime) vs. resuming a
  // postponed game (also flips status back to upcoming and clears the
  // postpone reason/previousStatus) — dispatch on the target game's status
  // at the moment the modal was opened.
  const handleRescheduleSave = (newDate) => {
    if (!rescheduleGame) return;
    updateGame(
      rescheduleGame.id,
      rescheduleGame.status === 'postponed'
        ? { startTime: newDate, status: 'upcoming', statusReason: '', previousStatus: '' }
        : { startTime: newDate }
    );
  };

  const handleCancel = (reason) => {
    if (!cancelGame) return;
    updateGame(cancelGame.id, { status: 'cancelled', statusReason: reason });
  };

  if (user?.role !== 'moderator') {
    return (
      <section className="flex flex-col items-center justify-center gap-3 py-24">
        <p className="text-gray-500 text-sm" style={{ fontFamily: B }}>This page is for moderator accounts.</p>
        <button onClick={() => navigate('/dashboard')} className="text-sm text-[#011B3B] underline" style={{ fontFamily: B }}>
          Back to Dashboard
        </button>
      </section>
    );
  }

  const GameRow = ({ game }) => {
    const { style, icon: Icon, label } = STATUS_CONFIG[game.status] ?? STATUS_CONFIG.upcoming;
    const pastDue = isPastDue(game);
    const canStart = canStartGame(game);
    return (
      <div className="flex flex-col sm:flex-row sm:items-center gap-3 p-4 border border-gray-100 bg-white">
        <span className={`flex items-center gap-1 w-fit text-xs font-semibold px-2.5 py-1 rounded-full shrink-0 ${style}`}>
          <Icon className="w-3 h-3" />{label}
        </span>

        <div className="flex-1 min-w-0">
          <p className="text-sm font-semibold text-[#011B3B] truncate" style={{ fontFamily: B }}>{game.homeTeam} vs {game.awayTeam}</p>
          <div className="flex flex-wrap items-center gap-x-3 gap-y-0.5 text-xs text-gray-400 mt-0.5" style={{ fontFamily: B }}>
            <span className="flex items-center gap-1"><MapPin className="w-3 h-3" />{game.venue}</span>
            <span className="flex items-center gap-1"><Calendar className="w-3 h-3" />{game.date} · {game.time}</span>
            {game.championship && <span className="flex items-center gap-1"><Trophy className="w-3 h-3" />{game.championship}</span>}
          </div>
          {pastDue && game.status === 'upcoming' && (
            <p className="text-xs text-red-500 mt-1 font-medium" style={{ fontFamily: B }}>Missed — nobody started it</p>
          )}
          {game.statusReason && (game.status === 'postponed' || game.status === 'suspended') && (
            <p className="text-xs text-gray-500 mt-1" style={{ fontFamily: B }}>Reason: {game.statusReason}</p>
          )}
        </div>

        <div className="flex flex-wrap gap-2 shrink-0">
          <button
            onClick={() => navigate(`/games/${game.id}`)}
            className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold bg-gray-100 text-gray-700 hover:bg-gray-200 transition-colors"
            style={{ fontFamily: B }}
          >
            <Eye className="w-3.5 h-3.5" /> View
          </button>

          {game.status === 'upcoming' && !pastDue && canStart && (
            <button
              onClick={() => navigate(`/games/${game.id}/simulate`)}
              className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold bg-[#c81434] text-white hover:bg-[#e21e43] transition-colors"
              style={{ fontFamily: B }}
            >
              <Play className="w-3.5 h-3.5" /> Start
            </button>
          )}

          {game.status === 'live' && (
            <button
              onClick={() => navigate(`/games/${game.id}/simulate`)}
              className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold bg-emerald-500 text-white hover:bg-emerald-400 transition-colors"
              style={{ fontFamily: B }}
            >
              <Radio className="w-3.5 h-3.5" /> Continue
            </button>
          )}

          {pastDue && game.status === 'upcoming' && (
            <>
              <button
                onClick={() => setRescheduleGame(game)}
                className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold bg-sky-500 text-white hover:bg-sky-400 transition-colors"
                style={{ fontFamily: B }}
              >
                <CalendarClock className="w-3.5 h-3.5" /> Reschedule
              </button>
              <button
                onClick={() => setCancelGame(game)}
                className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold bg-white text-[#c81434] border border-[#c81434]/30 hover:bg-red-50 transition-colors"
                style={{ fontFamily: B }}
              >
                <Ban className="w-3.5 h-3.5" /> Cancel
              </button>
            </>
          )}

          {game.status === 'suspended' && (
            <button
              onClick={() => handleUnsuspend(game)}
              className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold bg-emerald-50 text-emerald-700 border border-emerald-200 hover:bg-emerald-100 transition-colors"
              style={{ fontFamily: B }}
            >
              <RotateCcw className="w-3.5 h-3.5" /> Unsuspend
            </button>
          )}

          {game.status === 'postponed' && (
            <button
              onClick={() => setRescheduleGame(game)}
              className="flex items-center gap-1.5 px-3 py-2 text-xs font-semibold bg-sky-50 text-sky-700 border border-sky-200 hover:bg-sky-100 transition-colors"
              style={{ fontFamily: B }}
            >
              <CalendarClock className="w-3.5 h-3.5" /> Set New Date &amp; Time
            </button>
          )}
        </div>
      </div>
    );
  };

  const resolved = stats.completed + stats.postponed + stats.suspended + stats.cancelled;

  return (
    <section className="scrollbar-hide px-2 py-4 md:p-4 pb-12 space-y-4">
      <div>
        <h1 className="text-xl md:text-2xl font-semibold text-gray-900 uppercase tracking-widest" style={{ fontFamily: B }}>My Games</h1>
        <p className="text-xs text-gray-400 mt-0.5" style={{ fontFamily: B }}>Games assigned to you as moderator — {stats.total} total.</p>
      </div>

      {/* Small internal nav — this page is scoped to one moderator, not the full admin games list */}
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

      {tab === 'active' && (
        <div className="space-y-3">
          {loading ? (
            <div className="py-16 text-center text-sm text-gray-400 bg-white border border-gray-100" style={{ fontFamily: B }}>Loading your games…</div>
          ) : activeGames.length === 0 ? (
            <div className="py-16 text-center text-sm text-gray-400 bg-white border border-gray-100" style={{ fontFamily: B }}>
              No active games assigned to you right now.
            </div>
          ) : (
            activeGames.map((g) => <GameRow key={g.id} game={g} />)
          )}
        </div>
      )}

      {tab === 'performance' && (
        <div className="space-y-4">
          <div className="bg-white border border-gray-100 grid grid-cols-2 sm:grid-cols-4 divide-x divide-y sm:divide-y-0 divide-gray-100">
            {[
              { label: 'Total Games', value: stats.total },
              { label: 'Upcoming', value: stats.upcoming },
              { label: 'Live Now', value: stats.live },
              { label: 'Completed', value: stats.completed },
            ].map(({ label, value }) => (
              <div key={label} className="p-4 text-center">
                <p className="text-2xl font-semibold text-[#011B3B]" style={{ fontFamily: H }}>{value}</p>
                <p className="text-xs text-gray-400 uppercase tracking-wide mt-0.5" style={{ fontFamily: B }}>{label}</p>
              </div>
            ))}
          </div>

          <div className="bg-white border border-gray-100 p-5">
            <h3 className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-4" style={{ fontFamily: B }}>Resolution Breakdown</h3>
            <div className="space-y-3">
              {[
                { label: 'Completed', value: stats.completed, color: 'bg-emerald-500' },
                { label: 'Postponed', value: stats.postponed, color: 'bg-yellow-400' },
                { label: 'Suspended', value: stats.suspended, color: 'bg-orange-400' },
                { label: 'Cancelled', value: stats.cancelled, color: 'bg-gray-400' },
              ].map(({ label, value, color }) => {
                const pct = resolved ? Math.round((value / resolved) * 100) : 0;
                return (
                  <div key={label}>
                    <div className="flex items-center justify-between text-xs mb-1" style={{ fontFamily: B }}>
                      <span className="text-gray-600">{label}</span>
                      <span className="text-gray-400">{value} · {pct}%</span>
                    </div>
                    <div className="h-1.5 bg-gray-100 w-full">
                      <div className={`h-1.5 ${color}`} style={{ width: `${pct}%` }} />
                    </div>
                  </div>
                );
              })}
            </div>
            {stats.completionRate != null ? (
              <p className="text-xs text-gray-400 mt-4" style={{ fontFamily: B }}>
                <span className="font-semibold text-[#011B3B]">{stats.completionRate}%</span> of your resolved games were completed rather than postponed, suspended, or cancelled.
              </p>
            ) : (
              <p className="text-xs text-gray-400 mt-4" style={{ fontFamily: B }}>No resolved games yet.</p>
            )}
          </div>
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

      {rescheduleGame && (
        <RescheduleModal game={rescheduleGame} onSave={handleRescheduleSave} onClose={() => setRescheduleGame(null)} />
      )}
      {cancelGame && (
        <CancelGameModal game={cancelGame} onConfirm={handleCancel} onClose={() => setCancelGame(null)} />
      )}
    </section>
  );
}
