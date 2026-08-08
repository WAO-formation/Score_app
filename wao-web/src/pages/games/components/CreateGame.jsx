import React, { useState, useEffect } from 'react';
import { X, Trophy, Save, Calendar, MapPin, Clock, RefreshCw, UserCog, Users, Shield } from 'lucide-react';
import { collection, query, where, getDocs } from 'firebase/firestore';
import { db } from '../../../lib/firebase';
import { generateAccessCode } from '../../../services/matchesService';

const EMPTY_FORM = {
  homeTeamId: '',
  awayTeamId: '',
  date: '',
  time: '',
  venue: '',
  championshipId: '',
  moderatorUid: '',
  accessCode: generateAccessCode(),
  judges: ['', '', ''],
};

const CreateGame = ({ isOpen, onClose, onCreateGame }) => {
  const [form, setForm] = useState(EMPTY_FORM);
  const [errors, setErrors] = useState({});
  const [saving, setSaving] = useState(false);
  const [teams, setTeams] = useState([]);
  const [moderators, setModerators] = useState([]);
  const [judgeOptions, setJudgeOptions] = useState([]);
  const [venues, setVenues] = useState([]);
  const [championships, setChampionships] = useState([]);
  const [loadingOptions, setLoadingOptions] = useState(false);

  // Everything here is pulled live from Firestore, not mock data — teams,
  // the moderator who'll run this game's live scoring (the only non-admin
  // who gets to see its access code, see GameCard/GameDetails), and the
  // judges panel, all have to match real portal/roster accounts.
  useEffect(() => {
    if (!isOpen) return;
    setLoadingOptions(true);
    Promise.all([
      getDocs(collection(db, 'teams')),
      getDocs(query(collection(db, 'users'), where('role', '==', 'moderator'))),
      getDocs(query(collection(db, 'users'), where('role', '==', 'official'))),
      getDocs(collection(db, 'venues')),
      getDocs(collection(db, 'championships')),
    ])
      .then(([teamsSnap, modSnap, officialSnap, venueSnap, champSnap]) => {
        setTeams(teamsSnap.docs.map((d) => ({ id: d.id, name: d.data().name })));
        setModerators(modSnap.docs.map((d) => ({
          uid: d.id,
          name: d.data().displayName || d.data().username || d.data().email,
        })));
        setJudgeOptions(officialSnap.docs.map((d) => ({
          uid: d.id,
          name: d.data().displayName || d.data().username || d.data().email,
        })));
        setVenues(venueSnap.docs.map((d) => ({ id: d.id, name: d.data().name })));
        setChampionships(champSnap.docs.map((d) => ({ id: d.id, name: d.data().name })));
      })
      .catch(() => { setTeams([]); setModerators([]); setJudgeOptions([]); setVenues([]); setChampionships([]); })
      .finally(() => setLoadingOptions(false));
  }, [isOpen]);

  const setField = (key, value) => setForm((f) => ({ ...f, [key]: value }));

  const setJudge = (i, uid) =>
    setForm((f) => {
      const judges = [...f.judges];
      judges[i] = uid;
      return { ...f, judges };
    });

  const validate = () => {
    const e = {};
    if (!form.homeTeamId) e.homeTeamId = 'Required';
    if (!form.awayTeamId) e.awayTeamId = 'Required';
    if (form.homeTeamId && form.awayTeamId && form.homeTeamId === form.awayTeamId) e.awayTeamId = 'Cannot be same as home team';
    if (!form.date) e.date = 'Required';
    if (!form.time) e.time = 'Required';
    if (!form.venue) e.venue = 'Required';
    if (!form.moderatorUid) e.moderatorUid = 'Required';
    if (!form.accessCode) e.accessCode = 'Required';
    form.judges.forEach((j, i) => { if (!j) e[`judge${i}`] = 'Required'; });
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const handleCreate = async () => {
    if (!validate()) return;
    setSaving(true);
    try {
      const homeTeam = teams.find((t) => t.id === form.homeTeamId);
      const awayTeam = teams.find((t) => t.id === form.awayTeamId);
      const moderator = moderators.find((m) => m.uid === form.moderatorUid);
      const championship = championships.find((c) => c.id === form.championshipId);
      const judges = form.judges.map((uid) => {
        const j = judgeOptions.find((o) => o.uid === uid);
        return { uid, name: j?.name || '' };
      });

      await onCreateGame({
        homeTeamId: form.homeTeamId,
        awayTeamId: form.awayTeamId,
        homeTeam: homeTeam?.name || '',
        awayTeam: awayTeam?.name || '',
        date: form.date,
        time: form.time,
        venue: form.venue,
        championshipId: form.championshipId || null,
        championship: championship?.name || '',
        moderatorUid: form.moderatorUid,
        moderatorName: moderator?.name || '',
        accessCode: form.accessCode,
        judges,
      });
      handleClose();
    } catch {
      setErrors({ submit: 'Failed to create game. Please try again.' });
    } finally {
      setSaving(false);
    }
  };

  const handleClose = () => {
    setForm({ ...EMPTY_FORM, accessCode: generateAccessCode() });
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
                <select value={form.homeTeamId} onChange={(e) => setField('homeTeamId', e.target.value)} className={inputCls(errors.homeTeamId)} disabled={loadingOptions}>
                  <option value="">{loadingOptions ? 'Loading teams…' : 'Select home team'}</option>
                  {teams.map((t) => <option key={t.id} value={t.id}>{t.name}</option>)}
                </select>
                {errors.homeTeamId && <p className="text-xs text-red-500 mt-1">{errors.homeTeamId}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Away Team <span className="text-red-500">*</span></label>
                <select value={form.awayTeamId} onChange={(e) => setField('awayTeamId', e.target.value)} className={inputCls(errors.awayTeamId)} disabled={loadingOptions}>
                  <option value="">{loadingOptions ? 'Loading teams…' : 'Select away team'}</option>
                  {teams.filter((t) => t.id !== form.homeTeamId).map((t) => <option key={t.id} value={t.id}>{t.name}</option>)}
                </select>
                {errors.awayTeamId && <p className="text-xs text-red-500 mt-1">{errors.awayTeamId}</p>}
              </div>
            </div>
            {!loadingOptions && teams.length === 0 && (
              <p className="text-xs text-amber-600 mt-2">No teams yet — create one under Teams first.</p>
            )}

            {/* Match preview */}
            {form.homeTeamId && form.awayTeamId && (() => {
              const home = teams.find((t) => t.id === form.homeTeamId);
              const away = teams.find((t) => t.id === form.awayTeamId);
              return (
                <div className="mt-3 bg-gray-50 border border-gray-100 rounded-xl p-4 flex items-center justify-between">
                  <div className="flex items-center gap-2">
                    <div className="w-9 h-9 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center">
                      <span className="text-white font-bold text-xs">{home?.name?.substring(0, 2).toUpperCase()}</span>
                    </div>
                    <span className="font-semibold text-[#011B3B] text-sm">{home?.name}</span>
                  </div>
                  <span className="text-gray-400 font-bold text-sm">VS</span>
                  <div className="flex items-center gap-2">
                    <span className="font-semibold text-[#011B3B] text-sm">{away?.name}</span>
                    <div className="w-9 h-9 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                      <span className="text-white font-bold text-xs">{away?.name?.substring(0, 2).toUpperCase()}</span>
                    </div>
                  </div>
                </div>
              );
            })()}
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
                <p className="text-xs text-gray-400 mt-1">The game can't be started before this exact date and time.</p>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5"><MapPin className="w-3.5 h-3.5 inline mr-1" />Venue <span className="text-red-500">*</span></label>
                <select value={form.venue} onChange={(e) => setField('venue', e.target.value)} className={inputCls(errors.venue)} disabled={loadingOptions}>
                  <option value="">{loadingOptions ? 'Loading venues…' : 'Select venue'}</option>
                  {venues.map((v) => <option key={v.id} value={v.name}>{v.name}</option>)}
                </select>
                {errors.venue && <p className="text-xs text-red-500 mt-1">{errors.venue}</p>}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5"><Trophy className="w-3.5 h-3.5 inline mr-1" />Tournament</label>
                <select value={form.championshipId} onChange={(e) => setField('championshipId', e.target.value)} className={inputCls(false)} disabled={loadingOptions}>
                  <option value="">Select tournament</option>
                  {championships.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
                </select>
              </div>
            </div>
          </div>

          {/* ── Moderator ── */}
          <div>
            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-1.5">
              <UserCog className="w-3.5 h-3.5" /> Assigned Moderator
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Moderator <span className="text-red-500">*</span></label>
                <select value={form.moderatorUid} onChange={(e) => setField('moderatorUid', e.target.value)} className={inputCls(errors.moderatorUid)} disabled={loadingOptions}>
                  <option value="">{loadingOptions ? 'Loading moderators…' : 'Select moderator'}</option>
                  {moderators.map((m) => <option key={m.uid} value={m.uid}>{m.name}</option>)}
                </select>
                {errors.moderatorUid && <p className="text-xs text-red-500 mt-1">{errors.moderatorUid}</p>}
                {!loadingOptions && moderators.length === 0 && (
                  <p className="text-xs text-amber-600 mt-1">No moderator accounts yet — add one under Management &gt; Users.</p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1.5">Access Code <span className="text-red-500">*</span></label>
                <div className="flex gap-2">
                  <input type="text" value={form.accessCode} onChange={(e) => setField('accessCode', e.target.value.toUpperCase())} maxLength={8} className={`${inputCls(errors.accessCode)} font-mono flex-1`} />
                  <button type="button" onClick={() => setField('accessCode', generateAccessCode())} className="px-3 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors flex-shrink-0" title="Regenerate">
                    <RefreshCw className="w-4 h-4 text-gray-600" />
                  </button>
                </div>
                {errors.accessCode && <p className="text-xs text-red-500 mt-1">{errors.accessCode}</p>}
                <p className="text-xs text-gray-400 mt-1">Only the assigned moderator and admins can see this code.</p>
              </div>
            </div>
          </div>

          {/* ── Judges ── */}
          <div>
            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider mb-3 flex items-center gap-1.5">
              <Shield className="w-3.5 h-3.5" /> Judges (3 Required)
            </p>
            <div className="grid grid-cols-1 sm:grid-cols-3 gap-4">
              {form.judges.map((judgeUid, i) => (
                <div key={i}>
                  <label className="block text-sm font-medium text-gray-700 mb-1.5">Judge {i + 1} <span className="text-red-500">*</span></label>
                  <select
                    value={judgeUid}
                    onChange={(e) => setJudge(i, e.target.value)}
                    className={inputCls(errors[`judge${i}`])}
                    disabled={loadingOptions}
                  >
                    <option value="">{loadingOptions ? 'Loading…' : 'Select judge'}</option>
                    {judgeOptions
                      .filter((o) => !form.judges.includes(o.uid) || judgeUid === o.uid)
                      .map((o) => <option key={o.uid} value={o.uid}>{o.name}</option>)}
                  </select>
                  {errors[`judge${i}`] && <p className="text-xs text-red-500 mt-1">{errors[`judge${i}`]}</p>}
                </div>
              ))}
            </div>
            {!loadingOptions && judgeOptions.length === 0 && (
              <p className="text-xs text-amber-600 mt-2">No official accounts yet — add one under Management &gt; Users.</p>
            )}
            <p className="text-xs text-gray-400 mt-2">Judges can only score when the game timer is paused.</p>
          </div>

          {errors.submit && <p className="text-sm text-red-500">{errors.submit}</p>}
        </div>

        {/* Footer */}
        <div className="sticky bottom-0 bg-gray-50 px-5 py-4 flex gap-3 border-t border-gray-100 rounded-b-2xl">
          <button onClick={handleClose} className="flex-1 py-2.5 border-2 border-gray-200 text-gray-700 font-semibold rounded-xl hover:bg-gray-100 transition-all text-sm">
            Cancel
          </button>
          <button onClick={handleCreate} disabled={saving} className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-xl hover:shadow-lg transition-all text-sm disabled:opacity-60">
            <Save className="w-4 h-4" /> {saving ? 'Creating…' : 'Create Game'}
          </button>
        </div>
      </div>
    </div>
  );
};

export default CreateGame;
