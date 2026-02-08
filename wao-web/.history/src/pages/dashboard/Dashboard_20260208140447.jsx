// Dashboard.jsx - Fix the height and overflow issues
import { Plus, Users } from "lucide-react";
import React from "react";
import StatCard from "./components/GameStats";
import { sampleGames } from "../../config/constants";
import UpcomingGames from "./components/UpcomingGames";

function Dashboard() {
  return (
    <section className="flex flex-col lg:flex-row gap-4"> {/* REMOVED h-full */}
      {/* Main container */}
      <div className="flex-1 lg:w-[75%] space-y-6"> {/* REMOVED overflow-y-auto, FIXED typo: spacer-y-6 to space-y-6 */}
        {/* Welcome section */}
        <h2 className="text-xl lg:text-2xl font-bold text-[#011B3B]"> {/* REMOVED mb-4, using space-y-6 instead */}
          Overview
        </h2>

        <div className="grid grid-cols-1 md:grid-cols-3 gap-4"> {/* REMOVED mb-4, FIXED typo: grid-col-1 to grid-cols-1 */}
          <StatCard type="upcoming" count="12" subtitle="This Week's Games" />
          <StatCard type="live" count="5" subtitle="Active Right Now" />
          <StatCard type="completed" count="48" subtitle="This Month" />
        </div>

        {/* Recent teams added section */}
        <UpcomingGames games={sampleGames} />
      </div>

      {/* Mini section */}
      <aside className="w-full lg:w-[25%] space-y-6 lg:pl-2"> {/* REMOVED overflow-y-auto and scrollbar-hide */}
        {/* Add your aside content here */}
      </aside>
    </section>
  );
}

export default Dashboard;