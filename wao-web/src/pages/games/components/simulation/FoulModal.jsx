import { useState } from 'react';
import { AlertCircle } from 'lucide-react';
import { BRAND } from '../../../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const FoulModal = ({ game, onFoul, onClose }) => {
  const [selectedTeam, setSelectedTeam] = useState('home');
  const [playerName, setPlayerName]     = useState('');

  const handleSubmit = () => {
    if (playerName.trim()) {
      onFoul(selectedTeam, playerName.trim());
      onClose();
    }
  };

  return (
    <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
      <div className="bg-white w-full max-w-lg">

        {/* Header */}
        <div className="bg-[#c81434] px-6 py-4 flex items-center justify-between">
          <div className="flex items-center gap-2">
            <AlertCircle className="w-5 h-5 text-white" />
            <h3 className="text-lg text-white uppercase tracking-widest" style={{ fontFamily: H }}>Record Foul</h3>
          </div>
          <button onClick={onClose} className="text-white/70 hover:text-white text-xl">✕</button>
        </div>

        <div className="p-6 space-y-5">
          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2" style={{ fontFamily: B }}>Team</label>
            <div className="grid grid-cols-2 gap-3">
              {[
                { key: 'home', label: game?.homeTeam, active: 'bg-amber-50 border-amber-400 text-[#011B3B]' },
                { key: 'away', label: game?.awayTeam, active: 'bg-red-50 border-[#c81434] text-[#011B3B]' },
              ].map(({ key, label, active }) => (
                <button
                  key={key}
                  onClick={() => setSelectedTeam(key)}
                  className={`px-4 py-3 font-semibold border-2 transition-all text-sm ${
                    selectedTeam === key ? active : 'bg-gray-50 border-gray-200 text-gray-500'
                  }`}
                  style={{ fontFamily: B }}
                >
                  {label}
                </button>
              ))}
            </div>
          </div>

          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2" style={{ fontFamily: B }}>Player Name</label>
            <input
              type="text"
              value={playerName}
              onChange={(e) => setPlayerName(e.target.value)}
              onKeyPress={(e) => e.key === 'Enter' && handleSubmit()}
              placeholder="Enter player name"
              className="w-full px-4 py-2.5 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm"
              style={{ fontFamily: B }}
              autoFocus
            />
          </div>

          <button
            onClick={handleSubmit}
            disabled={!playerName.trim()}
            className="w-full bg-[#c81434] hover:bg-[#e21e43] text-white font-bold py-3 transition-all disabled:opacity-50 disabled:cursor-not-allowed"
            style={{ fontFamily: B }}
          >
            Record Foul
          </button>
        </div>
      </div>
    </div>
  );
};

export default FoulModal;
