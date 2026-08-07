import React from 'react';
import { Routes, Route } from 'react-router-dom';
import DashboardLayout from '../layout/DashboardLayout';
import Dashboard from '../pages/dashboard/Dashboard';
import Teams from '../pages/teams/Teams';
import TeamDetails from '../pages/teams/TeamDetails';
import Games from '../pages/games/Games';
import GameDetails from '../pages/games/GameDetails';
import GameSimulation from '../pages/games/components/LiveGame';
import Management from '../pages/management/management';
import Profile from '../pages/profile/Profile';
import ProtectedRoute from './ProtectedRoute';

const PrivateRoutes = () => {
  return (
    <Routes>
      <Route element={<ProtectedRoute />}>
        <Route element={<DashboardLayout />}>
          <Route path="dashboard" element={<Dashboard />} />
          <Route path="teams" element={<Teams />} />
          <Route path="teams/:teamId" element={<TeamDetails />} />
          <Route path="games" element={<Games />} />
          <Route path="games/:gameId" element={<GameDetails />} />
          <Route path="games/:gameId/simulate" element={<GameSimulation />} />
          <Route path="management" element={<Management />} />
          <Route path="profile" element={<Profile />} />
        </Route>
      </Route>
    </Routes>
  );
};

export default PrivateRoutes;
