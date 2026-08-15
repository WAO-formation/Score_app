/* eslint-disable no-unused-vars */
import React, { useState, useEffect, useMemo } from 'react';
import {
  ArrowLeft,
  Calendar,
  MapPin,
  Users,
  Award,
  Edit,
  Crown,
  Briefcase,
  Shield,
  Swords,
  Zap,
  Heart,
  Trash2,
  X,
  Plus,
  Save,
  UserPlus,
  MoreVertical
} from 'lucide-react';
import { useParams, useNavigate } from 'react-router-dom';
import { BRAND } from '../../config/brand';
import { useGames } from '../../context/GamesContext';
import {
  subscribeToTeam,
  subscribeToTeamStats,
  subscribeToPlayersByIds,
  updateTeam,
  addPlayerToTeam,
  updatePlayer,
  removePlayerFromTeam,
} from '../../services/teamsService';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const ROLE_STYLES = {
  King:       { icon: Crown,     bg: 'bg-violet-500' },
  Worker:     { icon: Briefcase, bg: 'bg-sky-500' },
  Protaque:   { icon: Shield,    bg: 'bg-emerald-500' },
  Antaque:    { icon: Swords,    bg: 'bg-red-500' },
  Warrior:    { icon: Zap,       bg: 'bg-amber-500' },
  Servitor:   { icon: Heart,     bg: 'bg-pink-500' },
  Sacrificer: { icon: Award,     bg: 'bg-fuchsia-500' },
  Substitute: { icon: Users,     bg: 'bg-gray-400' },
};

const RESULT_STYLES = {
  win:  { label: 'WIN',  bg: 'bg-emerald-500' },
  loss: { label: 'LOSS', bg: 'bg-red-500' },
  draw: { label: 'DRAW', bg: 'bg-amber-500' },
};

const INPUT = "w-full px-4 py-2.5 text-sm border border-gray-200 rounded-sm focus:outline-none focus:border-gray-400 bg-gray-50 transition";
const LABEL = "block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5";

const TeamDetails = () => {
  const { teamId } = useParams();
  const navigate = useNavigate();
  const { games } = useGames();
  const [activeTab, setActiveTab] = useState('roster');

  // Modals state
  const [showEditTeamModal, setShowEditTeamModal] = useState(false);
  const [showEditPlayerModal, setShowEditPlayerModal] = useState(false);
  const [showDeletePlayerModal, setShowDeletePlayerModal] = useState(false);
  const [showAddPlayerModal, setShowAddPlayerModal] = useState(false);
  const [selectedPlayer, setSelectedPlayer] = useState(null);
  const [openPlayerMenu, setOpenPlayerMenu] = useState(null);

  useEffect(() => {
    const closeMenu = (e) => {
      if (!e.target.closest('[data-actions-menu]')) setOpenPlayerMenu(null);
    };
    document.addEventListener('click', closeMenu);
    return () => document.removeEventListener('click', closeMenu);
  }, []);

  // Live Firestore data: the team doc itself, its teamStatistics doc (may
  // not exist yet for a brand-new team — subscribeToTeamStats already
  // normalizes that to all-zeros), and the actual player docs for every id
  // across the 8 roster arrays.
  const [team, setTeam] = useState(null);
  const [teamLoading, setTeamLoading] = useState(true);
  const [stats, setStats] = useState(null);
  const [players, setPlayers] = useState([]);

  useEffect(() => {
    setTeamLoading(true);
    return subscribeToTeam(
      teamId,
      (t) => { setTeam(t); setTeamLoading(false); },
      () => setTeamLoading(false)
    );
  }, [teamId]);

  useEffect(() => subscribeToTeamStats(teamId, setStats, () => setStats(null)), [teamId]);

  const rosterIds = useMemo(
    () => (team ? Object.values(team.roster).flat() : []),
    [team]
  );
  const rosterKey = rosterIds.join(',');

  useEffect(() => {
    if (!team) { setPlayers([]); return undefined; }
    return subscribeToPlayersByIds(rosterIds, setPlayers, () => setPlayers([]));
    // rosterIds is recomputed every render; rosterKey is its stable identity.
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [team?.id, rosterKey]);

  // This team's games, reusing GamesContext's live `games` array instead of
  // a separate query — see matchesService.docToGame for the full shape.
  const teamGames = useMemo(
    () => games.filter((g) => g.homeTeamId === teamId || g.awayTeamId === teamId),
    [games, teamId]
  );
  const upcomingGames = useMemo(
    () => teamGames
      .filter((g) => g.status === 'upcoming')
      .map((g) => ({ id: g.id, team1: g.homeTeam, team2: g.awayTeam, date: g.date, time: g.time, venue: g.venue, championship: g.championship })),
    [teamGames]
  );
  const pastGames = useMemo(
    () => teamGames
      .filter((g) => g.status === 'completed')
      .map((g) => {
        const isHome = g.homeTeamId === teamId;
        const ownScore = isHome ? g.homeScore : g.awayScore;
        const oppScore = isHome ? g.awayScore : g.homeScore;
        const result = ownScore === oppScore ? 'draw' : ownScore > oppScore ? 'win' : 'loss';
        return {
          id: g.id, team1: g.homeTeam, team2: g.awayTeam,
          team1Score: g.homeScore, team2Score: g.awayScore,
          date: g.date, venue: g.venue, championship: g.championship, result,
        };
      }),
    [teamGames, teamId]
  );

  // Form states
  const [teamForm, setTeamForm] = useState({
    name: '', coach: '', category: 'Senior', description: '', founded: '', icon: ''
  });

  const [playerForm, setPlayerForm] = useState({
    name: '',
    role: 'Substitute',
    number: '',
    age: ''
  });

  const availableRoles = ['King', 'Worker', 'Protaque', 'Antaque', 'Warrior', 'Servitor', 'Sacrificer', 'Substitute'];

  // Team CRUD Functions
  const handleEditTeam = () => {
    if (!team) return;
    setTeamForm({
      name: team.name,
      coach: team.coach,
      category: team.category,
      description: team.description,
      founded: team.founded,
      icon: team.icon
    });
    setShowEditTeamModal(true);
  };

  const handleSaveTeam = async () => {
    try {
      await updateTeam(teamId, {
        name: teamForm.name,
        coach: teamForm.coach,
        category: teamForm.category.toLowerCase(),
        description: teamForm.description,
        founded: teamForm.founded,
        icon: teamForm.icon.toUpperCase(),
      });
      setShowEditTeamModal(false);
    } catch (err) {
      alert('Failed to update team. Please try again.');
    }
  };

  // Player CRUD Functions
  const handleAddPlayer = () => {
    setPlayerForm({
      name: '',
      role: 'Substitute',
      number: players.length + 1,
      age: ''
    });
    setShowAddPlayerModal(true);
  };

  const handleSaveNewPlayer = async () => {
    if (!playerForm.name || !playerForm.age) {
      alert('Please fill in all required fields');
      return;
    }

    try {
      await addPlayerToTeam(teamId, {
        name: playerForm.name,
        role: playerForm.role,
        number: playerForm.number,
        age: playerForm.age,
        teamName: team?.name,
      });
      setShowAddPlayerModal(false);
    } catch (err) {
      alert('Failed to add player. Please try again.');
    }
  };

  const handleEditPlayer = (player) => {
    setSelectedPlayer(player);
    setPlayerForm({
      name: player.name,
      role: player.role,
      number: player.number,
      age: player.age
    });
    setOpenPlayerMenu(null);
    setShowEditPlayerModal(true);
  };

  const handleSavePlayer = async () => {
    if (!selectedPlayer) return;
    try {
      await updatePlayer(
        selectedPlayer.id,
        { name: playerForm.name, role: playerForm.role, number: playerForm.number, age: playerForm.age },
        { teamId, previousRoleValue: selectedPlayer.roleValue }
      );
      setShowEditPlayerModal(false);
    } catch (err) {
      alert('Failed to update player. Please try again.');
    }
  };

  const handleDeletePlayerConfirm = (player) => {
    setSelectedPlayer(player);
    setOpenPlayerMenu(null);
    setShowDeletePlayerModal(true);
  };

  const handleDeletePlayer = async () => {
    if (!selectedPlayer) return;
    try {
      await removePlayerFromTeam(teamId, selectedPlayer.id, selectedPlayer.roleValue);
      setShowDeletePlayerModal(false);
    } catch (err) {
      alert('Failed to remove player. Please try again.');
    }
  };

  const PlayerCard = ({ player }) => {
    const { icon: RoleIcon, bg } = ROLE_STYLES[player.role] ?? ROLE_STYLES.Substitute;
    return (
      <div className="bg-gray-50 border border-gray-100 p-4 hover:bg-gray-100 transition-colors">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3 min-w-0">
            <div className={`w-11 h-11 ${bg} flex items-center justify-center text-white font-bold flex-shrink-0`} style={{ fontFamily: H }}>
              {player.number}
            </div>
            <div className="min-w-0">
              <p className="font-semibold text-[#011B3B] text-sm truncate" style={{ fontFamily: B }}>{player.name}</p>
              <div className="flex items-center gap-1 text-xs text-gray-500" style={{ fontFamily: B }}>
                <RoleIcon className="w-3 h-3" />
                <span>{player.role}</span>
                <span>·</span>
                <span>{player.age}y</span>
              </div>
            </div>
          </div>
          <div className="relative flex-shrink-0" data-actions-menu>
            <button
              onClick={(e) => { e.stopPropagation(); setOpenPlayerMenu(openPlayerMenu === player.id ? null : player.id); }}
              className="p-1.5 hover:bg-gray-200 rounded transition-colors"
              title="Actions"
            >
              <MoreVertical className="w-4 h-4 text-gray-400" />
            </button>
            {openPlayerMenu === player.id && (
              <div className="absolute right-0 mt-1 w-40 bg-white border border-gray-100 shadow-lg rounded-sm z-20" data-actions-menu>
                <button onClick={() => handleEditPlayer(player)} className="w-full flex items-center gap-2 px-3 py-2.5 text-sm text-gray-700 hover:bg-gray-50" style={{ fontFamily: B }}>
                  <Edit className="w-3.5 h-3.5" /> Edit
                </button>
                <button onClick={() => handleDeletePlayerConfirm(player)} className="w-full flex items-center gap-2 px-3 py-2.5 text-sm text-red-500 hover:bg-red-50 border-t border-gray-50" style={{ fontFamily: B }}>
                  <Trash2 className="w-3.5 h-3.5" /> Remove
                </button>
              </div>
            )}
          </div>
        </div>
      </div>
    );
  };

  if (teamLoading) {
    return (
      <section className="flex items-center justify-center py-24">
        <p className="text-gray-400 text-sm" style={{ fontFamily: B }}>Loading team...</p>
      </section>
    );
  }

  if (!team) {
    return (
      <section className="flex flex-col items-center justify-center gap-3 py-24">
        <p className="text-gray-500 text-sm" style={{ fontFamily: B }}>Team not found.</p>
        <button
          onClick={() => navigate('/teams')}
          className="text-sm text-[#011B3B] underline"
          style={{ fontFamily: B }}
        >
          Back to Teams
        </button>
      </section>
    );
  }

  return (
    <section className="scrollbar-hide px-2 py-2 md:p-4 pb-8">
      {/* Header Section */}
      <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] shadow-lg p-5 mb-5 relative overflow-hidden">
        {/* Background Ball */}
        <img
          src="/assets/design/wao-ball.png"
          alt=""
          aria-hidden
          className="absolute -right-16 -top-16 w-64 h-64 object-contain opacity-10 pointer-events-none"
        />

        <div className="relative z-10">
          {/* Back Button */}
          <button
            onClick={() => navigate('/teams')}
            className="flex items-center gap-1.5 text-white/70 hover:text-white mb-4 text-sm transition-colors"
            style={{ fontFamily: B }}
          >
            <ArrowLeft className="w-4 h-4" />
            <span>Back to Teams</span>
          </button>

          {/* Team Info */}
          <div className="flex items-center justify-between gap-3">
            <div className="flex items-center gap-3 min-w-0">
              <div className="w-14 h-14 md:w-16 md:h-16 bg-amber-400 flex items-center justify-center flex-shrink-0">
                <span className="text-white font-medium text-lg md:text-xl" style={{ fontFamily: H }}>{team.icon}</span>
              </div>
              <div className="min-w-0">
                <h1 className="text-xl md:text-2xl text-white truncate" style={{ fontFamily: H }}>{team.name}</h1>
                <div className="flex flex-wrap items-center gap-x-3 gap-y-1 text-white/60 text-xs md:text-sm mt-1" style={{ fontFamily: B }}>
                  <span>Coach: {team.coach}</span>
                  <span className="hidden sm:inline">·</span>
                  <span>{team.category}</span>
                </div>
              </div>
            </div>
            <button
              onClick={handleEditTeam}
              className="flex items-center gap-1.5 px-3 py-2 md:px-4 md:py-2.5 bg-white text-[#011B3B] font-semibold uppercase tracking-wide hover:bg-gray-100 transition-colors text-xs md:text-sm flex-shrink-0"
              style={{ fontFamily: B }}
            >
              <Edit className="w-3.5 h-3.5 md:w-4 md:h-4" />
              <span>Edit</span>
            </button>
          </div>
        </div>
      </div>

      {/* Season Stats — teamStatistics/{teamId}, same schema wao_mobile's TeamStatistics writes/reads */}
      <div className="bg-white border border-gray-100 mb-5 grid grid-cols-3 md:grid-cols-6 divide-x divide-gray-100">
        {[
          { label: 'Played', value: stats?.totalGamesPlayed ?? 0 },
          { label: 'Won', value: stats?.wins ?? 0 },
          { label: 'Drawn', value: stats?.draws ?? 0 },
          { label: 'Lost', value: stats?.losses ?? 0 },
          { label: 'Goal Diff', value: (stats?.goalsScored ?? 0) - (stats?.goalsConceded ?? 0) },
          { label: 'Points', value: (stats?.wins ?? 0) * 3 + (stats?.draws ?? 0) },
        ].map(({ label, value }) => (
          <div key={label} className="p-3 md:p-4 text-center">
            <p className="text-lg md:text-xl font-semibold text-[#011B3B]" style={{ fontFamily: H }}>{value}</p>
            <p className="text-[10px] md:text-xs text-gray-400 uppercase tracking-wide mt-0.5" style={{ fontFamily: B }}>{label}</p>
          </div>
        ))}
      </div>

      {/* Tabs */}
      <div className="bg-white border border-gray-100 mb-5">
        <div className="flex border-b border-gray-100 overflow-x-auto scrollbar-hide">
          {[
            { key: 'roster', label: 'Team Roster' },
            { key: 'upcoming', label: 'Upcoming Games' },
            { key: 'past', label: 'Past Games' },
          ].map(({ key, label }) => (
            <button
              key={key}
              onClick={() => setActiveTab(key)}
              className={`px-5 py-3.5 text-sm font-semibold whitespace-nowrap transition-colors border-b-2 ${
                activeTab === key ? 'text-[#c81434] border-[#c81434]' : 'text-gray-500 border-transparent hover:text-[#011B3B]'
              }`}
              style={{ fontFamily: B }}
            >
              {label}
            </button>
          ))}
        </div>
      </div>

      {/* Tab Content */}
      {activeTab === 'roster' && (
        <div className="bg-white border border-gray-100 p-3 md:p-5">
          <div className="flex flex-col gap-2 mb-5">
            <h3 className="text-[#011B3B] uppercase tracking-widest text-sm" style={{ fontFamily: B }}>
              Team Roster ({players.length}/12 Players)
            </h3>
            <button
              onClick={handleAddPlayer}
              disabled={players.length >= 12}
              className={`flex items-center justify-center gap-2 w-full py-2.5 text-sm font-semibold uppercase tracking-wide transition-colors ${
                players.length >= 12
                  ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                  : 'text-white'
              }`}
              style={players.length >= 12 ? { fontFamily: B } : { fontFamily: B, backgroundColor: BRAND.primary }}
              onMouseEnter={e => { if (players.length < 12) e.currentTarget.style.backgroundColor = BRAND.primaryHover; }}
              onMouseLeave={e => { if (players.length < 12) e.currentTarget.style.backgroundColor = BRAND.primary; }}
            >
              <UserPlus className="w-4 h-4" />
              <span>Add Player</span>
            </button>
          </div>

          {/* Starting Seven */}
          <div className="mb-6">
            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3" style={{ fontFamily: B }}>Starting Seven</p>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
              {players.filter(p => p.role !== 'Substitute').map((player) => (
                <PlayerCard key={player.id} player={player} />
              ))}
            </div>
            {players.filter(p => p.role !== 'Substitute').length === 0 && (
              <p className="text-sm text-gray-400 py-2" style={{ fontFamily: B }}>No starters added yet.</p>
            )}
          </div>

          {/* Substitutes */}
          <div>
            <p className="text-xs font-semibold text-gray-400 uppercase tracking-wide mb-3" style={{ fontFamily: B }}>
              Substitutes ({players.filter(p => p.role === 'Substitute').length}/5)
            </p>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-3">
              {players.filter(p => p.role === 'Substitute').map((player) => (
                <PlayerCard key={player.id} player={player} />
              ))}
            </div>
            {players.filter(p => p.role === 'Substitute').length === 0 && (
              <p className="text-sm text-gray-400 py-2" style={{ fontFamily: B }}>No substitutes added yet.</p>
            )}
          </div>
        </div>
      )}

      {activeTab === 'upcoming' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {upcomingGames.length === 0 && (
            <p className="text-sm text-gray-400 col-span-full py-8 text-center" style={{ fontFamily: B }}>No upcoming games scheduled.</p>
          )}
          {upcomingGames.map((game) => (
            <div key={game.id} className="bg-white border border-gray-100 p-4">
              {/* Championship */}
              <p className="text-xs text-gray-400 font-medium uppercase tracking-wide text-center mb-4" style={{ fontFamily: B }}>
                {game.championship}
              </p>

              {/* Teams */}
              <div className="flex items-center justify-between gap-2 mb-4">
                <div className="flex flex-col items-center flex-1">
                  <div className="w-12 h-12 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center shadow-md mb-1.5">
                    <span className="text-white font-bold text-xs" style={{ fontFamily: H }}>{game.team1.substring(0, 2).toUpperCase()}</span>
                  </div>
                  <p className="text-xs font-semibold text-[#011B3B] text-center line-clamp-1" style={{ fontFamily: B }}>{game.team1}</p>
                </div>

                <div className="bg-[#011B3B] text-white text-xs font-bold px-3 py-1.5" style={{ fontFamily: B }}>VS</div>

                <div className="flex flex-col items-center flex-1">
                  <div className="w-12 h-12 bg-gradient-to-br from-[#c81434] to-[#a8022b] rounded-full flex items-center justify-center shadow-md mb-1.5">
                    <span className="text-white font-bold text-xs" style={{ fontFamily: H }}>{game.team2.substring(0, 2).toUpperCase()}</span>
                  </div>
                  <p className="text-xs font-semibold text-[#011B3B] text-center line-clamp-1" style={{ fontFamily: B }}>{game.team2}</p>
                </div>
              </div>

              {/* Meta */}
              <div className="flex items-center justify-between text-xs text-gray-400 border-t border-gray-100 pt-3" style={{ fontFamily: B }}>
                <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" />{game.venue}</span>
                <span className="flex items-center gap-1"><Calendar className="w-3.5 h-3.5" />{game.date} · {game.time}</span>
              </div>
            </div>
          ))}
        </div>
      )}

      {activeTab === 'past' && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {pastGames.length === 0 && (
            <p className="text-sm text-gray-400 col-span-full py-8 text-center" style={{ fontFamily: B }}>No past games yet.</p>
          )}
          {pastGames.map((game) => {
            const { label: resultLabel, bg: resultBg } = RESULT_STYLES[game.result] ?? RESULT_STYLES.draw;
            return (
              <div key={game.id} className="bg-white border border-gray-100 p-4 relative">
                {/* Result badge */}
                <div className="flex items-center justify-between mb-4">
                  <p className="text-xs text-gray-400 font-medium uppercase tracking-wide" style={{ fontFamily: B }}>
                    {game.championship}
                  </p>
                  <span className={`${resultBg} text-white text-xs font-bold px-2.5 py-1`} style={{ fontFamily: B }}>{resultLabel}</span>
                </div>

                {/* Teams + Scores */}
                <div className="flex items-center justify-between gap-2 mb-4">
                  <div className="flex flex-col items-center flex-1">
                    <div className="w-12 h-12 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center shadow-md mb-1.5">
                      <span className="text-white font-bold text-xs" style={{ fontFamily: H }}>{game.team1.substring(0, 2).toUpperCase()}</span>
                    </div>
                    <p className="text-xs font-semibold text-[#011B3B] text-center line-clamp-1 mb-1" style={{ fontFamily: B }}>{game.team1}</p>
                    <p className="text-2xl text-[#011B3B]" style={{ fontFamily: H }}>{game.team1Score}</p>
                  </div>

                  <div className="bg-gray-100 text-gray-500 text-xs font-bold px-3 py-1.5" style={{ fontFamily: B }}>FT</div>

                  <div className="flex flex-col items-center flex-1">
                    <div className="w-12 h-12 bg-gradient-to-br from-[#c81434] to-[#a8022b] rounded-full flex items-center justify-center shadow-md mb-1.5">
                      <span className="text-white font-bold text-xs" style={{ fontFamily: H }}>{game.team2.substring(0, 2).toUpperCase()}</span>
                    </div>
                    <p className="text-xs font-semibold text-[#011B3B] text-center line-clamp-1 mb-1" style={{ fontFamily: B }}>{game.team2}</p>
                    <p className="text-2xl text-[#011B3B]" style={{ fontFamily: H }}>{game.team2Score}</p>
                  </div>
                </div>

                {/* Meta */}
                <div className="flex items-center justify-between text-xs text-gray-400 border-t border-gray-100 pt-3" style={{ fontFamily: B }}>
                  <span className="flex items-center gap-1"><MapPin className="w-3.5 h-3.5" />{game.venue}</span>
                  <span className="flex items-center gap-1"><Calendar className="w-3.5 h-3.5" />{game.date}</span>
                </div>
              </div>
            );
          })}
        </div>
      )}

      {/* Edit Team Modal */}
      {showEditTeamModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-sm shadow-xl max-w-lg w-full p-6 relative max-h-[90vh] overflow-y-auto">
            <button onClick={() => setShowEditTeamModal(false)} className="absolute top-4 right-4 text-gray-300 hover:text-gray-500 transition-colors">
              <X className="w-4 h-4" />
            </button>

            <h3 className="text-base font-semibold text-gray-900 mb-6 uppercase tracking-wide" style={{ fontFamily: B }}>Edit Team Information</h3>

            <div className="space-y-4">
              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Team Name</label>
                <input
                  type="text"
                  value={teamForm.name}
                  onChange={(e) => setTeamForm({...teamForm, name: e.target.value})}
                  className={INPUT} style={{ fontFamily: B }}
                />
              </div>

              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Team Icon (2 letters)</label>
                <input
                  type="text"
                  maxLength={2}
                  value={teamForm.icon}
                  onChange={(e) => setTeamForm({...teamForm, icon: e.target.value.toUpperCase()})}
                  className={INPUT} style={{ fontFamily: B }}
                />
              </div>

              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Coach Name</label>
                <input
                  type="text"
                  value={teamForm.coach}
                  onChange={(e) => setTeamForm({...teamForm, coach: e.target.value})}
                  className={INPUT} style={{ fontFamily: B }}
                />
              </div>

              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Category</label>
                <select
                  value={teamForm.category}
                  onChange={(e) => setTeamForm({...teamForm, category: e.target.value})}
                  className={`${INPUT} appearance-none cursor-pointer`} style={{ fontFamily: B }}
                >
                  <option value="Senior">Senior</option>
                  <option value="Junior">Junior</option>
                  <option value="Youth">Youth</option>
                </select>
              </div>
            </div>

            <div className="flex gap-2 mt-6">
              <button
                onClick={() => setShowEditTeamModal(false)}
                className="flex-1 py-2.5 text-sm font-semibold text-gray-600 border border-gray-200 hover:bg-gray-50 transition-colors rounded-sm"
                style={{ fontFamily: B }}
              >
                Cancel
              </button>
              <button
                onClick={handleSaveTeam}
                className="flex-1 py-2.5 text-sm font-semibold text-white transition-colors rounded-sm flex items-center justify-center gap-2"
                style={{ fontFamily: B, backgroundColor: '#111' }}
                onMouseEnter={e => e.currentTarget.style.backgroundColor = '#333'}
                onMouseLeave={e => e.currentTarget.style.backgroundColor = '#111'}
              >
                <Save className="w-4 h-4" /> Save Changes
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Add Player Modal */}
      {showAddPlayerModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-sm shadow-xl max-w-sm w-full p-6 relative">
            <button onClick={() => setShowAddPlayerModal(false)} className="absolute top-4 right-4 text-gray-300 hover:text-gray-500 transition-colors">
              <X className="w-4 h-4" />
            </button>

            <h3 className="text-base font-semibold text-gray-900 mb-6 uppercase tracking-wide" style={{ fontFamily: B }}>Add New Player</h3>

            <div className="space-y-4">
              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Player Name *</label>
                <input
                  type="text"
                  value={playerForm.name}
                  onChange={(e) => setPlayerForm({...playerForm, name: e.target.value})}
                  className={INPUT} style={{ fontFamily: B }}
                  placeholder="Enter player name"
                />
              </div>

              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Role</label>
                <select
                  value={playerForm.role}
                  onChange={(e) => setPlayerForm({...playerForm, role: e.target.value})}
                  className={`${INPUT} appearance-none cursor-pointer`} style={{ fontFamily: B }}
                >
                  {availableRoles.map(role => (
                    <option key={role} value={role}>{role}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Jersey Number</label>
                <input
                  type="number"
                  value={playerForm.number}
                  onChange={(e) => setPlayerForm({...playerForm, number: e.target.value})}
                  className={INPUT} style={{ fontFamily: B }}
                  min="1" max="14"
                />
              </div>

              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Age *</label>
                <input
                  type="number"
                  value={playerForm.age}
                  onChange={(e) => setPlayerForm({...playerForm, age: e.target.value})}
                  className={INPUT} style={{ fontFamily: B }}
                  min="16" max="50"
                />
              </div>
            </div>

            <div className="flex gap-2 mt-6">
              <button
                onClick={() => setShowAddPlayerModal(false)}
                className="flex-1 py-2.5 text-sm font-semibold text-gray-600 border border-gray-200 hover:bg-gray-50 transition-colors rounded-sm"
                style={{ fontFamily: B }}
              >
                Cancel
              </button>
              <button
                onClick={handleSaveNewPlayer}
                className="flex-1 py-2.5 text-sm font-semibold text-white transition-colors rounded-sm flex items-center justify-center gap-2"
                style={{ fontFamily: B, backgroundColor: BRAND.primary }}
                onMouseEnter={e => e.currentTarget.style.backgroundColor = BRAND.primaryHover}
                onMouseLeave={e => e.currentTarget.style.backgroundColor = BRAND.primary}
              >
                <Plus className="w-4 h-4" /> Add Player
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Edit Player Modal */}
      {showEditPlayerModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-sm shadow-xl max-w-sm w-full p-6 relative">
            <button onClick={() => setShowEditPlayerModal(false)} className="absolute top-4 right-4 text-gray-300 hover:text-gray-500 transition-colors">
              <X className="w-4 h-4" />
            </button>

            <h3 className="text-base font-semibold text-gray-900 mb-6 uppercase tracking-wide" style={{ fontFamily: B }}>Edit Player</h3>

            <div className="space-y-4">
              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Player Name</label>
                <input
                  type="text"
                  value={playerForm.name}
                  onChange={(e) => setPlayerForm({...playerForm, name: e.target.value})}
                  className={INPUT} style={{ fontFamily: B }}
                />
              </div>

              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Role</label>
                <select
                  value={playerForm.role}
                  onChange={(e) => setPlayerForm({...playerForm, role: e.target.value})}
                  className={`${INPUT} appearance-none cursor-pointer`} style={{ fontFamily: B }}
                >
                  {availableRoles.map(role => (
                    <option key={role} value={role}>{role}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Jersey Number</label>
                <input
                  type="number"
                  value={playerForm.number}
                  onChange={(e) => setPlayerForm({...playerForm, number: e.target.value})}
                  className={INPUT} style={{ fontFamily: B }}
                  min="1" max="99"
                />
              </div>

              <div>
                <label className={LABEL} style={{ fontFamily: B }}>Age</label>
                <input
                  type="number"
                  value={playerForm.age}
                  onChange={(e) => setPlayerForm({...playerForm, age: e.target.value})}
                  className={INPUT} style={{ fontFamily: B }}
                  min="16" max="50"
                />
              </div>
            </div>

            <div className="flex gap-2 mt-6">
              <button
                onClick={() => setShowEditPlayerModal(false)}
                className="flex-1 py-2.5 text-sm font-semibold text-gray-600 border border-gray-200 hover:bg-gray-50 transition-colors rounded-sm"
                style={{ fontFamily: B }}
              >
                Cancel
              </button>
              <button
                onClick={handleSavePlayer}
                className="flex-1 py-2.5 text-sm font-semibold text-white transition-colors rounded-sm flex items-center justify-center gap-2"
                style={{ fontFamily: B, backgroundColor: '#111' }}
                onMouseEnter={e => e.currentTarget.style.backgroundColor = '#333'}
                onMouseLeave={e => e.currentTarget.style.backgroundColor = '#111'}
              >
                <Save className="w-4 h-4" /> Save Changes
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Player Modal */}
      {showDeletePlayerModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-sm shadow-xl max-w-sm w-full p-6 relative">
            <button onClick={() => setShowDeletePlayerModal(false)} className="absolute top-4 right-4 text-gray-300 hover:text-gray-500 transition-colors">
              <X className="w-4 h-4" />
            </button>

            <div className="w-12 h-12 rounded-sm flex items-center justify-center mx-auto mb-4" style={{ backgroundColor: `${BRAND.primary}15` }}>
              <Trash2 className="w-5 h-5" style={{ color: BRAND.primary }} />
            </div>

            <h3 className="text-base font-semibold text-gray-900 text-center mb-1 uppercase tracking-wide" style={{ fontFamily: B }}>
              Remove Player
            </h3>

            <p className="text-sm text-gray-400 text-center mb-6" style={{ fontFamily: B }}>
              Are you sure you want to remove <span className="font-semibold text-gray-700">{selectedPlayer?.name}</span> from the team? This cannot be undone.
            </p>

            <div className="flex gap-2">
              <button
                onClick={() => setShowDeletePlayerModal(false)}
                className="flex-1 py-2.5 text-sm font-semibold text-gray-600 border border-gray-200 hover:bg-gray-50 transition-colors rounded-sm"
                style={{ fontFamily: B }}
              >
                Cancel
              </button>
              <button
                onClick={handleDeletePlayer}
                className="flex-1 py-2.5 text-sm font-semibold text-white transition-colors rounded-sm"
                style={{ fontFamily: B, backgroundColor: BRAND.primary }}
                onMouseEnter={e => e.currentTarget.style.backgroundColor = BRAND.primaryHover}
                onMouseLeave={e => e.currentTarget.style.backgroundColor = BRAND.primary}
              >
                Remove
              </button>
            </div>
          </div>
        </div>
      )}
    </section>
  );
};

export default TeamDetails;
