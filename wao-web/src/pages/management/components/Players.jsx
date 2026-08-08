import React, { useState } from 'react';
import { Search, Filter, MoreVertical, Eye, Trash2, Plus, X, User } from 'lucide-react';
import { playersData as initialData, teamsData } from '../../../config/constants';
import { BRAND } from '../../../config/brand';
const B = BRAND.font.body;
const H = BRAND.font.heading;

const STATUS_STYLES = {
  active:    'bg-green-100 text-green-700',
  suspended: 'bg-red-100 text-red-600',
};

const POSITIONS = ['all', 'Forward', 'Guard', 'Center'];
const TEAMS = ['all', ...teamsData.map(t => t.name)];
const emptyForm = { name: '', team: teamsData[0].name, position: 'Forward', status: 'active', fouls: 0, suspendedUntil: '' };

export default function Players() {
  const [players, setPlayers]     = useState(initialData);
  const [search, setSearch]       = useState('');
  const [posFilter, setPosFilter] = useState('all');
  const [teamFilter, setTeamFilter] = useState('all');
  const [menuOpen, setMenuOpen]   = useState(null);
  const [modal, setModal]         = useState(null);
  const [selected, setSelected]   = useState(null);
  const [form, setForm]           = useState(emptyForm);

  const filtered = players.filter(p => {
    const matchSearch = p.name.toLowerCase().includes(search.toLowerCase());
    const matchPos    = posFilter === 'all' || p.position === posFilter;
    const matchTeam   = teamFilter === 'all' || p.team === teamFilter;
    return matchSearch && matchPos && matchTeam;
  });

  const openAdd    = () => { setForm(emptyForm); setModal('add'); };
  const openEdit   = (p) => { setSelected(p); setForm({ name: p.name, team: p.team, position: p.position, status: p.status, fouls: p.fouls, suspendedUntil: p.suspendedUntil || '' }); setModal('edit'); setMenuOpen(null); };
  const openDelete = (p) => { setSelected(p); setModal('delete'); setMenuOpen(null); };
  const openView   = (p) => { setSelected(p); setModal('view'); setMenuOpen(null); };
  const closeModal = () => { setModal(null); setSelected(null); };

  const handleSave = () => {
    const entry = { ...form, fouls: Number(form.fouls), suspendedUntil: form.suspendedUntil || null };
    if (modal === 'add') {
      setPlayers([...players, { ...entry, id: Date.now() }]);
    } else {
      setPlayers(players.map(p => p.id === selected.id ? { ...p, ...entry } : p));
    }
    closeModal();
  };

  const handleDelete = () => {
    setPlayers(players.filter(p => p.id !== selected.id));
    closeModal();
  };

  return (
    <section className="px-2 py-2 md:p-4">
      {/* Header */}
      <div className="flex flex-col gap-3 py-4 md:py-8 md:flex-row md:items-center md:justify-between">
        <h2 className="text-xl md:text-2xl text-[#011B3B] uppercase tracking-widest" style={{ fontFamily: H }}>Players</h2>
        <button
          onClick={openAdd}
          className="flex items-center gap-2 px-5 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] transition-all text-sm"
          style={{ fontFamily: B }}
        >
          <Plus className="w-4 h-4" /> Add Player
        </button>
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
              onChange={e => setSearch(e.target.value)}
              className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm"
            />
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={posFilter}
              onChange={e => setPosFilter(e.target.value)}
              className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 appearance-none bg-white text-sm min-w-[160px] cursor-pointer"
            >
              {POSITIONS.map(p => <option key={p} value={p}>{p === 'all' ? 'All Positions' : p}</option>)}
            </select>
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={teamFilter}
              onChange={e => setTeamFilter(e.target.value)}
              className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 appearance-none bg-white text-sm min-w-[160px] cursor-pointer"
            >
              {TEAMS.map(t => <option key={t} value={t}>{t === 'all' ? 'All Teams' : t}</option>)}
            </select>
          </div>
        </div>

        {/* Mobile cards */}
        <div className="md:hidden space-y-3">
          {filtered.map(p => (
            <div key={p.id} className="bg-white border border-gray-100 rounded-2xl shadow-sm p-4">
              <div className="flex items-start justify-between">
                <div className="flex items-center gap-3">
                  <div className="w-10 h-10 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center flex-shrink-0">
                    <span className="text-white font-bold text-xs">{p.name.substring(0, 2).toUpperCase()}</span>
                  </div>
                  <div>
                    <p className="font-bold text-[#011B3B] text-sm">{p.name}</p>
                    <p className="text-xs text-gray-500">{p.team}</p>
                  </div>
                </div>
                <div className="relative">
                  <button onClick={() => setMenuOpen(menuOpen === p.id ? null : p.id)} className="p-1.5 hover:bg-gray-100 rounded-lg">
                    <MoreVertical className="w-4 h-4 text-gray-500" />
                  </button>
                  {menuOpen === p.id && (
                    <div className="absolute right-0 mt-1 w-40 bg-white rounded-xl shadow-lg border border-gray-100 z-10">
                      <button onClick={() => openView(p)} className="w-full flex items-center gap-2 px-4 py-2.5 hover:bg-gray-50 text-sm"><Eye className="w-4 h-4 text-[#011B3B]" /> View</button>
                      <button onClick={() => openEdit(p)} className="w-full flex items-center gap-2 px-4 py-2.5 hover:bg-gray-50 text-sm"><User className="w-4 h-4 text-[#011B3B]" /> Edit</button>
                      <button onClick={() => openDelete(p)} className="w-full flex items-center gap-2 px-4 py-2.5 hover:bg-red-50 text-sm text-[#D30336] border-t border-gray-100"><Trash2 className="w-4 h-4" /> Delete</button>
                    </div>
                  )}
                </div>
              </div>
              <div className="flex items-center gap-2 mt-3 pt-3 border-t border-gray-100">
                <span className="text-xs bg-purple-100 text-purple-700 font-semibold px-2.5 py-1 rounded-full">{p.position}</span>
                <span className={`text-xs font-semibold px-2.5 py-1 rounded-full capitalize ${STATUS_STYLES[p.status]}`}>{p.status}</span>
                <span className="text-xs text-gray-400 ml-auto">{p.fouls} fouls</span>
              </div>
            </div>
          ))}
        </div>

        {/* Desktop table */}
        <div className="hidden md:block overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                {['Player', 'Team', 'Position', 'Fouls', 'Suspended Until', 'Status', 'Actions'].map(h => (
                  <th key={h} className="px-5 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider" style={{ fontFamily: B }}>{h}</th>
                ))}
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filtered.map(p => (
                <tr key={p.id} className="hover:bg-gray-50 transition-colors">
                  <td className="px-5 py-4">
                    <div className="flex items-center gap-3">
                      <div className="w-9 h-9 bg-[#c81434] flex items-center justify-center flex-shrink-0">
                        <span className="text-white font-bold text-xs" style={{ fontFamily: H }}>{p.name.substring(0, 2).toUpperCase()}</span>
                      </div>
                      <span className="font-medium text-[#011B3B] text-sm" style={{ fontFamily: B }}>{p.name}</span>
                    </div>
                  </td>
                  <td className="px-5 py-4 text-sm text-gray-600" style={{ fontFamily: B }}>{p.team}</td>
                  <td className="px-5 py-4">
                    <span className="text-xs bg-purple-100 text-purple-700 font-semibold px-2.5 py-1 rounded-full">{p.position}</span>
                  </td>
                  <td className="px-5 py-4">
                    <span className={`text-sm font-bold ${p.fouls >= 5 ? 'text-[#D30336]' : p.fouls >= 3 ? 'text-yellow-600' : 'text-[#011B3B]'}`}>{p.fouls}</span>
                  </td>
                  <td className="px-5 py-4 text-sm text-gray-500">{p.suspendedUntil ?? '—'}</td>
                  <td className="px-5 py-4">
                    <span className={`text-xs font-semibold px-2.5 py-1 rounded-full capitalize ${STATUS_STYLES[p.status]}`}>{p.status}</span>
                  </td>
                  <td className="px-5 py-4 relative">
                    <button onClick={() => setMenuOpen(menuOpen === p.id ? null : p.id)} className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                      <MoreVertical className="w-4 h-4 text-gray-600" />
                    </button>
                    {menuOpen === p.id && (
                      <div className="absolute right-0 mt-1 w-44 bg-white rounded-lg shadow-lg border border-gray-200 z-10">
                        <button onClick={() => openView(p)} className="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm"><Eye className="w-4 h-4 text-[#011B3B]" /> View Details</button>
                        <button onClick={() => openEdit(p)} className="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm"><User className="w-4 h-4 text-[#011B3B]" /> Edit</button>
                        <button onClick={() => openDelete(p)} className="w-full flex items-center gap-3 px-4 py-3 hover:bg-red-50 text-sm text-[#D30336] border-t border-gray-100"><Trash2 className="w-4 h-4" /> Delete</button>
                      </div>
                    )}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {filtered.length === 0 && (
            <div className="text-center py-12 text-gray-400">
              <User className="w-10 h-10 mx-auto mb-2 opacity-40" />
              <p className="text-sm">No players found</p>
            </div>
          )}
        </div>
      </div>

      {/* Add / Edit Modal */}
      {(modal === 'add' || modal === 'edit') && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white shadow-xl w-full max-w-md p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <h3 className="text-lg text-[#011B3B] mb-5 uppercase tracking-widest" style={{ fontFamily: H }}>{modal === 'add' ? 'Add Player' : 'Edit Player'}</h3>
            <div className="space-y-4">
              <div>
                <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Full Name</label>
                <input
                  type="text"
                  placeholder="e.g. Alex Rodriguez"
                  value={form.name}
                  onChange={e => setForm({ ...form, name: e.target.value })}
                  className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm"
                  style={{ fontFamily: B }}
                />
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Team</label>
                  <select value={form.team} onChange={e => setForm({ ...form, team: e.target.value })} className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm bg-white" style={{ fontFamily: B }}>
                    {teamsData.map(t => <option key={t.id} value={t.name}>{t.name}</option>)}
                  </select>
                </div>
                <div>
                  <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Position</label>
                  <select value={form.position} onChange={e => setForm({ ...form, position: e.target.value })} className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm bg-white" style={{ fontFamily: B }}>
                    {['Forward', 'Guard', 'Center'].map(pos => <option key={pos}>{pos}</option>)}
                  </select>
                </div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Fouls</label>
                  <input type="number" min="0" value={form.fouls} onChange={e => setForm({ ...form, fouls: e.target.value })} className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm" style={{ fontFamily: B }} />
                </div>
                <div>
                  <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Status</label>
                  <select value={form.status} onChange={e => setForm({ ...form, status: e.target.value })} className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm bg-white" style={{ fontFamily: B }}>
                    {['active', 'suspended'].map(s => <option key={s}>{s}</option>)}
                  </select>
                </div>
              </div>
              {form.status === 'suspended' && (
                <div>
                  <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Suspended Until</label>
                  <input type="date" value={form.suspendedUntil} onChange={e => setForm({ ...form, suspendedUntil: e.target.value })} className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm" style={{ fontFamily: B }} />
                </div>
              )}
            </div>
            <div className="flex gap-3 mt-6">
              <button onClick={closeModal} className="flex-1 py-2.5 border border-gray-300 text-gray-700 font-semibold hover:bg-gray-50 text-sm" style={{ fontFamily: B }}>Cancel</button>
              <button onClick={handleSave} className="flex-1 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] text-sm" style={{ fontFamily: B }}>
                {modal === 'add' ? 'Add Player' : 'Save Changes'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* View Modal */}
      {modal === 'view' && selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white shadow-xl w-full max-w-sm p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <div className="flex flex-col items-center mb-5">
              <div className="w-16 h-16 bg-[#c81434] flex items-center justify-center mb-3">
                <span className="text-white font-bold text-lg" style={{ fontFamily: H }}>{selected.name.substring(0, 2).toUpperCase()}</span>
              </div>
              <h3 className="text-lg text-[#011B3B]" style={{ fontFamily: H }}>{selected.name}</h3>
              <span className="text-xs bg-purple-100 text-purple-700 font-semibold px-2.5 py-1 rounded-full mt-1">{selected.position}</span>
            </div>
            <div className="space-y-1 text-sm">
              {[
                { label: 'Team',             value: selected.team },
                { label: 'Fouls',            value: <span className={`font-bold ${selected.fouls >= 5 ? 'text-[#D30336]' : selected.fouls >= 3 ? 'text-yellow-600' : 'text-[#011B3B]'}`}>{selected.fouls}</span> },
                { label: 'Suspended Until',  value: selected.suspendedUntil ?? '—' },
                { label: 'Status',           value: <span className={`capitalize font-semibold px-2 py-0.5 rounded-full text-xs ${STATUS_STYLES[selected.status]}`}>{selected.status}</span> },
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
      )}

      {/* Delete Modal */}
      {modal === 'delete' && selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white shadow-xl w-full max-w-sm p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <div className="w-14 h-14 bg-red-100 flex items-center justify-center mx-auto mb-4">
              <Trash2 className="w-7 h-7 text-[#c81434]" />
            </div>
            <h3 className="text-lg text-[#011B3B] text-center mb-2 uppercase tracking-widest" style={{ fontFamily: H }}>Delete Player</h3>
            <p className="text-gray-600 text-center text-sm mb-6" style={{ fontFamily: B }}>
              Are you sure you want to delete <span className="font-semibold text-[#011B3B]">{selected.name}</span>? This cannot be undone.
            </p>
            <div className="flex gap-3">
              <button onClick={closeModal} className="flex-1 py-2.5 border border-gray-300 text-gray-700 font-semibold hover:bg-gray-50 text-sm" style={{ fontFamily: B }}>Cancel</button>
              <button onClick={handleDelete} className="flex-1 py-2.5 bg-[#c81434] text-white font-semibold hover:bg-[#e21e43] text-sm" style={{ fontFamily: B }}>Delete</button>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
