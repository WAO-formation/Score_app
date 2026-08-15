import React, { useState, useEffect, useMemo } from 'react';
import { Search, Filter, MoreVertical, Eye, ShieldAlert, X, User } from 'lucide-react';
import { collection, doc, updateDoc, onSnapshot, serverTimestamp } from 'firebase/firestore';
import { db } from '../../../lib/firebase';
import { BRAND } from '../../../config/brand';
import Pagination, { paginate } from '../../../components/Pagination';
const B = BRAND.font.body;
const H = BRAND.font.heading;

const STATUS_STYLES = {
  active:    'bg-green-100 text-green-700',
  inactive:  'bg-gray-100 text-gray-500',
  suspended: 'bg-red-100 text-red-600',
};

// wao_mobile/lib/Model/teams_games/team/wao_player.dart's PlayerRole enum.
// "Position" (Forward/Guard/Center) and per-player fouls/suspension dates
// from the old mock have no backing field anywhere in this schema — fouls
// are tracked per-match as name strings (matches.fouls), not linked to
// player docs — so those columns are dropped rather than faked.
const ROLES = ['all', 'king', 'worker', 'protague', 'antague', 'warrior', 'sacrificer', 'servitor', 'substitute'];
const roleLabel = (r) => r ? r.charAt(0).toUpperCase() + r.slice(1) : '—';

export default function Players() {
  const [players, setPlayers]     = useState([]);
  const [loading, setLoading]     = useState(true);
  const [search, setSearch]       = useState('');
  const [roleFilter, setRoleFilter] = useState('all');
  const [teamFilter, setTeamFilter] = useState('all');
  const [menuOpen, setMenuOpen]   = useState(null);
  const [modal, setModal]         = useState(null); // 'view' | 'status'
  const [selected, setSelected]   = useState(null);
  const [newStatus, setNewStatus] = useState('active');
  const [saving, setSaving]       = useState(false);
  const [page, setPage]           = useState(1);

  useEffect(() => {
    const unsub = onSnapshot(collection(db, 'players'), (snap) => {
      setPlayers(snap.docs.map(d => ({ id: d.id, ...d.data() })));
      setLoading(false);
    }, () => setLoading(false));
    return unsub;
  }, []);

  useEffect(() => {
    const closeMenu = (e) => {
      if (!e.target.closest('[data-actions-menu]')) setMenuOpen(null);
    };
    document.addEventListener('click', closeMenu);
    return () => document.removeEventListener('click', closeMenu);
  }, []);

  // Denormalized on the player doc already (currentTeamName) — no join needed.
  const TEAMS = useMemo(
    () => ['all', ...Array.from(new Set(players.map(p => p.currentTeamName).filter(Boolean))).sort()],
    [players]
  );

  const filtered = players.filter(p => {
    const matchSearch = (p.name || '').toLowerCase().includes(search.toLowerCase());
    const matchRole    = roleFilter === 'all' || p.role === roleFilter;
    const matchTeam    = teamFilter === 'all' || p.currentTeamName === teamFilter;
    return matchSearch && matchRole && matchTeam;
  });
  const paged = paginate(filtered, page);
  const resetPage = () => setPage(1);

  const openView   = (p) => { setSelected(p); setModal('view'); setMenuOpen(null); };
  const openStatus = (p) => { setSelected(p); setNewStatus(p.status || 'active'); setModal('status'); setMenuOpen(null); };
  const closeModal = () => { setModal(null); setSelected(null); };

  const handleStatusChange = async () => {
    if (!selected) return;
    setSaving(true);
    try {
      await updateDoc(doc(db, 'players', selected.id), { status: newStatus, updatedAt: serverTimestamp() });
      closeModal();
    } catch (err) {
      console.error('Failed to update player status:', err);
    } finally {
      setSaving(false);
    }
  };

  return (
    <section className="px-2 py-2 md:p-4">
      {/* Header */}
      <div className="flex flex-col gap-3 py-4 md:py-8 md:flex-row md:items-center md:justify-between">
        <div>
          <h2 className="text-xl md:text-2xl text-[#011B3B] uppercase tracking-widest" style={{ fontFamily: H }}>Players</h2>
          <p className="text-sm text-gray-500 mt-1" style={{ fontFamily: B }}>Global roster view across all teams. Add or remove players from a team's page.</p>
        </div>
      </div>

      <div className="bg-white border border-gray-100 px-3 py-5 md:px-5 md:py-8">
        {/* Filters */}
        <div className="flex flex-col md:flex-row gap-3 mb-6">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search players..."
              value={search}
              onChange={e => { setSearch(e.target.value); resetPage(); }}
              className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm"
            />
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={roleFilter}
              onChange={e => { setRoleFilter(e.target.value); resetPage(); }}
              className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 appearance-none bg-white text-sm min-w-[160px] cursor-pointer"
            >
              {ROLES.map(r => <option key={r} value={r}>{r === 'all' ? 'All Roles' : roleLabel(r)}</option>)}
            </select>
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={teamFilter}
              onChange={e => { setTeamFilter(e.target.value); resetPage(); }}
              className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 appearance-none bg-white text-sm min-w-[160px] cursor-pointer"
            >
              {TEAMS.map(t => <option key={t} value={t}>{t === 'all' ? 'All Teams' : t}</option>)}
            </select>
          </div>
        </div>

        {loading ? (
          <div className="text-center py-16 text-gray-400" style={{ fontFamily: B }}>Loading players…</div>
        ) : (
          <>
            {/* Mobile cards */}
            <div className="md:hidden space-y-3">
              {paged.map(p => {
                const status = p.status || 'active';
                return (
                  <div key={p.id} className="bg-white border border-gray-100 rounded-2xl shadow-sm p-4">
                    <div className="flex items-start justify-between">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center flex-shrink-0">
                          <span className="text-white font-bold text-xs">{(p.name || '?').substring(0, 2).toUpperCase()}</span>
                        </div>
                        <div>
                          <p className="font-bold text-[#011B3B] text-sm">{p.name}</p>
                          <p className="text-xs text-gray-500">{p.currentTeamName || 'No team'}</p>
                        </div>
                      </div>
                      <div className="relative" data-actions-menu>
                        <button onClick={() => setMenuOpen(menuOpen === p.id ? null : p.id)} className="p-1.5 hover:bg-gray-100 rounded-lg">
                          <MoreVertical className="w-4 h-4 text-gray-500" />
                        </button>
                        {menuOpen === p.id && (
                          <div className="absolute right-0 mt-1 w-40 bg-white rounded-xl shadow-lg border border-gray-100 z-10" data-actions-menu>
                            <button onClick={() => openView(p)} className="w-full flex items-center gap-2 px-4 py-2.5 hover:bg-gray-50 text-sm"><Eye className="w-4 h-4 text-[#011B3B]" /> View</button>
                            <button onClick={() => openStatus(p)} className="w-full flex items-center gap-2 px-4 py-2.5 hover:bg-gray-50 text-sm border-t border-gray-100"><ShieldAlert className="w-4 h-4 text-[#011B3B]" /> Change Status</button>
                          </div>
                        )}
                      </div>
                    </div>
                    <div className="flex items-center gap-2 mt-3 pt-3 border-t border-gray-100">
                      <span className="text-xs bg-purple-100 text-purple-700 font-semibold px-2.5 py-1 rounded-full">{roleLabel(p.role)}</span>
                      <span className={`text-xs font-semibold px-2.5 py-1 rounded-full capitalize ${STATUS_STYLES[status]}`}>{status}</span>
                      <span className="text-xs text-gray-400 ml-auto">{p.gamesPlayed ?? 0} games</span>
                    </div>
                  </div>
                );
              })}
            </div>

            {/* Desktop table */}
            <div className="hidden md:block overflow-x-auto">
              <table className="w-full">
                <thead className="bg-gray-50 border-b border-gray-200">
                  <tr>
                    {['Player', 'Team', 'Role', 'Games Played', 'Status', 'Actions'].map(h => (
                      <th key={h} className="px-5 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider" style={{ fontFamily: B }}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {paged.map(p => {
                    const status = p.status || 'active';
                    return (
                      <tr key={p.id} className="hover:bg-gray-50 transition-colors">
                        <td className="px-5 py-4">
                          <div className="flex items-center gap-3">
                            <div className="w-9 h-9 bg-[#c81434] flex items-center justify-center flex-shrink-0">
                              <span className="text-white font-bold text-xs" style={{ fontFamily: H }}>{(p.name || '?').substring(0, 2).toUpperCase()}</span>
                            </div>
                            <span className="font-medium text-[#011B3B] text-sm" style={{ fontFamily: B }}>{p.name}</span>
                          </div>
                        </td>
                        <td className="px-5 py-4 text-sm text-gray-600" style={{ fontFamily: B }}>{p.currentTeamName || '—'}</td>
                        <td className="px-5 py-4">
                          <span className="text-xs bg-purple-100 text-purple-700 font-semibold px-2.5 py-1 rounded-full">{roleLabel(p.role)}</span>
                        </td>
                        <td className="px-5 py-4 text-sm font-bold text-[#011B3B]">{p.gamesPlayed ?? 0}</td>
                        <td className="px-5 py-4">
                          <span className={`text-xs font-semibold px-2.5 py-1 rounded-full capitalize ${STATUS_STYLES[status]}`}>{status}</span>
                        </td>
                        <td className="px-5 py-4 relative" data-actions-menu>
                          <button onClick={() => setMenuOpen(menuOpen === p.id ? null : p.id)} className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                            <MoreVertical className="w-4 h-4 text-gray-600" />
                          </button>
                          {menuOpen === p.id && (
                            <div className="absolute right-0 mt-1 w-44 bg-white rounded-lg shadow-lg border border-gray-200 z-10" data-actions-menu>
                              <button onClick={() => openView(p)} className="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm"><Eye className="w-4 h-4 text-[#011B3B]" /> View Details</button>
                              <button onClick={() => openStatus(p)} className="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm border-t border-gray-100"><ShieldAlert className="w-4 h-4 text-[#011B3B]" /> Change Status</button>
                            </div>
                          )}
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
              {filtered.length === 0 && (
                <div className="text-center py-12 text-gray-400">
                  <User className="w-10 h-10 mx-auto mb-2 opacity-40" />
                  <p className="text-sm">No players found</p>
                </div>
              )}
            </div>
            <Pagination total={filtered.length} page={page} onChange={setPage} />
          </>
        )}
      </div>

      {/* View Modal */}
      {modal === 'view' && selected && (() => {
        const status = selected.status || 'active';
        return (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
            <div className="bg-white shadow-xl w-full max-w-sm p-6 relative">
              <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
              <div className="flex flex-col items-center mb-5">
                <div className="w-16 h-16 bg-[#c81434] flex items-center justify-center mb-3">
                  <span className="text-white font-bold text-lg" style={{ fontFamily: H }}>{(selected.name || '?').substring(0, 2).toUpperCase()}</span>
                </div>
                <h3 className="text-lg text-[#011B3B]" style={{ fontFamily: H }}>{selected.name}</h3>
                <span className="text-xs bg-purple-100 text-purple-700 font-semibold px-2.5 py-1 rounded-full mt-1">{roleLabel(selected.role)}</span>
              </div>
              <div className="space-y-1 text-sm">
                {[
                  { label: 'Team',          value: selected.currentTeamName || '—' },
                  { label: 'Jersey Number', value: selected.jerseyNumber ?? '—' },
                  { label: 'Age',           value: selected.age ?? '—' },
                  { label: 'Games Played',  value: selected.gamesPlayed ?? 0 },
                  { label: 'Goals Scored',  value: selected.goalsScored ?? 0 },
                  { label: 'Assists',       value: selected.assists ?? 0 },
                  { label: 'Status',        value: <span className={`capitalize font-semibold px-2 py-0.5 rounded-full text-xs ${STATUS_STYLES[status]}`}>{status}</span> },
                ].map(({ label, value }) => (
                  <div key={label} className="flex justify-between py-2.5 border-b border-gray-100">
                    <span className="text-gray-500">{label}</span>
                    <span className="font-medium text-[#011B3B]">{value}</span>
                  </div>
                ))}
              </div>
              <button onClick={closeModal} className="w-full mt-5 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] text-sm" style={{ fontFamily: B }}>Close</button>
            </div>
          </div>
        );
      })()}

      {/* Change Status Modal */}
      {modal === 'status' && selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white shadow-xl w-full max-w-sm p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <h3 className="text-lg text-[#011B3B] mb-1 uppercase tracking-widest" style={{ fontFamily: H }}>Change Status</h3>
            <p className="text-sm text-gray-500 mb-5" style={{ fontFamily: B }}>{selected.name}</p>
            <select
              value={newStatus}
              onChange={e => setNewStatus(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm bg-white"
              style={{ fontFamily: B }}
            >
              {['active', 'inactive', 'suspended'].map(s => <option key={s} value={s}>{s.charAt(0).toUpperCase() + s.slice(1)}</option>)}
            </select>
            <div className="flex gap-3 mt-6">
              <button onClick={closeModal} className="flex-1 py-2.5 border border-gray-300 text-gray-700 font-semibold hover:bg-gray-50 text-sm" style={{ fontFamily: B }}>Cancel</button>
              <button onClick={handleStatusChange} disabled={saving} className="flex-1 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] text-sm disabled:opacity-50" style={{ fontFamily: B }}>
                {saving ? 'Saving…' : 'Save'}
              </button>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
