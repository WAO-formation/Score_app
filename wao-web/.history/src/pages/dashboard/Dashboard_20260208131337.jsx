import { Plus, Users } from "lucide-react";
import React from "react";
import StatCard from "./components/GameStats";

function Dashboard() {
  return (
    <section className="flex flex-col lg:flex-row gap-4 h-full">
      {/* this will cover the main container */}
      <div className="flex-1 lg:w-[75%] overflow-y-auto spacer-y-6 pr-0 scrollbar-hide ">
        {/* this is the welcome section  */}
        <h2 className="text-xl lg:2xl font-bold text-[#011B3B] mb-4">
          Overview
        </h2>

        <div className="grid grid-col-1 md:grid-cols-3 gap-4 mb-4">
          <StatCard type="upcoming" count="12" subtitle="This Week's Games" />
          <StatCard type="live" count="5" subtitle="Active Right Now" />
          <StatCard type="completed" count="48" subtitle="This Month" />
        </div>

        {/* this section will cover the recent teams added  */}

        <div className="flex flex-col md:flex-row gap-2">
          <div className="bg-gray-50 rounded-xl shadow-sm py-5 px-5 relative overflow-hidden md:w-[25%]">
            {/* Background ball decoration */}
            <div className="absolute -right-8 -bottom-8 opacity-5">
              <img
                src="/assets/design/wao-ball.png"
                alt="ball gradient"
                className="w-32 h-32 object-contain"
              />
            </div>

            <div className="relative z-10 space-y-8">
              {/* Title and count */}
              <div className="flex items-center justify-between">
                <h3 className="font-semibold text-[#011B3B]">
                  Create More Teams
                </h3>
              </div>

              {/* Stacked avatars with +N */}
              <div className="flex items-center justify-between">
                <div className="flex -space-x-2">
                  <div className="w-10 h-10 rounded-full bg-[#D30336] border-2 border-white flex items-center justify-center shadow-sm">
                    <span className="text-white font-bold text-xs">TW</span>
                  </div>
                  <div className="w-10 h-10 rounded-full bg-[#011B3B] border-2 border-white flex items-center justify-center shadow-sm">
                    <span className="text-white font-bold text-xs">LS</span>
                  </div>
                  <div className="w-10 h-10 rounded-full bg-[#FFC600] border-2 border-white flex items-center justify-center shadow-sm">
                    <span className="text-[#011B3B] font-bold text-xs">PR</span>
                  </div>
                  <div className="w-10 h-10 rounded-full bg-gradient-to-br from-[#D30336] to-[#FF3366] border-2 border-white flex items-center justify-center shadow-sm">
                    <span className="text-white font-bold text-xs">DF</span>
                  </div>
                  <div className="w-10 h-10 rounded-full bg-gray-100 border-2 border-white flex items-center justify-center shadow-sm">
                    <span className="text-[#011B3B] font-semibold text-xs">
                      +5
                    </span>
                  </div>
                </div>
              </div>

              {/* Full width button */}
              <button className="w-full py-2 bg-[#D30336] text-white text-gray-600 rounded-lg font-medium transition-colors flex items-center justify-center gap-2">
                Add Team
              </button>
            </div>
          </div>

          <div className="bg-gray-50 rounded-xl shadow-sm py-5 px-5 relative overflow-hidden md:w-[25%]"></div>
        </div>
      </div>

      {/* this is a mini section  */}
      <aside className="w-full lg:w-[25%] overflow-y-auto space-y-6 pl-0 lg:pl-2 scrollbar-hide"></aside>
    </section>
  );
}

export default Dashboard;
