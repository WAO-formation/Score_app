import { useState, useEffect } from 'react';
import { Trophy, Users, Search, Filter, MoreVertical, Trash2, Eye, ChevronLeft, ChevronRight, X, Shield, ChevronRight as Arrow } from 'lucide-react';
import { useNavigate } from 'react-router-dom';
import CreateTeam from '../../components/CreateTeam';
import * as teamsService from '../../services/teamsService';
import { useAuth } from '../../context/AuthContext';
import { BRAND } from '../../config/brand';

const CATEGORY_COLORS = {
  Senior: 'bg-blue-50 text-blue-700 border border-blue-100',
  Junior: 'bg-green-50 text-green-700 border border-green-100',
  Youth:  'bg-amber-50 text-amber-700 border border-amber-100',
};

function Teams() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const isAdmin = user?.role === 'admin';
  const isCoach = user?.role === 'moderator';
  const [teamsData, setTeamsData] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [showActionMenu, setShowActionMenu] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [teamsPerPage, setTeamsPerPage] = useState(10);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [teamToDelete, setTeamToDelete] = useState(null);
  const [showCreateTeamModal, setShowCreateTeamModal] = useState(false);

  const categories = ['all', 'Senior', 'Junior', 'Youth'];

  useEffect(() => {
    return teamsService.subscribeToTeams(
      (list) => { setTeamsData(list); setLoading(false); },
      (err) => { console.error('Failed to load teams:', err); setLoading(false); }
    );
  }, []);

  const filteredTeams = teamsData.filter(team => {
    const matchesSearch = team.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         team.coach.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || team.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  const totalPages = Math.ceil(filteredTeams.length / teamsPerPage);
  const indexOfLast = currentPage * teamsPerPage;
  const indexOfFirst = indexOfLast - teamsPerPage;
  const currentTeams = filteredTeams.slice(indexOfFirst, indexOfLast);

  // Keeps the current page in range as the live subscription's list shrinks
  // or grows (e.g. after a delete), instead of computing this once inside
  // confirmDelete against a snapshot of the array that's about to go stale.
  useEffect(() => {
    const maxPage = Math.max(1, Math.ceil(filteredTeams.length / teamsPerPage));
    if (currentPage > maxPage) setCurrentPage(maxPage);
  }, [filteredTeams.length, teamsPerPage, currentPage]);

  const handleSearchChange = (v) => { setSearchQuery(v); setCurrentPage(1); };
  const handleCategoryChange = (v) => { setSelectedCategory(v); setCurrentPage(1); };
  const handlePerPageChange = (v) => { setTeamsPerPage(Number(v)); setCurrentPage(1); };

  const viewTeamDetails = (id) => { navigate(`/teams/${id}`); setShowActionMenu(null); };

  const openDeleteModal = (team) => { setTeamToDelete(team); setShowDeleteModal(true); setShowActionMenu(null); };
  const closeDeleteModal = () => { setShowDeleteModal(false); setTeamToDelete(null); };
  const confirmDelete = async () => {
    if (!teamToDelete) return;
    const id = teamToDelete.id;
    closeDeleteModal();
    try {
      await teamsService.deleteTeam(id);
    } catch (err) {
      console.error('Failed to delete team:', err);
    }
  };

  const handleCreateTeam = async (input) => {
    const { players: rosterInput = [], ...teamInput } = input;
    const newTeamId = await teamsService.createTeam(teamInput);
    await Promise.all(
      rosterInput.map((p) =>
        teamsService.addPlayerToTeam(newTeamId, {
          name: p.name,
          role: p.role,
          number: p.number,
          age: p.age,
          teamName: teamInput.name,
        })
      )
    );
  };

  // Coach view: card grid, no admin controls
  if (isCoach) {
    return (
      <section className="scrollbar-hide px-2 py-2 md:p-4">
        <div className="flex flex-col gap-3 py-4 md:py-6 md:flex-row md:items-center md:justify-between">
          <div>
            <h2 className="text-xl md:text-2xl font-semibold text-gray-900 uppercase tracking-widest" style={{ fontFamily: BRAND.font.body }}>Teams</h2>
            <p className="text-xs text-gray-400 mt-0.5" style={{ fontFamily: BRAND.font.body }}>{teamsData.length} teams registered</p>
          </div>
          <div className="flex gap-2">
            <div className="relative">
              <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input
                type="text" placeholder="Search teams..."
                value={searchQuery} onChange={e => handleSearchChange(e.target.value)}
                className="pl-9 pr-4 py-2.5 text-sm border border-gray-200 rounded-sm focus:outline-none focus:border-gray-400 bg-gray-50 transition w-56"
                style={{ fontFamily: BRAND.font.body }}
              />
            </div>
            <div className="relative">
              <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <select
                value={selectedCategory} onChange={e => handleCategoryChange(e.target.value)}
                className="pl-9 pr-8 py-2.5 text-sm border border-gray-200 rounded-sm focus:outline-none focus:border-gray-400 bg-gray-50 appearance-none cursor-pointer min-w-[140px]"
                style={{ fontFamily: BRAND.font.body }}
              >
                {categories.map(c => <option key={c} value={c}>{c === 'all' ? 'All Categories' : c}</option>)}
              </select>
            </div>
          </div>
        </div>

        {loading ? (
          <div className="py-16 text-center text-sm text-gray-400" style={{ fontFamily: BRAND.font.body }}>Loading teams…</div>
        ) : filteredTeams.length === 0 ? (
          <div className="py-16 text-center">
            <div className="w-14 h-14 bg-gray-100 rounded-sm flex items-center justify-center mx-auto mb-4"><Users className="w-6 h-6 text-gray-300" /></div>
            <p className="text-sm text-gray-500" style={{ fontFamily: BRAND.font.body }}>No teams found.</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
            {filteredTeams.map(team => (
              <button
                key={team.id}
                onClick={() => viewTeamDetails(team.id)}
                className="bg-white border border-gray-100 p-5 text-left hover:shadow-md hover:border-gray-200 transition-all group"
              >
                <div className="flex items-start justify-between mb-4">
                  <div className="w-12 h-12 flex items-center justify-center text-white text-sm font-bold shrink-0" style={{ backgroundColor: BRAND.primary, fontFamily: BRAND.font.heading }}>
                    {team.icon}
                  </div>
                  <span className={`text-xs font-semibold px-2 py-0.5 rounded-sm ${CATEGORY_COLORS[team.category]}`} style={{ fontFamily: BRAND.font.body }}>{team.category}</span>
                </div>
                <p className="text-sm font-semibold text-[#011B3B] mb-1 truncate" style={{ fontFamily: BRAND.font.body }}>{team.name}</p>
                <p className="text-xs text-gray-400 mb-4" style={{ fontFamily: BRAND.font.body }}>Coach: {team.coach}</p>
                <div className="flex items-center justify-between border-t border-gray-50 pt-3">
                  <div className="flex items-center gap-1 text-xs text-gray-400" style={{ fontFamily: BRAND.font.body }}>
                    <Shield className="w-3.5 h-3.5" />
                    <span>{team.gamesPlayed} games</span>
                  </div>
                  <span className="text-xs text-gray-400 group-hover:text-[#011B3B] transition-colors flex items-center gap-0.5" style={{ fontFamily: BRAND.font.body }}>
                    Manage roster <Arrow className="w-3 h-3" />
                  </span>
                </div>
              </button>
            ))}
          </div>
        )}
      </section>
    );
  }

  return (
    <section className="scrollbar-hide px-2 py-2 md:p-4">

      {/* Page header */}
      <div className="flex flex-col gap-3 py-4 md:py-6 md:flex-row md:items-center md:justify-between">
        <div>
          <h2 className="text-xl md:text-2xl font-semibold text-gray-900 uppercase tracking-widest" style={{ fontFamily: BRAND.font.body }}>
            Teams
          </h2>
          <p className="text-xs text-gray-400 mt-0.5" style={{ fontFamily: BRAND.font.body }}>
            {teamsData.length} teams registered
          </p>
        </div>
        <div className="flex gap-2">
          <button
            onClick={() => setShowCreateTeamModal(true)}
            className="flex items-center gap-2 px-4 py-2.5 text-sm font-semibold uppercase tracking-wide text-white transition"
            style={{ fontFamily: BRAND.font.body, backgroundColor: '#111' }}
            onMouseEnter={e => e.currentTarget.style.backgroundColor = '#333'}
            onMouseLeave={e => e.currentTarget.style.backgroundColor = '#111'}
          >
            <Users className="w-4 h-4" /> Create Team
          </button>
          {isAdmin && (
            <button
              onClick={() => navigate('/games/create')}
              className="flex items-center gap-2 px-4 py-2.5 text-sm font-semibold uppercase tracking-wide text-white transition"
              style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
              onMouseEnter={e => e.currentTarget.style.backgroundColor = BRAND.primaryHover}
              onMouseLeave={e => e.currentTarget.style.backgroundColor = BRAND.primary}
            >
              <Trophy className="w-4 h-4" /> Create Game
            </button>
          )}
        </div>
      </div>

      {/* Filters */}
      <div className="bg-white border border-gray-100 rounded-sm p-4 mb-4">
        <div className="flex flex-col md:flex-row gap-3">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text" placeholder="Search teams or coaches..."
              value={searchQuery} onChange={e => handleSearchChange(e.target.value)}
              className="w-full pl-9 pr-4 py-2.5 text-sm border border-gray-200 rounded-sm focus:outline-none focus:border-gray-400 bg-gray-50 transition"
              style={{ fontFamily: BRAND.font.body }}
            />
          </div>
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <select
              value={selectedCategory} onChange={e => handleCategoryChange(e.target.value)}
              className="pl-9 pr-8 py-2.5 text-sm border border-gray-200 rounded-sm focus:outline-none focus:border-gray-400 bg-gray-50 appearance-none cursor-pointer min-w-[160px]"
              style={{ fontFamily: BRAND.font.body }}
            >
              {categories.map(c => (
                <option key={c} value={c}>{c === 'all' ? 'All Categories' : c}</option>
              ))}
            </select>
          </div>
          <select
            value={teamsPerPage} onChange={e => handlePerPageChange(e.target.value)}
            className="px-4 py-2.5 text-sm border border-gray-200 rounded-sm focus:outline-none focus:border-gray-400 bg-gray-50 appearance-none cursor-pointer min-w-[120px]"
            style={{ fontFamily: BRAND.font.body }}
          >
            {[5, 10, 20, 50].map(n => <option key={n} value={n}>{n} per page</option>)}
          </select>
        </div>
      </div>

      {/* Table */}
      <div className="bg-white border border-gray-100 rounded-sm">
        {loading ? (
          <div className="py-16 text-center text-sm text-gray-400" style={{ fontFamily: BRAND.font.body }}>Loading teams…</div>
        ) : filteredTeams.length > 0 ? (
          <>
            {/* Mobile cards */}
            <div className="md:hidden divide-y divide-gray-50">
              {currentTeams.map(team => (
                <div key={team.id} className="p-4 flex items-center justify-between gap-3 hover:bg-gray-50 transition-colors cursor-pointer" onClick={() => viewTeamDetails(team.id)}>
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-sm flex items-center justify-center text-white text-xs font-bold shrink-0" style={{ backgroundColor: BRAND.primary, fontFamily: BRAND.font.body }}>
                      {team.icon}
                    </div>
                    <div>
                      <p className="text-sm font-semibold text-gray-900" style={{ fontFamily: BRAND.font.body }}>{team.name}</p>
                      <p className="text-xs text-gray-400" style={{ fontFamily: BRAND.font.body }}>{team.coach}</p>
                    </div>
                  </div>
                  <div className="flex items-center gap-2">
                    <span className={`text-xs font-semibold px-2 py-0.5 rounded-sm ${CATEGORY_COLORS[team.category]}`} style={{ fontFamily: BRAND.font.body }}>{team.category}</span>
                    <div className="relative" onClick={e => e.stopPropagation()}>
                      <button onClick={() => setShowActionMenu(showActionMenu === team.id ? null : team.id)} className="p-1.5 hover:bg-gray-100 rounded transition-colors">
                        <MoreVertical className="w-4 h-4 text-gray-400" />
                      </button>
                      {showActionMenu === team.id && (
                        <div className="absolute right-0 top-8 w-40 bg-white border border-gray-100 shadow-lg rounded-sm z-20">
                          <button onClick={() => viewTeamDetails(team.id)} className="w-full flex items-center gap-2 px-3 py-2.5 text-sm text-gray-700 hover:bg-gray-50" style={{ fontFamily: BRAND.font.body }}>
                            <Eye className="w-3.5 h-3.5" /> View Details
                          </button>
                          <button onClick={() => openDeleteModal(team)} className="w-full flex items-center gap-2 px-3 py-2.5 text-sm text-red-500 hover:bg-red-50 border-t border-gray-50" style={{ fontFamily: BRAND.font.body }}>
                            <Trash2 className="w-3.5 h-3.5" /> Delete
                          </button>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              ))}
            </div>

            {/* Desktop table */}
            <div className="hidden md:block overflow-x-auto">
              <table className="w-full">
                <thead>
                  <tr className="border-b border-gray-100">
                    {['Team', 'Coach', 'Category', 'Games Played', ''].map(h => (
                      <th key={h} className="px-5 py-3.5 text-left text-xs font-semibold text-gray-400 uppercase tracking-widest" style={{ fontFamily: BRAND.font.body }}>{h}</th>
                    ))}
                  </tr>
                </thead>
                <tbody className="divide-y divide-gray-50">
                  {currentTeams.map(team => (
                    <tr key={team.id} className="hover:bg-gray-50 transition-colors cursor-pointer group" onClick={() => viewTeamDetails(team.id)}>
                      <td className="px-5 py-4">
                        <div className="flex items-center gap-3">
                          <div className="w-9 h-9 rounded-sm flex items-center justify-center text-white text-xs font-bold shrink-0" style={{ backgroundColor: BRAND.primary, fontFamily: BRAND.font.body }}>
                            {team.icon}
                          </div>
                          <span className="text-sm font-semibold text-gray-900" style={{ fontFamily: BRAND.font.body }}>{team.name}</span>
                        </div>
                      </td>
                      <td className="px-5 py-4 text-sm text-gray-500" style={{ fontFamily: BRAND.font.body }}>{team.coach}</td>
                      <td className="px-5 py-4">
                        <span className={`text-xs font-semibold px-2.5 py-1 rounded-sm ${CATEGORY_COLORS[team.category]}`} style={{ fontFamily: BRAND.font.body }}>{team.category}</span>
                      </td>
                      <td className="px-5 py-4 text-sm font-semibold text-gray-900" style={{ fontFamily: BRAND.font.body }}>{team.gamesPlayed}</td>
                      <td className="px-5 py-4 relative" onClick={e => e.stopPropagation()}>
                        <button onClick={() => setShowActionMenu(showActionMenu === team.id ? null : team.id)} className="p-1.5 hover:bg-gray-100 rounded transition-colors opacity-0 group-hover:opacity-100">
                          <MoreVertical className="w-4 h-4 text-gray-400" />
                        </button>
                        {showActionMenu === team.id && (
                          <div className="absolute right-4 top-10 w-44 bg-white border border-gray-100 shadow-lg rounded-sm z-20">
                            <button onClick={() => viewTeamDetails(team.id)} className="w-full flex items-center gap-2 px-4 py-2.5 text-sm text-gray-700 hover:bg-gray-50" style={{ fontFamily: BRAND.font.body }}>
                              <Eye className="w-3.5 h-3.5" /> View Details
                            </button>
                            <button onClick={() => openDeleteModal(team)} className="w-full flex items-center gap-2 px-4 py-2.5 text-sm text-red-500 hover:bg-red-50 border-t border-gray-50" style={{ fontFamily: BRAND.font.body }}>
                              <Trash2 className="w-3.5 h-3.5" /> Delete Team
                            </button>
                          </div>
                        )}
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>

            {/* Pagination */}
            <div className="px-5 py-4 border-t border-gray-50 flex flex-col sm:flex-row items-center justify-between gap-3">
              <p className="text-xs text-gray-400" style={{ fontFamily: BRAND.font.body }}>
                Showing <span className="font-semibold text-gray-700">{indexOfFirst + 1}</span>–<span className="font-semibold text-gray-700">{Math.min(indexOfLast, filteredTeams.length)}</span> of <span className="font-semibold text-gray-700">{filteredTeams.length}</span> teams
              </p>
              <div className="flex items-center gap-1.5">
                <button onClick={() => setCurrentPage(p => Math.max(1, p - 1))} disabled={currentPage === 1}
                  className="p-2 rounded-sm border border-gray-200 text-gray-500 hover:bg-gray-50 disabled:opacity-30 disabled:cursor-not-allowed transition-colors">
                  <ChevronLeft className="w-4 h-4" />
                </button>
                {[...Array(totalPages)].map((_, i) => {
                  const p = i + 1;
                  if (p === 1 || p === totalPages || (p >= currentPage - 1 && p <= currentPage + 1)) return (
                    <button key={p} onClick={() => setCurrentPage(p)}
                      className="w-8 h-8 rounded-sm text-xs font-semibold transition-colors border"
                      style={{
                        fontFamily: BRAND.font.body,
                        backgroundColor: currentPage === p ? BRAND.primary : 'transparent',
                        color: currentPage === p ? '#fff' : '#6b7280',
                        borderColor: currentPage === p ? BRAND.primary : '#e5e7eb',
                      }}
                    >{p}</button>
                  );
                  if (p === currentPage - 2 || p === currentPage + 2) return <span key={p} className="text-gray-300 text-xs">…</span>;
                  return null;
                })}
                <button onClick={() => setCurrentPage(p => Math.min(totalPages, p + 1))} disabled={currentPage === totalPages}
                  className="p-2 rounded-sm border border-gray-200 text-gray-500 hover:bg-gray-50 disabled:opacity-30 disabled:cursor-not-allowed transition-colors">
                  <ChevronRight className="w-4 h-4" />
                </button>
              </div>
            </div>
          </>
        ) : (
          <div className="py-16 text-center">
            <div className="w-14 h-14 bg-gray-100 rounded-sm flex items-center justify-center mx-auto mb-4">
              <Users className="w-6 h-6 text-gray-300" />
            </div>
            <p className="text-sm font-semibold text-gray-500 mb-1" style={{ fontFamily: BRAND.font.body }}>No teams found</p>
            <p className="text-xs text-gray-400" style={{ fontFamily: BRAND.font.body }}>
              {searchQuery || selectedCategory !== 'all' ? 'Try adjusting your filters.' : 'Create your first team to get started.'}
            </p>
          </div>
        )}
      </div>

      {/* Delete modal */}
      {showDeleteModal && (
        <div className="fixed inset-0 bg-black/50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-sm shadow-xl max-w-sm w-full p-6 relative">
            <button onClick={closeDeleteModal} className="absolute top-4 right-4 text-gray-300 hover:text-gray-500 transition-colors">
              <X className="w-4 h-4" />
            </button>
            <div className="w-12 h-12 rounded-sm flex items-center justify-center mx-auto mb-4" style={{ backgroundColor: `${BRAND.primary}15` }}>
              <Trash2 className="w-5 h-5" style={{ color: BRAND.primary }} />
            </div>
            <h3 className="text-base font-semibold text-gray-900 text-center mb-1 uppercase tracking-wide" style={{ fontFamily: BRAND.font.body }}>Delete Team</h3>
            <p className="text-sm text-gray-400 text-center mb-6" style={{ fontFamily: BRAND.font.body }}>
              Are you sure you want to delete <span className="font-semibold text-gray-700">{teamToDelete?.name}</span>? This cannot be undone.
            </p>
            <div className="flex gap-2">
              <button onClick={closeDeleteModal} className="flex-1 py-2.5 text-sm font-semibold text-gray-600 border border-gray-200 hover:bg-gray-50 transition-colors rounded-sm" style={{ fontFamily: BRAND.font.body }}>
                Cancel
              </button>
              <button onClick={confirmDelete} className="flex-1 py-2.5 text-sm font-semibold text-white transition-colors rounded-sm" style={{ fontFamily: BRAND.font.body, backgroundColor: BRAND.primary }}
                onMouseEnter={e => e.currentTarget.style.backgroundColor = BRAND.primaryHover}
                onMouseLeave={e => e.currentTarget.style.backgroundColor = BRAND.primary}
              >
                Delete
              </button>
            </div>
          </div>
        </div>
      )}

      <CreateTeam isOpen={showCreateTeamModal} onClose={() => setShowCreateTeamModal(false)} onCreateTeam={handleCreateTeam} />
    </section>
  );
}

export default Teams;
