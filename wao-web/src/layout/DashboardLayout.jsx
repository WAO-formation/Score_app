import React, { useState } from 'react';
import { Outlet } from 'react-router-dom';
import SideNav from '../components/SideNav';
import Header from '../components/Header';
import { useAuth } from '../context/AuthContext';

const DashboardLayout = () => {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false);
  const { user } = useAuth();
  const userName = user?.displayName || user?.email || 'Account';
  const roleLabel = user?.role === 'admin' ? 'Admin' : 'Moderator';

  return (
    <div className="flex h-screen bg-gray-50 overflow-hidden">
      {/* Side Navigation */}
      <SideNav
        isSidebarOpen={isSidebarOpen}
        setIsSidebarOpen={setIsSidebarOpen}
        userName={userName}
        roleLabel={roleLabel}
      />

      {/* Main Content Area */}
      <div className={`flex-1 flex flex-col overflow-hidden transition-all duration-300 ${isSidebarOpen ? 'lg:ml-64' : 'lg:ml-20'}`}>
        {/* Header */}
        <Header
          onMenuClick={() => setIsSidebarOpen(!isSidebarOpen)}
          userName={userName}
          roleLabel={roleLabel}
        />

        {/* Content Area - Outlet renders child routes */}
        <main className="flex-1 overflow-y-auto px-4 md:px-6 ">
          <Outlet />
        </main>
      </div>
    </div>
  );
};

export default DashboardLayout;