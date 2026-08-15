import React, { useState, useEffect } from 'react';
import { Search, Filter, MoreVertical, Eye, X, UserCheck, ShieldAlert } from 'lucide-react';
import { collection, query, where, doc, updateDoc, onSnapshot, serverTimestamp } from 'firebase/firestore';
import { db } from '../../../lib/firebase';
import { useAuth } from '../../../context/AuthContext';
import { useGames } from '../../../context/GamesContext';
import { BRAND } from '../../../config/brand';
import Pagination, { paginate } from '../../../components/Pagination';
const B = BRAND.font.body;
const H = BRAND.font.heading;

// `status` isn't a field wao_mobile writes on official accounts today — it's
// a wao-web-only moderation flag layered on top of the shared `users`
// collection (see firestore.rules: an admin may update any field on any
// user doc). Docs created before this existed simply don't have it, so
// treat a missing value as 'active' rather than showing an empty badge.
const STATUS_STYLES = {
  active:    'bg-green-100 text-green-700',
  inactive:  'bg-gray-100 text-gray-500',
  suspended: 'bg-red-100 text-red-600',
};
const STATUSES = ['all', 'active', 'inactive', 'suspended'];

export default function Officials() {
  const { user } = useAuth();
  const isAdmin = user?.role === 'admin';
  const { games } = useGames();

  const [officials, setOfficials] = useState([]);
  const [loading, setLoading]     = useState(true);
  const [search, setSearch]       = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [menuOpen, setMenuOpen]   = useState(null);
  const [modal, setModal]         = useState(null); // 'view' | 'status'
  const [selected, setSelected]   = useState(null);
  const [newStatus, setNewStatus] = useState('active');
  const [saving, setSaving]       = useState(false);
  const [page, setPage]           = useState(1);

  useEffect(() => {
    const q = query(collection(db, 'users'), where('role', '==', 'official'));
    const unsub = onSnapshot(q, (snap) => {
      setOfficials(snap.docs.map(d => ({ id: d.id, ...d.data() })));
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

  // Real count, derived from live games rather than a stored/fabricated
  // number: how many matches list this official's uid in their judges panel.
  const gamesOfficiatedFor = (uid) =>
    games.filter(g => (g.judges || []).some(j => j.uid === uid)).length;

  const filtered = officials.filter(o => {
    const name = o.displayName || o.username || o.email || '';
    const matchSearch = name.toLowerCase().includes(search.toLowerCase()) ||
                        (o.email || '').toLowerCase().includes(search.toLowerCase());
    const status = o.status || 'active';
    const matchStatus = statusFilter === 'all' || status === statusFilter;
    return matchSearch && matchStatus;
  });
  const paged = paginate(filtered, page);
  const resetPage = () => setPage(1);

  const openView   = (o) => { setSelected(o); setModal('view'); setMenuOpen(null); };
  const openStatus = (o) => { setSelected(o); setNewStatus(o.status || 'active'); setModal('status'); setMenuOpen(null); };
  const closeModal = () => { setModal(null); setSelected(null); };

  const handleStatusChange = async () => {
    if (!selected) return;
    setSaving(true);
    try {
      await updateDoc(doc(db, 'users', selected.id), { status: newStatus, updatedAt: serverTimestamp() });
      closeModal();
    } catch (err) {
      console.error('Failed to update official status:', err);
    } finally {
      setSaving(false);
    }
  };

  return (
    <section className="px-2 py-2 md:p-4">
      {/* Header */}
      <div className="flex flex-col gap-3 py-4 md:py-8 md:flex-row md:items-center md:justify-between">
        <div>
          <h2 className="text-xl md:text-2xl text-[#011B3B] uppercase tracking-widest" style={{ fontFamily: H }}>Officials</h2>
          <p className="text-sm text-gray-500 mt-1" style={{ fontFamily: B }}>Accounts with the "official" role. Add new officials under Management &gt; Users.</p>
        </div>
      </div>

      <div className="bg-white border border-gray-100 px-3 py-5 md:px-5 md:py-8">
        {/* Filters */}
        <div className="flex flex-col md:flex-row gap-3 mb-6">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search by name or email..."
              value={search}
              onChange={e => { setSearch(e.target.value); resetPage(); }}
              className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm"
            />
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={statusFilter}
              onChange={e => { setStatusFilter(e.target.value); resetPage(); }}
              className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 appearance-none bg-white text-sm min-w-[160px] cursor-pointer"
            >
              {STATUSES.map(s => <option key={s} value={s}>{s === 'all' ? 'All Statuses' : s.charAt(0).toUpperCase() + s.slice(1)}</option>)}
            </select>
          </div>
        </div>

        {loading ? (
          <div className="text-center py-16 text-gray-400" style={{ fontFamily: B }}>Loading officials…</div>
        ) : (
          <>
            {/* Mobile cards */}
            <div className="md:hidden space-y-3">
              {paged.map(o => {
                const name = o.displayName || o.username || o.email;
                const status = o.status || 'active';
                return (
                  <div key={o.id} className="bg-white border border-gray-100 rounded-2xl shadow-sm p-4">
                    <div className="flex items-start justify-between">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-full flex items-center justify-center flex-shrink-0">
                          <span className="text-white font-bold text-xs">{name.substring(0, 2).toUpperCase()}</span>
                        </div>
                        <div>
                          <p className="font-bold text-[#011B3B] text-sm">{name}</p>
                          <p className="text-xs text-gray-500">{o.email}</p>
                        </div>
                      </div>
                      <div className="relative" data-actions-menu>
                        <button onClick={() => setMenuOpen(menuOpen === o.id ? null : o.id)} className="p-1.5 hover:bg-gray-100 rounded-lg">
                          <MoreVertical className="w-4 h-4 text-gray-500" />
                        </button>
                        {menuOpen === o.id && (
                          <div className="absolute right-0 mt-1 w-40 bg-white rounded-xl shadow-lg border border-gray-100 z-10" data-actions-menu>
                            <button onClick={() => openView(o)} className="w-full flex items-center gap-2 px-4 py-2.5 hover:bg-gray-50 text-sm"><Eye className="w-4 h-4 text-[#011B3B]" /> View</button>
                            {isAdmin && (
                              <button onClick={() => openStatus(o)} className="w-full flex items-center gap-2 px-4 py-2.5 hover:bg-gray-50 text-sm border-t border-gray-100"><ShieldAlert className="w-4 h-4 text-[#011B3B]" /> Change Status</button>
                            )}
                          </div>
                        )}
                      </div>
                    </div>
                    <div className="flex items-center gap-2 mt-3 pt-3 border-t border-gray-100">
                      <span className={`text-xs font-semibold px-2.5 py-1 rounded-full capitalize ${STATUS_STYLES[status]}`}>{status}</span>
                      <span className="text-xs text-gray-400 ml-auto">{gamesOfficiatedFor(o.id)} games</span>
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
                    {['Official', 'Email', 'Phone', 'Games', 'Status', 'Actions'].map(h => (
                      <th key={h} className="px-5 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider" style={{ fontFamily: B }}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {paged.map(o => {
                    const name = o.displayName || o.username || o.email;
                    const status = o.status || 'active';
                    return (
                      <tr key={o.id} className="hover:bg-gray-50 transition-colors">
                        <td className="px-5 py-4">
                          <div className="flex items-center gap-3">
                            <div className="w-9 h-9 bg-[#011B3B] flex items-center justify-center flex-shrink-0">
                              <span className="text-white font-medium text-xs" style={{ fontFamily: H }}>{name.substring(0, 2).toUpperCase()}</span>
                            </div>
                            <span className="font-medium text-[#011B3B] text-sm" style={{ fontFamily: B }}>{name}</span>
                          </div>
                        </td>
                        <td className="px-5 py-4 text-sm text-gray-600" style={{ fontFamily: B }}>{o.email}</td>
                        <td className="px-5 py-4 text-sm text-gray-600" style={{ fontFamily: B }}>{o.phone || '—'}</td>
                        <td className="px-5 py-4 text-sm font-semibold text-[#011B3B]" style={{ fontFamily: B }}>{gamesOfficiatedFor(o.id)}</td>
                        <td className="px-5 py-4">
                          <span className={`text-xs font-semibold px-2.5 py-1 rounded-full capitalize ${STATUS_STYLES[status]}`}>{status}</span>
                        </td>
                        <td className="px-5 py-4 relative" data-actions-menu>
                          <button onClick={() => setMenuOpen(menuOpen === o.id ? null : o.id)} className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                            <MoreVertical className="w-4 h-4 text-gray-600" />
                          </button>
                          {menuOpen === o.id && (
                            <div className="absolute right-0 mt-1 w-44 bg-white rounded-lg shadow-lg border border-gray-200 z-10" data-actions-menu>
                              <button onClick={() => openView(o)} className="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm"><Eye className="w-4 h-4 text-[#011B3B]" /> View Details</button>
                              {isAdmin && (
                                <button onClick={() => openStatus(o)} className="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm border-t border-gray-100"><ShieldAlert className="w-4 h-4 text-[#011B3B]" /> Change Status</button>
                              )}
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
                  <UserCheck className="w-10 h-10 mx-auto mb-2 opacity-40" />
                  <p className="text-sm">No officials found</p>
                </div>
              )}
            </div>
            <Pagination total={filtered.length} page={page} onChange={setPage} />
          </>
        )}
      </div>

      {/* View Modal */}
      {modal === 'view' && selected && (() => {
        const name = selected.displayName || selected.username || selected.email;
        const status = selected.status || 'active';
        return (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
            <div className="bg-white shadow-xl w-full max-w-sm p-6 relative">
              <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
              <div className="flex flex-col items-center mb-5">
                <div className="w-16 h-16 bg-[#011B3B] flex items-center justify-center mb-3">
                  <span className="text-white font-bold text-lg" style={{ fontFamily: H }}>{name.substring(0, 2).toUpperCase()}</span>
                </div>
                <h3 className="text-lg text-[#011B3B]" style={{ fontFamily: H }}>{name}</h3>
              </div>
              <div className="space-y-1 text-sm">
                {[
                  { label: 'Email',            value: selected.email },
                  { label: 'Phone',            value: selected.phone || '—' },
                  { label: 'Games Officiated', value: gamesOfficiatedFor(selected.id) },
                  { label: 'Status',           value: <span className={`capitalize font-semibold px-2 py-0.5 rounded-full text-xs ${STATUS_STYLES[status]}`}>{status}</span> },
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
            <p className="text-sm text-gray-500 mb-5" style={{ fontFamily: B }}>
              {selected.displayName || selected.username || selected.email}
            </p>
            <select
              value={newStatus}
              onChange={e => setNewStatus(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm bg-white"
              style={{ fontFamily: B }}
            >
              {['active', 'inactive', 'suspended'].map(s => <option key={s} value={s} className="capitalize">{s.charAt(0).toUpperCase() + s.slice(1)}</option>)}
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
