import { useState } from 'react';
import { AlertCircle } from 'lucide-react';

const FoulModal = ({ game, onFoul, onClose }) => {
  const [selectedTeam, setSelectedTeam] = useState('home');
  const [playerName, setPlayerName] = useState('');

  const handleSubmit = () => {
    if (playerName.trim()) {
      onFoul(selectedTeam, playerName.trim());
      onClose();
    }
  };

  return (
    <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl max-w-lg w-full">
        <div className="bg-gradient-to-br from-red-500 to-red-600 px-6 py-4 rounded-t-2xl flex items-center justify-between">
          <div className="flex items-center gap-2">
            <AlertCircle className="w-6 h-6 text-white" />
            <h3 className="text-xl font-bold text-white">Record Foul</h3>
          </div>
          <button onClick={onClose} className="text-white/80 hover:text-white text-2xl">✕</button>
        </div>

        <div className="p-6 space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Team</label>
            <div className="grid grid-cols-2 gap-3">
              {[
                { key: 'home', label: game?.homeTeam, active: 'bg-yellow-100 border-yellow-400' },
                { key: 'away', label: game?.awayTeam, active: 'bg-red-100 border-red-400' },
              ].map(({ key, label, active }) => (
                <button
                  key={key}
                  onClick={() => setSelectedTeam(key)}
                  className={`px-4 py-3 rounded-lg font-medium border-2 transition-all ${
                    selectedTeam === key ? `${active} text-[#011B3B]` : 'bg-gray-100 border-gray-300 text-gray-600'
                  }`}
                >
                  {label}
                </button>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">Player Name</label>
            <input
              type="text"
              value={playerName}
              onChange={(e) => setPlayerName(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSubmit()}
              placeholder="Enter player name"
              className="w-full px-4 py-2 border-2 border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-red-500"
              autoFocus
            />
          </div>

          <button
            onClick={handleSubmit}
            disabled={!playerName.trim()}
            className="w-full bg-gradient-to-br from-red-500 to-red-600 text-white font-bold py-3 rounded-lg hover:shadow-lg transition-all disabled:opacity-50 disabled:cursor-not-allowed"
          >
            Record Foul
          </button>
        </div>
      </div>
    </div>
  );
};

export default FoulModal;
