import React, { useState } from 'react';
import { Trophy, Users, Search, Filter, MoreVertical, Edit, Trash2, Eye, ChevronLeft, ChevronRight } from "lucide-react";

function Teams() {
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [showActionMenu, setShowActionMenu] = useState(null);
  const [currentPage, setCurrentPage] = useState(1);
  const [teamsPerPage, setTeamsPerPage] = useState(10);

  // Sample teams data (replace with your actual data)
  const teamsData = [
    {
      id: 1,
      name: "Thunder Lions",
      coach: "John Smith",
      category: "Senior",
      gamesPlayed: 15,
      icon: "TL"
    },
    {
      id: 2,
      name: "Phoenix Warriors",
      coach: "Sarah Johnson",
      category: "Junior",
      gamesPlayed: 12,
      icon: "PW"
    },
    {
      id: 3,
      name: "Storm Eagles",
      coach: "Michael Brown",
      category: "Youth",
      gamesPlayed: 8,
      icon: "SE"
    },
    {
      id: 4,
      name: "Blazing Tigers",
      coach: "Emma Davis",
      category: "Senior",
      gamesPlayed: 20,
      icon: "BT"
    },
    {
      id: 5,
      name: "Ice Wolves",
      coach: "David Wilson",
      category: "Junior",
      gamesPlayed: 10,
      icon: "IW"
    },
    {
      id: 6,
      name: "Dragon Force",
      coach: "Lisa Anderson",
      category: "Youth",
      gamesPlayed: 14,
      icon: "DF"
    },
    {
      id: 7,
      name: "Mighty Sharks",
      coach: "Robert Taylor",
      category: "Senior",
      gamesPlayed: 18,
      icon: "MS"
    },
    {
      id: 8,
      name: "Golden Hawks",
      coach: "Jennifer Lee",
      category: "Junior",
      gamesPlayed: 11,
      icon: "GH"
    },
    {
      id: 9,
      name: "Steel Panthers",
      coach: "Chris Martin",
      category: "Youth",
      gamesPlayed: 9,
      icon: "SP"
    },
    {
      id: 10,
      name: "Blazing Comets",
      coach: "Amanda White",
      category: "Senior",
      gamesPlayed: 16,
      icon: "BC"
    },
    {
      id: 11,
      name: "Wild Mustangs",
      coach: "Kevin Harris",
      category: "Junior",
      gamesPlayed: 13,
      icon: "WM"
    },
    {
      id: 12,
      name: "Royal Falcons",
      coach: "Michelle Clark",
      category: "Youth",
      gamesPlayed: 7,
      icon: "RF"
    }
  ];

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

  return (
    <section className='scrollbar-hide p-2'>
      <div className="flex flex-col md:flex-row py-5 md:py-8 justify-between items-center">
        <h2 className="text-xl lg:text-2xl font-bold text-[#011B3B]">
          Teams Management
        </h2>

        <div className="flex gap-3">
          {/* Create Team Button */}
          <button className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200">
            <Users className="w-5 h-5" />
            <span>Create Team</span>
          </button>

          {/* Create Game Button */}
          <button className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200">
            <Trophy className="w-5 h-5" />
            <span>Create Game</span>
          </button>
        </div>
      </div>

      {/* Search and Filter Section */}
      <div className="bg-white rounded-lg shadow-sm p-4 mb-6">
        <div className="flex flex-col md:flex-row gap-4">
          {/* Search Bar */}
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search teams or coaches..."
              value={searchQuery}
              onChange={(e) => handleSearchChange(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336] focus:border-transparent"
            />
          </div>

          {/* Category Filter */}
          <div className="relative">
            <Filter className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <select
              value={selectedCategory}
              onChange={(e) => handleCategoryChange(e.target.value)}
              className="pl-10 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336] focus:border-transparent cursor-pointer appearance-none bg-white min-w-[180px]"
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
              className="pl-4 pr-8 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-[#D30336] focus:border-transparent cursor-pointer appearance-none bg-white min-w-[120px]"
            >
              <option value={5}>5 per page</option>
              <option value={10}>10 per page</option>
              <option value={20}>20 per page</option>
              <option value={50}>50 per page</option>
            </select>
          </div>
        </div>

        
      </div>
    </section>
  );
}

export default Teams;