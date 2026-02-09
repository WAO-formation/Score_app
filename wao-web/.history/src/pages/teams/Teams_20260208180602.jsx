import React from 'react'
import { Trophy, Users } from "lucide-react";

function Teams() {
  return (
    <section className='scrollbar-hide p-2'>
        <div className="flex flex-col md:flex-row py-5 md:py-8 justify-between items-center">
        <h2 className="text-xl lg:text-2xl font-bold text-[#011B3B]">
          Teams Management
        </h2>

        <div className="flex gap-3">
          {/* Create Team Button */}
          <button className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200">
            <Users className="w-5 h-5" />
            <span>Create Team</span>
          </button>

          {/* Create Game Button */}
          <button className="flex items-center cursor-pointer gap-2 px-6 py-3 bg-gradient-to-br from-[#D30336] to-[#a8022b] text-white font-semibold rounded-lg hover:shadow-lg hover:scale-105 transition-all duration-200">
            <Trophy className="w-5 h-5" />
            <span>Create Game</span>
          </button>
        </div>
      </div>

      
    </section>
  )
}

export default Teams