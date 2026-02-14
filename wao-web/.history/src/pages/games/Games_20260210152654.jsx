// src/pages/Games/Games.jsx
import React, { useState } from "react";
import { Trophy, Calendar, Play, Plus, Search, Filter } from "lucide-react";
import CreateGame from "./components/CreateGame";
import GameCard from "./components/GameCard";
import { gamesData as initialGamesData } from "../../config/constants";
import StatCard from "../../components/GameStats";

function Games() {
  const [games, setGames] = useState(initialGamesData);
  const [showCreateGameModal, setShowCreateGameModal] = useState(false);
  const [activeTab, setActiveTab] = useState("upcoming"); // upcoming, live, completed
  const [searchQuery, setSearchQuery] = useState("");

  const handleCreateGame = (newGame) => {
    setGames([...games, newGame]);
  };

  const handleStartGame = (gameId) => {
    // Navigate to game simulation
    window.location.href = `/games/${gameId}/simulate`;
  };

  const filteredGames = games.filter((game) => {
    const matchesSearch =
      game.homeTeam.toLowerCase().includes(searchQuery.toLowerCase()) ||
      game.awayTeam.toLowerCase().includes(searchQuery.toLowerCase()) ||
      game.venue.toLowerCase().includes(searchQuery.toLowerCase());

    const matchesTab = game.status === activeTab;

    return matchesSearch && matchesTab;
  });

  const upcomingGames = games.filter((g) => g.status === "upcoming");
  const liveGames = games.filter((g) => g.status === "live");
  const completedGames = games.filter((g) => g.status === "completed");

  return (
    <section className="scrollbar-hide p-2 pb-8">
      {/* Header */}
      <div className="flex flex-col md:flex-row py-5 md:py-8 justify-between items-center">
        <h2 className="text-xl lg:text-2xl font-bold text-[#011B3B]">
          Games Management
        </h2>

        <button
          onClick={() => setShowCreateGameModal(true)}
          className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200"
        >
          <Plus className="w-5 h-5" />
          <span>Create Game</span>
        </button>
      </div>

      {/* Stats Cards */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <StatCard
          type="upcoming"
          count={upcomingGames.length}
          subtitle="This Week's Games"
        />
        <StatCard
          type="live"
          count={liveGames.length}
          subtitle="Active Right Now"
        />
        <StatCard
          type="completed"
          count={completedGames.length}
          subtitle="This Month"
        />
      </div>

      {/* Tabs and Search */}
      <div className="bg-white rounded-lg shadow-sm mb-6">
        <div className="flex flex-col md:flex-row items-center justify-between p-4 border-b border-gray-200">
          {/* Tabs */}
          <div className="flex border-b border-gray-200 md:border-0 w-full md:w-auto mb-4 md:mb-0">
            <button
              onClick={() => setActiveTab("upcoming")}
              className={`px-6 py-3 font-medium whitespace-nowrap transition-colors ${
                activeTab === "upcoming"
                  ? "text-[#D30336] border-b-2 border-[#D30336] md:border-0 md:bg-red-50 md:rounded-lg"
                  : "text-gray-600 hover:text-[#011B3B]"
              }`}
            >
              Upcoming ({upcomingGames.length})
            </button>
            <button
              onClick={() => setActiveTab("live")}
              className={`px-6 py-3 font-medium whitespace-nowrap transition-colors ${
                activeTab === "live"
                  ? "text-[#D30336] border-b-2 border-[#D30336] md:border-0 md:bg-red-50 md:rounded-lg"
                  : "text-gray-600 hover:text-[#011B3B]"
              }`}
            >
              Live ({liveGames.length})
            </button>
            <button
              onClick={() => setActiveTab("completed")}
              className={`px-6 py-3 font-medium whitespace-nowrap transition-colors ${
                activeTab === "completed"
                  ? "text-[#D30336] border-b-2 border-[#D30336] md:border-0 md:bg-red-50 md:rounded-lg"
                  : "text-gray-600 hover:text-[#011B3B]"
              }`}
            >
              Completed ({completedGames.length})
            </button>
          </div>

          {/* Search */}
          <div className="relative w-full md:w-auto">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search games..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="w-full md:w-64 pl-10 pr-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 focus:border-transparent"
            />
          </div>
        </div>

        {/* Games Grid */}
        <div className="p-6">
          {filteredGames.length > 0 ? (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {filteredGames.map((game) => (
                <GameCard
                  key={game.id}
                  game={game}
                  onStartGame={handleStartGame}
                />
              ))}
            </div>
          ) : (
            <div className="text-center py-12">
              <div className="w-20 h-20 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
                <Trophy className="w-10 h-10 text-gray-400" />
              </div>
              <h3 className="text-xl font-bold text-[#011B3B] mb-2">
                No {activeTab} games
              </h3>
              <p className="text-gray-600 mb-6">
                {activeTab === "upcoming"
                  ? "Create a new game to get started."
                  : `No ${activeTab} games at the moment.`}
              </p>
              {activeTab === "upcoming" && (
                <button
                  onClick={() => setShowCreateGameModal(true)}
                  className="flex items-center gap-2 px-6 py-3 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200 mx-auto"
                >
                  <Plus className="w-5 h-5" />
                  <span>Create Game</span>
                </button>
              )}
            </div>
          )}
        </div>
      </div>

      {/* Create Game Modal */}
      <CreateGame
        isOpen={showCreateGameModal}
        onClose={() => setShowCreateGameModal(false)}
        onCreateGame={handleCreateGame}
      />
    </section>
  );
}

export default Games;
