import React, { useState, useEffect } from 'react';
import { Search, MoreVertical, Trash2, Plus, X, Trophy } from 'lucide-react';
import { useAuth } from '../../../context/AuthContext';
import { subscribeToChampionships, createChampionship, updateChampionship, deleteChampionship } from '../../../services/championshipsService';

export default function Tournaments() {
  const { user } = useAuth();
  const isAdmin = user?.role === 'admin';

  const [tournaments, setTournaments] = useState([]);
  const [loading, setLoading]         = useState(true);
  const [search, setSearch]           = useState('');
  const [menuOpen, setMenuOpen]       = useState(null);
  const [modal, setModal]             = useState(null);
  const [selected, setSelected]       = useState(null);
  const [form, setForm]               = useState({ name: '' });
  const [saving, setSaving]           = useState(false);

  useEffect(() => {
    return subscribeToChampionships(
      (list) => { setTournaments(list); setLoading(false); },
      (err) => { console.error('Failed to load tournaments:', err); setLoading(false); }
    );
  }, []);

  useEffect(() => {
    const closeMenu = (e) => {
      if (!e.target.closest('[data-actions-menu]')) setMenuOpen(null);
    };
    document.addEventListener('click', closeMenu);
    return () => document.removeEventListener('click', closeMenu);
  }, []);

  const filtered = tournaments.filter(t => t.name.toLowerCase().includes(search.toLowerCase()));

  const openAdd    = () => { setForm({ name: '' }); setModal('add'); };
  const openEdit   = (t) => { setSelected(t); setForm({ name: t.name }); setModal('edit'); setMenuOpen(null); };
  const openDelete = (t) => { setSelected(t); setModal('delete'); setMenuOpen(null); };
  const closeModal = () => { setModal(null); setSelected(null); };

  const handleSave = async () => {
    if (!form.name.trim()) return;
    setSaving(true);
    try {
      if (modal === 'add') {
        await createChampionship(form.name.trim());
      } else {
        await updateChampionship(selected.id, form.name.trim());
      }
      closeModal();
    } catch (err) {
      console.error('Failed to save tournament:', err);
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    setSaving(true);
    try {
      await deleteChampionship(selected.id);
      closeModal();
    } catch (err) {
      console.error('Failed to delete tournament:', err);
    } finally {
      setSaving(false);
    }
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-base font-bold text-[#011B3B]">Tournaments <span className="text-gray-400 font-normal text-sm">({filtered.length})</span></h3>
        {isAdmin && (
          <button onClick={openAdd} className="flex items-center gap-1.5 px-4 py-2 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all text-sm">
            <Plus className="w-4 h-4" /> Add Tournament
          </button>
        )}
      </div>

      <div className="relative mb-4">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
        <input
          type="text"
          placeholder="Search tournaments..."
          value={search}
          onChange={e => setSearch(e.target.value)}
          className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm"
        />
      </div>

      {loading ? (
        <p className="text-sm text-gray-400 text-center py-6">Loading tournaments…</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-3">
          {filtered.map(t => (
            <div key={t.id} className="flex items-center justify-between bg-gray-50 rounded-xl px-4 py-3 border border-gray-100">
              <div className="flex items-center gap-3">
                <div className="w-9 h-9 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-lg flex items-center justify-center flex-shrink-0">
                  <Trophy className="w-4 h-4 text-white" />
                </div>
                <span className="font-medium text-[#011B3B] text-sm">{t.name}</span>
              </div>
              {isAdmin && (
                <div className="relative" data-actions-menu>
                  <button onClick={() => setMenuOpen(menuOpen === t.id ? null : t.id)} className="p-1.5 hover:bg-gray-200 rounded-lg">
                    <MoreVertical className="w-4 h-4 text-gray-500" />
                  </button>
                  {menuOpen === t.id && (
                    <div className="absolute right-0 mt-1 w-36 bg-white rounded-lg shadow-lg border border-gray-200 z-10" data-actions-menu>
                      <button onClick={() => openEdit(t)} className="w-full flex items-center gap-2 px-3 py-2.5 hover:bg-gray-50 text-sm text-[#011B3B]"><Trophy className="w-4 h-4" /> Edit</button>
                      <button onClick={() => openDelete(t)} className="w-full flex items-center gap-2 px-3 py-2.5 hover:bg-red-50 text-sm text-[#D30336] border-t border-gray-100"><Trash2 className="w-4 h-4" /> Delete</button>
                    </div>
                  )}
                </div>
              )}
            </div>
          ))}
          {filtered.length === 0 && (
            <p className="text-sm text-gray-400 col-span-full text-center py-6">No tournaments found</p>
          )}
        </div>
      )}

      {/* Add / Edit Modal */}
      {(modal === 'add' || modal === 'edit') && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-sm p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <h3 className="text-lg font-bold text-[#011B3B] mb-4">{modal === 'add' ? 'Add Tournament' : 'Edit Tournament'}</h3>
            <label className="block text-sm font-medium text-gray-700 mb-1">Tournament Name</label>
            <input
              type="text"
              placeholder="e.g. Premier League"
              value={form.name}
              onChange={e => setForm({ name: e.target.value })}
              className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm mb-5"
            />
            <div className="flex gap-3">
              <button onClick={closeModal} className="flex-1 py-2.5 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 text-sm">Cancel</button>
              <button onClick={handleSave} disabled={saving} className="flex-1 py-2.5 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg text-sm disabled:opacity-50">
                {saving ? 'Saving…' : modal === 'add' ? 'Add Tournament' : 'Save Changes'}
              </button>
            </div>
          </div>
        </div>
      )}

      {/* Delete Modal */}
      {modal === 'delete' && selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-sm p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <div className="w-14 h-14 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Trash2 className="w-7 h-7 text-[#D30336]" />
            </div>
            <h3 className="text-lg font-bold text-[#011B3B] text-center mb-2">Delete Tournament</h3>
            <p className="text-gray-600 text-center text-sm mb-6">
              Are you sure you want to delete <span className="font-semibold text-[#011B3B]">{selected.name}</span>?
            </p>
            <div className="flex gap-3">
              <button onClick={closeModal} className="flex-1 py-2.5 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 text-sm">Cancel</button>
              <button onClick={handleDelete} disabled={saving} className="flex-1 py-2.5 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg text-sm disabled:opacity-50">
                {saving ? 'Deleting…' : 'Delete'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
