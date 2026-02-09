import { Trophy } from "lucide-react";
import React from "react";
import StatCard from "./components/GameStats";
import { sampleGames } from "../../config/constants";
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
      <aside className="w-full lg:w-[25%] space-y-6 pl-0 lg:pl-2">
        {/* Add your aside content here */}
      </aside>
    </section>
  );
}

export default Dashboard;