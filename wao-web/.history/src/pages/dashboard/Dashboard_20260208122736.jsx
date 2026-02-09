import { Calendar, Home } from "lucide-react";
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

        <div className="grid grid-col-1 md:grid-cols-3 gap-4">
          <StatCard type="upcoming" count="12" subtitle="This Week's Games" />
          <StatCard type="live" count="5" subtitle="Active Right Now" />
          <StatCard type="completed" count="48" subtitle="This Month" />
        </div>

        {/* this section will cover the recent teams added  */}

        
      </div>

      {/* this is a mini section  */}
      <aside className="w-full lg:w-[25%] overflow-y-auto space-y-6 pl-0 lg:pl-2 scrollbar-hide"></aside>
    </section>
  );
}

export default Dashboard;
