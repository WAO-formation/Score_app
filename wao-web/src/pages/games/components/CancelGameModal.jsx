import { useState } from 'react';
import { AlertTriangle, Ban } from 'lucide-react';
import { BRAND } from '../../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const CancelGameModal = ({ game, onConfirm, onClose }) => {
  const [reason, setReason] = useState('Game was not played on the scheduled date.');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const handleConfirm = async () => {
    if (!reason.trim()) { setError('A reason is required.'); return; }
    setSaving(true);
    setError('');
    try {
      await onConfirm(reason.trim());
      onClose();
    } catch {
      setError('Failed to cancel the game. Please try again.');
      setSaving(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
      <div className="bg-white w-full max-w-sm">
        <div className="bg-[#c81434] px-5 py-4 flex items-center gap-2">
          <AlertTriangle className="w-5 h-5 text-white" />
          <h3 className="text-white uppercase tracking-widest text-sm" style={{ fontFamily: H }}>Cancel Game</h3>
        </div>

        <div className="p-5 space-y-4">
          <p className="text-xs text-gray-500" style={{ fontFamily: B }}>
            {game.homeTeam} vs {game.awayTeam} was scheduled for {game.date} at {game.time} and was never played.
            This marks it cancelled — it stays in the games history, just no longer shows as upcoming.
          </p>

          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5" style={{ fontFamily: B }}>Reason</label>
            <textarea
              rows={3}
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              className="w-full px-4 py-2.5 border border-gray-200 text-sm resize-none focus:outline-none focus:border-gray-400"
              style={{ fontFamily: B }}
            />
          </div>

          {error && <p className="text-sm text-red-500" style={{ fontFamily: B }}>{error}</p>}
        </div>

        <div className="px-5 pb-5 flex gap-3">
          <button
            onClick={onClose}
            className="flex-1 py-2.5 border-2 border-gray-200 text-gray-600 font-semibold hover:bg-gray-50 transition-colors text-sm"
            style={{ fontFamily: B }}
          >
            Never Mind
          </button>
          <button
            onClick={handleConfirm}
            disabled={saving}
            className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-[#c81434] text-white font-semibold hover:bg-[#e21e43] transition-all text-sm disabled:opacity-60"
            style={{ fontFamily: B }}
          >
            <Ban className="w-4 h-4" /> {saving ? 'Cancelling…' : 'Cancel Game'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default CancelGameModal;
