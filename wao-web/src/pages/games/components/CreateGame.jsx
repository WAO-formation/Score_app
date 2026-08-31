import React, { useState } from 'react';
import { X, Trophy, Save, Calendar, MapPin, Clock, RefreshCw, User, Users, Shield } from 'lucide-react';
import { teamsData, staffData, venuesData, tournamentsData } from '../../../config/constants';

const generateCode = () => Math.random().toString(36).substring(2, 8).toUpperCase();

const simulators = staffData.filter((s) => s.role === 'simulator' || s.role === 'both');
const judges     = staffData.filter((s) => s.role === 'judge'     || s.role === 'both');

const EMPTY_FORM = {
  homeTeam: '',
  awayTeam: '',
  date: '',
  time: '',
  venue: '',
  championship: '',
  simulator: '',
  accessCode: generateCode(),
  judges: ['', '', ''],
};

const CreateGame = ({ isOpen, onClose, onCreateGame }) => {
  const [form, setForm] = useState(EMPTY_FORM);
  const [errors, setErrors] = useState({});

  const setField = (key, value) => setForm((f) => ({ ...f, [key]: value }));

  const setJudge = (i, value) =>
    setForm((f) => {
      const judges = [...f.judges];
      judges[i] = value;
      return { ...f, judges };
    });

  const validate = () => {
    const e = {};
    if (!form.homeTeam) e.homeTeam = 'Required';
    if (!form.awayTeam) e.awayTeam = 'Required';
    if (form.homeTeam && form.awayTeam && form.homeTeam === form.awayTeam) e.awayTeam = 'Cannot be same as home team';
    if (!form.date) e.date = 'Required';
    if (!form.time) e.time = 'Required';
    if (!form.venue) e.venue = 'Required';
    if (!form.simulator) e.simulator = 'Required';
    if (!form.accessCode) e.accessCode = 'Required';
    form.judges.forEach((j, i) => { if (!j.trim()) e[`judge${i}`] = 'Required'; });
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const handleCreate = () => {
    if (!validate()) return;
    onCreateGame({
      id: Date.now(),
      homeTeam: form.homeTeam,
      awayTeam: form.awayTeam,
      date: form.date,
      time: form.time,
      venue: form.venue,
      championship: form.championship,
      simulator: form.simulator,
      accessCode: form.accessCode,
      judges: form.judges,
      status: 'upcoming',
      currentQuarter: 'Q1',
      timeRemaining: '17:00',
      homeScore: 0,
      awayScore: 0,
      quarters: { q1: { home: 0, away: 0 }, q2: { home: 0, away: 0 }, q3: { home: 0, away: 0 }, q4: { home: 0, away: 0 } },
      scoring: { kingdom: { home: 0, away: 0 }, workout: { home: 0, away: 0 }, goalSetting: { home: 0, away: 0 }, judges: { home: 0, away: 0 } },
      fouls: { home: [], away: [] },
      events: [],
    });
    handleClose();
  };

  const handleClose = () => {
    setForm({ ...EMPTY_FORM, accessCode: generateCode() });
    setErrors({});
    onClose();
  };

  if (!isOpen) return null;

  const inputCls = (err) =>
    `w-full px-4 py-2.5 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#D30336] ${err ? 'border-red-400 bg-red-50' : 'border-gray-200'}`;

  return (
    <div className="fixed inset-0 bg-black/60 flex items-center justify-center z-50 p-4">
      <div className="bg-white rounded-2xl shadow-2xl w-full max-w-2xl max-h-[92vh] overflow-y-auto">

        {/* Header */}
        <div className="sticky top-0 z-10 bg-gradient-to-br from-[#D30336] to-[#a8022b] px-6 py-4 flex items-center justify-between rounded-t-2xl">
          <div className="flex items-center gap-3">
            <div className="w-9 h-9 bg-white/20 rounded-xl flex items-center justify-center">
              <Trophy className="w-5 h-5 text-white" />
            </div>
            <div>
              <h2 className="text-lg font-bold text-white">Create New Game</h2>
              <p className="text-white/70 text-xs">Schedule a new WAO! match</p>
            </div>
          </div>
          <button onClick={handleClose} className="text-white/80 hover:text-white transition-colors">
            <X className="w-5 h-5" />
          </button>
        </div>

        <div className="p-5 space-y-6">

          {/* ── Teams ── */}
          <div>
            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-1.5">
              <Users className="w-3.5 h-3.5" /> Teams
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Home Team <span className="text-red-500">*</span></label>
                <select value={form.homeTeam} onChange={(e) => setField('homeTeam', e.target.value)} className={inputCls(errors.homeTeam)}>
                  <option value="">Select home team</option>
                  {teamsData.map((t) => <option key={t.id} value={t.name}>{t.name}</option>)}
                </select>
                {errors.homeTeam && <p className="text-xs text-red-500 mt-1">{errors.homeTeam}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Away Team <span className="text-red-500">*</span></label>
                <select value={form.awayTeam} onChange={(e) => setField('awayTeam', e.target.value)} className={inputCls(errors.awayTeam)}>
                  <option value="">Select away team</option>
                  {teamsData.filter((t) => t.name !== form.homeTeam).map((t) => <option key={t.id} value={t.name}>{t.name}</option>)}
                </select>
                {errors.awayTeam && <p className="text-xs text-red-500 mt-1">{errors.awayTeam}</p>}
              </div>
            </div>

            {/* Match preview */}
            {form.homeTeam && form.awayTeam && (
              <div className="mt-3 bg-gray-50 border border-gray-100 rounded-xl p-4 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-9 h-9 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center">
                    <span className="text-white font-bold text-xs">{form.homeTeam.substring(0, 2).toUpperCase()}</span>
                  </div>
                  <span className="font-semibold text-[#011B3B] text-sm">{form.homeTeam}</span>
                </div>
                <span className="text-gray-400 font-bold text-sm">VS</span>
                <div className="flex items-center gap-2">
                  <span className="font-semibold text-[#011B3B] text-sm">{form.awayTeam}</span>
                  <div className="w-9 h-9 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                    <span className="text-white font-bold text-xs">{form.awayTeam.substring(0, 2).toUpperCase()}</span>
                  </div>
                </div>
              </div>
            )}
          </div>

          {/* ── Date / Time / Venue / Championship ── */}
          <div>
            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-1.5">
              <Calendar className="w-3.5 h-3.5" /> Match Details
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5"><Calendar className="w-3.5 h-3.5 inline mr-1" />Date <span className="text-red-500">*</span></label>
                <input type="date" value={form.date} onChange={(e) => setField('date', e.target.value)} className={inputCls(errors.date)} />
                {errors.date && <p className="text-xs text-red-500 mt-1">{errors.date}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5"><Clock className="w-3.5 h-3.5 inline mr-1" />Time <span className="text-red-500">*</span></label>
                <input type="time" value={form.time} onChange={(e) => setField('time', e.target.value)} className={inputCls(errors.time)} />
                {errors.time && <p className="text-xs text-red-500 mt-1">{errors.time}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5"><MapPin className="w-3.5 h-3.5 inline mr-1" />Venue <span className="text-red-500">*</span></label>
                <select value={form.venue} onChange={(e) => setField('venue', e.target.value)} className={inputCls(errors.venue)}>
                  <option value="">Select venue</option>
                  {venuesData.map((v) => <option key={v.id} value={v.name}>{v.name}</option>)}
                </select>
                {errors.venue && <p className="text-xs text-red-500 mt-1">{errors.venue}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5"><Trophy className="w-3.5 h-3.5 inline mr-1" />Tournament</label>
                <select value={form.championship} onChange={(e) => setField('championship', e.target.value)} className={inputCls(false)}>
                  <option value="">Select tournament</option>
                  {tournamentsData.map((t) => <option key={t.id} value={t.name}>{t.name}</option>)}
                </select>
              </div>
            </div>
          </div>

          {/* ── Simulator ── */}
          <div>
            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-1.5">
              <User className="w-3.5 h-3.5" /> Game Simulator
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Simulator <span className="text-red-500">*</span></label>
                <select value={form.simulator} onChange={(e) => setField('simulator', e.target.value)} className={inputCls(errors.simulator)}>
                  <option value="">Select simulator</option>
                  {simulators.map((s) => <option key={s.id} value={s.name}>{s.name}</option>)}
                </select>
                {errors.simulator && <p className="text-xs text-red-500 mt-1">{errors.simulator}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Access Code <span className="text-red-500">*</span></label>
                <div className="flex gap-2">
                  <input type="text" value={form.accessCode} onChange={(e) => setField('accessCode', e.target.value.toUpperCase())} maxLength={8} className={`${inputCls(errors.accessCode)} font-mono flex-1`} />
                  <button type="button" onClick={() => setField('accessCode', generateCode())} className="px-3 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors flex-shrink-0" title="Regenerate">
                    <RefreshCw className="w-4 h-4 text-gray-600" />
                  </button>
                </div>
                {errors.accessCode && <p className="text-xs text-red-500 mt-1">{errors.accessCode}</p>}
                <p className="text-xs text-gray-400 mt-1">Simulator uses this code to start the game. Can be changed.</p>
              </div>
            </div>
          </div>

          {/* ── Judges ── */}
          <div>
            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-1.5">
              <Shield className="w-3.5 h-3.5" /> Judges (3 Required)
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              {form.judges.map((judge, i) => (
                <div key={i}>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Judge {i + 1} <span className="text-red-500">*</span></label>
                  <select
                    value={judge}
                    onChange={(e) => setJudge(i, e.target.value)}
                    className={inputCls(errors[`judge${i}`])}
                  >
                    <option value="">Select judge</option>
                    {judges
                      .filter((j) => !form.judges.includes(j.name) || form.judges[i] === j.name)
                      .map((j) => <option key={j.id} value={j.name}>{j.name}</option>)}
                  </select>
                  {errors[`judge${i}`] && <p className="text-xs text-red-500 mt-1">{errors[`judge${i}`]}</p>}
                </div>
              ))}
            </div>
            <p className="text-xs text-gray-400 mt-2">Judges can only score when the game timer is paused.</p>
          </div>
        </div>

        {/* Footer */}
        <div className="sticky bottom-0 bg-gray-50 px-5 py-4 flex gap-3 border-t border-gray-100 rounded-b-2xl">
          <button onClick={handleClose} className="flex-1 py-2.5 border-2 border-gray-200 text-gray-700 font-semibold rounded-xl hover:bg-gray-100 transition-all text-sm">
            Cancel
          </button>
          <button onClick={handleCreate} className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-xl hover:shadow-lg transition-all text-sm">
            <Save className="w-4 h-4" /> Create Game
          </button>
        </div>
      </div>
    </div>
  );
};

export default CreateGame;
