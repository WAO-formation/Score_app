/* eslint-disable no-unused-vars */
import React, { useState, useEffect, useRef } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  ArrowLeft, 
  Play, 
  Pause, 
  RotateCcw,
  Plus,
  Minus,
  Trophy,
  Clock,
  Users,
  AlertCircle,
  Save,
  Flag,
  Zap,
  Activity,
  Target,
  Award
} from 'lucide-react';
import { gamesData } from '../../../config/constants';

const GameSimulation = () => {
  const { gameId } = useParams();
  const navigate = useNavigate();
  const [game, setGame] = useState(null);
  const [isPlaying, setIsPlaying] = useState(false);
  const [currentQuarter, setCurrentQuarter] = useState(1);
  const [timeRemaining, setTimeRemaining] = useState(17 * 60); // 17 minutes in seconds
  const [showScoreModal, setShowScoreModal] = useState(false);
  const [showFoulModal, setShowFoulModal] = useState(false);
  const [showQuarterTransition, setShowQuarterTransition] = useState(false);
  const [showTimeAdjust, setShowTimeAdjust] = useState(false);
  const [activeScoreTab, setActiveScoreTab] = useState('kingdom');
  const [showStats, setShowStats] = useState(true);
  const timerRef = useRef(null);

  // Initialize game data
  useEffect(() => {
    const foundGame = gamesData.find(g => g.id === parseInt(gameId));
    if (foundGame) {
      setGame({
        ...foundGame,
        status: 'live',
        homeScore: foundGame.homeScore || 0,
        awayScore: foundGame.awayScore || 0,
        quarters: foundGame.quarters || {
          q1: { home: 0, away: 0 },
          q2: { home: 0, away: 0 },
          q3: { home: 0, away: 0 },
          q4: { home: 0, away: 0 }
        },
        scoring: foundGame.scoring || {
          kingdom: { home: 0, away: 0 },
          workout: { home: 0, away: 0 },
          goalSetting: { home: 0, away: 0 },
          judges: { home: 0, away: 0 }
        },
        fouls: foundGame.fouls || {
          home: [],
          away: []
        },
        events: foundGame.events || []
      });
    }
  }, [gameId]);

  // Timer logic
  useEffect(() => {
    if (isPlaying && timeRemaining > 0) {
      timerRef.current = setInterval(() => {
        setTimeRemaining(prev => {
          if (prev <= 1) {
            handleQuarterEnd();
            return 0;
          }
          return prev - 1;
        });
      }, 1000);
    } else {
      clearInterval(timerRef.current);
    }

    return () => clearInterval(timerRef.current);
  }, [isPlaying, timeRemaining]);

  const handleQuarterEnd = () => {
    setIsPlaying(false);
    if (currentQuarter < 4) {
      setShowQuarterTransition(true);
      setTimeout(() => {
        setShowQuarterTransition(false);
        setCurrentQuarter(prev => prev + 1);
        // Set time for next quarter
        const nextQuarterTime = currentQuarter < 2 ? 17 * 60 : 13 * 60;
        setTimeRemaining(nextQuarterTime);
      }, 3000);
    } else {
      // Game ended
      handleEndGame();
    }
  };

  const handleEndGame = () => {
    // Update game status to completed
    if (window.confirm('Game has ended. Save results?')) {
      setGame(prev => ({ ...prev, status: 'completed' }));
      navigate(`/games/${gameId}`);
    }
  };

  const formatTime = (seconds) => {
    const mins = Math.floor(seconds / 60);
    const secs = seconds % 60;
    return `${mins.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`;
  };

  const addScore = (team, category, points) => {
    setGame(prev => {
      const newGame = { ...prev };
      
      // Update category score
      newGame.scoring[category][team] += points;
      
      // Update total score
      newGame[`${team}Score`] = Object.values(newGame.scoring).reduce(
        (total, cat) => total + cat[team], 
        0
      );
      
      // Update quarter score
      const quarterKey = `q${currentQuarter}`;
      newGame.quarters[quarterKey][team] = Object.values(newGame.scoring).reduce(
        (total, cat) => total + cat[team], 
        0
      ) - Object.entries(newGame.quarters).reduce((sum, [key, val]) => {
        if (key !== quarterKey) return sum + val[team];
        return sum;
      }, 0);

      // Add event
      newGame.events.unshift({
        id: Date.now(),
        quarter: currentQuarter,
        time: formatTime(timeRemaining),
        team: team,
        type: 'score',
        category: category,
        points: points,
        description: `${points} point${points > 1 ? 's' : ''} - ${category}`
      });

      return newGame;
    });
  };

  const addFoul = (team, player) => {
    setGame(prev => {
      const newGame = { ...prev };
      newGame.fouls[team].push({
        player: player,
        quarter: `Q${currentQuarter}`,
        minute: formatTime(timeRemaining)
      });

      newGame.events.unshift({
        id: Date.now(),
        quarter: currentQuarter,
        time: formatTime(timeRemaining),
        team: team,
        type: 'foul',
        player: player,
        description: `Foul - ${player}`
      });

      return newGame;
    });
    setShowFoulModal(false);
  };

  const ScoreModal = () => (
    <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="sticky top-0 bg-gradient-to-br from-[#011B3B] to-[#022d5f] px-6 py-4">
          <div className="flex items-center justify-between">
            <h3 className="text-xl font-bold text-white">Add Score</h3>
            <button
              onClick={() => setShowScoreModal(false)}
              className="text-white/80 hover:text-white"
            >
              ✕
            </button>
          </div>
        </div>

        {/* Category Tabs */}
        <div className="flex border-b border-gray-200 overflow-x-auto">
          {[
            { id: 'kingdom', label: 'Kingdom (30%)', icon: '👑', color: 'purple' },
            { id: 'workout', label: 'Workout (30%)', icon: '💪', color: 'blue' },
            { id: 'goalSetting', label: 'Goal Setting (30%)', icon: '🎯', color: 'green' },
            { id: 'judges', label: 'Judges (10%)', icon: '⚖️', color: 'orange' }
          ].map(cat => (
            <button
              key={cat.id}
              onClick={() => setActiveScoreTab(cat.id)}
              className={`px-6 py-4 font-medium whitespace-nowrap transition-colors flex items-center gap-2 ${
                activeScoreTab === cat.id
                  ? 'text-[#D30336] border-b-2 border-[#D30336]'
                  : 'text-gray-600 hover:text-[#011B3B]'
              }`}
            >
              <span className="text-2xl">{cat.icon}</span>
              <span>{cat.label}</span>
            </button>
          ))}
        </div>

        {/* Score Content */}
        <div className="p-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            {/* Home Team */}
            <div className="bg-gradient-to-br from-yellow-50 to-orange-50 rounded-xl p-6 border-2 border-yellow-200">
              <div className="flex items-center gap-3 mb-6">
                
                <div className="w-16 h-16 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center shadow-lg">
                  <span className="text-white font-bold text-xl">
                    {game?.homeTeam.substring(0, 2).toUpperCase()}
                  </span>
                </div>
                <div>
                  <h4 className="text-lg font-bold text-[#011B3B]">{game?.homeTeam}</h4>
                  <p className="text-sm text-gray-600">Current: {game?.scoring[activeScoreTab]?.home || 0} pts</p>
                </div>
              </div>

              <div className="space-y-3">
                {[1, 2, 3, 5].map(points => (
                  <button
                    key={points}
                    onClick={() => {
                      addScore('home', activeScoreTab, points);
                      setShowScoreModal(false);
                    }}
                    className="w-full bg-white hover:bg-yellow-100 border-2 border-yellow-300 rounded-lg px-4 py-3 font-bold text-[#011B3B] transition-all hover:scale-105 hover:shadow-md"
                  >
                    +{points} Point{points > 1 ? 's' : ''}
                  </button>
                ))}
              </div>
            </div>

            {/* Away Team */}
            <div className="bg-gradient-to-br from-red-50 to-pink-50 rounded-xl p-6 border-2 border-red-200">
              <div className="flex items-center gap-3 mb-6">
                <div className="w-16 h-16 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center shadow-lg">
                  <span className="text-white font-bold text-xl">
                    {game?.awayTeam.substring(0, 2).toUpperCase()}
                  </span>
                </div>
                <div>
                  <h4 className="text-lg font-bold text-[#011B3B]">{game?.awayTeam}</h4>
                  <p className="text-sm text-gray-600">Current: {game?.scoring[activeScoreTab]?.away || 0} pts</p>
                </div>
              </div>

              <div className="space-y-3">
                {[1, 2, 3, 5].map(points => (
                  <button
                    key={points}
                    onClick={() => {
                      addScore('away', activeScoreTab, points);
                      setShowScoreModal(false);
                    }}
                    className="w-full bg-white hover:bg-red-100 border-2 border-red-300 rounded-lg px-4 py-3 font-bold text-[#011B3B] transition-all hover:scale-105 hover:shadow-md"
                  >
                    +{points} Point{points > 1 ? 's' : ''}
                  </button>
                ))}
              </div>
            </div>
          </div>

          {/* Category Info */}
          <div className="mt-6 bg-blue-50 border border-blue-200 rounded-lg p-4">
            <p className="text-sm text-blue-800">
              {activeScoreTab === 'kingdom' && '👑 Kingdom: Points scored by invading opponent\'s Kingdom and bouncing the ball (1 point per second-interval bounce)'}
              {activeScoreTab === 'workout' && '💪 Workout: Points accrued for time spent in your own Workout area while displaying skills'}
              {activeScoreTab === 'goalSetting' && '🎯 Goal Setting: Standard goals (1 point) and specialized scores from Oval-Crown/Goalposts'}
              {activeScoreTab === 'judges' && '⚖️ Judges: Additional points awarded by judges (10% of total score)'}
            </p>
          </div>
        </div>
      </div>
    </div>
  );

  const FoulModal = () => {
    const [selectedTeam, setSelectedTeam] = useState('home');
    const [playerName, setPlayerName] = useState('');

    return (
      <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
        <div className="bg-white rounded-2xl shadow-2xl max-w-lg w-full">
          <div className="bg-gradient-to-br from-red-500 to-red-600 px-6 py-4 rounded-t-2xl">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <AlertCircle className="w-6 h-6 text-white" />
                <h3 className="text-xl font-bold text-white">Record Foul</h3>
              </div>
              <button
                onClick={() => setShowFoulModal(false)}
                className="text-white/80 hover:text-white"
              >
                ✕
              </button>
            </div>
          </div>

          <div className="p-6 space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Team</label>
              <div className="grid grid-cols-2 gap-3">
                <button
                  onClick={() => setSelectedTeam('home')}
                  className={`px-4 py-3 rounded-lg font-medium transition-all ${
                    selectedTeam === 'home'
                      ? 'bg-yellow-100 border-2 border-yellow-400 text-[#011B3B]'
                      : 'bg-gray-100 border-2 border-gray-300 text-gray-600'
                  }`}
                >
                  {game?.homeTeam}
                </button>
                <button
                  onClick={() => setSelectedTeam('away')}
                  className={`px-4 py-3 rounded-lg font-medium transition-all ${
                    selectedTeam === 'away'
                      ? 'bg-red-100 border-2 border-red-400 text-[#011B3B]'
                      : 'bg-gray-100 border-2 border-gray-300 text-gray-600'
                  }`}
                >
                  {game?.awayTeam}
                </button>
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">Player Name</label>
              <input
                type="text"
                value={playerName}
                onChange={(e) => setPlayerName(e.target.value)}
                placeholder="Enter player name"
                className="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500"
              />
            </div>

            <button
              onClick={() => {
                if (playerName.trim()) {
                  addFoul(selectedTeam, playerName);
                  setPlayerName('');
                }
              }}
              className="w-full bg-gradient-to-br from-red-500 to-red-600 text-white font-bold py-3 rounded-lg hover:shadow-lg transition-all"
            >
              Record Foul
            </button>
          </div>
        </div>
      </div>
    );
  };

  const TimeAdjustModal = () => {
    const [minutes, setMinutes] = useState(Math.floor(timeRemaining / 60));
    const [seconds, setSeconds] = useState(timeRemaining % 60);

    const handleSave = () => {
      setTimeRemaining(minutes * 60 + seconds);
      setShowTimeAdjust(false);
    };

    return (
      <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
        <div className="bg-white rounded-2xl shadow-2xl max-w-md w-full">
          <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] px-6 py-4 rounded-t-2xl">
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Clock className="w-6 h-6 text-white" />
                <h3 className="text-xl font-bold text-white">Adjust Time</h3>
              </div>
              <button
                onClick={() => setShowTimeAdjust(false)}
                className="text-white/80 hover:text-white"
              >
                ✕
              </button>
            </div>
          </div>

          <div className="p-6 space-y-6">
            <div className="flex items-center justify-center gap-4">
              {/* Minutes */}
              <div className="text-center">
                <label className="block text-sm font-medium text-gray-700 mb-2">Minutes</label>
                <div className="flex flex-col gap-2">
                  <button
                    onClick={() => setMinutes(prev => Math.min(17, prev + 1))}
                    className="bg-gray-200 hover:bg-gray-300 p-2 rounded-lg"
                  >
                    <Plus className="w-5 h-5" />
                  </button>
                  <div className="text-5xl font-black text-[#011B3B] w-24 text-center">
                    {minutes.toString().padStart(2, '0')}
                  </div>
                  <button
                    onClick={() => setMinutes(prev => Math.max(0, prev - 1))}
                    className="bg-gray-200 hover:bg-gray-300 p-2 rounded-lg"
                  >
                    <Minus className="w-5 h-5" />
                  </button>
                </div>
              </div>

              <div className="text-5xl font-black text-[#011B3B] pt-8">:</div>

              {/* Seconds */}
              <div className="text-center">
                <label className="block text-sm font-medium text-gray-700 mb-2">Seconds</label>
                <div className="flex flex-col gap-2">
                  <button
                    onClick={() => setSeconds(prev => prev === 59 ? 0 : prev + 1)}
                    className="bg-gray-200 hover:bg-gray-300 p-2 rounded-lg"
                  >
                    <Plus className="w-5 h-5" />
                  </button>
                  <div className="text-5xl font-black text-[#011B3B] w-24 text-center">
                    {seconds.toString().padStart(2, '0')}
                  </div>
                  <button
                    onClick={() => setSeconds(prev => prev === 0 ? 59 : prev - 1)}
                    className="bg-gray-200 hover:bg-gray-300 p-2 rounded-lg"
                  >
                    <Minus className="w-5 h-5" />
                  </button>
                </div>
              </div>
            </div>

            <div className="flex gap-3">
              <button
                onClick={() => setShowTimeAdjust(false)}
                className="flex-1 px-4 py-3 border-2 border-gray-300 text-gray-700 font-bold rounded-lg hover:bg-gray-100 transition-all"
              >
                Cancel
              </button>
              <button
                onClick={handleSave}
                className="flex-1 px-4 py-3 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-bold rounded-lg hover:shadow-lg transition-all"
              >
                Save Time
              </button>
            </div>
          </div>
        </div>
      </div>
    );
  };

  if (!game) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="text-center">
          <div className="animate-spin rounded-full h-16 w-16 border-b-2 border-[#D30336] mx-auto mb-4"></div>
          <p className="text-gray-600">Loading game...</p>
        </div>
      </div>
    );
  }

  return (
    <section className="min-h-screen bg-gradient-to-br from-gray-50 to-gray-100 p-2 pb-8">
      {/* Quarter Transition */}
      {showQuarterTransition && (
        <div className="fixed inset-0 bg-gradient-to-br from-[#011B3B] to-[#022d5f] flex items-center justify-center z-50">
          <div className="text-center animate-pulse">
            <Trophy className="w-32 h-32 text-[#FFC600] mx-auto mb-6" />
            <h2 className="text-5xl font-black text-white mb-4">
              End of Q{currentQuarter}
            </h2>
            <p className="text-2xl text-white/80">
              Starting Q{currentQuarter + 1}...
            </p>
          </div>
        </div>
      )}

      {/* Header */}
      <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-2xl shadow-2xl p-6 mb-6 relative overflow-hidden">
        <div className="absolute -right-32 -top-32 opacity-10">
          <img
            src="/assets/design/wao-ball.png"
            alt="ball"
            className="w-96 h-96 object-contain"
          />
        </div>

        <div className="relative z-10">
          <button
            onClick={() => navigate(`/games/${gameId}`)}
            className="flex items-center gap-2 text-white/80 hover:text-white mb-4 transition-colors"
          >
            <ArrowLeft className="w-5 h-5" />
            <span className="text-sm">Back to Game Details</span>
          </button>

          {/* Live Badge */}
          <div className="absolute top-6 right-6">
            <div className="flex items-center gap-2 bg-red-500 px-4 py-2 rounded-full animate-pulse">
              <div className="w-3 h-3 bg-white rounded-full animate-ping"></div>
              <span className="text-white font-bold text-sm">LIVE</span>
            </div>
          </div>

          {/* Scoreboard */}
          <div className="grid grid-cols-3 gap-6 items-center mt-8">
            {/* Home Team */}
            <div className="text-center">
              <div className="w-32 h-32 mx-auto bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center shadow-2xl mb-4">
                <span className="text-white font-black text-5xl">
                  {game.homeTeam.substring(0, 2).toUpperCase()}
                </span>
              </div>
              <h3 className="text-white text-2xl font-bold mb-2">{game.homeTeam}</h3>
              <div className="text-7xl font-black text-white">{game.homeScore}</div>
            </div>

            {/* Center - Quarter & Time */}
            <div className="text-center">
              <div className="bg-white/10 backdrop-blur-sm rounded-2xl p-6 border border-white/20">
                <div className="text-[#FFC600] text-xl font-bold mb-2">QUARTER {currentQuarter}</div>
                <div 
                  onClick={() => setShowTimeAdjust(true)}
                  className="text-white text-6xl font-black mb-4 cursor-pointer hover:text-[#FFC600] transition-colors"
                  title="Click to adjust time"
                >
                  {formatTime(timeRemaining)}
                </div>
                
                <div className="flex gap-3 justify-center">
                  <button
                    onClick={() => setIsPlaying(!isPlaying)}
                    className="bg-white/20 hover:bg-white/30 p-4 rounded-xl transition-all"
                  >
                    {isPlaying ? (
                      <Pause className="w-6 h-6 text-white" />
                    ) : (
                      <Play className="w-6 h-6 text-white" />
                    )}
                  </button>
                  <button
                    onClick={() => setTimeRemaining(currentQuarter <= 2 ? 17 * 60 : 13 * 60)}
                    className="bg-white/20 hover:bg-white/30 p-4 rounded-xl transition-all"
                    title="Reset quarter time"
                  >
                    <RotateCcw className="w-6 h-6 text-white" />
                  </button>
                  <button
                    onClick={() => setShowTimeAdjust(true)}
                    className="bg-white/20 hover:bg-white/30 p-4 rounded-xl transition-all"
                    title="Adjust time manually"
                  >
                    <Clock className="w-6 h-6 text-white" />
                  </button>
                </div>
              </div>
            </div>

            {/* Away Team */}
            <div className="text-center">
              <div className="w-32 h-32 mx-auto bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center shadow-2xl mb-4">
                <span className="text-white font-black text-5xl">
                  {game.awayTeam.substring(0, 2).toUpperCase()}
                </span>
              </div>
              <h3 className="text-white text-2xl font-bold mb-2">{game.awayTeam}</h3>
              <div className="text-7xl font-black text-white">{game.awayScore}</div>
            </div>
          </div>
        </div>
      </div>

      {/* Action Buttons */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-6">
        <button
          onClick={() => setShowScoreModal(true)}
          className="bg-gradient-to-br from-green-500 to-green-600 text-white font-bold py-4 px-6 rounded-xl hover:shadow-xl transition-all flex items-center justify-center gap-2"
        >
          <Plus className="w-5 h-5" />
          Add Score
        </button>
        <button
          onClick={() => setShowFoulModal(true)}
          className="bg-gradient-to-br from-red-500 to-red-600 text-white font-bold py-4 px-6 rounded-xl hover:shadow-xl transition-all flex items-center justify-center gap-2"
        >
          <AlertCircle className="w-5 h-5" />
          Add Foul
        </button>
        <button
          onClick={() => setCurrentQuarter(prev => Math.min(4, prev + 1))}
          className="bg-gradient-to-br from-blue-500 to-blue-600 text-white font-bold py-4 px-6 rounded-xl hover:shadow-xl transition-all flex items-center justify-center gap-2"
        >
          <Flag className="w-5 h-5" />
          Next Quarter
        </button>
        <button
          onClick={handleEndGame}
          className="bg-gradient-to-br from-purple-500 to-purple-600 text-white font-bold py-4 px-6 rounded-xl hover:shadow-xl transition-all flex items-center justify-center gap-2"
        >
          <Trophy className="w-5 h-5" />
          End Game
        </button>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        {/* Quarter Breakdown */}
        <div className="bg-white rounded-2xl shadow-lg p-6">
          <h3 className="text-xl font-bold text-[#011B3B] mb-4 flex items-center gap-2">
            <Activity className="w-6 h-6" />
            Quarter Breakdown
          </h3>
          <div className="space-y-3">
            {[1, 2, 3, 4].map(q => (
              <div key={q} className={`p-4 rounded-xl transition-all ${
                currentQuarter === q ? 'bg-gradient-to-r from-yellow-50 to-yellow-100 border-2 border-yellow-400' : 'bg-gray-50'
              }`}>
                <div className="flex items-center justify-between">
                  <span className="font-bold text-[#011B3B]">Q{q}</span>
                  <div className="flex gap-8">
                    <span className="font-bold text-yellow-600">{game.quarters[`q${q}`]?.home || 0}</span>
                    <span className="font-bold text-red-600">{game.quarters[`q${q}`]?.away || 0}</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Scoring Categories */}
        <div className="bg-white rounded-2xl shadow-lg p-6">
          <h3 className="text-xl font-bold text-[#011B3B] mb-4 flex items-center gap-2">
            <Target className="w-6 h-6" />
            Scoring Breakdown
          </h3>
          <div className="space-y-4">
            {[
              { key: 'kingdom', label: 'Kingdom', icon: '👑', color: 'purple', percentage: 30 },
              { key: 'workout', label: 'Workout', icon: '💪', color: 'blue', percentage: 30 },
              { key: 'goalSetting', label: 'Goal Setting', icon: '🎯', color: 'green', percentage: 30 },
              { key: 'judges', label: 'Judges', icon: '⚖️', color: 'orange', percentage: 10 }
            ].map(cat => (
              <div key={cat.key} className={`bg-${cat.color}-50 p-4 rounded-xl`}>
                <div className="flex items-center justify-between mb-2">
                  <div className="flex items-center gap-2">
                    <span className="text-2xl">{cat.icon}</span>
                    <span className="font-bold text-[#011B3B]">{cat.label}</span>
                    <span className="text-xs text-gray-500">({cat.percentage}%)</span>
                  </div>
                </div>
                <div className="flex justify-between items-center">
                  <div className="flex items-center gap-2">
                    <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
                    <span className="font-bold text-lg">{game.scoring[cat.key]?.home || 0}</span>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className="font-bold text-lg">{game.scoring[cat.key]?.away || 0}</span>
                    <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>

      {/* Live Events Feed */}
      <div className="bg-white rounded-2xl shadow-lg p-6">
        <h3 className="text-xl font-bold text-[#011B3B] mb-4 flex items-center gap-2">
          <Zap className="w-6 h-6" />
          Live Events
        </h3>
        <div className="space-y-2 max-h-96 overflow-y-auto">
          {game.events.length > 0 ? (
            game.events.map((event) => (
              <div key={event.id} className={`p-4 rounded-xl border-l-4 ${
                event.type === 'score' ? 'bg-green-50 border-green-500' : 'bg-red-50 border-red-500'
              }`}>
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="bg-[#011B3B] text-white text-xs font-bold px-2 py-1 rounded">
                      Q{event.quarter}
                    </div>
                    <span className="text-sm font-mono text-gray-600">{event.time}</span>
                    <span className="font-semibold text-[#011B3B]">
                      {event.team === 'home' ? game.homeTeam : game.awayTeam}
                    </span>
                  </div>
                  <span className="text-sm text-gray-700">{event.description}</span>
                </div>
              </div>
            ))
          ) : (
            <p className="text-center text-gray-500 py-8">No events yet. Start the game!</p>
          )}
        </div>
      </div>

      {/* Modals */}
      {showScoreModal && <ScoreModal />}
      {showFoulModal && <FoulModal />}
      {showTimeAdjust && <TimeAdjustModal />}
    </section>
  );
};

export default GameSimulation;