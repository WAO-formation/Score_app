import { Home } from "lucide-react";
import React from "react";

function Dashboard() {
  return (
    <section className="flex flex-col lg:flex-row gap-4 h-full">
      {/* this will cover the main container */}
      <div className="flex-1 lg:w-[75%] overflow-y-auto spacer-y-6 pr-0 scrollbar-hide ">
        {/* this is the welcome section  */}
        <h2 className="text-xl lg:2xl font-bold text-[#011B3B] mb-4">
          Overview
        </h2>

        <div className="grid grid-col-1 md:grid-cols-3 gap-4">
          <div className="shadow-sm py-6 px-6 bg-gradient-to-br from-[#FFC600] to-[#FFD700] rounded-xl relative overflow-hidden">
            {/* Ball image positioned at bottom right */}
            <div className="absolute -right-8 -bottom-8 opacity-15">
              <img
                src="/assets/design/wao-ball.png"
                alt="ball gradient"
                className="w-32 h-32 object-contain"
              />
            </div>

            {/* Content */}
            <div className="relative z-10">
              <div className="flex gap-3 items-center mb-6">
                {/* icons design */}
                <div className="bg-white/30 backdrop-blur-sm p-3 rounded-xl shadow-sm">
                  <cale className="w-5 h-5 text-white" />
                </div>

                <h4 className="font-semibold text-white/90 text-base">
                  Upcoming Games
                </h4>
              </div>

              <div className="space-y-1">
                <h2 className="text-4xl font-bold text-white drop-shadow-sm">
                  12
                </h2>
                <p className="text-white/80 text-sm font-medium">
                  This Week's Games
                </p>
              </div>
            </div>
          </div>

          <div className="shadow-sm py-4 px-4 bg-yellow-400 rounded-xl">
            <div className="flex gap-2 items-center mb-4">
              {/* icons design  */}
              <div className="bg-white/20 p-2 rounded-lg">
                <Home className="w-6 h-6 text-white" />
              </div>

              <h4 className="font-semibold text-white text-sm">
                Upcoming Games
              </h4>
            </div>

            <h2 className="text-2xl font-bold text-white mb-2">12</h2>

            <p className="text-white text-sm">This Week's Games</p>
          </div>

          <div className="shadow-sm py-4 px-4 bg-yellow-400 rounded-xl">
            <div className="flex gap-2 items-center mb-4">
              {/* icons design  */}
              <div className="bg-white/20 p-2 rounded-lg">
                <Home className="w-6 h-6 text-white" />
              </div>

              <h4 className="font-semibold text-white text-sm">
                Upcoming Games
              </h4>
            </div>

            <h2 className="text-2xl font-bold text-white mb-2">12</h2>

            <p className="text-white text-sm">This Week's Games</p>
          </div>
        </div>
      </div>

      {/* this is a mini section  */}
      <aside className="w-full lg:w-[25%] overflow-y-auto space-y-6 pl-0 lg:pl-2 scrollbar-hide"></aside>
    </section>
  );
}

export default Dashboard;
