/* eslint-disable no-unused-vars */
import React, { useState } from "react";
import { Bell, Search, Menu, User } from "lucide-react";

const Header = ({ onMenuClick }) => {
  return (
    <header className="h-16 bg-white shadow-sm flex items-center justify-between px-4 md:px-6">
      
     <div className="flex items-center gap-2 ">
         <button
        onClick={onMenuClick}
        className=" p-2 text-[#011B3B] bg-gray hover:bg-gray-100 rounded-lg transition-colors"
      >
        <Menu className="w-6 h-6" />
      </button>

        <h2 className="text-xl font-bold text-[#011B3B]">Dashboard</h2>
     </div>

      {/* Right Side Icons */}
      <div className="flex items-center space-x-2 md:space-x-4">
        {/* Search Icon for Mobile */}
        <button className="md:hidden p-2 text-gray-600 hover:bg-gray-100 rounded-lg transition-colors">
          <Search className="w-5 h-5" />
        </button>

        {/* Search Bar - Hidden on mobile, shown on tablet and up */}
      <div className="hidden md:flex flex-1 max-w-md mx-4 lg:mx-8">
        <div className="relative w-3/4">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
          <input
            type="text"
            placeholder="Search..."
            className="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-slate-300 focus:border-transparent"
          />
        </div>
      </div>

        {/* Notification Bell */}
        <button className="relative p-2 text-gray-600 hover:bg-gray-100 rounded-lg transition-colors">
          <Bell className="w-5 h-5" />
          <span className="absolute top-1.5 right-1.5 w-2 h-2 bg-[#D30336] rounded-full"></span>
        </button>

        {/* User Avatar */}
        <div className="flex items-center space-x-2 md:space-x-3 pl-2 md:pl-4 border-l border-gray-200">
          <div className="w-8 h-8 md:w-9 md:h-9 bg-[#FFC600] rounded-full flex items-center justify-center">
            <span className="text-[#011B3B] font-semibold text-xs md:text-sm">
              JD
            </span>
          </div>
          {/* User Name - Hidden on mobile */}
          <div className="hidden lg:block">
            <p className="text-sm font-medium text-[#131314]">
              Afanyu Emmanuel
            </p>
            <p className="text-xs text-gray-500">Admin</p>
          </div>
        </div>
      </div>
    </header>
  );
};

export default Header;
