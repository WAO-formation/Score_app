import { Trophy } from "lucide-react";
import React from "react";
import StatCard from "./components/GameStats";
import { sampleGames, recentTeams, u } from "../../config/constants";
import UpcomingGames from "./components/UpcomingGames";

function Dashboard() {
  return (
    <section className="flex flex-col lg:flex-row gap-4 h-full overflow-y-auto scrollbar-hide pb-8">
      {/* this will cover the main container */}
      <div className="flex-1 lg:w-[75%] space-y-6 pr-0">
        {/* this is the welcome section  */}
        <h2 className="text-xl lg:text-2xl font-bold text-[#011B3B] mb-4 md:mt-6 mt-4">
          Overview
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-4">
          <StatCard type="upcoming" count="12" subtitle="This Week's Games" />
          <StatCard type="live" count="5" subtitle="Active Right Now" />
          <StatCard type="completed" count="48" subtitle="This Month" />
        </div>

        {/* this section will cover the recent teams added  */}
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

      {/* this is a mini section  */}
      <aside className='w-full lg:w-[25%] overflow-y-auto space-y-6 pl-0 lg:pl-2 scrollbar-hide'>
        {/* Calendar Widget */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-bold text-[#011B3B]">Calendar</h3>
            <CalendarDays className="w-5 h-5 text-[#D30336]" />
          </div>
          <div className="space-y-2">
            <div className="text-center py-4 bg-gray-50 rounded-lg">
              <p className="text-3xl font-bold text-[#011B3B]">08</p>
              <p className="text-sm text-gray-600">February 2026</p>
            </div>
            <div className="grid grid-cols-7 gap-1 text-center text-xs mt-4">
              {['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day, i) => (
                <div key={i} className="font-semibold text-gray-600 py-2">
                  {day}
                </div>
              ))}
              {[...Array(28)].map((_, i) => (
                <div
                  key={i}
                  className={`py-2 rounded ${
                    i + 1 === 8
                      ? 'bg-[#D30336] text-white font-bold'
                      : 'hover:bg-gray-100 text-gray-700'
                  }`}
                >
                  {i + 1}
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* Upcoming Events */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-bold text-[#011B3B]">Upcoming Events</h3>
            <Clock className="w-5 h-5 text-[#D30336]" />
          </div>
          <div className="space-y-3">
            {upcomingEvents.map((event) => (
              <div
                key={event.id}
                className="p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer"
              >
                <p className="font-medium text-[#011B3B] text-sm mb-1">
                  {event.title}
                </p>
                <div className="flex items-center justify-between text-xs text-gray-600">
                  <span>{event.date}</span>
                  <span className="text-[#D30336] font-medium">{event.time}</span>
                </div>
              </div>
            ))}
          </div>
          <button className="w-full mt-4 text-[#D30336] text-sm font-medium hover:underline">
            View All Events
          </button>
        </div>

        {/* Recent Teams */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-bold text-[#011B3B]">Recent Teams</h3>
            <Users className="w-5 h-5 text-[#D30336]" />
          </div>
          <div className="space-y-3">
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
                    <p className="text-xs text-gray-600">{team.members} members</p>
                  </div>
                </div>
                <span
                  className={`px-2 py-1 rounded-full text-xs font-medium ${
                    team.status === 'Active'
                      ? 'bg-green-100 text-green-700'
                      : 'bg-gray-200 text-gray-700'
                  }`}
                >
                  {team.status}
                </span>
              </div>
            ))}
          </div>
          <button className="w-full mt-4 text-[#D30336] text-sm font-medium hover:underline">
            View All Teams
          </button>
        </div>

        {/* Quick Actions */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h3 className="text-lg font-bold text-[#011B3B] mb-4">Quick Actions</h3>
          <div className="space-y-2">
            <button className="w-full py-3 bg-[#D30336] text-white rounded-lg hover:bg-[#A50229] transition-colors font-medium">
              Schedule New Game
            </button>
            <button className="w-full py-3 bg-[#FFC600] text-[#011B3B] rounded-lg hover:bg-[#E6B200] transition-colors font-medium">
              Add New Team
            </button>
            <button className="w-full py-3 bg-gray-100 text-[#011B3B] rounded-lg hover:bg-gray-200 transition-colors font-medium">
              View Reports
            </button>
          </div>
        </div>
      </aside>
    </section>
  );
}

export default Dashboard;