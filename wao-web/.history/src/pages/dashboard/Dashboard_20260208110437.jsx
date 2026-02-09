import React from 'react';
import { Users, Trophy, Calendar, TrendingUp, CalendarDays, Clock } from 'lucide-react';

function Dashboard() {
  const stats = [
    {
      title: 'Total Teams',
      value: '24',
      change: '+12%',
      icon: Users,
      color: 'bg-blue-500',
    },
    {
      title: 'Active Games',
      value: '156',
      change: '+8%',
      icon: Trophy,
      color: 'bg-[#D30336]',
    },
    {
      title: 'Upcoming Events',
      value: '12',
      change: '+3%',
      icon: Calendar,
      color: 'bg-[#FFC600]',
    },
    {
      title: 'Growth Rate',
      value: '23%',
      change: '+5%',
      icon: TrendingUp,
      color: 'bg-green-500',
    },
  ];

  const upcomingEvents = [
    { id: 1, title: 'Team A vs Team B', date: 'Feb 10, 2026', time: '3:00 PM' },
    { id: 2, title: 'Team C vs Team D', date: 'Feb 12, 2026', time: '5:00 PM' },
    { id: 3, title: 'Team E vs Team F', date: 'Feb 15, 2026', time: '2:00 PM' },
    { id: 4, title: 'Team G vs Team H', date: 'Feb 18, 2026', time: '4:00 PM' },
  ];

  const recentTeams = [
    { id: 1, name: 'Thunder Warriors', members: 24, status: 'Active' },
    { id: 2, name: 'Lightning Strikers', members: 22, status: 'Active' },
    { id: 3, name: 'Phoenix Rising', members: 20, status: 'Inactive' },
    { id: 4, name: 'Dragon Force', members: 25, status: 'Active' },
  ];

  return (
    <section className='flex flex-col lg:flex-row gap-4 md:gap-6 h-full'>
      {/* Main Content - 70% */}
      <div className='flex-1 lg:w-[70%] overflow-y-auto space-y-6 pr-0 lg:pr-2'>
        {/* Welcome Section */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h1 className="text-2xl font-bold text-[#011B3B] mb-2">
            Welcome back, Afanyu!
          </h1>
          <p className="text-gray-600">
            Here's what's happening with your sports management today.
          </p>
        </div>

        {/* Stats Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4 md:gap-6">
          {stats.map((stat, index) => {
            const Icon = stat.icon;
            return (
              <div
                key={index}
                className="bg-white rounded-lg shadow-sm p-6 hover:shadow-md transition-shadow"
              >
                <div className="flex items-center justify-between mb-4">
                  <div className={`${stat.color} p-3 rounded-lg`}>
                    <Icon className="w-6 h-6 text-white" />
                  </div>
                  <span className="text-green-600 text-sm font-medium">
                    {stat.change}
                  </span>
                </div>
                <h3 className="text-gray-600 text-sm font-medium mb-1">
                  {stat.title}
                </h3>
                <p className="text-2xl font-bold text-[#011B3B]">{stat.value}</p>
              </div>
            );
          })}
        </div>

        {/* Recent Activity */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h2 className="text-xl font-bold text-[#011B3B] mb-4">
            Recent Activity
          </h2>
          <div className="space-y-4">
            {[1, 2, 3, 4, 5].map((item) => (
              <div
                key={item}
                className="flex items-center justify-between py-3 border-b last:border-b-0"
              >
                <div className="flex items-center space-x-3">
                  <div className="w-10 h-10 bg-gray-100 rounded-full flex items-center justify-center">
                    <Trophy className="w-5 h-5 text-[#D30336]" />
                  </div>
                  <div>
                    <p className="font-medium text-[#011B3B]">
                      New game scheduled
                    </p>
                    <p className="text-sm text-gray-500">2 hours ago</p>
                  </div>
                </div>
                <button className="text-[#D30336] text-sm font-medium hover:underline">
                  View
                </button>
              </div>
            ))}
          </div>
        </div>

        {/* Add more content here to test scrolling */}
        <div className="bg-white rounded-lg shadow-sm p-6">
          <h2 className="text-xl font-bold text-[#011B3B] mb-4">
            Performance Overview
          </h2>
          <div className="h-64 bg-gray-50 rounded-lg flex items-center justify-center">
            <p className="text-gray-400">Chart placeholder</p>
          </div>
        </div>
      </div>

      {/* Sidebar - 30% */}
      <aside className='w-full lg:w-[30%] overflow-y-auto space-y-6 pl-0 lg:pl-2'>
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