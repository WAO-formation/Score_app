// DashboardLayout.jsx - REMOVE overflow-hidden from the main container
import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import SideNav from '../components/SideNav';
import Header from '../components/header';

const DashboardLayout = () => {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const [currentPage, setCurrentPage] = useState('Dashboard');
  const userName = "Afanyu Emmanuel";

  return (
    <div className="flex h-screen bg-[#F0F4F9]"> {/* REMOVED overflow-hidden */}
      {/* Side Navigation */}
      <SideNav 
        isSidebarOpen={isSidebarOpen} 
        setIsSidebarOpen={setIsSidebarOpen}
        setCurrentPage={setCurrentPage}
        userName={userName}
      />

      {/* Main Content Area */}
      <div className={`flex-1 flex flex-col transition-all duration-300 ${isSidebarOpen ? 'lg:ml-64' : 'lg:ml-20'}`}>
        {/* Header */}
        <Header 
          onMenuClick={() => setIsSidebarOpen(!isSidebarOpen)}
          currentPage={currentPage}
          userName={userName}
        />

        {/* Content Area - Outlet renders child routes */}
        <main className="flex-1 overflow-y-auto p-4 md:p-6">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default DashboardLayout;