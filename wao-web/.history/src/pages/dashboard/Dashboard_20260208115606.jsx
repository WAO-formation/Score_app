import { Home } from "lucide-react";
import React from "react";

function Dashboard() {
  return (
    <section className="flex flex-col lg:flex-row gap-4 h-full">
      {/* this will cover the main container */}
      <div className="flex-1 lg:w-[75%] overflow-y-auto spacer-y-6 pr-0 scrollbar-hide ">
        {/* this is the welcome section  */}
        <h2 className="text-xl lg:2xl font-bold text-[#011B3B] mb-4">Overview</h2>

        <div className="grid grid-col-1 md:grid-cols-3 gap-4">
            <div className="shadow-sm py-4 px-4 bg-yellow-400 rounded-xl relative">

                <div className="absolute">
                    <img src="/public" alt="" />
                </div>
               <div className="flex gap-2 items-center mb-4">
                 {/* icons design  */}
                <div className="bg-white/20 p-2 rounded-lg">
                    <Home className="w-6 h-6 text-white" />
                </div>

                <h4 className="font-semibold text-white text-sm">Upcoming Games</h4>
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

                <h4 className="font-semibold text-white text-sm">Upcoming Games</h4>
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

                <h4 className="font-semibold text-white text-sm">Upcoming Games</h4>
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
