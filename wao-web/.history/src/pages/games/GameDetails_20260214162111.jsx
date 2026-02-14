// src/pages/Games/GameDetails.jsx
import React, { useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  ArrowLeft, 
  Calendar, 
  MapPin, 
  Clock, 
  Trophy,
  Play,
  Users,
  AlertCircle,
  TrendingUp,
  Activity,
  Copy,
  Check
} from 'lucide-react';
import { gamesData } from '../../config/constants';

const GameDetails = () => {
  const { gameId } = useParams();
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState('overview');
  const [copied, setCopied] = useState(false);

  // Find the game
  const game = gamesData.find(g => g.id === parseInt(gameId));

  if (!game) {
    return (
      <div className="p-8 text-center">
        <h2 className="text-2xl font-bold text-[#011B3B] mb-4">Game not found</h2>
        <button
          onClick={() => navigate('/games')}
          className="px-6 py-3 bg-[#011B3B] text-white rounded-lg hover:bg-[#022d5f]"
        >
          Back to Games
        </button>
      </div>
    );
  }

  // Sample team stats (in real app, fetch from backend)
  const homeTeamStats = {
    name: game.homeTeam,
    icon: game.homeTeam.substring(0, 2).toUpperCase(),
    form: ['W', 'W', 'D', 'L', 'W'],
    stats: {
      wins: 8,
      losses: 2,
      draws: 2,
      goalsFor: 96,
      goalsAgainst: 54,
      avgScore: 48
    },
    lastFiveGames: [
      { opponent: "Storm Eagles", result: "W", score: "45-42", date: "Feb 5" },
      { opponent: "Dragon Force", result: "W", score: "48-44", date: "Feb 1" },
      { opponent: "Blazing Tigers", result: "D", score: "43-43", date: "Jan 28" },
      { opponent: "Ice Wolves", result: "L", score: "40-47", date: "Jan 22" },
      { opponent: "Golden Hawks", result: "W", score: "51-38", date: "Jan 18" }
    ],
    scoringBreakdown: {
      kingdom: 28,
      workout: 29,
      goalSetting: 28,
      judges: 11
    }
  };

  const awayTeamStats = {
    name: game.awayTeam,
    icon: game.awayTeam.substring(0, 2).toUpperCase(),
    form: ['L', 'W', 'W', 'D', 'W'],
    stats: {
      wins: 7,
      losses: 3,
      draws: 2,
      goalsFor: 84,
      goalsAgainst: 62,
      avgScore: 42
    },
    lastFiveGames: [
      { opponent: "Royal Falcons", result: "L", score: "39-44", date: "Feb 6" },
      { opponent: "Wild Mustangs", result: "W", score: "46-41", date: "Feb 2" },
      { opponent: "Steel Panthers", result: "W", score: "43-38", date: "Jan 29" },
      { opponent: "Mighty Sharks", result: "D", score: "42-42", date: "Jan 24" },
      { opponent: "Blazing Comets", result: "W", score: "48-40", date: "Jan 20" }
    ],
    scoringBreakdown: {
      kingdom: 26,
      workout: 27,
      goalSetting: 30,
      judges: 10
    }
  };

  const handleCopyCode = () => {
    navigator.clipboard.writeText(game.accessCode);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleStartGame = () => {
    navigate(`/games/${game.id}/simulate`);
  };

  const getFormColor = (result) => {
    switch(result) {
      case 'W': return 'bg-green-500';
      case 'L': return 'bg-red-500';
      case 'D': return 'bg-yellow-500';
      default: return 'bg-gray-500';
    }
  };

  return (
    <section className="scrollbar-hide p-2 pb-8">
      {/* Header */}
      <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-lg shadow-lg p-6 mb-6 relative overflow-hidden">
        {/* Background Ball */}
        <div className="absolute -right-30 -top-30 opacity-10">
          <img
            src="/assets/design/wao-ball.png"
            alt="ball gradient"
            className="w-80 h-80 object-contain"
          />
        </div>

        <div className="relative z-10">
          {/* Back Button */}
          <button
            onClick={() => navigate('/games')}
            className="flex items-center gap-2 text-white/80 hover:text-white mb-4 transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
            <span className="text-sm">Back to Games</span>
          </button>

          {/* Game Status Badge */}
          <div className="absolute top-4 right-4">
            <div className={`px-4 py-2 rounded-full text-sm font-bold text-white ${
              game.status === 'live' ? 'bg-green-500 animate-pulse' :
              game.status === 'upcoming' ? 'bg-blue-500' :
              'bg-gray-500'
            }`}>
              {game.status === 'live' ? '🔴 LIVE' : game.status.toUpperCase()}
            </div>
          </div>

          {/* Teams Matchup */}
          <div className="flex flex-col md:flex-row items-center justify-center gap-6 mb-6">
            {/* Home Team */}
            <div className="flex flex-col items-center">
             <div className="w-24 h-24 bg-yellow-400 rounded-full flex items-center justify-center mb-2 relative shadow-md overflow-hidden">
            {/* Small ball image cutting into the team icon */}
            <div className="absolute -left-15 -top-8 w-30 h-30 opacity-40 pointer-events-none">
              <img
                src="/assets/design/wao-ball.png"
                alt="ball"
                className="w-full h-full object-contain brightness-0 invert opacity-80"
              />
            </div>

            <span className="text-white font-bold text-sm relative z-10">
              {game.homeTeam.substring(0, 2).toUpperCase()}
            </span>
          </div>

              <h3 className="text-white text-xl font-bold">{game.homeTeam}</h3>
              {game.status === 'completed' && (
                <p className="text-4xl font-bold text-white mt-2">{game.homeScore}</p>
              )}
            </div>

            {/* VS or Live Score */}
            <div className="flex flex-col items-center">
              {game.status === 'live' ? (
                <div className="text-center">
                  <div className="bg-white/20 px-6 py-3 rounded-lg backdrop-blur-sm mb-2">
                    <p className="text-white text-sm mb-1">{game.currentQuarter}</p>
                    <p className="text-white text-3xl font-bold">
                      {game.homeScore} - {game.awayScore}
                    </p>
                    <p className="text-white/80 text-sm mt-1">{game.timeRemaining}</p>
                  </div>
                </div>
              ) : (
                <div className="bg-white/20 px-8 py-4 rounded-lg backdrop-blur-sm">
                  <span className="text-white font-bold text-2xl">VS</span>
                </div>
              )}
            </div>

            {/* Away Team */}
            <div className="flex flex-col items-center">
              <div className="w-24 h-24 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center shadow-lg mb-3">
                <span className="text-white font-bold text-3xl">
                  {awayTeamStats.icon}
                </span>
              </div>
              <h3 className="text-white text-xl font-bold">{game.awayTeam}</h3>
              {game.status === 'completed' && (
                <p className="text-4xl font-bold text-white mt-2">{game.awayScore}</p>
              )}
            </div>
          </div>

          {/* Game Info */}
          <div className="flex flex-wrap items-center justify-center gap-6 text-white/80 text-sm">
            <div className="flex items-center gap-2">
              <Calendar className="w-4 h-4" />
              <span>{new Date(game.date).toLocaleDateString('en-US', { 
                weekday: 'long', 
                year: 'numeric', 
                month: 'long', 
                day: 'numeric' 
              })}</span>
            </div>
            <div className="flex items-center gap-2">
              <Clock className="w-4 h-4" />
              <span>{game.time}</span>
            </div>
            <div className="flex items-center gap-2">
              <MapPin className="w-4 h-4" />
              <span>{game.venue}</span>
            </div>
            {game.championship && (
              <div className="flex items-center gap-2">
                <Trophy className="w-4 h-4" />
                <span>{game.championship}</span>
              </div>
            )}
          </div>

          {/* Access Code & Action Button */}
          <div className="flex flex-col md:flex-row items-center justify-center gap-4 mt-6">
            {game.status === 'upcoming' && (
              <>
                <div className="bg-white/10 backdrop-blur-sm px-6 py-3 rounded-lg border border-white/20">
                  <div className="flex items-center gap-3">
                    <div>
                      <p className="text-white/70 text-xs mb-1">Access Code</p>
                      <p className="text-white font-bold font-mono text-lg">{game.accessCode}</p>
                    </div>
                    <button
                      onClick={handleCopyCode}
                      className="p-2 hover:bg-white/10 rounded-lg transition-colors"
                    >
                      {copied ? (
                        <Check className="w-5 h-5 text-green-400" />
                      ) : (
                        <Copy className="w-5 h-5 text-white" />
                      )}
                    </button>
                  </div>
                </div>

                <button
                  onClick={handleStartGame}
                  className="flex items-center gap-2 px-8 py-3 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] text-white font-bold rounded-lg hover:shadow-xl transition-all duration-200"
                >
                  <Play className="w-5 h-5" />
                  <span>Start Game</span>
                </button>
              </>
            )}

            {game.status === 'live' && (
              <button
                onClick={handleStartGame}
                className="flex items-center gap-2 px-8 py-3 bg-gradient-to-br from-green-500 to-green-600 text-white font-bold rounded-lg hover:shadow-xl transition-all duration-200 animate-pulse"
              >
                <Play className="w-5 h-5" />
                <span>Resume Game</span>
              </button>
            )}
          </div>
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
            onClick={() => setActiveTab('team-stats')}
            className={`px-6 py-4 font-medium whitespace-nowrap transition-colors ${
              activeTab === 'team-stats'
                ? 'text-[#D30336] border-b-2 border-[#D30336]'
                : 'text-gray-600 hover:text-[#011B3B]'
            }`}
          >
            Team Statistics
          </button>
          <button
            onClick={() => setActiveTab('past-games')}
            className={`px-6 py-4 font-medium whitespace-nowrap transition-colors ${
              activeTab === 'past-games'
                ? 'text-[#D30336] border-b-2 border-[#D30336]'
                : 'text-gray-600 hover:text-[#011B3B]'
            }`}
          >
            Past 5 Games
          </button>
          {(game.status === 'live' || game.status === 'completed') && (
            <button
              onClick={() => setActiveTab('game-details')}
              className={`px-6 py-4 font-medium whitespace-nowrap transition-colors ${
                activeTab === 'game-details'
                  ? 'text-[#D30336] border-b-2 border-[#D30336]'
                  : 'text-gray-600 hover:text-[#011B3B]'
              }`}
            >
              Game Details
            </button>
          )}
        </div>
      </div>

      {/* Tab Content */}
      {activeTab === 'overview' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Home Team Overview */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-12 h-12 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center">
                <span className="text-white font-bold">{homeTeamStats.icon}</span>
              </div>
              <div>
                <h3 className="text-lg font-bold text-[#011B3B]">{homeTeamStats.name}</h3>
                <p className="text-sm text-gray-600">Home Team</p>
              </div>
            </div>

            {/* Recent Form */}
            <div className="mb-6">
              <h4 className="text-sm font-semibold text-gray-700 mb-2">Recent Form</h4>
              <div className="flex gap-2">
                {homeTeamStats.form.map((result, index) => (
                  <div
                    key={index}
                    className={`w-10 h-10 rounded-full flex items-center justify-center font-bold text-white ${getFormColor(result)}`}
                  >
                    {result}
                  </div>
                ))}
              </div>
            </div>

            {/* Stats Grid */}
            <div className="grid grid-cols-2 gap-4">
              <div className="bg-green-50 rounded-lg p-3 text-center">
                <p className="text-2xl font-bold text-green-600">{homeTeamStats.stats.wins}</p>
                <p className="text-xs text-gray-600">Wins</p>
              </div>
              <div className="bg-red-50 rounded-lg p-3 text-center">
                <p className="text-2xl font-bold text-red-600">{homeTeamStats.stats.losses}</p>
                <p className="text-xs text-gray-600">Losses</p>
              </div>
              <div className="bg-yellow-50 rounded-lg p-3 text-center">
                <p className="text-2xl font-bold text-yellow-600">{homeTeamStats.stats.draws}</p>
                <p className="text-xs text-gray-600">Draws</p>
              </div>
              <div className="bg-blue-50 rounded-lg p-3 text-center">
                <p className="text-2xl font-bold text-blue-600">{homeTeamStats.stats.avgScore}</p>
                <p className="text-xs text-gray-600">Avg Score</p>
              </div>
            </div>

            {/* Goals */}
            <div className="grid grid-cols-2 gap-4 mt-4">
              <div className="text-center">
                <p className="text-xl font-bold text-[#011B3B]">{homeTeamStats.stats.goalsFor}</p>
                <p className="text-xs text-gray-600">Goals For</p>
              </div>
              <div className="text-center">
                <p className="text-xl font-bold text-[#011B3B]">{homeTeamStats.stats.goalsAgainst}</p>
                <p className="text-xs text-gray-600">Goals Against</p>
              </div>
            </div>
          </div>

          {/* Away Team Overview */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-12 h-12 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                <span className="text-white font-bold">{awayTeamStats.icon}</span>
              </div>
              <div>
                <h3 className="text-lg font-bold text-[#011B3B]">{awayTeamStats.name}</h3>
                <p className="text-sm text-gray-600">Away Team</p>
              </div>
            </div>

            {/* Recent Form */}
            <div className="mb-6">
              <h4 className="text-sm font-semibold text-gray-700 mb-2">Recent Form</h4>
              <div className="flex gap-2">
                {awayTeamStats.form.map((result, index) => (
                  <div
                    key={index}
                    className={`w-10 h-10 rounded-full flex items-center justify-center font-bold text-white ${getFormColor(result)}`}
                  >
                    {result}
                  </div>
                ))}
              </div>
            </div>

            {/* Stats Grid */}
            <div className="grid grid-cols-2 gap-4">
              <div className="bg-green-50 rounded-lg p-3 text-center">
                <p className="text-2xl font-bold text-green-600">{awayTeamStats.stats.wins}</p>
                <p className="text-xs text-gray-600">Wins</p>
              </div>
              <div className="bg-red-50 rounded-lg p-3 text-center">
                <p className="text-2xl font-bold text-red-600">{awayTeamStats.stats.losses}</p>
                <p className="text-xs text-gray-600">Losses</p>
              </div>
              <div className="bg-yellow-50 rounded-lg p-3 text-center">
                <p className="text-2xl font-bold text-yellow-600">{awayTeamStats.stats.draws}</p>
                <p className="text-xs text-gray-600">Draws</p>
              </div>
              <div className="bg-blue-50 rounded-lg p-3 text-center">
                <p className="text-2xl font-bold text-blue-600">{awayTeamStats.stats.avgScore}</p>
                <p className="text-xs text-gray-600">Avg Score</p>
              </div>
            </div>

            {/* Goals */}
            <div className="grid grid-cols-2 gap-4 mt-4">
              <div className="text-center">
                <p className="text-xl font-bold text-[#011B3B]">{awayTeamStats.stats.goalsFor}</p>
                <p className="text-xs text-gray-600">Goals For</p>
              </div>
              <div className="text-center">
                <p className="text-xl font-bold text-[#011B3B]">{awayTeamStats.stats.goalsAgainst}</p>
                <p className="text-xs text-gray-600">Goals Against</p>
              </div>
            </div>
          </div>
        </div>
      )}

      {activeTab === 'team-stats' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Home Team Scoring Breakdown */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-12 h-12 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center">
                <span className="text-white font-bold">{homeTeamStats.icon}</span>
              </div>
              <h3 className="text-lg font-bold text-[#011B3B]">{homeTeamStats.name}</h3>
            </div>

            <h4 className="text-sm font-semibold text-gray-700 mb-4">Scoring Breakdown (%)</h4>

            <div className="space-y-4">
              {/* Kingdom */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-sm font-medium text-gray-700">Kingdom</span>
                  <span className="text-sm font-bold text-[#011B3B]">{homeTeamStats.scoringBreakdown.kingdom}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-3">
                  <div 
                    className="bg-gradient-to-r from-purple-500 to-purple-600 h-3 rounded-full transition-all duration-500"
                    style={{ width: `${homeTeamStats.scoringBreakdown.kingdom}%` }}
                  ></div>
                </div>
              </div>

              {/* Workout */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-sm font-medium text-gray-700">Workout</span>
                  <span className="text-sm font-bold text-[#011B3B]">{homeTeamStats.scoringBreakdown.workout}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-3">
                  <div 
                    className="bg-gradient-to-r from-blue-500 to-blue-600 h-3 rounded-full transition-all duration-500"
                    style={{ width: `${homeTeamStats.scoringBreakdown.workout}%` }}
                  ></div>
                </div>
              </div>

              {/* Goal Setting */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-sm font-medium text-gray-700">Goal Setting</span>
                  <span className="text-sm font-bold text-[#011B3B]">{homeTeamStats.scoringBreakdown.goalSetting}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-3">
                  <div 
                    className="bg-gradient-to-r from-green-500 to-green-600 h-3 rounded-full transition-all duration-500"
                    style={{ width: `${homeTeamStats.scoringBreakdown.goalSetting}%` }}
                  ></div>
                </div>
              </div>

              {/* Judges */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-sm font-medium text-gray-700">Judges</span>
                  <span className="text-sm font-bold text-[#011B3B]">{homeTeamStats.scoringBreakdown.judges}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-3">
                  <div 
                    className="bg-gradient-to-r from-orange-500 to-orange-600 h-3 rounded-full transition-all duration-500"
                    style={{ width: `${homeTeamStats.scoringBreakdown.judges}%` }}
                  ></div>
                </div>
              </div>
            </div>
          </div>

          {/* Away Team Scoring Breakdown */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-12 h-12 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                <span className="text-white font-bold">{awayTeamStats.icon}</span>
              </div>
              <h3 className="text-lg font-bold text-[#011B3B]">{awayTeamStats.name}</h3>
            </div>

            <h4 className="text-sm font-semibold text-gray-700 mb-4">Scoring Breakdown (%)</h4>

            <div className="space-y-4">
              {/* Kingdom */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-sm font-medium text-gray-700">Kingdom</span>
                  <span className="text-sm font-bold text-[#011B3B]">{awayTeamStats.scoringBreakdown.kingdom}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-3">
                  <div 
                    className="bg-gradient-to-r from-purple-500 to-purple-600 h-3 rounded-full transition-all duration-500"
                    style={{ width: `${awayTeamStats.scoringBreakdown.kingdom}%` }}
                  ></div>
                </div>
              </div>

              {/* Workout */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-sm font-medium text-gray-700">Workout</span>
                  <span className="text-sm font-bold text-[#011B3B]">{awayTeamStats.scoringBreakdown.workout}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-3">
                  <div 
                    className="bg-gradient-to-r from-blue-500 to-blue-600 h-3 rounded-full transition-all duration-500"
                    style={{ width: `${awayTeamStats.scoringBreakdown.workout}%` }}
                  ></div>
                </div>
              </div>

              {/* Goal Setting */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-sm font-medium text-gray-700">Goal Setting</span>
                  <span className="text-sm font-bold text-[#011B3B]">{awayTeamStats.scoringBreakdown.goalSetting}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-3">
                  <div 
                    className="bg-gradient-to-r from-green-500 to-green-600 h-3 rounded-full transition-all duration-500"
                    style={{ width: `${awayTeamStats.scoringBreakdown.goalSetting}%` }}
                  ></div>
                </div>
              </div>

              {/* Judges */}
              <div>
                <div className="flex justify-between items-center mb-2">
                  <span className="text-sm font-medium text-gray-700">Judges</span>
                  <span className="text-sm font-bold text-[#011B3B]">{awayTeamStats.scoringBreakdown.judges}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-3">
                  <div 
                    className="bg-gradient-to-r from-orange-500 to-orange-600 h-3 rounded-full transition-all duration-500"
                    style={{ width: `${awayTeamStats.scoringBreakdown.judges}%` }}
                  ></div>
                </div>
              </div>
            </div>
          </div>
        </div>
      )}

      {activeTab === 'past-games' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          {/* Home Team Past 5 Games */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-12 h-12 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center">
                <span className="text-white font-bold">{homeTeamStats.icon}</span>
              </div>
              <h3 className="text-lg font-bold text-[#011B3B]">{homeTeamStats.name}</h3>
            </div>

            <h4 className="text-sm font-semibold text-gray-700 mb-4">Last 5 Games</h4>

            <div className="space-y-3">
              {homeTeamStats.lastFiveGames.map((game, index) => (
                <div key={index} className="bg-gray-50 rounded-lg p-4 flex items-center justify-between hover:bg-gray-100 transition-colors">
                  <div className="flex items-center gap-3">
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-white ${getFormColor(game.result)}`}>
                      {game.result}
                    </div>
                    <div>
                      <p className="font-semibold text-[#011B3B] text-sm">vs {game.opponent}</p>
                      <p className="text-xs text-gray-600">{game.date}</p>
                    </div>
                  </div>
                  <p className="font-bold text-[#011B3B]">{game.score}</p>
                </div>
              ))}
            </div>
          </div>

          {/* Away Team Past 5 Games */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center gap-3 mb-6">
              <div className="w-12 h-12 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                <span className="text-white font-bold">{awayTeamStats.icon}</span>
              </div>
              <h3 className="text-lg font-bold text-[#011B3B]">{awayTeamStats.name}</h3>
            </div>

            <h4 className="text-sm font-semibold text-gray-700 mb-4">Last 5 Games</h4>

            <div className="space-y-3">
              {awayTeamStats.lastFiveGames.map((game, index) => (
                <div key={index} className="bg-gray-50 rounded-lg p-4 flex items-center justify-between hover:bg-gray-100 transition-colors">
                  <div className="flex items-center gap-3">
                    <div className={`w-8 h-8 rounded-full flex items-center justify-center font-bold text-white ${getFormColor(game.result)}`}>
                      {game.result}
                    </div>
                    <div>
                      <p className="font-semibold text-[#011B3B] text-sm">vs {game.opponent}</p>
                      <p className="text-xs text-gray-600">{game.date}</p>
                    </div>
                  </div>
                  <p className="font-bold text-[#011B3B]">{game.score}</p>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {activeTab === 'game-details' && (game.status === 'live' || game.status === 'completed') && (
        <div className="space-y-6">
          {/* Quarter by Quarter Breakdown */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <h3 className="text-lg font-bold text-[#011B3B] mb-6">Quarter by Quarter</h3>
            
            <div className="overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="border-b border-gray-200">
                    <th className="text-left py-3 px-4 text-sm font-semibold text-gray-700">Team</th>
                    <th className="text-center py-3 px-4 text-sm font-semibold text-gray-700">Q1</th>
                    <th className="text-center py-3 px-4 text-sm font-semibold text-gray-700">Q2</th>
                    <th className="text-center py-3 px-4 text-sm font-semibold text-gray-700">Q3</th>
                    <th className="text-center py-3 px-4 text-sm font-semibold text-gray-700">Q4</th>
                    <th className="text-center py-3 px-4 text-sm font-semibold text-gray-700 bg-gray-50">Total</th>
                  </tr>
                </thead>
                <tbody>
                  <tr className="border-b border-gray-100">
                    <td className="py-4 px-4">
                      <div className="flex items-center gap-2">
                        <div className="w-8 h-8 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center">
                          <span className="text-white font-bold text-xs">{homeTeamStats.icon}</span>
                        </div>
                        <span className="font-semibold text-[#011B3B]">{game.homeTeam}</span>
                      </div>
                    </td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B]">{game.quarters.q1.home}</td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B]">{game.quarters.q2.home}</td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B]">{game.quarters.q3.home}</td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B]">{game.quarters.q4.home}</td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B] text-xl bg-gray-50">{game.homeScore}</td>
                  </tr>
                  <tr>
                    <td className="py-4 px-4">
                      <div className="flex items-center gap-2">
                        <div className="w-8 h-8 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                          <span className="text-white font-bold text-xs">{awayTeamStats.icon}</span>
                        </div>
                        <span className="font-semibold text-[#011B3B]">{game.awayTeam}</span>
                      </div>
                    </td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B]">{game.quarters.q1.away}</td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B]">{game.quarters.q2.away}</td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B]">{game.quarters.q3.away}</td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B]">{game.quarters.q4.away}</td>
                    <td className="text-center py-4 px-4 font-bold text-[#011B3B] text-xl bg-gray-50">{game.awayScore}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>

          {/* Scoring Breakdown */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <h3 className="text-lg font-bold text-[#011B3B] mb-6">Scoring Breakdown</h3>
            
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              {/* Kingdom */}
              <div className="bg-purple-50 rounded-lg p-4">
                <h4 className="text-sm font-semibold text-purple-900 mb-3">Kingdom (30%)</h4>
                <div className="space-y-2">
                  <div className="flex justify-between items-center">
                    <span className="text-xs text-gray-700">{game.homeTeam}</span>
                    <span className="font-bold text-purple-900">{game.scoring.kingdom.home}</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="text-xs text-gray-700">{game.awayTeam}</span>
                    <span className="font-bold text-purple-900">{game.scoring.kingdom.away}</span>
                  </div>
                </div>
              </div>

              {/* Workout */}
              <div className="bg-blue-50 rounded-lg p-4">
                <h4 className="text-sm font-semibold text-blue-900 mb-3">Workout (30%)</h4>
                <div className="space-y-2">
                  <div className="flex justify-between items-center">
                    <span className="text-xs text-gray-700">{game.homeTeam}</span>
                    <span className="font-bold text-blue-900">{game.scoring.workout.home}</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="text-xs text-gray-700">{game.awayTeam}</span>
                    <span className="font-bold text-blue-900">{game.scoring.workout.away}</span>
                  </div>
                </div>
              </div>

              {/* Goal Setting */}
              <div className="bg-green-50 rounded-lg p-4">
                <h4 className="text-sm font-semibold text-green-900 mb-3">Goal Setting (30%)</h4>
                <div className="space-y-2">
                  <div className="flex justify-between items-center">
                    <span className="text-xs text-gray-700">{game.homeTeam}</span>
                    <span className="font-bold text-green-900">{game.scoring.goalSetting.home}</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="text-xs text-gray-700">{game.awayTeam}</span>
                    <span className="font-bold text-green-900">{game.scoring.goalSetting.away}</span>
                  </div>
                </div>
              </div>

              {/* Judges */}
              <div className="bg-orange-50 rounded-lg p-4">
                <h4 className="text-sm font-semibold text-orange-900 mb-3">Judges (10%)</h4>
                <div className="space-y-2">
                  <div className="flex justify-between items-center">
                    <span className="text-xs text-gray-700">{game.homeTeam}</span>
                    <span className="font-bold text-orange-900">{game.scoring.judges.home}</span>
                  </div>
                  <div className="flex justify-between items-center">
                    <span className="text-xs text-gray-700">{game.awayTeam}</span>
                    <span className="font-bold text-orange-900">{game.scoring.judges.away}</span>
                  </div>
                </div>
              </div>
            </div>
          </div>

          {/* Fouls */}
          {(game.fouls.home.length > 0 || game.fouls.away.length > 0) && (
            <div className="bg-white rounded-lg shadow-sm p-6">
              <h3 className="text-lg font-bold text-[#011B3B] mb-6">Fouls</h3>
              
              <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
                {/* Home Team Fouls */}
                <div>
                  <h4 className="text-sm font-semibold text-gray-700 mb-3">{game.homeTeam}</h4>
                  {game.fouls.home.length > 0 ? (
                    <div className="space-y-2">
                      {game.fouls.home.map((foul, index) => (
                        <div key={index} className="bg-red-50 rounded-lg p-3 flex items-center justify-between">
                          <div>
                            <p className="font-semibold text-[#011B3B] text-sm">{foul.player}</p>
                            <p className="text-xs text-gray-600">{foul.quarter} - {foul.minute}'</p>
                          </div>
                          <AlertCircle className="w-5 h-5 text-red-600" />
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-sm text-gray-500 italic">No fouls recorded</p>
                  )}
                </div>

                {/* Away Team Fouls */}
                <div>
                  <h4 className="text-sm font-semibold text-gray-700 mb-3">{game.awayTeam}</h4>
                  {game.fouls.away.length > 0 ? (
                    <div className="space-y-2">
                      {game.fouls.away.map((foul, index) => (
                        <div key={index} className="bg-red-50 rounded-lg p-3 flex items-center justify-between">
                          <div>
                            <p className="font-semibold text-[#011B3B] text-sm">{foul.player}</p>
                            <p className="text-xs text-gray-600">{foul.quarter} - {foul.minute}'</p>
                          </div>
                          <AlertCircle className="w-5 h-5 text-red-600" />
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-sm text-gray-500 italic">No fouls recorded</p>
                  )}
                </div>
              </div>
            </div>
          )}
        </div>
      )}
    </section>
  );
};

export default GameDetails;