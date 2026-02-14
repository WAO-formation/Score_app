/* eslint-disable no-unused-vars */
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Calendar, 
  MapPin, 
  Trophy, 
  Users, 
  Award,
  AlertCircle,
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
  UserPlus
} from 'lucide-react';
import { useParams, useNavigate } from 'react-router-dom';

const TeamDetails = () => {
  const { teamId } = useParams();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState('roster');
  
  // Modals state
  const [showEditTeamModal, setShowEditTeamModal] = useState(false);
  const [showEditPlayerModal, setShowEditPlayerModal] = useState(false);
  const [showDeletePlayerModal, setShowDeletePlayerModal] = useState(false);
  const [showAddPlayerModal, setShowAddPlayerModal] = useState(false);
  const [selectedPlayer, setSelectedPlayer] = useState(null);

  // Sample team data - replace with your actual data source
  const [team, setTeam] = useState({
    id: 1,
    name: "Thunder Lions",
    coach: "John Smith",
    category: "Senior",
    gamesPlayed: 15,
    icon: "TL",
    description: "A powerhouse team known for aggressive gameplay and strong defensive strategies.",
    founded: "2020",
    stats: {
      wins: 10,
      losses: 3,
      draws: 2,
      penalties: 5,
      goalsScored: 45,
      goalsConceded: 23
    },
    players: [
      { id: 1, name: "Marcus Johnson", role: "King", number: 1, age: 28 },
      { id: 2, name: "David Chen", role: "Worker", number: 2, age: 25 },
      { id: 3, name: "Alex Rodriguez", role: "Protaque", number: 3, age: 26 },
      { id: 4, name: "James Wilson", role: "Antaque", number: 4, age: 27 },
      { id: 5, name: "Michael Brown", role: "Warrior", number: 5, age: 29 },
      { id: 6, name: "Chris Taylor", role: "Servitor", number: 6, age: 24 },
      { id: 7, name: "Ryan Davis", role: "Sacrificer", number: 7, age: 26 },
      { id: 8, name: "Kevin Lee", role: "Substitute", number: 8, age: 23 },
      { id: 9, name: "Tom Harris", role: "Substitute", number: 9, age: 25 },
      { id: 10, name: "Daniel White", role: "Substitute", number: 10, age: 24 },
      { id: 11, name: "Sam Clark", role: "Substitute", number: 11, age: 22 },
      { id: 12, name: "Jake Martin", role: "Substitute", number: 12, age: 23 }
    ],
    upcomingGames: [
      {
        id: 1,
        team1: "Thunder Lions",
        team2: "Phoenix Warriors",
        date: "Feb 15, 2026",
        time: "3:00 PM",
        venue: "Main Arena",
        championship: "Premier League"
      },
      {
        id: 2,
        team1: "Thunder Lions",
        team2: "Storm Eagles",
        date: "Feb 22, 2026",
        time: "5:00 PM",
        venue: "City Stadium",
        championship: "Cup Tournament"
      }
    ],
    pastGames: [
      {
        id: 1,
        team1: "Thunder Lions",
        team1Score: 3,
        team2: "Blazing Tigers",
        team2Score: 2,
        date: "Feb 1, 2026",
        venue: "Main Arena",
        championship: "Premier League",
        result: "win"
      },
      {
        id: 2,
        team1: "Ice Wolves",
        team1Score: 2,
        team2: "Thunder Lions",
        team2Score: 2,
        date: "Jan 25, 2026",
        venue: "North Stadium",
        championship: "Premier League",
        result: "draw"
      },
      {
        id: 3,
        team1: "Thunder Lions",
        team1Score: 1,
        team2: "Dragon Force",
        team2Score: 3,
        date: "Jan 18, 2026",
        venue: "Main Arena",
        championship: "Cup Tournament",
        result: "loss"
      }
    ]
  });

  // Form states
  const [teamForm, setTeamForm] = useState({
    name: team.name,
    coach: team.coach,
    category: team.category,
    description: team.description,
    founded: team.founded,
    icon: team.icon
  });

  const [playerForm, setPlayerForm] = useState({
    name: '',
    role: 'Substitute',
    number: '',
    age: ''
  });

  const availableRoles = ['King', 'Worker', 'Protaque', 'Antaque', 'Warrior', 'Servitor', 'Sacrificer', 'Substitute'];

  const getRoleIcon = (role) => {
    switch(role) {
      case 'King': return <Crown className="w-4 h-4" />;
      case 'Worker': return <Briefcase className="w-4 h-4" />;
      case 'Protaque': return <Shield className="w-4 h-4" />;
      case 'Antaque': return <Swords className="w-4 h-4" />;
      case 'Warrior': return <Zap className="w-4 h-4" />;
      case 'Servitor': return <Heart className="w-4 h-4" />;
      case 'Sacrificer': return <Award className="w-4 h-4" />;
      default: return <Users className="w-4 h-4" />;
    }
  };

  const getRoleColor = (role) => {
    const colors = {
      'King': 'from-purple-500 to-purple-700',
      'Worker': 'from-blue-500 to-blue-700',
      'Protaque': 'from-green-500 to-green-700',
      'Antaque': 'from-red-500 to-red-700',
      'Warrior': 'from-orange-500 to-orange-700',
      'Servitor': 'from-pink-500 to-pink-700',
      'Sacrificer': 'from-yellow-500 to-yellow-700',
      'Substitute': 'from-gray-400 to-gray-600'
    };
    return colors[role] || 'from-gray-400 to-gray-600';
  };

  // Team CRUD Functions
  const handleEditTeam = () => {
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

  const handleSaveTeam = () => {
    setTeam({
      ...team,
      ...teamForm
    });
    setShowEditTeamModal(false);
  };

  // Player CRUD Functions
  const handleAddPlayer = () => {
    setPlayerForm({
      name: '',
      role: 'Substitute',
      number: team.players.length + 1,
      age: ''
    });
    setShowAddPlayerModal(true);
  };

  const handleSaveNewPlayer = () => {
    if (!playerForm.name || !playerForm.age) {
      alert('Please fill in all required fields');
      return;
    }

    const newPlayer = {
      id: team.players.length + 1,
      ...playerForm,
      number: parseInt(playerForm.number),
      age: parseInt(playerForm.age)
    };

    setTeam({
      ...team,
      players: [...team.players, newPlayer]
    });
    setShowAddPlayerModal(false);
  };

  const handleEditPlayer = (player) => {
    setSelectedPlayer(player);
    setPlayerForm({
      name: player.name,
      role: player.role,
      number: player.number,
      age: player.age
    });
    setShowEditPlayerModal(true);
  };

  const handleSavePlayer = () => {
    setTeam({
      ...team,
      players: team.players.map(p => 
        p.id === selectedPlayer.id 
          ? { ...p, ...playerForm, number: parseInt(playerForm.number), age: parseInt(playerForm.age) }
          : p
      )
    });
    setShowEditPlayerModal(false);
  };

  const handleDeletePlayerConfirm = (player) => {
    setSelectedPlayer(player);
    setShowDeletePlayerModal(true);
  };

  const handleDeletePlayer = () => {
    setTeam({
      ...team,
      players: team.players.filter(p => p.id !== selectedPlayer.id)
    });
    setShowDeletePlayerModal(false);
  };

  return (
    <section className="scrollbar-hide p-2 pb-8">
      {/* Header Section */}
      <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-lg shadow-lg p-6 mb-6 relative overflow-hidden">
        {/* Background Ball */}
        <div className="absolute -right-20 -top-20 opacity-10">
          <img
            src="/assets/design/wao-ball.png"
            alt="ball gradient"
            className="w-60 h-60 object-contain"
          />
        </div>

        <div className="relative z-10">
          {/* Back Button */}
          <button
            onClick={() => navigate('/teams')}
            className="flex items-center gap-2 text-white/80 hover:text-white mb-4 transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
            <span className="text-sm">Back to Teams</span>
          </button>

          {/* Team Info */}
          <div className="flex flex-col md:flex-row items-start md:items-center justify-between gap-4">
            <div className="flex items-center gap-4">
              <div className="w-20 h-20 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center shadow-lg">
                <span className="text-white font-bold text-2xl">{team.icon}</span>
              </div>
              <div>
                <h1 className="text-3xl font-bold text-white mb-1">{team.name}</h1>
                <div className="flex items-center gap-4 text-white/80 text-sm">
                  <span>Coach: {team.coach}</span>
                  <span>•</span>
                  <span>{team.category}</span>
                </div>
              </div>
            </div>

            <button 
              onClick={handleEditTeam}
              className="flex items-center gap-2 px-6 py-3 bg-white text-[#011B3B] font-semibold rounded-lg hover:shadow-lg transition-all duration-200"
            >
              <Edit className="w-4 h-4" />
              <span>Edit Team</span>
            </button>
          </div>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white rounded-lg shadow-sm mb-6">
        <div className="flex border-b border-gray-200 overflow-x-auto scrollbar-hide">
          <button
            onClick={() => setActiveTab('roster')}
            className={`px-6 py-4 font-medium whitespace-nowrap transition-colors ${
              activeTab === 'roster'
                ? 'text-[#D30336] border-b-2 border-[#D30336]'
                : 'text-gray-600 hover:text-[#011B3B]'
            }`}
          >
            Team Roster
          </button>
          <button
            onClick={() => setActiveTab('upcoming')}
            className={`px-6 py-4 font-medium whitespace-nowrap transition-colors ${
              activeTab === 'upcoming'
                ? 'text-[#D30336] border-b-2 border-[#D30336]'
                : 'text-gray-600 hover:text-[#011B3B]'
            }`}
          >
            Upcoming Games
          </button>
          <button
            onClick={() => setActiveTab('past')}
            className={`px-6 py-4 font-medium whitespace-nowrap transition-colors ${
              activeTab === 'past'
                ? 'text-[#D30336] border-b-2 border-[#D30336]'
                : 'text-gray-600 hover:text-[#011B3B]'
            }`}
          >
            Past Games
          </button>
        </div>
      </div>

      {/* Tab Content */}
      {activeTab === 'roster' && (
        <div className="bg-white rounded-lg shadow-sm p-6">
          <div className="flex items-center justify-between mb-6">
            <h3 className="text-lg font-bold text-[#011B3B]">Team Roster ({team.players.length}/12 Players)</h3>
            <button 
              onClick={handleAddPlayer}
              disabled={team.players.length >= 12}
              className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-all ${
                team.players.length >= 12
                  ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                  : 'bg-gradient-to-br from-[#FFC600] to-[#FF6B35] text-white hover:shadow-lg'
              }`}
            >
              <UserPlus className="w-4 h-4" />
              <span>Add Player</span>
            </button>
          </div>
          
          {/* Starting Seven */}
          <div className="mb-6">
            <h4 className="text-md font-semibold text-gray-700 mb-3">Starting Seven</h4>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {team.players.filter(p => p.role !== 'Substitute').map((player) => (
                <div key={player.id} className="bg-gradient-to-br from-gray-50 to-white rounded-lg p-4 border border-gray-100 hover:shadow-md transition-shadow">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className={`w-12 h-12 bg-gradient-to-br ${getRoleColor(player.role)} rounded-full flex items-center justify-center text-white font-bold`}>
                        {player.number}
                      </div>
                      <div className="flex-1">
                        <p className="font-semibold text-[#011B3B]">{player.name}</p>
                        <div className="flex items-center gap-1 text-xs text-gray-600">
                          {getRoleIcon(player.role)}
                          <span>{player.role}</span>
                          <span>•</span>
                          <span>{player.age}y</span>
                        </div>
                      </div>
                    </div>
                    <div className="flex gap-1">
                      <button 
                        onClick={() => handleEditPlayer(player)}
                        className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                      >
                        <Edit className="w-4 h-4 text-[#011B3B]" />
                      </button>
                      <button 
                        onClick={() => handleDeletePlayerConfirm(player)}
                        className="p-2 hover:bg-red-50 rounded-lg transition-colors"
                      >
                        <Trash2 className="w-4 h-4 text-[#D30336]" />
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Substitutes */}
          <div>
            <h4 className="text-md font-semibold text-gray-700 mb-3">Substitutes ({team.players.filter(p => p.role === 'Substitute').length}/5)</h4>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {team.players.filter(p => p.role === 'Substitute').map((player) => (
                <div key={player.id} className="bg-gradient-to-br from-gray-50 to-white rounded-lg p-4 border border-gray-100 hover:shadow-md transition-shadow">
                  <div className="flex items-center justify-between">
                    <div className="flex items-center gap-3">
                      <div className={`w-12 h-12 bg-gradient-to-br ${getRoleColor(player.role)} rounded-full flex items-center justify-center text-white font-bold`}>
                        {player.number}
                      </div>
                      <div className="flex-1">
                        <p className="font-semibold text-[#011B3B]">{player.name}</p>
                        <div className="flex items-center gap-1 text-xs text-gray-600">
                          <Users className="w-3 h-3" />
                          <span>{player.role}</span>
                          <span>•</span>
                          <span>{player.age}y</span>
                        </div>
                      </div>
                    </div>
                    <div className="flex gap-1">
                      <button 
                        onClick={() => handleEditPlayer(player)}
                        className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                      >
                        <Edit className="w-4 h-4 text-[#011B3B]" />
                      </button>
                      <button 
                        onClick={() => handleDeletePlayerConfirm(player)}
                        className="p-2 hover:bg-red-50 rounded-lg transition-colors"
                      >
                        <Trash2 className="w-4 h-4 text-[#D30336]" />
                      </button>
                    </div>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {activeTab === 'upcoming' && (
        <div className="overflow-x-auto overflow-y-hidden scrollbar-hide">
          <div className="flex gap-4 pb-2" style={{ width: 'max-content' }}>
            {team.upcomingGames.map((game) => (
              <div
                key={game.id}
                className="w-[320px] bg-gradient-to-br from-gray-50 to-white rounded-xl p-4 overflow-hidden flex-shrink-0 shadow-sm border border-gray-100"
              >
                {/* Teams Section */}
                <div className="flex items-center justify-between mb-4 relative z-10">
                  {/* Team 1 */}
                  <div className="flex flex-col items-center flex-1">
                    <div className="w-14 h-14 bg-yellow-400 rounded-full flex items-center justify-center mb-2 relative shadow-md overflow-visible">
                      {/* Small ball image cutting into the team icon */}
                      <div className="absolute -left-15 -top-18 w-30 h-30 opacity-40 pointer-events-none">
                        <img
                          src="/assets/design/wao-ball.png"
                          alt="ball"
                          className="w-full h-full object-contain brightness-0 invert opacity-80"
                        />
                      </div>

                      <span className="text-white font-bold text-sm relative z-10">
                        {game.team1.substring(0, 2).toUpperCase()}
                      </span>
                    </div>
                    <p className="text-gray-500 text-[12px] font-semibold text-center line-clamp-1">
                      {game.team1}
                    </p>
                  </div>

                  {/* VS Badge */}
                  <div className="flex flex-col items-center mx-3">
                    <div className="bg-gradient-to-br from-[#3a3a3a] to-[#2a2a2a] px-4 py-2 rounded-lg shadow-md">
                      <span className="text-white font-bold text-sm">VS</span>
                    </div>
                    <div className="mt-2 text-center">
                      <p className="text-[#FFC600] text-xs font-semibold">{game.time}</p>
                    </div>
                  </div>

                  {/* Team 2 */}
                  <div className="flex flex-col items-center flex-1">
                    an className="text-white font-bold text-sm">
                        {game.team2.substring(0, 2).toUpperCase()}
                      </span>
                    </div><div className="w-14 h-14 bg-[#A50229] rounded-full flex items-center justify-center mb-2 shadow-md">
                      <sp
                    <p className="text-gray-500 text-[12px] font-semibold text-center line-clamp-1">
                      {game.team2}
                    </p>
                  </div>
                </div>

                {/* Championship */}
                <div className="text-center mb-3 relative z-10">
                  <p className="text-gray-400 text-xs uppercase tracking-wider font-medium">
                    {game.championship}
                  </p>
                </div>

                {/* Divider */}
                <div className="border-t border-gray-200 my-3"></div>

                {/* Info */}
                <div className="flex items-center justify-between text-xs relative z-10">
                  <div className="flex items-center gap-1 text-gray-400">
                    <MapPin className="w-3.5 h-3.5" />
                    <span>{game.venue}</span>
                  </div>
                  <div className="flex items-center gap-1 text-gray-400">
                    <Calendar className="w-3.5 h-3.5" />
                    <span>{game.date}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {activeTab === 'past' && (
        <div className="overflow-x-auto overflow-y-hidden scrollbar-hide">
          <div className="flex gap-4 pb-2" style={{ width: 'max-content' }}>
            {team.pastGames.map((game) => (
              <div
                key={game.id}
                className="w-[320px] bg-gradient-to-br from-gray-50 to-white rounded-xl p-4 relative overflow-hidden flex-shrink-0 shadow-sm border border-gray-100"
              >
                {/* Background Ball */}
                <div className="absolute -right-12 -bottom-12 opacity-5 pointer-events-none">
                  <img
                    src="/assets/design/wao-ball.png"
                    alt="ball gradient"
                    className="w-40 h-40 object-contain"
                  />
                </div>

                {/* Win/Loss/Draw Badge */}
                <div className="absolute top-4 right-4 z-10">
                  <div className={`px-3 py-1 rounded-full text-xs font-bold text-white ${
                    game.result === 'win' ? 'bg-green-500' :
                    game.result === 'loss' ? 'bg-red-500' :
                    'bg-yellow-500'
                  }`}>
                    {game.result === 'win' ? 'WIN' : game.result === 'loss' ? 'LOSS' : 'DRAW'}
                  </div>
                </div>

                {/* Teams Section with Scores */}
                <div className="flex items-center justify-between mb-4 relative z-10">
                  {/* Team 1 */}
                  <div className="flex flex-col items-center flex-1">
                    <div className="w-14 h-14 bg-yellow-400 rounded-full flex items-center justify-center mb-2 shadow-md">
                      <span className="text-white font-bold text-sm">
                        {game.team1.substring(0, 2).toUpperCase()}
                      </span>
                    </div>
                    <p className="text-gray-500 text-[12px] font-semibold text-center line-clamp-1 mb-1">
                      {game.team1}
                    </p>
                    <p className="text-2xl font-bold text-[#011B3B]">{game.team1Score}</p>
                  </div>

                  {/* VS Badge */}
                  <div className="flex flex-col items-center mx-3">
                    <div className="bg-gradient-to-br from-[#3a3a3a] to-[#2a2a2a] px-4 py-2 rounded-lg shadow-md">
                      <span className="text-white font-bold text-sm">FT</span>
                    </div>
                  </div>

                  {/* Team 2 */}
                  <div className="flex flex-col items-center flex-1">
                    <div className="w-14 h-14 bg-[#A50229] rounded-full flex items-center justify-center mb-2 shadow-md">
                      <span className="text-white font-bold text-sm">
                        {game.team2.substring(0, 2).toUpperCase()}
                      </span>
                    </div>
                    <p className="text-gray-500 text-[12px] font-semibold text-center line-clamp-1 mb-1">
                      {game.team2}
                    </p>
                    <p className="text-2xl font-bold text-[#011B3B]">{game.team2Score}</p>
                  </div>
                </div>

                {/* Championship */}
                <div className="text-center mb-3 relative z-10">
                  <p className="text-gray-400 text-xs uppercase tracking-wider font-medium">
                    {game.championship}
                  </p>
                </div>

                {/* Divider */}
                <div className="border-t border-gray-200 my-3"></div>

                {/* Info */}
                <div className="flex items-center justify-between text-xs relative z-10">
                  <div className="flex items-center gap-1 text-gray-400">
                    <MapPin className="w-3.5 h-3.5" />
                    <span>{game.venue}</span>
                  </div>
                  <div className="flex items-center gap-1 text-gray-400">
                    <Calendar className="w-3.5 h-3.5" />
                    <span>{game.date}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* Edit Team Modal */}
      {showEditTeamModal && (
        <div className="fixed inset-0 bg-black/50 bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-2xl w-full p-6 relative max-h-[90vh] overflow-y-auto">
            <button
              onClick={() => setShowEditTeamModal(false)}
              className="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition-colors"
            >
              <X className="w-5 h-5" />
            </button>

            <h3 className="text-xl font-bold text-[#011B3B] mb-6">Edit Team Information</h3>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Team Name</label>
                <input
                  type="text"
                  value={teamForm.name}
                  onChange={(e) => setTeamForm({...teamForm, name: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Team Icon (2 letters)</label>
                <input
                  type="text"
                  maxLength={2}
                  value={teamForm.icon}
                  onChange={(e) => setTeamForm({...teamForm, icon: e.target.value.toUpperCase()})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Coach Name</label>
                <input
                  type="text"
                  value={teamForm.coach}
                  onChange={(e) => setTeamForm({...teamForm, coach: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Category</label>
                <select
                  value={teamForm.category}
                  onChange={(e) => setTeamForm({...teamForm, category: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                >
                  <option value="Senior">Senior</option>
                  <option value="Junior">Junior</option>
                  <option value="Youth">Youth</option>
                </select>
              </div>
            </div>

            <div className="flex gap-3 mt-6">
              <button
                onClick={() => setShowEditTeamModal(false)}
                className="flex-1 px-4 py-3 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-all duration-200"
              >
                Cancel
              </button>
              <button
                onClick={handleSaveTeam}
                className="flex-1 px-4 py-3 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg transition-all duration-200 flex items-center justify-center gap-2"
              >
                <Save className="w-4 h-4" />
                Save Changes
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Add Player Modal */}
      {showAddPlayerModal && (
        <div className="fixed inset-0 bg-black/50 bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 relative">
            <button
              onClick={() => setShowAddPlayerModal(false)}
              className="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition-colors"
            >
              <X className="w-5 h-5" />
            </button>

            <h3 className="text-xl font-bold text-[#011B3B] mb-6">Add New Player</h3>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Player Name *</label>
                <input
                  type="text"
                  value={playerForm.name}
                  onChange={(e) => setPlayerForm({...playerForm, name: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                  placeholder="Enter player name"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Role</label>
                <select
                  value={playerForm.role}
                  onChange={(e) => setPlayerForm({...playerForm, role: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                >
                  {availableRoles.map(role => (
                    <option key={role} value={role}>{role}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Jersey Number</label>
                <input
                  type="number"
                  value={playerForm.number}
                  onChange={(e) => setPlayerForm({...playerForm, number: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                  min="1"
                  max="14"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Age *</label>
                <input
                  type="number"
                  value={playerForm.age}
                  onChange={(e) => setPlayerForm({...playerForm, age: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                  min="16"
                  max="50"
                />
              </div>
            </div>

            <div className="flex gap-3 mt-6">
              <button
                onClick={() => setShowAddPlayerModal(false)}
                className="flex-1 px-4 py-3 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-all duration-200"
              >
                Cancel
              </button>
              <button
                onClick={handleSaveNewPlayer}
                className="flex-1 px-4 py-3 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] text-white font-semibold rounded-lg hover:shadow-lg transition-all duration-200 flex items-center justify-center gap-2"
              >
                <Plus className="w-4 h-4" />
                Add Player
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Edit Player Modal */}
      {showEditPlayerModal && (
        <div className="fixed inset-0 bg-black/50 bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 relative">
            <button
              onClick={() => setShowEditPlayerModal(false)}
              className="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition-colors"
            >
              <X className="w-5 h-5" />
            </button>

            <h3 className="text-xl font-bold text-[#011B3B] mb-6">Edit Player</h3>

            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Player Name</label>
                <input
                  type="text"
                  value={playerForm.name}
                  onChange={(e) => setPlayerForm({...playerForm, name: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Role</label>
                <select
                  value={playerForm.role}
                  onChange={(e) => setPlayerForm({...playerForm, role: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                >
                  {availableRoles.map(role => (
                    <option key={role} value={role}>{role}</option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Jersey Number</label>
                <input
                  type="number"
                  value={playerForm.number}
                  onChange={(e) => setPlayerForm({...playerForm, number: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                  min="1"
                  max="99"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">Age</label>
                <input
                  type="number"
                  value={playerForm.age}
                  onChange={(e) => setPlayerForm({...playerForm, age: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                  min="16"
                  max="50"
                />
              </div>
            </div>

            <div className="flex gap-3 mt-6">
              <button
                onClick={() => setShowEditPlayerModal(false)}
                className="flex-1 px-4 py-3 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-all duration-200"
              >
                Cancel
              </button>
              <button
                onClick={handleSavePlayer}
                className="flex-1 px-4 py-3 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg transition-all duration-200 flex items-center justify-center gap-2"
              >
                <Save className="w-4 h-4" />
                Save Changes
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Player Modal */}
      {showDeletePlayerModal && (
        <div className="fixed inset-0 bg-black/50 bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 relative">
            <button
              onClick={() => setShowDeletePlayerModal(false)}
              className="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition-colors"
            >
              <X className="w-5 h-5" />
            </button>

            <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Trash2 className="w-8 h-8 text-[#D30336]" />
            </div>

            <h3 className="text-xl font-bold text-[#011B3B] text-center mb-2">
              Remove Player
            </h3>

            <p className="text-gray-600 text-center mb-6">
              Are you sure you want to remove <span className="font-semibold text-[#011B3B]">{selectedPlayer?.name}</span> from the team? This action cannot be undone.
            </p>

            <div className="flex gap-3">
              <button
                onClick={() => setShowDeletePlayerModal(false)}
                className="flex-1 px-4 py-3 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-all duration-200"
              >
                Cancel
              </button>
              <button
                onClick={handleDeletePlayer}
                className="flex-1 px-4 py-3 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg transition-all duration-200"
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