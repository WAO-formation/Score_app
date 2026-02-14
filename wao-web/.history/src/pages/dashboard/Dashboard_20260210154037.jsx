import { Trophy, Users } from "lucide-react";
import React, { useState } from "react";
import StatCard from "../../components/GameStats";
import { sampleGames, recentTeams } from "../../config/constants";
import UpcomingGames from "./components/UpcomingGames";
import MainCalendar from "../../components/MainCalendar";
import { gamesData as initialGamesData } from "../../config/constants";

function Dashboard() {
  const [games, setGames] = useState(initialGamesData);
  const [showCreateGameModal, setShowCreateGameModal] = useState(false);

  const handleCreateGame = (newGame) => {
    setGames([...games, newGame]);
  };

  const upcomingGames = games.filter((g) => g.status === "upcoming");
  const liveGames = games.filter((g) => g.status === "live");
  const completedGames = games.filter((g) => g.status === "completed");

  return (
    <section className="scrollbar-hide pb-8">
      <div className="flex flex-col md:flex-row py-5 md:py-8 justify-between items-center">
        <h2 className="text-xl lg:text-2xl font-bold text-[#011B3B]">
          Overview
        </h2>

        <div className="flex gap-3">
          {/* Create Team Button */}
          <button className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200">
            <Users className="w-5 h-5" />
            <span>Create Team</span>
          </button>

          {/* Create Game Button */}
          <button
            onClick={() => setShowCreateGameModal(true)}
            className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200"
          >
            <Trophy className="w-5 h-5" />
            <span>Create Game</span>
          </button>
        </div>
      </div>

      <div className="flex flex-col lg:flex-row h-full overflow-y-auto scrollbar-hide pb-8">
        {/* Main container */}
        <div className="flex-1 lg:w-[75%] space-y-6 pr-0 lg:pr-2">
          {/* Stats Grid */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
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

          {/* Upcoming Games */}
          <UpcomingGames games={sampleGames} />

          {/* Recent Activity */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <h2 className="text-xl font-bold text-[#011B3B] mb-4">
              Recent Activity
            </h2>
            <div className="space-y-4">
              {[1, 2, 3, 4, 5].map((item) => (
                <div
                  key={item}
                  className="flex items-center justify-between py-3 border-b border-gray-200 last:border-b-0"
                >
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center">
                      <Trophy className="w-5 h-5 text-[#011B3B]" />
                    </div>
                    <div>
                      <p className="font-medium text-[#011B3B]">
                        New game scheduled
                      </p>
                      <p className="text-sm text-gray-500">2 hours ago</p>
                    </div>
                  </div>
                  <button className="text-[#D30336] cursor-pointer text-sm font-medium hover:underline">
                    View
                  </button>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Sidebar */}
        <aside className="w-full lg:w-[25%] space-y-3 pl-0 lg:pl-2">
          {/* Calendar Widget */}

          <MainCalendar />

          {/* Recent Teams */}
          <div className="bg-white rounded-lg shadow-sm p-6">
            <div className="flex items-center justify-between mb-4">
              <h3 className="text-lg font-bold text-[#011B3B]">Recent Teams</h3>
              <Users className="w-5 h-5 text-[#D30336]" />
            </div>
            <div className="space-y-1">
              {recentTeams.map((team) => (
                <div
                  key={team.id}
                  className="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer"
                >
                  <div className="flex items-center space-x-3">
                    <div className="w-10 h-10 bg-[#D30336] rounded-full flex items-center justify-center">
                      <span className="text-white font-bold text-xs">
                        {team.name.substring(0, 2).toUpperCase()}
                      </span>
                    </div>
                    <div>
                      <p className="font-medium text-[#011B3B] text-sm">
                        {team.name}
                      </p>
                      <p className="text-xs text-gray-600">
                        {team.members} members
                      </p>
                    </div>
                  </div>
                </div>
              ))}
            </div>
            <button className="w-full mt-4 text-[#D30336] text-sm font-medium hover:underline">
              View All Teams
            </button>
          </div>
        </aside>
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

export default Dashboard;
