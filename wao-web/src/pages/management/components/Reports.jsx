import React, { useState, useEffect } from 'react';
import { Search, Filter, Eye, Plus, Trash2, X, FileText, CheckCircle, Clock, AlertCircle } from 'lucide-react';
import { useAuth } from '../../../context/AuthContext';
import { useGames } from '../../../context/GamesContext';
import { subscribeToReports, createReport, updateReportStatus, deleteReport } from '../../../services/reportsService';
import { BRAND } from '../../../config/brand';
const B = BRAND.font.body;
const H = BRAND.font.heading;

const STATUS_STYLES = {
  pending:  { style: 'bg-yellow-100 text-yellow-700', icon: Clock },
  reviewed: { style: 'bg-blue-100 text-blue-700',   icon: Eye },
  resolved: { style: 'bg-green-100 text-green-700', icon: CheckCircle },
};

const TYPE_STYLES = {
  'Foul Report':        'bg-red-100 text-red-700',
  'Misconduct':         'bg-orange-100 text-orange-700',
  'Score Dispute':      'bg-purple-100 text-purple-700',
  'Official Complaint': 'bg-gray-100 text-gray-700',
};

const STATUSES = ['all', 'pending', 'reviewed', 'resolved'];
const TYPES    = ['Foul Report', 'Misconduct', 'Score Dispute', 'Official Complaint'];

const formatDate = (d) => d ? d.toISOString().slice(0, 10) : '—';

export default function Reports() {
  const { user } = useAuth();
  const isAdmin = user?.role === 'admin';
  const { games } = useGames();

  const [reports, setReports]       = useState([]);
  const [loading, setLoading]       = useState(true);
  const [search, setSearch]         = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [typeFilter, setTypeFilter] = useState('all');
  const [modal, setModal]           = useState(null); // 'add' | 'view' | 'status'
  const [selected, setSelected]     = useState(null);
  const [saving, setSaving]         = useState(false);
  const [form, setForm]             = useState({ matchId: '', type: TYPES[0], description: '' });

  useEffect(() => {
    return subscribeToReports(
      (list) => { setReports(list); setLoading(false); },
      (err) => { console.error('Failed to load reports:', err); setLoading(false); }
    );
  }, []);

  const filtered = reports.filter(r => {
    const matchSearch = r.matchLabel.toLowerCase().includes(search.toLowerCase()) ||
                        r.type.toLowerCase().includes(search.toLowerCase());
    const matchStatus = statusFilter === 'all' || r.status === statusFilter;
    const matchType   = typeFilter === 'all' || r.type === typeFilter;
    return matchSearch && matchStatus && matchType;
  });

  const openAdd         = () => { setForm({ matchId: games[0]?.id || '', type: TYPES[0], description: '' }); setModal('add'); };
  const openView        = (r) => { setSelected(r); setModal('view'); };
  const openEditStatus  = (r) => { setSelected(r); setModal('status'); };
  const closeModal      = () => { setModal(null); setSelected(null); };

  const handleCreate = async () => {
    if (!form.matchId || !form.description.trim()) return;
    setSaving(true);
    try {
      const game = games.find(g => g.id === form.matchId);
      await createReport({
        matchId: form.matchId,
        matchLabel: game ? `${game.homeTeam} vs ${game.awayTeam}` : '',
        type: form.type,
        description: form.description.trim(),
        createdBy: user?.uid || '',
        createdByName: user?.displayName || '',
      });
      closeModal();
    } catch (err) {
      console.error('Failed to create report:', err);
    } finally {
      setSaving(false);
    }
  };

  const handleStatusChange = async (newStatus) => {
    if (!selected) return;
    setSaving(true);
    try {
      await updateReportStatus(selected.id, newStatus);
      closeModal();
    } catch (err) {
      console.error('Failed to update report status:', err);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async (r) => {
    try {
      await deleteReport(r.id);
      if (selected?.id === r.id) closeModal();
    } catch (err) {
      console.error('Failed to delete report:', err);
    }
  };

  const stats = {
    pending:  reports.filter(r => r.status === 'pending').length,
    reviewed: reports.filter(r => r.status === 'reviewed').length,
    resolved: reports.filter(r => r.status === 'resolved').length,
  };

  return (
    <section className="px-2 py-2 md:p-4">
      <div className="flex flex-col gap-3 py-4 md:py-8 md:flex-row md:items-center md:justify-between">
        <h2 className="text-xl md:text-2xl text-[#011B3B] uppercase tracking-widest" style={{ fontFamily: H }}>Reports</h2>
        <button
          onClick={openAdd}
          className="flex items-center gap-2 px-5 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] transition-all text-sm"
          style={{ fontFamily: B }}
        >
          <Plus className="w-4 h-4" /> New Report
        </button>
      </div>

      {/* Stats */}
      <div className="grid grid-cols-3 gap-3 mb-6">
        {[
          { label: 'Pending',  count: stats.pending,  color: 'from-yellow-400 to-yellow-500', icon: Clock },
          { label: 'Reviewed', count: stats.reviewed, color: 'from-blue-500 to-blue-600',     icon: Eye },
          { label: 'Resolved', count: stats.resolved, color: 'from-green-500 to-green-600',   icon: CheckCircle },
        ].map(({ label, count, color, icon: Icon }) => (
          <div key={label} className={`bg-gradient-to-br ${color} rounded-xl p-4 text-white`}>
            <div className="flex items-center justify-between mb-1">
              <span className="text-xs font-semibold opacity-80">{label}</span>
              <Icon className="w-4 h-4 opacity-80" />
            </div>
            <p className="text-2xl font-bold">{count}</p>
          </div>
        ))}
      </div>

      <div className="bg-white border border-gray-100 px-3 py-5 md:px-5 md:py-8">
        {/* Filters */}
        <div className="flex flex-col md:flex-row gap-3 mb-6">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search by game or type..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm"
            />
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={typeFilter}
              onChange={e => setTypeFilter(e.target.value)}
              className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 appearance-none bg-white text-sm min-w-[180px] cursor-pointer"
            >
              <option value="all">All Types</option>
              {TYPES.map(t => <option key={t} value={t}>{t}</option>)}
            </select>
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={statusFilter}
              onChange={e => setStatusFilter(e.target.value)}
              className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 appearance-none bg-white text-sm min-w-[160px] cursor-pointer"
            >
              {STATUSES.map(s => <option key={s} value={s}>{s === 'all' ? 'All Statuses' : s.charAt(0).toUpperCase() + s.slice(1)}</option>)}
            </select>
          </div>
        </div>

        {loading ? (
          <div className="text-center py-16 text-gray-400" style={{ fontFamily: B }}>Loading reports…</div>
        ) : (
          <>
            {/* Mobile cards */}
            <div className="md:hidden space-y-3">
              {filtered.map(r => {
                const { style, icon: StatusIcon } = STATUS_STYLES[r.status] || STATUS_STYLES.pending;
                return (
                  <div key={r.id} className="bg-white border border-gray-100 rounded-2xl shadow-sm p-4">
                    <div className="flex items-start justify-between gap-2 mb-3">
                      <div>
                        <span className={`text-xs font-semibold px-2.5 py-1 rounded-full ${TYPE_STYLES[r.type] ?? 'bg-gray-100 text-gray-600'}`}>{r.type}</span>
                        <p className="font-semibold text-[#011B3B] text-sm mt-2">{r.matchLabel || 'Unlinked'}</p>
                        <p className="text-xs text-gray-400 mt-0.5">{formatDate(r.createdAt)}</p>
                      </div>
                      <span className={`flex items-center gap-1 text-xs font-semibold px-2.5 py-1 rounded-full capitalize flex-shrink-0 ${style}`}>
                        <StatusIcon className="w-3 h-3" />{r.status}
                      </span>
                    </div>
                    <p className="text-xs text-gray-500 line-clamp-2 mb-3">{r.description}</p>
                    <div className="flex gap-2 pt-3 border-t border-gray-100">
                      <button onClick={() => openView(r)} className="flex-1 py-1.5 text-xs font-semibold border border-gray-300 rounded-lg hover:bg-gray-50 text-[#011B3B]">View</button>
                      <button onClick={() => openEditStatus(r)} className="flex-1 py-1.5 text-xs font-semibold bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white rounded-lg">Update Status</button>
                      {isAdmin && (
                        <button onClick={() => handleDelete(r)} className="px-3 py-1.5 text-xs font-semibold border border-red-200 text-[#D30336] rounded-lg hover:bg-red-50"><Trash2 className="w-3.5 h-3.5" /></button>
                      )}
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
                    {['Type', 'Game', 'Date', 'Description', 'Status', 'Actions'].map(h => (
                      <th key={h} className="px-5 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider" style={{ fontFamily: B }}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {filtered.map(r => {
                    const { style, icon: StatusIcon } = STATUS_STYLES[r.status] || STATUS_STYLES.pending;
                    return (
                      <tr key={r.id} className="hover:bg-gray-50 transition-colors">
                        <td className="px-5 py-4">
                          <span className={`text-xs font-semibold px-2.5 py-1 rounded-full ${TYPE_STYLES[r.type] ?? 'bg-gray-100 text-gray-600'}`}>{r.type}</span>
                        </td>
                        <td className="px-5 py-4 text-sm font-medium text-[#011B3B]" style={{ fontFamily: B }}>{r.matchLabel || 'Unlinked'}</td>
                        <td className="px-5 py-4 text-sm text-gray-500" style={{ fontFamily: B }}>{formatDate(r.createdAt)}</td>
                        <td className="px-5 py-4 text-sm text-gray-500 max-w-xs truncate" style={{ fontFamily: B }}>{r.description}</td>
                        <td className="px-5 py-4">
                          <span className={`flex items-center gap-1 w-fit text-xs font-semibold px-2.5 py-1 rounded-full capitalize ${style}`}>
                            <StatusIcon className="w-3 h-3" />{r.status}
                          </span>
                        </td>
                        <td className="px-5 py-4">
                          <div className="flex items-center gap-2">
                            <button onClick={() => openView(r)} className="p-1.5 hover:bg-gray-100 rounded-lg transition-colors" title="View">
                              <Eye className="w-4 h-4 text-[#011B3B]" />
                            </button>
                            <button onClick={() => openEditStatus(r)} className="text-xs font-semibold px-3 py-1.5 bg-[#011B3B] text-white hover:bg-[#022d5f] transition-all" style={{ fontFamily: B }}>
                              Update
                            </button>
                            {isAdmin && (
                              <button onClick={() => handleDelete(r)} className="p-1.5 hover:bg-red-50 rounded-lg transition-colors" title="Delete">
                                <Trash2 className="w-4 h-4 text-[#D30336]" />
                              </button>
                            )}
                          </div>
                        </td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
              {filtered.length === 0 && (
                <div className="text-center py-12 text-gray-400">
                  <FileText className="w-10 h-10 mx-auto mb-2 opacity-40" />
                  <p className="text-sm">No reports found</p>
                </div>
              )}
            </div>
          </>
        )}
      </div>

      {/* Add Report Modal */}
      {modal === 'add' && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white shadow-xl w-full max-w-md p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <h3 className="text-lg text-[#011B3B] mb-5 uppercase tracking-widest" style={{ fontFamily: H }}>New Report</h3>
            <div className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Game</label>
                <select
                  value={form.matchId}
                  onChange={e => setForm({ ...form, matchId: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm bg-white"
                  style={{ fontFamily: B }}
                >
                  <option value="">Select game</option>
                  {games.map(g => <option key={g.id} value={g.id}>{g.homeTeam} vs {g.awayTeam} — {g.date}</option>)}
                </select>
                {games.length === 0 && <p className="text-xs text-amber-600 mt-1">No games yet — create one under Games first.</p>}
              </div>
              <div>
                <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Type</label>
                <select
                  value={form.type}
                  onChange={e => setForm({ ...form, type: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm bg-white"
                  style={{ fontFamily: B }}
                >
                  {TYPES.map(t => <option key={t} value={t}>{t}</option>)}
                </select>
              </div>
              <div>
                <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Description</label>
                <textarea
                  rows={4}
                  placeholder="Describe what happened..."
                  value={form.description}
                  onChange={e => setForm({ ...form, description: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm resize-none"
                  style={{ fontFamily: B }}
                />
              </div>
            </div>
            <div className="flex gap-3 mt-6">
              <button onClick={closeModal} className="flex-1 py-2.5 border border-gray-300 text-gray-700 font-semibold hover:bg-gray-50 text-sm" style={{ fontFamily: B }}>Cancel</button>
              <button onClick={handleCreate} disabled={saving || !form.matchId || !form.description.trim()} className="flex-1 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] text-sm disabled:opacity-50" style={{ fontFamily: B }}>
                {saving ? 'Submitting…' : 'Submit Report'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* View Modal */}
      {modal === 'view' && selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white shadow-xl w-full max-w-md p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <div className="flex items-center gap-3 mb-5">
              <div className="w-12 h-12 bg-gray-100 rounded-xl flex items-center justify-center">
                <AlertCircle className="w-6 h-6 text-[#011B3B]" />
              </div>
              <div>
                <span className={`text-xs font-semibold px-2.5 py-1 rounded-full ${TYPE_STYLES[selected.type] ?? 'bg-gray-100 text-gray-600'}`}>{selected.type}</span>
                <p className="font-bold text-[#011B3B] mt-1">{selected.matchLabel || 'Unlinked'}</p>
              </div>
            </div>
            <div className="space-y-1 text-sm mb-5">
              {[
                { label: 'Date',       value: formatDate(selected.createdAt) },
                { label: 'Filed By',   value: selected.createdByName || '—' },
                { label: 'Status',     value: <span className={`capitalize font-semibold px-2 py-0.5 rounded-full text-xs ${(STATUS_STYLES[selected.status] || STATUS_STYLES.pending).style}`}>{selected.status}</span> },
              ].map(({ label, value }) => (
                <div key={label} className="flex justify-between py-2.5 border-b border-gray-100">
                  <span className="text-gray-500">{label}</span>
                  <span className="font-medium text-[#011B3B]">{value}</span>
                </div>
              ))}
            </div>
            <div className="bg-gray-50 rounded-xl p-4">
              <p className="text-xs font-semibold text-gray-500 uppercase tracking-wide mb-2">Description</p>
              <p className="text-sm text-gray-700">{selected.description}</p>
            </div>
            <div className="flex gap-3 mt-5">
              {isAdmin && (
                <button onClick={() => handleDelete(selected)} className="py-2.5 px-4 border border-red-200 text-[#D30336] font-semibold hover:bg-red-50 text-sm" style={{ fontFamily: B }}>Delete</button>
              )}
              <button onClick={closeModal} className="flex-1 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] text-sm" style={{ fontFamily: B }}>Close</button>
            </div>
          </div>
        </div>
      )}

      {/* Update Status Modal */}
      {modal === 'status' && selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white shadow-xl w-full max-w-sm p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <h3 className="text-lg text-[#011B3B] mb-1 uppercase tracking-widest" style={{ fontFamily: H }}>Update Status</h3>
            <p className="text-sm text-gray-500 mb-5" style={{ fontFamily: B }}>{selected.matchLabel || 'Unlinked'}</p>
            <div className="space-y-2">
              {['pending', 'reviewed', 'resolved'].map(s => {
                const { style, icon: StatusIcon } = STATUS_STYLES[s];
                return (
                  <button
                    key={s}
                    disabled={saving}
                    onClick={() => handleStatusChange(s)}
                    className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl border-2 transition-all text-sm font-semibold capitalize disabled:opacity-50 ${
                      selected.status === s ? 'border-[#011B3B] bg-gray-50' : 'border-gray-200 hover:border-gray-300'
                    }`}
                  >
                    <span className={`flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs ${style}`}>
                      <StatusIcon className="w-3 h-3" />{s}
                    </span>
                    {selected.status === s && <span className="ml-auto text-xs text-gray-400">current</span>}
                  </button>
                );
              })}
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
