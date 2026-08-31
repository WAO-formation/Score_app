import { useState } from 'react';
import { X, Calendar, Clock, Save } from 'lucide-react';
import { BRAND } from '../../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const RescheduleModal = ({ game, onSave, onClose }) => {
  const [date, setDate] = useState(game.date || '');
  const [time, setTime] = useState(game.time || '');
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  const handleSave = async () => {
    if (!date || !time) { setError('Pick both a date and a time.'); return; }
    setSaving(true);
    setError('');
    try {
      await onSave(new Date(`${date}T${time}`));
      onClose();
    } catch {
      setError('Failed to reschedule. Please try again.');
      setSaving(false);
    }
  };

  return (
    <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
      <div className="bg-white w-full max-w-sm">
        <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] px-5 py-4 flex items-center justify-between">
          <h3 className="text-white uppercase tracking-widest text-sm" style={{ fontFamily: H }}>Reschedule Game</h3>
          <button onClick={onClose} className="text-white/70 hover:text-white text-xl leading-none">✕</button>
        </div>

        <div className="p-5 space-y-4">
          <p className="text-xs text-gray-500" style={{ fontFamily: B }}>
            {game.homeTeam} vs {game.awayTeam} was scheduled for {game.date} at {game.time} and was never played.
          </p>

          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5" style={{ fontFamily: B }}>
              <Calendar className="w-3.5 h-3.5 inline mr-1" />New Date
            </label>
            <input
              type="date"
              value={date}
              onChange={(e) => setDate(e.target.value)}
              className="w-full px-4 py-2.5 border border-gray-200 text-sm focus:outline-none focus:border-gray-400"
              style={{ fontFamily: B }}
            />
          </div>

          <div>
            <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1.5" style={{ fontFamily: B }}>
              <Clock className="w-3.5 h-3.5 inline mr-1" />New Time
            </label>
            <input
              type="time"
              value={time}
              onChange={(e) => setTime(e.target.value)}
              className="w-full px-4 py-2.5 border border-gray-200 text-sm focus:outline-none focus:border-gray-400"
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
            Cancel
          </button>
          <button
            onClick={handleSave}
            disabled={saving}
            className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] transition-all text-sm disabled:opacity-60"
            style={{ fontFamily: B }}
          >
            <Save className="w-4 h-4" /> {saving ? 'Saving…' : 'Save New Time'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default RescheduleModal;
