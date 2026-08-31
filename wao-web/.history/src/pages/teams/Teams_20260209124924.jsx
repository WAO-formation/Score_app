import React, { useState } from 'react';
import { Trophy, Users, Search, Filter, MoreVertical, Trash2, Eye, ChevronLeft, ChevronRight, X } from "lucide-react";
import { teamsData as initialTeamsData } from '../../config/constants';
import { useNavigate } from 'react-router-dom';
import CreateTeam from '../../components/CreateTeam';

function Teams() {
  const navigate = useNavigate();
  const [teamsData, setTeamsData] = useState(initialTeamsData);
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [showActionMenu, setShowActionMenu] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [teamsPerPage, setTeamsPerPage] = useState(10);
  const [showDeleteModal, setShowDeleteModal] = useState(false);
  const [teamToDelete, setTeamToDelete] = useState(null);
  const [showCreateTeamModal, setShowCreateTeamModal] = useState(false);

  const categories = ['all', 'Senior', 'Junior', 'Youth'];

  // Filter teams based on search and category
  const filteredTeams = teamsData.filter(team => {
    const matchesSearch = team.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                         team.coach.toLowerCase().includes(searchQuery.toLowerCase());
    const matchesCategory = selectedCategory === 'all' || team.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  // Pagination calculations
  const totalPages = Math.ceil(filteredTeams.length / teamsPerPage);
  const indexOfLastTeam = currentPage * teamsPerPage;
  const indexOfFirstTeam = indexOfLastTeam - teamsPerPage;
  const currentTeams = filteredTeams.slice(indexOfFirstTeam, indexOfLastTeam);

  // Reset to page 1 when filters change
  const handleSearchChange = (value) => {
    setSearchQuery(value);
    setCurrentPage(1);
  };

  const handleCategoryChange = (value) => {
    setSelectedCategory(value);
    setCurrentPage(1);
  };

  const handleTeamsPerPageChange = (value) => {
    setTeamsPerPage(Number(value));
    setCurrentPage(1);
  };

  const toggleActionMenu = (teamId) => {
    setShowActionMenu(showActionMenu === teamId ? null : teamId);
  };

  const goToNextPage = () => {
    if (currentPage < totalPages) {
      setCurrentPage(currentPage + 1);
    }
  };

  const goToPreviousPage = () => {
    if (currentPage > 1) {
      setCurrentPage(currentPage - 1);
    }
  };

  // Navigate to team details
  const viewTeamDetails = (teamId) => {
    navigate(`/teams/${teamId}`);
    setShowActionMenu(null);
  };

  // Create team
  const handleCreateTeam = (newTeam) => {
    setTeamsData([...teamsData, newTeam]);
  };

  // Delete team functions
  const openDeleteModal = (team) => {
    setTeamToDelete(team);
    setShowDeleteModal(true);
    setShowActionMenu(null);
  };

  const closeDeleteModal = () => {
    setShowDeleteModal(false);
    setTeamToDelete(null);
  };

  const confirmDeleteTeam = () => {
    if (teamToDelete) {
      setTeamsData(teamsData.filter(team => team.id !== teamToDelete.id));
      
      const newFilteredTeams = teamsData.filter(
        team => team.id !== teamToDelete.id
      ).filter(team => {
        const matchesSearch = team.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                             team.coach.toLowerCase().includes(searchQuery.toLowerCase());
        const matchesCategory = selectedCategory === 'all' || team.category === selectedCategory;
        return matchesSearch && matchesCategory;
      });
      
      const newTotalPages = Math.ceil(newFilteredTeams.length / teamsPerPage);
      if (currentPage > newTotalPages && newTotalPages > 0) {
        setCurrentPage(newTotalPages);
      }
      
      closeDeleteModal();
    }
  };

  return (
    <section className='scrollbar-hide p-2'>
      <div className="flex flex-col md:flex-row py-5 md:py-8 justify-between items-center">
        <h2 className="text-xl lg:text-2xl font-bold text-[#011B3B]">
          Teams Management
        </h2>

        <div className="flex gap-3">
          <button 
            onClick={() => setShowCreateTeamModal(true)}
            className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200"
          >
            <Users className="w-5 h-5" />
            <span>Create Team</span>
          </button>

          {/* Create Game Button */}
          <button className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200">
            <Trophy className="w-5 h-5" />
            <span>Create Game</span>
          </button>
          {/* Create Game Button */}
          <button className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200">
            <Trophy className="w-5 h-5" />
            <span>Create Game</span>
          </button>
        </div>
      </div>

      {/* Search and Filter Section */}
      <div className="bg-white rounded-lg shadow-sm px-5 py-10 mb-6">
        <div className="flex flex-col md:flex-row gap-4 mb-6">
          {/* Search Bar */}
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search teams or coaches..."
              value={searchQuery}
              onChange={(e) => handleSearchChange(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 focus:border-transparent"
            />
          </div>

          {/* Category Filter */}
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <select
              value={selectedCategory}
              onChange={(e) => handleCategoryChange(e.target.value)}
              className="pl-10 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 focus:border-transparent cursor-pointer appearance-none bg-white min-w-[180px]"
            >
              {categories.map((category) => (
                <option key={category} value={category}>
                  {category === 'all' ? 'All Categories' : category}
                </option>
              ))}
            </select>
          </div>

          {/* Teams Per Page */}
          <div className="relative">
            <select
              value={teamsPerPage}
              onChange={(e) => handleTeamsPerPageChange(e.target.value)}
              className="pl-4 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 focus:border-transparent cursor-pointer appearance-none bg-white min-w-[120px]"
            >
              <option value={5}>5 per page</option>
              <option value={10}>10 per page</option>
              <option value={20}>20 per page</option>
              <option value={50}>50 per page</option>
            </select>
          </div>
        </div>

        {/* Teams Table */}
        {filteredTeams.length > 0 ? (
          <>
            <div className="overflow-hidden">
              <div className="overflow-x-auto scrollbar-hide">
                <table className="w-full min-w-[800px]">
                  <thead className="bg-gray-50 border-b border-gray-200">
                    <tr>
                      <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Team
                      </th>
                      <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Coach
                      </th>
                      <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Category
                      </th>
                      <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Games Played
                      </th>
                      <th className="px-6 py-4 text-left text-xs font-semibold text-gray-600 uppercase tracking-wider">
                        Actions
                      </th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-200">
                    {currentTeams.map((team) => (
                      <tr 
                        key={team.id} 
                        className="hover:bg-gray-50 transition-colors cursor-pointer"
                        onClick={() => viewTeamDetails(team.id)}
                      >
                        {/* Team Icon & Name */}
                        <td className="px-6 py-4 whitespace-nowrap">
                          <div className="flex items-center gap-3">
                            <div className="w-10 h-10 bg-gradient-to-br from-[#D30336] to-[#a8022b] rounded-full flex items-center justify-center">
                              <span className="text-white font-bold text-sm">
                                {team.icon}
                              </span>
                            </div>
                            <span className="font-medium text-[#011B3B]">{team.name}</span>
                          </div>
                        </td>

                        {/* Coach */}
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className="text-gray-700">{team.coach}</span>
                        </td>

                        {/* Category */}
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className={`px-3 py-1 rounded-full text-xs font-semibold ${
                            team.category === 'Senior' ? 'bg-blue-100 text-blue-800' :
                            team.category === 'Junior' ? 'bg-green-100 text-green-800' :
                            'bg-yellow-100 text-yellow-800'
                          }`}>
                            {team.category}
                          </span>
                        </td>

                        {/* Games Played */}
                        <td className="px-6 py-4 whitespace-nowrap">
                          <span className="font-semibold text-[#011B3B]">{team.gamesPlayed}</span>
                        </td>

                        {/* Actions */}
                        <td className="px-6 py-4 whitespace-nowrap relative" onClick={(e) => e.stopPropagation()}>
                          <button
                            onClick={() => toggleActionMenu(team.id)}
                            className="p-2 hover:bg-gray-100 rounded-lg transition-colors"
                          >
                            <MoreVertical className="w-5 h-5 text-gray-600" />
                          </button>

                          {/* Action Menu Dropdown */}
                          {showActionMenu === team.id && (
                            <div className="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-lg border border-gray-200 z-10">
                              <button 
                                onClick={() => viewTeamDetails(team.id)}
                                className="w-full flex items-center gap-3 px-4 py-3 hover:bg-gray-50 transition-colors text-left"
                              >
                                <Eye className="w-4 h-4 text-[#011B3B]" />
                                <span className="text-sm text-gray-700">View Details</span>
                              </button>
                              <button 
                                onClick={() => openDeleteModal(team)}
                                className="w-full flex items-center gap-3 px-4 py-3 hover:bg-red-50 transition-colors text-left border-t border-gray-100"
                              >
                                <Trash2 className="w-4 h-4 text-[#D30336]" />
                                <span className="text-sm text-[#D30336]">Delete Team</span>
                              </button>
                            </div>
                          )}
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>

            {/* Pagination Controls */}
            <div className="p-4 mt-4">
              <div className="flex flex-col md:flex-row items-center justify-between gap-4">
                {/* Results Info */}
                <div className="text-sm text-gray-600">
                  Showing <span className="font-semibold text-[#011B3B]">{indexOfFirstTeam + 1}</span> to{' '}
                  <span className="font-semibold text-[#011B3B]">
                    {Math.min(indexOfLastTeam, filteredTeams.length)}
                  </span>{' '}
                  of <span className="font-semibold text-[#011B3B]">{filteredTeams.length}</span> teams
                </div>

                {/* Pagination Buttons */}
                <div className="flex items-center gap-2">
                  <button
                    onClick={goToPreviousPage}
                    disabled={currentPage === 1}
                    className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-all ${
                      currentPage === 1
                        ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                        : 'bg-[#011B3B] text-white hover:bg-[#022d5f] hover:shadow-lg'
                    }`}
                  >
                    <ChevronLeft className="w-4 h-4" />
                    <span className="hidden sm:inline">Previous</span>
                  </button>

                  {/* Page Numbers */}
                  <div className="flex items-center gap-1">
                    {[...Array(totalPages)].map((_, index) => {
                      const pageNumber = index + 1;
                      if (
                        pageNumber === 1 ||
                        pageNumber === totalPages ||
                        (pageNumber >= currentPage - 1 && pageNumber <= currentPage + 1)
                      ) {
                        return (
                          <button
                            key={pageNumber}
                            onClick={() => setCurrentPage(pageNumber)}
                            className={`w-10 h-10 rounded-lg font-medium transition-all ${
                              currentPage === pageNumber
                                ? 'bg-[#D30336] text-white shadow-lg'
                                : 'bg-gray-100 text-gray-700 hover:bg-gray-200'
                            }`}
                          >
                            {pageNumber}
                          </button>
                        );
                      } else if (
                        pageNumber === currentPage - 2 ||
                        pageNumber === currentPage + 2
                      ) {
                        return (
                          <span key={pageNumber} className="px-2 text-gray-400">
                            ...
                          </span>
                        );
                      }
                      return null;
                    })}
                  </div>

                  <button
                    onClick={goToNextPage}
                    disabled={currentPage === totalPages}
                    className={`flex items-center gap-2 px-4 py-2 rounded-lg font-medium transition-all ${
                      currentPage === totalPages
                        ? 'bg-gray-100 text-gray-400 cursor-not-allowed'
                        : 'bg-[#011B3B] text-white hover:bg-[#022d5f] hover:shadow-lg'
                    }`}
                  >
                    <span className="hidden sm:inline">Next</span>
                    <ChevronRight className="w-4 h-4" />
                  </button>
                </div>
              </div>
            </div>
          </>
        ) : (
          // Empty State
          <div className="p-12 text-center">
            <div className="flex flex-col items-center">
              <div className="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mb-4">
                <Users className="w-10 h-10 text-gray-400" />
              </div>
              <h3 className="text-xl font-bold text-[#011B3B] mb-2">No Teams Found</h3>
              <p className="text-gray-600 mb-6">
                {searchQuery || selectedCategory !== 'all' 
                  ? "No teams match your search criteria. Try adjusting your filters."
                  : "Get started by creating your first team!"}
              </p>
              <button className="flex items-center gap-2 px-6 py-3 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200">
                <Users className="w-5 h-5" />
                <span>Create Your First Team</span>
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Delete Confirmation Modal */}
      {showDeleteModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 relative">
            {/* Close button */}
            <button
              onClick={closeDeleteModal}
              className="absolute top-4 right-4 text-gray-400 hover:text-gray-600 transition-colors"
            >
              <X className="w-5 h-5" />
            </button>

            {/* Icon */}
            <div className="w-16 h-16 bg-red-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Trash2 className="w-8 h-8 text-[#D30336]" />
            </div>

            {/* Title */}
            <h3 className="text-xl font-bold text-[#011B3B] text-center mb-2">
              Delete Team
            </h3>

            {/* Message */}
            <p className="text-gray-600 text-center mb-6">
              Are you sure you want to delete <span className="font-semibold text-[#011B3B]">{teamToDelete?.name}</span>? This action cannot be undone.
            </p>

            {/* Buttons */}
            <div className="flex gap-3">
              <button
                onClick={closeDeleteModal}
                className="flex-1 px-4 py-3 border-2 border-gray-300 text-gray-700 font-semibold rounded-lg hover:bg-gray-50 transition-all duration-200"
              >
                Cancel
              </button>
              <button
                onClick={confirmDeleteTeam}
                className="flex-1 px-4 py-3 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200"
              >
                Delete
              </button>
            </div>
          </div>
        </div>
      )}
    </section>
  );
}

export default Teams;