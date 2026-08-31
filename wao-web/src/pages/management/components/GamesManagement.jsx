import React, { useState } from 'react';
import { Search, Filter, Trash2, X, Trophy, MapPin, Calendar, Radio, CheckCircle, AlertTriangle, PauseCircle, Ban, Eye, Clock } from 'lucide-react';
import { useGames } from '../../../context/GamesContext';

const STATUS_CONFIG = {
  upcoming:   { style: 'bg-blue-100 text-blue-700',    icon: Calendar,     label: 'Upcoming' },
  live:       { style: 'bg-red-100 text-[#D30336]',    icon: Radio,        label: 'Live' },
  completed:  { style: 'bg-green-100 text-green-700',  icon: CheckCircle,  label: 'Completed' },
  postponed:  { style: 'bg-yellow-100 text-yellow-700',icon: PauseCircle,  label: 'Postponed' },
  suspended:  { style: 'bg-orange-100 text-orange-700',icon: AlertTriangle, label: 'Suspended' },
  cancelled:  { style: 'bg-gray-100 text-gray-600',    icon: Ban,          label: 'Cancelled' },
};

const STATUSES = ['all', 'upcoming', 'live', 'completed', 'postponed', 'suspended', 'cancelled'];
const CHANGE_STATUSES = ['postponed', 'suspended', 'cancelled'];

export default function GamesManagement() {
  const { games, deleteGame, updateGame } = useGames();
  const [search, setSearch]       = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [modal, setModal]         = useState(null); // 'delete' | 'status'
  const [selected, setSelected]   = useState(null);
  const [newStatus, setNewStatus] = useState('');
  const [reason, setReason]       = useState('');

  const filtered = games.filter(g => {
    const matchSearch = g.homeTeam.toLowerCase().includes(search.toLowerCase()) ||
                        g.awayTeam.toLowerCase().includes(search.toLowerCase()) ||
                        g.venue.toLowerCase().includes(search.toLowerCase());
    const matchStatus = statusFilter === 'all' || g.status?.toLowerCase() === statusFilter;
    return matchSearch && matchStatus;
  });

  const openDelete = (g) => { setSelected(g); setModal('delete'); };
  const openStatus = (g) => { setSelected(g); setNewStatus('postponed'); setReason(''); setModal('status'); };
  const openView   = (g) => { setSelected(g); setModal('view'); };
  const closeModal = () => { setSelected(null); setModal(null); setReason(''); };

  const handleDelete = () => {
    if (!selected) return;
    const id = selected.id;
    closeModal();
    deleteGame(id);
  };

  const handleStatusChange = () => {
    if (!selected || !newStatus || !reason.trim()) return;
    updateGame(selected.id, { status: newStatus, statusReason: reason.trim() });
    closeModal();
  };

  return (
    <section className="px-2 py-2 md:p-4">
      <div className="py-4 md:py-8">
        <h2 className="text-lg md:text-2xl font-bold text-[#011B3B]">Games Management</h2>
        <p className="text-sm text-gray-500 mt-1">Delete games that should no longer be accessible.</p>
      </div>

      <div className="bg-white rounded-lg shadow-sm px-3 py-5 md:px-5 md:py-8">
        {/* Filters */}
        <div className="flex flex-col md:flex-row gap-3 mb-6">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search by team or venue..."
              value={search}
              onChange={e => setSearch(e.target.value)}
              className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm"
            />
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

        {/* Mobile cards */}
        <div className="md:hidden space-y-3">
          {filtered.map(g => {
            const cfg = STATUS_CONFIG[g.status?.toLowerCase()] ?? STATUS_CONFIG['upcoming'];
            const { style, icon: StatusIcon, label } = cfg;
            return (
              <div key={g.id} className="bg-white border border-gray-100 rounded-2xl shadow-sm p-4">
                <div className="flex items-start justify-between gap-2">
                  <div className="flex-1 min-w-0">
                    <div className="flex items-center gap-2 mb-2">
                      <span className={`flex items-center gap-1 text-xs font-semibold px-2.5 py-1 rounded-full ${style}`}>
                        <StatusIcon className="w-3 h-3" />{label}
                      </span>
                      <span className="text-xs text-gray-400">{g.championship}</span>
                    </div>
                    <p className="font-bold text-[#011B3B] text-sm truncate">{g.homeTeam} vs {g.awayTeam}</p>
                    <div className="flex items-center gap-3 mt-1 text-xs text-gray-400">
                      <span className="flex items-center gap-1"><MapPin className="w-3 h-3" />{g.venue}</span>
                      <span className="flex items-center gap-1"><Calendar className="w-3 h-3" />{g.date}</span>
                    </div>
                  </div>
                  <button onClick={() => openView(g)} className="p-2 hover:bg-gray-100 rounded-lg transition-colors flex-shrink-0" title="View Details">
                    <Eye className="w-4 h-4 text-[#011B3B]" />
                  </button>
                  <button onClick={() => openStatus(g)} className="p-2 hover:bg-yellow-50 rounded-lg transition-colors flex-shrink-0" title="Change Status">
                    <AlertTriangle className="w-4 h-4 text-yellow-600" />
                  </button>
                  <button onClick={() => openDelete(g)} className="p-2 hover:bg-red-50 rounded-lg transition-colors flex-shrink-0">
                    <Trash2 className="w-4 h-4 text-[#D30336]" />
                  </button>
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
                {['Game', 'Championship', 'Venue', 'Date', 'Score', 'Status', 'Actions'].map(h => (
                  <th key={h} className="px-5 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">{h}</th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filtered.map(g => {
                const { style, icon: StatusIcon, label } = STATUS_CONFIG[g.status?.toLowerCase()] ?? STATUS_CONFIG['upcoming'];
                return (
                  <tr key={g.id} className="hover:bg-gray-50 transition-colors">
                    <td className="px-5 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-9 h-9 bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-full flex items-center justify-center flex-shrink-0">
                          <Trophy className="w-4 h-4 text-white" />
                        </div>
                        <div>
                          <p className="font-medium text-[#011B3B] text-sm">{g.homeTeam}</p>
                          <p className="text-xs text-gray-400">vs {g.awayTeam}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-5 py-4 text-sm text-gray-600">{g.championship}</td>
                    <td className="px-5 py-4 text-sm text-gray-600">{g.venue}</td>
                    <td className="px-5 py-4 text-sm text-gray-500">{g.date} · {g.time}</td>
                    <td className="px-5 py-4 text-sm font-bold text-[#011B3B]">
                      {g.status === 'upcoming' ? '—' : `${g.homeScore} - ${g.awayScore}`}
                    </td>
                    <td className="px-5 py-4">
                      <span className={`flex items-center gap-1 w-fit text-xs font-semibold px-2.5 py-1 rounded-full ${style}`}>
                        <StatusIcon className="w-3 h-3" />{label}
                      </span>
                    </td>
                    <td className="px-5 py-4">
                      <div className="flex items-center gap-2">
                        <button onClick={() => openView(g)} className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold text-[#011B3B] border border-gray-300 rounded-lg hover:bg-gray-50 transition-colors">
                          <Eye className="w-3.5 h-3.5" /> View
                        </button>
                        <button onClick={() => openStatus(g)} className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold text-yellow-700 border border-yellow-300 rounded-lg hover:bg-yellow-50 transition-colors">
                          <AlertTriangle className="w-3.5 h-3.5" /> Status
                        </button>
                        <button onClick={() => openDelete(g)} className="flex items-center gap-1.5 px-3 py-1.5 text-xs font-semibold text-[#D30336] border border-[#D30336]/30 rounded-lg hover:bg-red-50 transition-colors">
                          <Trash2 className="w-3.5 h-3.5" /> Delete
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
          {filtered.length === 0 && (
            <div className="text-center py-12 text-gray-400">
              <Trophy className="w-10 h-10 mx-auto mb-2 opacity-40" />
              <p className="text-sm">No games found</p>
            </div>
          )}
        </div>
      </div>

      {/* View Details Modal */}
      {modal === 'view' && selected && (() => {
        const { style, icon: StatusIcon, label } = STATUS_CONFIG[selected.status?.toLowerCase()] ?? STATUS_CONFIG['upcoming'];
        return (
          <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
            <div className="bg-white rounded-xl shadow-xl w-full max-w-md p-6 relative">
              <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
              <div className="flex items-center gap-3 mb-5">
                <div className="w-12 h-12 bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-xl flex items-center justify-center flex-shrink-0">
                  <Trophy className="w-6 h-6 text-white" />
                </div>
                <div>
                  <p className="font-bold text-[#011B3B]">{selected.homeTeam} vs {selected.awayTeam}</p>
                  <span className={`flex items-center gap-1 w-fit text-xs font-semibold px-2.5 py-1 rounded-full mt-1 ${style}`}>
                    <StatusIcon className="w-3 h-3" />{label}
                  </span>
                </div>
              </div>

              <div className="space-y-1 text-sm mb-4">
                {[
                  { label: 'Championship', value: selected.championship },
                  { label: 'Venue',        value: <span className="flex items-center gap-1"><MapPin className="w-3 h-3" />{selected.venue}</span> },
                  { label: 'Date & Time',  value: <span className="flex items-center gap-1"><Clock className="w-3 h-3" />{selected.date} · {selected.time}</span> },
                  { label: 'Score',        value: selected.status === 'upcoming' ? '—' : `${selected.homeScore} - ${selected.awayScore}` },
                ].map(({ label, value }) => (
                  <div key={label} className="flex justify-between py-2.5 border-b border-gray-100">
                    <span className="text-gray-500">{label}</span>
                    <span className="font-medium text-[#011B3B]">{value}</span>
                  </div>
                ))}
              </div>

              {selected.statusReason && (
                <div className="bg-yellow-50 border border-yellow-200 rounded-xl p-4">
                  <p className="text-xs font-semibold text-yellow-700 uppercase tracking-wide mb-1">Status Reason</p>
                  <p className="text-sm text-yellow-900">{selected.statusReason}</p>
                </div>
              )}

              <button onClick={closeModal} className="w-full mt-5 py-2.5 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg text-sm">Close</button>
            </div>
          </div>
        );
      })()}

      {/* Change Status Modal */}
      {modal === 'status' && selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-sm p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <h3 className="text-lg font-bold text-[#011B3B] mb-1">Change Game Status</h3>
            <p className="text-sm text-gray-500 mb-5">{selected.homeTeam} vs {selected.awayTeam}</p>
            <div className="space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">New Status</label>
                <div className="grid grid-cols-3 gap-2">
                  {CHANGE_STATUSES.map(s => {
                    const { style, icon: Icon, label } = STATUS_CONFIG[s];
                    return (
                      <button
                        key={s}
                        onClick={() => setNewStatus(s)}
                        className={`flex flex-col items-center gap-1.5 p-3 rounded-xl border-2 transition-all text-xs font-semibold ${
                          newStatus === s ? 'border-[#011B3B] bg-gray-50' : 'border-gray-200 hover:border-gray-300'
                        }`}
                      >
                        <span className={`flex items-center gap-1 px-2 py-0.5 rounded-full ${style}`}>
                          <Icon className="w-3 h-3" />
                        </span>
                        {label}
                      </button>
                    );
                  })}
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">Reason <span className="text-red-500">*</span></label>
                <textarea
                  rows={3}
                  placeholder="Provide a reason for this status change..."
                  value={reason}
                  onChange={e => setReason(e.target.value)}
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm resize-none"
                />
              </div>
            </div>
            <div className="flex gap-3 mt-5">
              <button onClick={closeModal} className="flex-1 py-2.5 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 text-sm">Cancel</button>
              <button
                onClick={handleStatusChange}
                disabled={!reason.trim()}
                className="flex-1 py-2.5 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg text-sm disabled:opacity-50 disabled:cursor-not-allowed"
              >
                Confirm
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Confirmation Modal */}
      {modal === 'delete' && selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-sm p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <div className="w-14 h-14 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Trash2 className="w-7 h-7 text-[#D30336]" />
            </div>
            <h3 className="text-lg font-bold text-[#011B3B] text-center mb-2">Delete Game</h3>
            <p className="text-gray-600 text-center text-sm mb-1">
              Are you sure you want to delete
            </p>
            <p className="text-center font-semibold text-[#011B3B] text-sm mb-6">
              {selected.homeTeam} vs {selected.awayTeam}?
            </p>
            <div className="flex gap-3">
              <button onClick={closeModal} className="flex-1 py-2.5 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 text-sm">Cancel</button>
              <button onClick={handleDelete} className="flex-1 py-2.5 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg text-sm">Delete</button>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
