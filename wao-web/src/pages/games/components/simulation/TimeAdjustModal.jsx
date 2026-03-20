import { useState } from 'react';
import { Clock, Plus, Minus } from 'lucide-react';
import { QUARTER_TIMES } from '../../../../context/GamesContext';

const Spinner = ({ label, value, min, max, onChange }) => (
  <div className="flex flex-col items-center gap-2">
    <button
      onClick={() => onChange(Math.min(max, value + 1))}
      className="bg-gray-100 hover:bg-gray-200 active:bg-gray-300 w-10 h-10 rounded-xl flex items-center justify-center transition-colors"
    >
      <Plus className="w-4 h-4 text-[#011B3B]" />
    </button>
    <input
      type="number"
      min={min}
      max={max}
      value={value}
      onChange={(e) => {
        const v = Math.max(min, Math.min(max, parseInt(e.target.value) || 0));
        onChange(v);
      }}
      className="w-16 text-center text-4xl font-black text-[#011B3B] border-2 border-gray-200 rounded-xl py-2 focus:outline-none focus:border-[#011B3B] [appearance:textfield] [&::-webkit-outer-spin-button]:appearance-none [&::-webkit-inner-spin-button]:appearance-none"
    />
    <button
      onClick={() => onChange(Math.max(min, value - 1))}
      className="bg-gray-100 hover:bg-gray-200 active:bg-gray-300 w-10 h-10 rounded-xl flex items-center justify-center transition-colors"
    >
      <Minus className="w-4 h-4 text-[#011B3B]" />
    </button>
    <span className="text-xs text-gray-500 font-medium">{label}</span>
  </div>
);

const TimeAdjustModal = ({ timeRemaining, currentQuarter, onSave, onClose }) => {
  const [minutes, setMinutes] = useState(Math.floor(timeRemaining / 60));
  const [seconds, setSeconds] = useState(timeRemaining % 60);
  const maxMinutes = Math.floor((QUARTER_TIMES[currentQuarter] ?? 13 * 60) / 60);

  return (
    <div className="fixed inset-0 bg-black/70 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-sm">
        <div className="bg-gradient-to-br from-[#011B3B] to-[#022d5f] px-5 py-4 rounded-t-2xl flex items-center justify-between">
          <div className="flex items-center gap-2">
            <Clock className="w-5 h-5 text-white" />
            <h3 className="text-lg font-bold text-white">Adjust Time</h3>
          </div>
          <button onClick={onClose} className="text-white/70 hover:text-white text-xl leading-none">✕</button>
        </div>

        <div className="p-6">
          <div className="flex items-center justify-center gap-3 mb-6">
            <Spinner label="MIN" value={minutes} min={0} max={maxMinutes} onChange={setMinutes} />
            <span className="text-4xl font-black text-[#011B3B] pb-6">:</span>
            <Spinner label="SEC" value={seconds} min={0} max={59} onChange={setSeconds} />
          </div>

          <p className="text-center text-xs text-gray-400 mb-5">
            Max for Q{currentQuarter}: {maxMinutes}:00
          </p>

          <div className="flex gap-3">
            <button
              onClick={onClose}
              className="flex-1 py-3 border-2 border-gray-200 text-gray-600 font-semibold rounded-xl hover:bg-gray-50 transition-colors"
            >
              Cancel
            </button>
            <button
              onClick={() => { onSave(minutes * 60 + seconds); onClose(); }}
              className="flex-1 py-3 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-bold rounded-xl hover:shadow-lg transition-all"
            >
              Set Time
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TimeAdjustModal;
