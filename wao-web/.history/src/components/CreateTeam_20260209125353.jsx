/* eslint-disable react-hooks/purity */
import React, { useState } from 'react';
import { X, Users, Save, Plus, Trash2, Crown, Briefcase, Shield, Swords, Zap, Heart, Award } from 'lucide-react';

const CreateTeam = ({ isOpen, onClose, onCreateTeam }) => {
  const [step, setStep] = useState(1); // 1: Team Info, 2: Add Players

  const [teamForm, setTeamForm] = useState({
    name: '',
    coach: '',
    category: 'Senior',
    description: '',
    founded: new Date().getFullYear().toString(),
    icon: ''
  });

  const [players, setPlayers] = useState([]);
  const [playerForm, setPlayerForm] = useState({
    name: '',
    role: 'King',
    number: 1,
    age: ''
  });

  const availableRoles = [
    'King',
    'Worker',
    'Protaque',
    'Antaque',
    'Warrior',
    'Servitor',
    'Sacrificer',
    'Substitute'
  ];

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

  const handleAddPlayer = () => {
    if (!playerForm.name || !playerForm.age) {
      alert('Please fill in player name and age');
      return;
    }

    if (players.length >= 12) {
      alert('Maximum 12 players allowed per team');
      return;
    }

    const newPlayer = {
      id: players.length + 1,
      ...playerForm,
      number: parseInt(playerForm.number),
      age: parseInt(playerForm.age)
    };

    setPlayers([...players, newPlayer]);
    
    // Reset form with next number
    setPlayerForm({
      name: '',
      role: 'King',
      number: players.length + 2,
      age: ''
    });
  };

  const handleRemovePlayer = (playerId) => {
    setPlayers(players.filter(p => p.id !== playerId));
  };

  const handleNextStep = () => {
    if (!teamForm.name || !teamForm.coach || !teamForm.icon) {
      alert('Please fill in all required team information');
      return;
    }

    if (teamForm.icon.length !== 2) {
      alert('Team icon must be exactly 2 letters');
      return;
    }

    setStep(2);
  };

  const handleCreateTeam = () => {
    if (players.length === 0) {
      alert('Please add at least one player to the team');
      return;
    }

    const newTeam = {
      id: Date.now(),
      ...teamForm,
      icon: teamForm.icon.toUpperCase(),
      gamesPlayed: 0,
      players: players,
      stats: {
        wins: 0,
        losses: 0,
        draws: 0,
        penalties: 0,
        goalsScored: 0,
        goalsConceded: 0
      },
      upcomingGames: [],
      pastGames: []
    };

    onCreateTeam(newTeam);
    handleClose();
  };

  const handleClose = () => {
    // Reset all forms
    setTeamForm({
      name: '',
      coach: '',
      category: 'Senior',
      description: '',
      founded: new Date().getFullYear().toString(),
      icon: ''
    });
    setPlayers([]);
    setPlayerForm({
      name: '',
      role: 'King',
      number: 1,
      age: ''
    });
    setStep(1);
    onClose();
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black/ bg-opacity-50 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-lg shadow-xl max-w-4xl w-full max-h-[90vh] overflow-y-auto">
        {/* Header */}
        <div className="sticky top-0 bg-gradient-to-br from-[#011B3B] to-[#022d5f] px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 bg-white/20 rounded-full flex items-center justify-center">
              <Users className="w-5 h-5 text-white" />
            </div>
            <div>
              <h2 className="text-xl font-bold text-white">Create New Team</h2>
              <p className="text-white/70 text-sm">
                Step {step} of 2: {step === 1 ? 'Team Information' : 'Add Players'}
              </p>
            </div>
          </div>
          <button
            onClick={handleClose}
            className="text-white/80 hover:text-white transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Progress Bar */}
        <div className="px-6 pt-4">
          <div className="flex items-center gap-2">
            <div className={`flex-1 h-2 rounded-full ${step >= 1 ? 'bg-[#D30336]' : 'bg-gray-200'}`} />
            <div className={`flex-1 h-2 rounded-full ${step >= 2 ? 'bg-[#D30336]' : 'bg-gray-200'}`} />
          </div>
        </div>

        {/* Content */}
        <div className="p-6">
          {step === 1 ? (
            // Step 1: Team Information
            <div className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Team Name <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    value={teamForm.name}
                    onChange={(e) => setTeamForm({...teamForm, name: e.target.value})}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                    placeholder="e.g., Thunder Lions"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Team Icon (2 letters) <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    maxLength={2}
                    value={teamForm.icon}
                    onChange={(e) => setTeamForm({...teamForm, icon: e.target.value.toUpperCase()})}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                    placeholder="e.g., TL"
                  />
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Coach Name <span className="text-red-500">*</span>
                  </label>
                  <input
                    type="text"
                    value={teamForm.coach}
                    onChange={(e) => setTeamForm({...teamForm, coach: e.target.value})}
                    className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                    placeholder="e.g., John Smith"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Category
                  </label>
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

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Founded Year
                </label>
                <input
                  type="text"
                  value={teamForm.founded}
                  onChange={(e) => setTeamForm({...teamForm, founded: e.target.value})}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                  placeholder="e.g., 2020"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Team Description
                </label>
                <textarea
                  value={teamForm.description}
                  onChange={(e) => setTeamForm({...teamForm, description: e.target.value})}
                  rows={3}
                  className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                  placeholder="Describe your team's style and strengths..."
                />
              </div>

              {/* Team Preview */}
              {teamForm.name && teamForm.icon && (
                <div className="bg-gradient-to-br from-gray-50 to-white border border-gray-200 rounded-lg p-4">
                  <p className="text-sm font-medium text-gray-700 mb-3">Team Preview</p>
                  <div className="flex items-center gap-3">
                    <div className="w-16 h-16 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                      <span className="text-white font-bold text-xl">{teamForm.icon}</span>
                    </div>
                    <div>
                      <p className="font-bold text-[#011B3B] text-lg">{teamForm.name}</p>
                      <p className="text-sm text-gray-600">Coach: {teamForm.coach || 'Not set'}</p>
                      <p className="text-xs text-gray-500">{teamForm.category} • Founded {teamForm.founded}</p>
                    </div>
                  </div>
                </div>
              )}
            </div>
          ) : (
            // Step 2: Add Players
            <div className="space-y-6">
              {/* Add Player Form */}
              <div className="bg-gradient-to-br from-blue-50 to-white border border-blue-200 rounded-lg p-4">
                <h3 className="text-md font-semibold text-[#011B3B] mb-4">Add Player ({players.length}/12)</h3>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-4">
                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Player Name <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="text"
                      value={playerForm.name}
                      onChange={(e) => setPlayerForm({...playerForm, name: e.target.value})}
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                      placeholder="Enter player name"
                    />
                  </div>

                  <div>
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Role
                    </label>
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
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Jersey Number
                    </label>
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
                    <label className="block text-sm font-medium text-gray-700 mb-2">
                      Age <span className="text-red-500">*</span>
                    </label>
                    <input
                      type="number"
                      value={playerForm.age}
                      onChange={(e) => setPlayerForm({...playerForm, age: e.target.value})}
                      className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336]"
                      min="16"
                      max="50"
                      placeholder="Age"
                    />
                  </div>
                </div>

                <button
                  onClick={handleAddPlayer}
                  disabled={players.length >= 12}
                  className={`w-full flex items-center justify-center gap-2 px-4 py-2 rounded-lg font-medium transition-all ${
                    players.length >= 12
                      ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                      : 'bg-gradient-to-br from-[#FFC600] to-[#FF6B35] text-white hover:shadow-lg'
                  }`}
                >
                  <Plus className="w-4 h-4" />
                  Add Player to Roster
                </button>
              </div>

              {/* Players List */}
              {players.length > 0 && (
                <div>
                  <h3 className="text-md font-semibold text-[#011B3B] mb-3">Team Roster</h3>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                    {players.map((player) => (
                      <div
                        key={player.id}
                        className="bg-gradient-to-br from-gray-50 to-white rounded-lg p-3 border border-gray-100 flex items-center justify-between"
                      >
                        <div className="flex items-center gap-3">
                          <div className={`w-10 h-10 bg-gradient-to-br ${getRoleColor(player.role)} rounded-full flex items-center justify-center text-white font-bold text-sm`}>
                            {player.number}
                          </div>
                          <div>
                            <p className="font-semibold text-[#011B3B] text-sm">{player.name}</p>
                            <div className="flex items-center gap-1 text-xs text-gray-600">
                              {getRoleIcon(player.role)}
                              <span>{player.role}</span>
                              <span>•</span>
                              <span>{player.age}y</span>
                            </div>
                          </div>
                        </div>
                        <button
                          onClick={() => handleRemovePlayer(player.id)}
                          className="p-2 hover:bg-red-50 rounded-lg transition-colors"
                        >
                          <Trash2 className="w-4 h-4 text-[#D30336]" />
                        </button>
                      </div>
                    ))}
                  </div>
                </div>
              )}

              {players.length === 0 && (
                <div className="text-center py-8 bg-gray-50 rounded-lg border-2 border-dashed border-gray-300">
                  <Users className="w-12 h-12 text-gray-400 mx-auto mb-2" />
                  <p className="text-gray-600 text-sm">No players added yet</p>
                  <p className="text-gray-400 text-xs">Add at least one player to create the team</p>
                </div>
              )}
            </div>
          )}
        </div>

        {/* Footer */}
        <div className="sticky bottom-0 bg-gray-50 px-6 py-4 flex items-center justify-between border-t border-gray-200">
          <div className="text-sm text-gray-600">
            {step === 1 ? (
              <span>Fill in team information to continue</span>
            ) : (
              <span>{players.length} player{players.length !== 1 ? 's' : ''} added</span>
            )}
          </div>

          <div className="flex gap-3">
            {step === 2 && (
              <button
                onClick={() => setStep(1)}
                className="px-6 py-2 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-100 transition-all duration-200"
              >
                Back
              </button>
            )}

            <button
              onClick={handleClose}
              className="px-6 py-2 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-100 transition-all duration-200"
            >
              Cancel
            </button>

            {step === 1 ? (
              <button
                onClick={handleNextStep}
                className="px-6 py-2 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg transition-all duration-200"
              >
                Next: Add Players
              </button>
            ) : (
              <button
                onClick={handleCreateTeam}
                className="flex items-center gap-2 px-6 py-2 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg transition-all duration-200"
              >
                <Save className="w-4 h-4" />
                Create Team
              </button>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default CreateTeam;