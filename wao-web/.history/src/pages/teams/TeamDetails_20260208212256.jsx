/* eslint-disable no-unused-vars */
import React, { useState } from 'react';
import { 
  ArrowLeft, 
  Calendar, 
  MapPin, 
  Trophy, 
  Users, 
  TrendingUp,
  Award,
  AlertCircle,
  Edit,
  Crown,
  Briefcase,
  Shield,
  Swords,
  Zap,
  Heart
} from 'lucide-react';
import { useParams, useNavigate } from 'react-router-dom';

const TeamDetails = () => {
  const { teamId } = useParams();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState('overview');

  // Sample team data - replace with your actual data source
  const team = {
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
  };

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
                  <span>•</span>
                  <span>Founded {team.founded}</span>
                </div>
              </div>
            </div>

            <button className="flex items-center gap-2 px-6 py-3 bg-white text-[#011B3B] font-semibold rounded-lg hover:shadow-lg transition-all duration-200">
              <Edit className="w-4 h-4" />
              <span>Edit Team</span>
            </button>
          </div>

          {/* Description */}
          <p className="text-white/70 mt-4 max-w-2xl">{team.description}</p>
        </div>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-2 md:grid-cols-6 gap-4 mb-6">
        <div className="bg-white rounded-lg shadow-sm p-4 text-center">
          <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center mx-auto mb-2">
            <Trophy className="w-5 h-5 text-green-600" />
          </div>
          <p className="text-2xl font-bold text-green-600">{team.stats.wins}</p>
          <p className="text-xs text-gray-600">Wins</p>
        </div>

        <div className="bg-white rounded-lg shadow-sm p-4 text-center">
          <div className="w-10 h-10 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-2">
            <AlertCircle className="w-5 h-5 text-red-600" />
          </div>
          <p className="text-2xl font-bold text-red-600">{team.stats.losses}</p>
          <p className="text-xs text-gray-600">Losses</p>
        </div>

        <div className="bg-white rounded-lg shadow-sm p-4 text-center">
          <div className="w-10 h-10 bg-yellow-100 rounded-full flex items-center justify-center mx-auto mb-2">
            <TrendingUp className="w-5 h-5 text-yellow-600" />
          </div>
          <p className="text-2xl font-bold text-yellow-600">{team.stats.draws}</p>
          <p className="text-xs text-gray-600">Draws</p>
        </div>

        <div className="bg-white rounded-lg shadow-sm p-4 text-center">
          <div className="w-10 h-10 bg-orange-100 rounded-full flex items-center justify-center mx-auto mb-2">
            <Award className="w-5 h-5 text-orange-600" />
          </div>
          <p className="text-2xl font-bold text-orange-600">{team.stats.penalties}</p>
          <p className="text-xs text-gray-600">Penalties</p>
        </div>

        <div className="bg-white rounded-lg shadow-sm p-4 text-center">
          <div className="w-10 h-10 bg-blue-100 rounded-full flex items-center justify-center mx-auto mb-2">
            <Trophy className="w-5 h-5 text-blue-600" />
          </div>
          <p className="text-2xl font-bold text-blue-600">{team.stats.goalsScored}</p>
          <p className="text-xs text-gray-600">Goals For</p>
        </div>

        <div className="bg-white rounded-lg shadow-sm p-4 text-center">
          <div className="w-10 h-10 bg-purple-100 rounded-full flex items-center justify-center mx-auto mb-2">
            <Shield className="w-5 h-5 text-purple-600" />
          </div>
          <p className="text-2xl font-bold text-purple-600">{team.stats.goalsConceded}</p>
          <p className="text-xs text-gray-600">Goals Against</p>
        </div>
      </div>

      {/* Tabs */}
      <div className="bg-white rounded-lg shadow-sm mb-6">
        <div className="flex border-b border-gray-200 overflow-x-auto scrollbar-hide">
          <button
            onClick={() => setActiveTab('overview')}
            className={`px-6 py-4 font-medium whitespace-nowrap transition-colors ${
              activeTab === 'overview'
                ? 'text-[#D30336] border-b-2 border-[#D30336]'
                : 'text-gray-600 hover:text-[#011B3B]'
            }`}
          >
            Overview
          </button>
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
      {activeTab === 'overview' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Performance Chart Placeholder */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <h3 className="text-lg font-bold text-[#011B3B] mb-4">Performance Overview</h3>
            <div className="h-64 flex items-center justify-center bg-gray-50 rounded-lg">
              <p className="text-gray-400">Performance chart coming soon</p>
            </div>
          </div>

          {/* Recent Form */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <h3 className="text-lg font-bold text-[#011B3B] mb-4">Recent Form</h3>
            <div className="flex gap-2 mb-4">
              {['W', 'W', 'D', 'L', 'W'].map((result, index) => (
                <div
                  key={index}
                  className={`w-10 h-10 rounded-full flex items-center justify-center font-bold text-white ${
                    result === 'W' ? 'bg-green-500' :
                    result === 'L' ? 'bg-red-500' :
                    'bg-yellow-500'
                  }`}
                >
                  {result}
                </div>
              ))}
            </div>
            <div className="space-y-3">
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Win Rate</span>
                <span className="font-bold text-[#011B3B]">
                  {((team.stats.wins / team.gamesPlayed) * 100).toFixed(0)}%
                </span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Goals Per Game</span>
                <span className="font-bold text-[#011B3B]">
                  {(team.stats.goalsScored / team.gamesPlayed).toFixed(1)}
                </span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-600">Clean Sheets</span>
                <span className="font-bold text-[#011B3B]">5</span>
              </div>
            </div>
          </div>
        </div>
      )}

      {activeTab === 'roster' && (
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h3 className="text-lg font-bold text-[#011B3B] mb-4">Team Roster (12 Players)</h3>
          
          {/* Starting Seven */}
          <div className="mb-6">
            <h4 className="text-md font-semibold text-gray-700 mb-3">Starting Seven</h4>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {team.players.filter(p => p.role !== 'Substitute').map((player) => (
                <div key={player.id} className="bg-gradient-to-br from-gray-50 to-white rounded-lg p-4 border border-gray-100 hover:shadow-md transition-shadow">
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
                </div>
              ))}
            </div>
          </div>

          {/* Substitutes */}
          <div>
            <h4 className="text-md font-semibold text-gray-700 mb-3">Substitutes (5)</h4>
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {team.players.filter(p => p.role === 'Substitute').map((player) => (
                <div key={player.id} className="bg-gradient-to-br from-gray-50 to-white rounded-lg p-4 border border-gray-100 hover:shadow-md transition-shadow">
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

                {/* Teams Section */}
                <div className="flex items-center justify-between mb-4 relative z-10">
                  {/* Team 1 */}
                  <div className="flex flex-col items-center flex-1">
                    <div className="w-14 h-14 bg-yellow-400 rounded-full flex items-center justify-center mb-2 shadow-md">
                      <span className="text-white font-bold text-sm">
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
                    <div className="w-14 h-14 bg-[#A50229] rounded-full flex items-center justify-center mb-2 shadow-md">
                      <span className="text-white font-bold text-sm">
                        {game.team2.substring(0, 2).toUpperCase()}
                      </span>
                    </div>
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
    </section>
  );
};

export default TeamDetails;