import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import DashboardLayout from '../layout/DashboardLayout';


import Dashboard from '../pages/dashboard/Dashboard';
import TestDashboard from '../pages/testfile';
import Teams from '../pages/teams/Teams';
import TeamDetails from '../pages/teams/TeamDetails';
import Games from '../pages/games/Games';
// import Games from '../pages/Games';
// import Management from '../pages/Management';
// import Settings from '../pages/Settings';

const AppRoutes = () => {
  return (
    <Routes>
      {/* Dashboard Routes - Wrapped in Layout */}
      <Route path="/" element={<DashboardLayout />}>
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<Dashboard />} />
        <Route path='Teams' element={<Teams />} />
        <Route path="teams/:teamId" element={<TeamDetails />} />
        <Route path="games" element={<Games />} />
        <Route path="games/:gameId" element={<Game />} />
        {/* <Route path="teams" element={<Teams />} />
        <Route path="games" element={<Games />} />
        <Route path="management" element={<Management />} />
        <Route path="settings" element={<Settings />} /> */}
      </Route>

      {/* 404 Route */}
      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  );
};

export default AppRoutes;