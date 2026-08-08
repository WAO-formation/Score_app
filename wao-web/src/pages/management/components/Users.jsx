import React, { useState, useEffect } from 'react';
import { Search, Filter, MoreVertical, Plus, X, ShieldCheck, KeyRound, Copy, Check, UserCog } from 'lucide-react';
import {
  collection, query, orderBy, onSnapshot,
  doc, setDoc, updateDoc, serverTimestamp,
} from 'firebase/firestore';
import { createUserWithEmailAndPassword, updateProfile, signOut } from 'firebase/auth';
import { db, secondaryAuth } from '../../../lib/firebase';
import { useAuth } from '../../../context/AuthContext';
import { BRAND } from '../../../config/brand';

// Every account created here starts with this password and must change it
// on first login (ForcePasswordChange, gated in ProtectedRoute) — sharing
// one known default is simpler to hand off than an emailed reset link, at
// the cost of it being a shared secret until the user changes it.
const DEFAULT_PASSWORD = 'Wao@2024!';

const B = BRAND.font.body;
const H = BRAND.font.heading;

const ROLES = ['admin', 'moderator', 'official', 'coach', 'player', 'fan'];
const ROLE_LABELS = {
  admin: 'Admin', moderator: 'Moderator', official: 'Official',
  coach: 'Coach', player: 'Player', fan: 'Fan',
};
const ROLE_STYLES = {
  admin:     'bg-red-100 text-[#c81434]',
  moderator: 'bg-violet-100 text-violet-700',
  official:  'bg-blue-100 text-blue-700',
  coach:     'bg-emerald-100 text-emerald-700',
  player:    'bg-amber-100 text-amber-700',
  fan:       'bg-gray-100 text-gray-500',
};

const emptyForm = { name: '', email: '', role: 'moderator' };

export default function Users() {
  const { user: currentAdmin } = useAuth();
  const [users, setUsers]     = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch]   = useState('');
  const [roleFilter, setRoleFilter] = useState('all');
  const [menuOpen, setMenuOpen] = useState(null);

  const [modal, setModal]     = useState(null); // 'add' | 'role'
  const [selected, setSelected] = useState(null);
  const [form, setForm]       = useState(emptyForm);
  const [newRole, setNewRole] = useState('fan');
  const [saving, setSaving]   = useState(false);
  const [error, setError]     = useState('');
  const [createdEmail, setCreatedEmail] = useState('');
  const [copied, setCopied]   = useState(false);

  useEffect(() => {
    const q = query(collection(db, 'users'), orderBy('createdAt', 'desc'));
    const unsub = onSnapshot(q, (snap) => {
      setUsers(snap.docs.map(d => ({ id: d.id, ...d.data() })));
      setLoading(false);
    }, () => setLoading(false));
    return unsub;
  }, []);

  const filtered = users.filter(u => {
    const name = u.displayName || u.username || '';
    const matchSearch = name.toLowerCase().includes(search.toLowerCase()) ||
                        (u.email || '').toLowerCase().includes(search.toLowerCase());
    const matchRole = roleFilter === 'all' || u.role === roleFilter;
    return matchSearch && matchRole;
  });

  const openAdd = () => { setForm(emptyForm); setError(''); setCreatedEmail(''); setCopied(false); setModal('add'); };
  const openRoleChange = (u) => { setSelected(u); setNewRole(u.role || 'fan'); setModal('role'); setMenuOpen(null); };
  const closeModal = () => { setModal(null); setSelected(null); setError(''); setCreatedEmail(''); };

  const handleAddUser = async () => {
    if (!form.name.trim() || !form.email.trim()) return setError('Name and email are required.');
    setError('');
    setSaving(true);
    try {
      const cred = await createUserWithEmailAndPassword(secondaryAuth, form.email.trim(), DEFAULT_PASSWORD);
      await updateProfile(cred.user, { displayName: form.name.trim() });

      await setDoc(doc(db, 'users', cred.user.uid), {
        username: form.name.trim(),
        displayName: form.name.trim(),
        email: form.email.trim(),
        role: form.role,
        mustChangePassword: true,
        createdAt: serverTimestamp(),
        updatedAt: serverTimestamp(),
        favoriteTeamIds: [],
        favoriteMatchIds: [],
        totalMatches: 0,
        totalTeams: 0,
        themePreference: 'system',
        notificationsEnabled: true,
        emailNotifications: false,
        language: 'English',
      });

      await signOut(secondaryAuth);
      setCreatedEmail(form.email.trim());
    } catch (err) {
      setError(
        err.code === 'auth/email-already-in-use' ? 'An account with this email already exists.' :
        err.code === 'auth/invalid-email'        ? 'Enter a valid email address.' :
        'Failed to create account. Please try again.'
      );
    } finally {
      setSaving(false);
    }
  };

  const copyPassword = () => {
    navigator.clipboard.writeText(DEFAULT_PASSWORD);
    setCopied(true);
    setTimeout(() => setCopied(false), 2000);
  };

  const handleRoleChange = async () => {
    if (!selected) return;
    setSaving(true);
    try {
      await updateDoc(doc(db, 'users', selected.id), { role: newRole, updatedAt: serverTimestamp() });
      closeModal();
    } catch {
      setError('Failed to update role. Please try again.');
    } finally {
      setSaving(false);
    }
  };

  return (
    <section className="px-2 py-2 md:p-4">
      {/* Header */}
      <div className="flex flex-col gap-3 py-4 md:py-8 md:flex-row md:items-center md:justify-between">
        <div>
          <h2 className="text-xl md:text-2xl text-[#011B3B] uppercase tracking-widest" style={{ fontFamily: H }}>Users</h2>
          <p className="text-sm text-gray-500 mt-1" style={{ fontFamily: B }}>Grant portal access to admins and moderators.</p>
        </div>
        <button
          onClick={openAdd}
          className="flex items-center gap-2 px-5 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] transition-all text-sm"
          style={{ fontFamily: B }}
        >
          <Plus className="w-4 h-4" /> Add User
        </button>
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
              onChange={e => setSearch(e.target.value)}
              className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm"
              style={{ fontFamily: B }}
            />
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={roleFilter}
              onChange={e => setRoleFilter(e.target.value)}
              className="pl-9 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 appearance-none bg-white text-sm min-w-[160px] cursor-pointer"
              style={{ fontFamily: B }}
            >
              <option value="all">All Roles</option>
              {ROLES.map(r => <option key={r} value={r}>{ROLE_LABELS[r]}</option>)}
            </select>
          </div>
        </div>

        {loading ? (
          <div className="text-center py-16 text-gray-400" style={{ fontFamily: B }}>Loading users…</div>
        ) : (
          <>
            {/* Mobile cards */}
            <div className="md:hidden space-y-3">
              {filtered.map(u => {
                const name = u.displayName || u.username || u.email;
                const isSelf = u.id === currentAdmin?.uid;
                return (
                  <div key={u.id} className="bg-white border border-gray-100 rounded-2xl shadow-sm p-4">
                    <div className="flex items-start justify-between">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-full flex items-center justify-center flex-shrink-0">
                          <span className="text-white font-bold text-xs">{name.substring(0, 2).toUpperCase()}</span>
                        </div>
                        <div>
                          <p className="font-bold text-[#011B3B] text-sm">{name}{isSelf && <span className="text-gray-400 font-normal"> (you)</span>}</p>
                          <p className="text-xs text-gray-500">{u.email}</p>
                        </div>
                      </div>
                      <div className="relative">
                        <button onClick={() => setMenuOpen(menuOpen === u.id ? null : u.id)} className="p-1.5 hover:bg-gray-100 rounded-lg">
                          <MoreVertical className="w-4 h-4 text-gray-500" />
                        </button>
                        {menuOpen === u.id && (
                          <div className="absolute right-0 mt-1 w-44 bg-white rounded-xl shadow-lg border border-gray-100 z-10">
                            <button
                              onClick={() => openRoleChange(u)}
                              disabled={isSelf}
                              className="w-full flex items-center gap-2 px-4 py-2.5 hover:bg-gray-50 text-sm disabled:opacity-40 disabled:cursor-not-allowed"
                            >
                              <UserCog className="w-4 h-4 text-[#011B3B]" /> Change Role
                            </button>
                          </div>
                        )}
                      </div>
                    </div>
                    <div className="flex items-center gap-2 mt-3 pt-3 border-t border-gray-100">
                      <span className={`text-xs font-semibold px-2.5 py-1 rounded-full ${ROLE_STYLES[u.role] || ROLE_STYLES.fan}`}>{ROLE_LABELS[u.role] || u.role}</span>
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
                    {['User', 'Email', 'Role', ''].map(h => (
                      <th key={h} className="px-5 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider" style={{ fontFamily: B }}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-100">
                  {filtered.map(u => {
                    const name = u.displayName || u.username || u.email;
                    const isSelf = u.id === currentAdmin?.uid;
                    return (
                      <tr key={u.id} className="hover:bg-gray-50 transition-colors">
                        <td className="px-5 py-4">
                          <div className="flex items-center gap-3">
                            <div className="w-9 h-9 bg-[#011B3B] flex items-center justify-center flex-shrink-0">
                              <span className="text-white font-medium text-xs" style={{ fontFamily: H }}>{name.substring(0, 2).toUpperCase()}</span>
                            </div>
                            <span className="font-medium text-[#011B3B] text-sm" style={{ fontFamily: B }}>
                              {name}{isSelf && <span className="text-gray-400 font-normal"> (you)</span>}
                            </span>
                          </div>
                        </td>
                        <td className="px-5 py-4 text-sm text-gray-600" style={{ fontFamily: B }}>{u.email}</td>
                        <td className="px-5 py-4">
                          <span className={`text-xs font-semibold px-2.5 py-1 rounded-full ${ROLE_STYLES[u.role] || ROLE_STYLES.fan}`}>{ROLE_LABELS[u.role] || u.role}</span>
                        </td>
                        <td className="px-5 py-4 relative">
                          <button onClick={() => setMenuOpen(menuOpen === u.id ? null : u.id)} className="p-2 hover:bg-gray-100 rounded-lg transition-colors">
                            <MoreVertical className="w-4 h-4 text-gray-600" />
                          </button>
                          {menuOpen === u.id && (
                            <div className="absolute right-4 mt-1 w-44 bg-white rounded-lg shadow-lg border border-gray-200 z-10">
                              <button
                                onClick={() => openRoleChange(u)}
                                disabled={isSelf}
                                className="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 text-sm disabled:opacity-40 disabled:cursor-not-allowed"
                              >
                                <UserCog className="w-4 h-4 text-[#011B3B]" /> Change Role
                              </button>
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
                  <ShieldCheck className="w-10 h-10 mx-auto mb-2 opacity-40" />
                  <p className="text-sm">No users found</p>
                </div>
              )}
            </div>
          </>
        )}
      </div>

      {/* Add User Modal */}
      {modal === 'add' && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white shadow-xl w-full max-w-md p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>

            {createdEmail ? (
              <div className="text-center py-4">
                <div className="w-14 h-14 bg-green-100 flex items-center justify-center mx-auto mb-4">
                  <ShieldCheck className="w-7 h-7 text-green-600" />
                </div>
                <h3 className="text-lg text-[#011B3B] mb-2 uppercase tracking-widest" style={{ fontFamily: H }}>Account Created</h3>
                <p className="text-gray-600 text-sm mb-4" style={{ fontFamily: B }}>
                  Share these sign-in details with <span className="font-semibold text-[#011B3B]">{createdEmail}</span>. They'll be asked to set their own password the first time they sign in.
                </p>
                <div className="flex items-center justify-between gap-3 bg-gray-50 border border-gray-200 px-4 py-3 mb-6 text-left">
                  <div>
                    <p className="text-xs text-gray-400 uppercase tracking-wide" style={{ fontFamily: B }}>Temporary Password</p>
                    <p className="text-sm font-bold text-[#011B3B] font-mono">{DEFAULT_PASSWORD}</p>
                  </div>
                  <button onClick={copyPassword} className="p-2 hover:bg-gray-200 transition-colors" title="Copy password">
                    {copied ? <Check className="w-4 h-4 text-green-600" /> : <Copy className="w-4 h-4 text-gray-500" />}
                  </button>
                </div>
                <button onClick={closeModal} className="w-full py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] text-sm" style={{ fontFamily: B }}>Done</button>
              </div>
            ) : (
              <>
                <h3 className="text-lg text-[#011B3B] mb-1 uppercase tracking-widest" style={{ fontFamily: H }}>Add User</h3>
                <p className="text-sm text-gray-500 mb-5 flex items-center gap-1.5" style={{ fontFamily: B }}>
                  <KeyRound className="w-3.5 h-3.5 flex-shrink-0" /> They'll start with a default password and set their own on first sign-in.
                </p>

                {error && (
                  <div className="mb-4 px-4 py-2.5 bg-red-50 text-red-600 text-sm border border-red-200" style={{ fontFamily: B }}>{error}</div>
                )}

                <div className="space-y-4">
                  <div>
                    <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Full Name</label>
                    <input
                      type="text" placeholder="e.g. James Osei"
                      value={form.name}
                      onChange={e => setForm({ ...form, name: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm"
                      style={{ fontFamily: B }}
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Email</label>
                    <input
                      type="email" placeholder="e.g. james@wao.com"
                      value={form.email}
                      onChange={e => setForm({ ...form, email: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm"
                      style={{ fontFamily: B }}
                    />
                  </div>
                  <div>
                    <label className="block text-xs font-semibold text-gray-500 uppercase tracking-wide mb-1" style={{ fontFamily: B }}>Role</label>
                    <select
                      value={form.role}
                      onChange={e => setForm({ ...form, role: e.target.value })}
                      className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm bg-white"
                      style={{ fontFamily: B }}
                    >
                      {ROLES.map(r => <option key={r} value={r}>{ROLE_LABELS[r]}</option>)}
                    </select>
                  </div>
                </div>

                <div className="flex gap-3 mt-6">
                  <button onClick={closeModal} className="flex-1 py-2.5 border border-gray-300 text-gray-700 font-semibold hover:bg-gray-50 text-sm" style={{ fontFamily: B }}>Cancel</button>
                  <button onClick={handleAddUser} disabled={saving} className="flex-1 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] text-sm disabled:opacity-50" style={{ fontFamily: B }}>
                    {saving ? 'Creating…' : 'Create Account'}
                  </button>
                </div>
              </>
            )}
          </div>
        </div>
      )}

      {/* Change Role Modal */}
      {modal === 'role' && selected && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white shadow-xl w-full max-w-sm p-6 relative">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <h3 className="text-lg text-[#011B3B] mb-1 uppercase tracking-widest" style={{ fontFamily: H }}>Change Role</h3>
            <p className="text-sm text-gray-500 mb-5" style={{ fontFamily: B }}>
              {selected.displayName || selected.username || selected.email}
            </p>

            {error && (
              <div className="mb-4 px-4 py-2.5 bg-red-50 text-red-600 text-sm border border-red-200" style={{ fontFamily: B }}>{error}</div>
            )}

            <select
              value={newRole}
              onChange={e => setNewRole(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 focus:outline-none focus:ring-2 focus:ring-[#c81434]/30 text-sm bg-white"
              style={{ fontFamily: B }}
            >
              {ROLES.map(r => <option key={r} value={r}>{ROLE_LABELS[r]}</option>)}
            </select>

            <div className="flex gap-3 mt-6">
              <button onClick={closeModal} className="flex-1 py-2.5 border border-gray-300 text-gray-700 font-semibold hover:bg-gray-50 text-sm" style={{ fontFamily: B }}>Cancel</button>
              <button onClick={handleRoleChange} disabled={saving} className="flex-1 py-2.5 bg-[#011B3B] text-white font-semibold hover:bg-[#022d5f] text-sm disabled:opacity-50" style={{ fontFamily: B }}>
                {saving ? 'Saving…' : 'Save'}
              </button>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}
