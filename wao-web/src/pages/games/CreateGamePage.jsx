import { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import {
  ArrowLeft, ArrowRight, Check, Trophy, Save, Calendar, MapPin, Clock,
  RefreshCw, UserCog, Users, Shield,
} from 'lucide-react';
import { collection, query, where, getDocs } from 'firebase/firestore';
import { db } from '../../lib/firebase';
import { generateAccessCode } from '../../services/matchesService';
import { useGames } from '../../context/GamesContext';
import { BRAND } from '../../config/brand';

const B = BRAND.font.body;
const H = BRAND.font.heading;

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

const STEPS = [
  { key: 'details',   label: 'Match Details', icon: Calendar },
  { key: 'officials', label: 'Officials',     icon: UserCog },
  { key: 'review',    label: 'Review',        icon: Check },
];

const inputCls = (err) =>
  `w-full px-4 py-2.5 border rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#D30336] ${err ? 'border-red-400 bg-red-50' : 'border-gray-200'}`;

const CreateGamePage = () => {
  const navigate = useNavigate();
  const { addGame } = useGames();

  const [step, setStep] = useState(0);
  const [form, setForm] = useState(EMPTY_FORM);
  const [errors, setErrors] = useState({});
  const [saving, setSaving] = useState(false);
  const [teams, setTeams] = useState([]);
  const [moderators, setModerators] = useState([]);
  const [judgeOptions, setJudgeOptions] = useState([]);
  const [venues, setVenues] = useState([]);
  const [championships, setChampionships] = useState([]);
  const [loadingOptions, setLoadingOptions] = useState(true);

  // Everything here is pulled live from Firestore, not mock data — teams,
  // the moderator who'll run this game's live scoring (the only non-admin
  // who gets to see its access code, see GameCard/GameDetails), and the
  // judges panel, all have to match real portal/roster accounts.
  //
  // allSettled, not all: these five queries are independent, and a
  // permission error on one (e.g. a moderator's `users` role-query briefly
  // rejected before firestore.rules allowed it) must not blank out the
  // other four that already succeeded — that previously made a real,
  // populated Teams collection show "No teams yet" just because the
  // moderator/official lookup failed alongside it.
  useEffect(() => {
    const userNameOf = (d) => d.data().displayName || d.data().username || d.data().email;
    Promise.allSettled([
      getDocs(collection(db, 'teams')),
      getDocs(query(collection(db, 'users'), where('role', '==', 'moderator'))),
      getDocs(query(collection(db, 'users'), where('role', '==', 'official'))),
      getDocs(collection(db, 'venues')),
      getDocs(collection(db, 'championships')),
    ]).then(([teamsRes, modRes, officialRes, venueRes, champRes]) => {
      setTeams(teamsRes.status === 'fulfilled' ? teamsRes.value.docs.map((d) => ({ id: d.id, name: d.data().name })) : []);
      setModerators(modRes.status === 'fulfilled' ? modRes.value.docs.map((d) => ({ uid: d.id, name: userNameOf(d) })) : []);
      setJudgeOptions(officialRes.status === 'fulfilled' ? officialRes.value.docs.map((d) => ({ uid: d.id, name: userNameOf(d) })) : []);
      setVenues(venueRes.status === 'fulfilled' ? venueRes.value.docs.map((d) => ({ id: d.id, name: d.data().name })) : []);
      setChampionships(champRes.status === 'fulfilled' ? champRes.value.docs.map((d) => ({ id: d.id, name: d.data().name })) : []);
      setLoadingOptions(false);
    });
  }, []);

  const setField = (key, value) => setForm((f) => ({ ...f, [key]: value }));

  const setJudge = (i, uid) =>
    setForm((f) => {
      const judges = [...f.judges];
      judges[i] = uid;
      return { ...f, judges };
    });

  const homeTeam = teams.find((t) => t.id === form.homeTeamId);
  const awayTeam = teams.find((t) => t.id === form.awayTeamId);
  const moderator = moderators.find((m) => m.uid === form.moderatorUid);
  const championship = championships.find((c) => c.id === form.championshipId);

  const validateStep = (i) => {
    const e = {};
    if (i === 0) {
      if (!form.homeTeamId) e.homeTeamId = 'Required';
      if (!form.awayTeamId) e.awayTeamId = 'Required';
      if (form.homeTeamId && form.awayTeamId && form.homeTeamId === form.awayTeamId) e.awayTeamId = 'Cannot be same as home team';
      if (!form.date) e.date = 'Required';
      if (!form.time) e.time = 'Required';
      if (!form.venue) e.venue = 'Required';
    } else if (i === 1) {
      if (!form.moderatorUid) e.moderatorUid = 'Required';
      if (!form.accessCode) e.accessCode = 'Required';
      form.judges.forEach((j, idx) => { if (!j) e[`judge${idx}`] = 'Required'; });
    }
    setErrors(e);
    return Object.keys(e).length === 0;
  };

  const goNext = () => { if (validateStep(step)) setStep((s) => Math.min(s + 1, STEPS.length - 1)); };
  const goBack = () => { setErrors({}); setStep((s) => Math.max(s - 1, 0)); };

  // Jumping via the stepper itself only re-validates steps already passed —
  // never blocks going backward to fix something.
  const goToStep = (i) => {
    if (i <= step) { setErrors({}); setStep(i); return; }
    for (let s = step; s < i; s++) { if (!validateStep(s)) return; }
    setStep(i);
  };

  const handleCreate = async () => {
    if (!validateStep(0) || !validateStep(1)) return;
    setSaving(true);
    try {
      const judges = form.judges.map((uid) => {
        const j = judgeOptions.find((o) => o.uid === uid);
        return { uid, name: j?.name || '' };
      });

      const newGameId = await addGame({
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
      navigate(`/games/${newGameId}`);
    } catch {
      setErrors({ submit: 'Failed to create game. Please try again.' });
      setSaving(false);
    }
  };

  return (
    <section className="max-w-3xl mx-auto px-2 py-4 md:p-4 pb-12">

      {/* Header */}
      <div className="flex items-center gap-3 mb-6">
        <button
          onClick={() => navigate('/games')}
          className="flex items-center gap-1.5 text-gray-500 hover:text-[#011B3B] text-sm transition-colors"
          style={{ fontFamily: B }}
        >
          <ArrowLeft className="w-4 h-4" /> Back to Games
        </button>
      </div>

      <div className="flex items-center gap-3 mb-8">
        <div className="w-11 h-11 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-xl flex items-center justify-center shrink-0">
          <Trophy className="w-5 h-5 text-white" />
        </div>
        <div>
          <h1 className="text-xl md:text-2xl text-[#011B3B]" style={{ fontFamily: H }}>Create New Game</h1>
          <p className="text-sm text-gray-500" style={{ fontFamily: B }}>Schedule a new WAO! match</p>
        </div>
      </div>

      {/* Stepper */}
      <div className="flex items-center mb-8">
        {STEPS.map((s, i) => {
          const Icon = s.icon;
          const isDone = i < step;
          const isActive = i === step;
          return (
            <div key={s.key} className="flex items-center flex-1 last:flex-initial">
              <button
                onClick={() => goToStep(i)}
                className="flex flex-col items-center gap-1.5 shrink-0"
              >
                <div
                  className={`w-9 h-9 rounded-full flex items-center justify-center transition-colors ${
                    isDone ? 'bg-[#011B3B] text-white' : isActive ? 'bg-[#D30336] text-white' : 'bg-gray-100 text-gray-400'
                  }`}
                >
                  {isDone ? <Check className="w-4 h-4" /> : <Icon className="w-4 h-4" />}
                </div>
                <span className={`text-xs font-medium hidden sm:block ${isActive ? 'text-[#011B3B]' : 'text-gray-400'}`} style={{ fontFamily: B }}>
                  {s.label}
                </span>
              </button>
              {i < STEPS.length - 1 && (
                <div className={`flex-1 h-0.5 mx-2 transition-colors ${isDone ? 'bg-[#011B3B]' : 'bg-gray-100'}`} />
              )}
            </div>
          );
        })}
      </div>

      {/* Step content */}
      <div className="bg-white border border-gray-100 rounded-2xl p-5 md:p-6 shadow-sm min-h-[360px]">

        {step === 0 && (
          <div className="space-y-4">
            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider flex items-center gap-1.5">
              <Users className="w-3.5 h-3.5" /> Who's playing?
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
              <p className="text-xs text-amber-600">No teams yet — create one under Teams first.</p>
            )}

            {form.homeTeamId && form.awayTeamId && (
              <div className="bg-gray-50 border border-gray-100 rounded-xl p-4 flex items-center justify-between">
                <div className="flex items-center gap-2">
                  <div className="w-9 h-9 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center">
                    <span className="text-white font-bold text-xs">{homeTeam?.name?.substring(0, 2).toUpperCase()}</span>
                  </div>
                  <span className="font-semibold text-[#011B3B] text-sm">{homeTeam?.name}</span>
                </div>
                <span className="text-gray-400 font-bold text-sm">VS</span>
                <div className="flex items-center gap-2">
                  <span className="font-semibold text-[#011B3B] text-sm">{awayTeam?.name}</span>
                  <div className="w-9 h-9 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                    <span className="text-white font-bold text-xs">{awayTeam?.name?.substring(0, 2).toUpperCase()}</span>
                  </div>
                </div>
              </div>
            )}

            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider flex items-center gap-1.5 pt-2">
              <Calendar className="w-3.5 h-3.5" /> When and where?
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
                  <option value="">Friendly (no tournament)</option>
                  {championships.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
                </select>
                <p className="text-xs text-gray-400 mt-1">Defaults to a friendly match unless you pick a tournament.</p>
              </div>
            </div>
          </div>
        )}

        {step === 1 && (
          <div className="space-y-6">
            <div className="space-y-4">
              <p className="text-xs font-bold text-gray-400 uppercase tracking-wider flex items-center gap-1.5">
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
                    <button type="button" onClick={() => setField('accessCode', generateAccessCode())} className="px-3 py-2 bg-gray-100 hover:bg-gray-200 rounded-lg transition-colors shrink-0" title="Regenerate">
                      <RefreshCw className="w-4 h-4 text-gray-600" />
                    </button>
                  </div>
                  {errors.accessCode && <p className="text-xs text-red-500 mt-1">{errors.accessCode}</p>}
                  <p className="text-xs text-gray-400 mt-1">Only the assigned moderator and admins can see this code.</p>
                </div>
              </div>
            </div>

            <div className="space-y-4">
              <p className="text-xs font-bold text-gray-400 uppercase tracking-wider flex items-center gap-1.5">
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
                <p className="text-xs text-amber-600">No official accounts yet — add one under Management &gt; Users.</p>
              )}
              <p className="text-xs text-gray-400">Judges can only score when the game timer is paused.</p>
            </div>
          </div>
        )}

        {step === 2 && (
          <div className="space-y-5">
            <p className="text-xs font-bold text-gray-400 uppercase tracking-wider flex items-center gap-1.5">
              <Check className="w-3.5 h-3.5" /> Review before creating
            </p>

            <div className="bg-gray-50 border border-gray-100 rounded-xl p-4 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <div className="w-9 h-9 bg-gradient-to-br from-[#FFC600] to-[#FF6B35] rounded-full flex items-center justify-center">
                  <span className="text-white font-bold text-xs">{homeTeam?.name?.substring(0, 2).toUpperCase()}</span>
                </div>
                <span className="font-semibold text-[#011B3B] text-sm">{homeTeam?.name}</span>
              </div>
              <span className="text-gray-400 font-bold text-sm">VS</span>
              <div className="flex items-center gap-2">
                <span className="font-semibold text-[#011B3B] text-sm">{awayTeam?.name}</span>
                <div className="w-9 h-9 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                  <span className="text-white font-bold text-xs">{awayTeam?.name?.substring(0, 2).toUpperCase()}</span>
                </div>
              </div>
            </div>

            <dl className="grid grid-cols-1 sm:grid-cols-2 gap-x-6 gap-y-3 text-sm">
              {[
                ['Date', form.date], ['Time', form.time], ['Venue', form.venue],
                ['Tournament', championship?.name || 'Friendly'],
                ['Moderator', moderator?.name || '—'], ['Access Code', form.accessCode],
              ].map(([label, value]) => (
                <div key={label} className="flex justify-between border-b border-gray-100 pb-2">
                  <dt className="text-gray-500" style={{ fontFamily: B }}>{label}</dt>
                  <dd className="text-[#011B3B] font-medium" style={{ fontFamily: B }}>{value}</dd>
                </div>
              ))}
            </dl>

            <div>
              <p className="text-xs text-gray-500 mb-1.5" style={{ fontFamily: B }}>Judges</p>
              <div className="flex flex-wrap gap-2">
                {form.judges.map((uid, i) => {
                  const j = judgeOptions.find((o) => o.uid === uid);
                  return (
                    <span key={i} className="text-xs bg-gray-100 text-gray-700 px-2.5 py-1 rounded-full" style={{ fontFamily: B }}>
                      {j?.name || '—'}
                    </span>
                  );
                })}
              </div>
            </div>

            {errors.submit && <p className="text-sm text-red-500">{errors.submit}</p>}
          </div>
        )}
      </div>

      {/* Footer nav */}
      <div className="flex gap-3 mt-5">
        <button
          onClick={step === 0 ? () => navigate('/games') : goBack}
          className="flex-1 sm:flex-initial px-6 py-2.5 border-2 border-gray-200 text-gray-700 font-semibold rounded-xl hover:bg-gray-100 transition-all text-sm"
          style={{ fontFamily: B }}
        >
          {step === 0 ? 'Cancel' : 'Back'}
        </button>
        {step < STEPS.length - 1 ? (
          <button
            onClick={goNext}
            className="flex-1 flex items-center justify-center gap-2 px-6 py-2.5 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-xl hover:shadow-lg transition-all text-sm"
            style={{ fontFamily: B }}
          >
            Next <ArrowRight className="w-4 h-4" />
          </button>
        ) : (
          <button
            onClick={handleCreate}
            disabled={saving}
            className="flex-1 flex items-center justify-center gap-2 px-6 py-2.5 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-xl hover:shadow-lg transition-all text-sm disabled:opacity-60"
            style={{ fontFamily: B }}
          >
            <Save className="w-4 h-4" /> {saving ? 'Creating…' : 'Create Game'}
          </button>
        )}
      </div>
    </section>
  );
};

export default CreateGamePage;
