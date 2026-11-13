import React, { useState, useEffect } from 'react';
import { Search, MoreVertical, Trash2, Edit, Plus, X, Newspaper, Save, Image as ImageIcon, Calendar, User } from 'lucide-react';
import { useAuth } from '../../../context/AuthContext';
import { subscribeToNews, createNews, updateNews, deleteNews } from '../../../services/newsService';

const INPUT = 'w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm';
const LABEL = 'block text-sm font-medium text-gray-700 mb-1';

const emptyParagraph = () => ({ subtitle: '', content: '' });
const emptyForm = () => ({
  title: '',
  category: '',
  author: '',
  imageUrl: '',
  publishedDate: new Date().toISOString().slice(0, 16), // datetime-local value
  mainParagraph: emptyParagraph(),
  optionalParagraphs: [],
});

const formatDate = (d) => d.toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' });

export default function News() {
  const { user } = useAuth();
  const isAdmin = user?.role === 'admin';

  const [articles, setArticles] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');
  const [menuOpen, setMenuOpen] = useState(null);
  const [modal, setModal] = useState(null); // 'form' | 'delete'
  const [editingId, setEditingId] = useState(null);
  const [selected, setSelected] = useState(null);
  const [form, setForm] = useState(emptyForm());
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState('');

  useEffect(() => {
    return subscribeToNews(
      (list) => { setArticles(list); setLoading(false); },
      (err) => { console.error('Failed to load news:', err); setLoading(false); }
    );
  }, []);

  useEffect(() => {
    const closeMenu = (e) => {
      if (!e.target.closest('[data-actions-menu]')) setMenuOpen(null);
    };
    document.addEventListener('click', closeMenu);
    return () => document.removeEventListener('click', closeMenu);
  }, []);

  const filtered = articles.filter((a) =>
    a.title.toLowerCase().includes(search.toLowerCase()) ||
    (a.category || '').toLowerCase().includes(search.toLowerCase())
  );

  const openAdd = () => { setEditingId(null); setForm(emptyForm()); setError(''); setModal('form'); };
  const openEdit = (a) => {
    setEditingId(a.id);
    setForm({
      title: a.title,
      category: a.category || '',
      author: a.author || '',
      imageUrl: a.imageUrl || '',
      publishedDate: a.publishedDate.toISOString().slice(0, 16),
      mainParagraph: { ...a.mainParagraph },
      optionalParagraphs: a.optionalParagraphs.map((p) => ({ ...p })),
    });
    setError('');
    setModal('form');
    setMenuOpen(null);
  };
  const openDelete = (a) => { setSelected(a); setModal('delete'); setMenuOpen(null); };
  const closeModal = () => { setModal(null); setSelected(null); setEditingId(null); };

  const setField = (key, value) => setForm((f) => ({ ...f, [key]: value }));
  const setMainParagraph = (key, value) => setForm((f) => ({ ...f, mainParagraph: { ...f.mainParagraph, [key]: value } }));

  const addOptionalParagraph = () => setForm((f) => ({ ...f, optionalParagraphs: [...f.optionalParagraphs, emptyParagraph()] }));
  const removeOptionalParagraph = (i) => setForm((f) => ({ ...f, optionalParagraphs: f.optionalParagraphs.filter((_, idx) => idx !== i) }));
  const setOptionalParagraph = (i, key, value) => setForm((f) => ({
    ...f,
    optionalParagraphs: f.optionalParagraphs.map((p, idx) => (idx === i ? { ...p, [key]: value } : p)),
  }));

  const handleSave = async () => {
    if (!form.title.trim()) { setError('Title is required.'); return; }
    if (!form.mainParagraph.content.trim()) { setError('The main paragraph needs some content.'); return; }

    setSaving(true);
    setError('');
    const article = {
      title: form.title.trim(),
      category: form.category.trim(),
      author: form.author.trim(),
      imageUrl: form.imageUrl.trim(),
      publishedDate: new Date(form.publishedDate),
      mainParagraph: { subtitle: form.mainParagraph.subtitle.trim(), content: form.mainParagraph.content.trim() },
      optionalParagraphs: form.optionalParagraphs
        .filter((p) => p.content.trim())
        .map((p) => ({ subtitle: p.subtitle.trim(), content: p.content.trim() })),
    };

    try {
      if (editingId) {
        await updateNews(editingId, article);
      } else {
        await createNews(article);
      }
      closeModal();
    } catch (err) {
      console.error('Failed to save article:', err);
      setError('Failed to save. Please try again.');
    } finally {
      setSaving(false);
    }
  };

  const handleDelete = async () => {
    setSaving(true);
    try {
      await deleteNews(selected.id);
      closeModal();
    } catch (err) {
      console.error('Failed to delete article:', err);
    } finally {
      setSaving(false);
    }
  };

  return (
    <div>
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-base font-bold text-[#011B3B]">News <span className="text-gray-400 font-normal text-sm">({filtered.length})</span></h3>
        {isAdmin && (
          <button onClick={openAdd} className="flex items-center gap-1.5 px-4 py-2 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all text-sm">
            <Plus className="w-4 h-4" /> Add Article
          </button>
        )}
      </div>

      <div className="relative mb-4">
        <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
        <input
          type="text"
          placeholder="Search by title or category..."
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          className="w-full pl-9 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 text-sm"
        />
      </div>

      {loading ? (
        <p className="text-sm text-gray-400 text-center py-6">Loading news…</p>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
          {filtered.map((a) => (
            <div key={a.id} className="bg-gray-50 rounded-xl border border-gray-100 overflow-hidden flex flex-col">
              <div className="h-32 bg-gray-200 flex items-center justify-center overflow-hidden">
                {a.imageUrl ? (
                  <img src={a.imageUrl} alt="" className="w-full h-full object-cover" onError={(e) => { e.currentTarget.style.display = 'none'; }} />
                ) : (
                  <Newspaper className="w-8 h-8 text-gray-400" />
                )}
              </div>
              <div className="p-4 flex-1 flex flex-col">
                <div className="flex items-start justify-between gap-2 mb-1.5">
                  {a.category && (
                    <span className="text-[10px] font-bold uppercase tracking-wide px-2 py-0.5 bg-[#011B3B]/10 text-[#011B3B] rounded-full">{a.category}</span>
                  )}
                  {isAdmin && (
                    <div className="relative ml-auto" data-actions-menu>
                      <button onClick={() => setMenuOpen(menuOpen === a.id ? null : a.id)} className="p-1 hover:bg-gray-200 rounded-lg flex-shrink-0">
                        <MoreVertical className="w-4 h-4 text-gray-500" />
                      </button>
                      {menuOpen === a.id && (
                        <div className="absolute right-0 mt-1 w-36 bg-white rounded-lg shadow-lg border border-gray-200 z-10" data-actions-menu>
                          <button onClick={() => openEdit(a)} className="w-full flex items-center gap-2 px-3 py-2.5 hover:bg-gray-50 text-sm text-[#011B3B]"><Edit className="w-3.5 h-3.5" /> Edit</button>
                          <button onClick={() => openDelete(a)} className="w-full flex items-center gap-2 px-3 py-2.5 hover:bg-red-50 text-sm text-[#D30336] border-t border-gray-100"><Trash2 className="w-3.5 h-3.5" /> Delete</button>
                        </div>
                      )}
                    </div>
                  )}
                </div>
                <p className="font-semibold text-[#011B3B] text-sm leading-snug mb-1 line-clamp-2">{a.title}</p>
                <p className="text-xs text-gray-500 line-clamp-2 mb-3">{a.mainParagraph.content}</p>
                <div className="mt-auto flex items-center gap-3 text-[11px] text-gray-400">
                  {a.author && <span className="flex items-center gap-1"><User className="w-3 h-3" />{a.author}</span>}
                  <span className="flex items-center gap-1"><Calendar className="w-3 h-3" />{formatDate(a.publishedDate)}</span>
                </div>
              </div>
            </div>
          ))}
          {filtered.length === 0 && (
            <p className="text-sm text-gray-400 col-span-full text-center py-6">No news articles found</p>
          )}
        </div>
      )}

      {/* Add / Edit Modal */}
      {modal === 'form' && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-xl shadow-xl w-full max-w-xl p-6 relative max-h-[90vh] overflow-y-auto">
            <button onClick={closeModal} className="absolute top-4 right-4 text-gray-400 hover:text-gray-600"><X className="w-5 h-5" /></button>
            <h3 className="text-lg font-bold text-[#011B3B] mb-5">{editingId ? 'Edit Article' : 'Add Article'}</h3>

            <div className="space-y-4">
              <div>
                <label className={LABEL}>Title *</label>
                <input type="text" placeholder="e.g. WAO! Season Opener This Weekend" value={form.title} onChange={(e) => setField('title', e.target.value)} className={INPUT} />
              </div>

              <div className="grid grid-cols-2 gap-3">
                <div>
                  <label className={LABEL}>Category</label>
                  <input type="text" placeholder="e.g. Announcements" value={form.category} onChange={(e) => setField('category', e.target.value)} className={INPUT} />
                </div>
                <div>
                  <label className={LABEL}>Author</label>
                  <input type="text" placeholder="e.g. WAO! Press" value={form.author} onChange={(e) => setField('author', e.target.value)} className={INPUT} />
                </div>
              </div>

              <div>
                <label className={LABEL}><ImageIcon className="w-3.5 h-3.5 inline mr-1 -mt-0.5" />Image URL</label>
                <input type="text" placeholder="Paste a Google Drive share link or direct image URL" value={form.imageUrl} onChange={(e) => setField('imageUrl', e.target.value)} className={INPUT} />
                <p className="text-xs text-gray-400 mt-1">Mobile resolves a Google Drive share link automatically — no need to convert it yourself.</p>
              </div>

              <div>
                <label className={LABEL}><Calendar className="w-3.5 h-3.5 inline mr-1 -mt-0.5" />Published date</label>
                <input type="datetime-local" value={form.publishedDate} onChange={(e) => setField('publishedDate', e.target.value)} className={INPUT} />
              </div>

              <div className="border-t border-gray-100 pt-4">
                <p className="text-xs font-bold text-gray-400 uppercase tracking-wide mb-2">Main paragraph</p>
                <input
                  type="text" placeholder="Subtitle (optional)" value={form.mainParagraph.subtitle}
                  onChange={(e) => setMainParagraph('subtitle', e.target.value)} className={`${INPUT} mb-2`}
                />
                <textarea
                  placeholder="Article content *" value={form.mainParagraph.content} rows={4}
                  onChange={(e) => setMainParagraph('content', e.target.value)} className={INPUT}
                />
              </div>

              {form.optionalParagraphs.map((p, i) => (
                <div key={i} className="border-t border-gray-100 pt-4">
                  <div className="flex items-center justify-between mb-2">
                    <p className="text-xs font-bold text-gray-400 uppercase tracking-wide">Paragraph {i + 2}</p>
                    <button onClick={() => removeOptionalParagraph(i)} className="text-xs text-[#D30336] hover:underline flex items-center gap-1">
                      <Trash2 className="w-3 h-3" /> Remove
                    </button>
                  </div>
                  <input
                    type="text" placeholder="Subtitle (optional)" value={p.subtitle}
                    onChange={(e) => setOptionalParagraph(i, 'subtitle', e.target.value)} className={`${INPUT} mb-2`}
                  />
                  <textarea
                    placeholder="Paragraph content" value={p.content} rows={3}
                    onChange={(e) => setOptionalParagraph(i, 'content', e.target.value)} className={INPUT}
                  />
                </div>
              ))}

              <button onClick={addOptionalParagraph} className="text-sm text-[#011B3B] font-medium hover:underline flex items-center gap-1.5">
                <Plus className="w-4 h-4" /> Add another paragraph
              </button>

              {error && <p className="text-sm text-red-500">{error}</p>}
            </div>

            <div className="flex gap-3 mt-6">
              <button onClick={closeModal} className="flex-1 py-2.5 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 text-sm">Cancel</button>
              <button onClick={handleSave} disabled={saving} className="flex-1 flex items-center justify-center gap-2 py-2.5 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg text-sm disabled:opacity-50">
                <Save className="w-4 h-4" /> {saving ? 'Saving…' : editingId ? 'Save Changes' : 'Publish Article'}
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
            <h3 className="text-lg font-bold text-[#011B3B] text-center mb-2">Delete Article</h3>
            <p className="text-gray-600 text-center text-sm mb-6">
              Are you sure you want to delete <span className="font-semibold text-[#011B3B]">{selected.title}</span>? This cannot be undone.
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
