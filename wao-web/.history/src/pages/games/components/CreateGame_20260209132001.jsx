/* eslint-disable react-hooks/purity */
// src/components/CreateGame.jsx
import React, { useState } from 'react';
import { X, Trophy, Save, Calendar, MapPin, Clock } from 'lucide-react';
import { teamsData } from '../../../config/constants';

const CreateGame = ({ isOpen, onClose, onCreateGame }) => {
  const [gameForm, setGameForm] = useState({
    homeTeam: '',
    awayTeam: '',
    date: '',
    time: '',
    venue: '',
    championship: ''
  });

  const generateAccessCode = () => {
    return Math.random().toString(36).substring(2, 8).toUpperCase();
  };

  const handleCreateGame = () => {
    if (!gameForm.homeTeam || !gameForm.awayTeam || !gameForm.date || !gameForm.time || !gameForm.venue) {
      alert('Please fill in all required fields');
      return;
    }

    if (gameForm.homeTeam === gameForm.awayTeam) {
      alert('Home team and away team cannot be the same');
      return;
    }

    const newGame = {
      id: Date.now(),
      ...gameForm,
      status: 'upcoming',
      accessCode: generateAccessCode(),
      currentQuarter: 'Q1',
      timeRemaining: '17:00',
      homeScore: 0,
      awayScore: 0,
      quarters: {
        q1: { home: 0, away: 0 },
        q2: { home: 0, away: 0 },
        q3: { home: 0, away: 0 },
        q4: { home: 0, away: 0 }
      },
      scoring: {
        kingdom: { home: 0, away: 0 },
        workout: { home: 0, away: 0 },
        goalSetting: { home: 0, away: 0 },
        judges: { home: 0, away: 0 }
      },
      fouls: {
        home: [],
        away: []
      },
      events: []
    };

    onCreateGame(newGame);
    handleClose();
  };

  const handleClose = () => {
    setGameForm({
      homeTeam: '',
      awayTeam: '',
      date: '',
      time: '',
      venue: '',
      championship: ''
    });
    onClose();
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/ bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="sticky top-0 bg-gradient-to-br from-[#D30336] to-[#a8022b] px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center">
              <Trophy className="w-5 h-5 text-white" />
            </div>
            <div>
              <h2 className="text-xl font-bold text-white">Create New Game</h2>
              <p className="text-white/70 text-sm">Schedule a new WAO! match</p>
            </div>
          </div>
          <button
            onClick={handleClose}
            className="text-white/80 hover:text-white transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Content */}
        <div className="p-6 space-y-6">
          {/* Teams Selection */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Home Team <span className="text-red-500">*</span>
              </label>
              <select
                value={gameForm.homeTeam}
                onChange={(e) => setGameForm({...gameForm, homeTeam: e.target.value})}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
              >
                <option value="">Select home team</option>
                {teamsData.map(team => (
                  <option key={team.id} value={team.name}>{team.name}</option>
                ))}
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                Away Team <span className="text-red-500">*</span>
              </label>
              <select
                value={gameForm.awayTeam}
                onChange={(e) => setGameForm({...gameForm, awayTeam: e.target.value})}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
              >
                <option value="">Select away team</option>
                {teamsData.filter(team => team.name !== gameForm.homeTeam).map(team => (
                  <option key={team.id} value={team.name}>{team.name}</option>
                ))}
              </select>
            </div>
          </div>

          {/* Match Preview */}
          {gameForm.homeTeam && gameForm.awayTeam && (
            <div className="bg-gradient-to-br from-gray-50 to-white border border-gray-200 rounded-lg p-4">
              <p className="text-sm font-medium text-gray-700 mb-3">Match Preview</p>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-10 h-10 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center">
                    <span className="text-white font-bold text-xs">
                      {gameForm.homeTeam.substring(0, 2).toUpperCase()}
                    </span>
                  </div>
                  <span className="font-semibold text-[#011B3B]">{gameForm.homeTeam}</span>
                </div>
                <span className="text-gray-400 font-bold">VS</span>
                <div className="flex items-center gap-2">
                  <span className="font-semibold text-[#011B3B]">{gameForm.awayTeam}</span>
                  <div className="w-10 h-10 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                    <span className="text-white font-bold text-xs">
                      {gameForm.awayTeam.substring(0, 2).toUpperCase()}
                    </span>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* Date and Time */}
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                <Calendar className="w-4 h-4 inline mr-1" />
                Date <span className="text-red-500">*</span>
              </label>
              <input
                type="date"
                value={gameForm.date}
                onChange={(e) => setGameForm({...gameForm, date: e.target.value})}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">
                <Clock className="w-4 h-4 inline mr-1" />
                Time <span className="text-red-500">*</span>
              </label>
              <input
                type="time"
                value={gameForm.time}
                onChange={(e) => setGameForm({...gameForm, time: e.target.value})}
                className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
              />
            </div>
          </div>

          {/* Venue */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              <MapPin className="w-4 h-4 inline mr-1" />
              Venue <span className="text-red-500">*</span>
            </label>
            <input
              type="text"
              value={gameForm.venue}
              onChange={(e) => setGameForm({...gameForm, venue: e.target.value})}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
              placeholder="e.g., Main Arena, City Stadium"
            />
          </div>

          {/* Championship */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Championship/Tournament
            </label>
            <input
              type="text"
              value={gameForm.championship}
              onChange={(e) => setGameForm({...gameForm, championship: e.target.value})}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
              placeholder="e.g., Premier League, Cup Tournament"
            />
          </div>

          {/* Info Box */}
          <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
            <p className="text-sm text-blue-800">
              <strong>Note:</strong> An access code will be automatically generated for this game. 
              You'll need this code to start the game simulation.
            </p>
          </div>
        </div>

        {/* Footer */}
        <div className="sticky bottom-0 bg-gray-50 px-6 py-4 flex items-center justify-end gap-3 border-t border-gray-200">
          <button
            onClick={handleClose}
            className="px-6 py-2 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-100 transition-all duration-200"
          >
            Cancel
          </button>
          <button
            onClick={handleCreateGame}
            className="flex items-center gap-2 px-6 py-2 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg transition-all duration-200"
          >
            <Save className="w-4 h-4" />
            Create Game
          </button>
        </div>
      </div>
    </div>
  );
};

export default CreateGame;