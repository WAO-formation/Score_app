import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import DashboardLayout from '../layout/DashboardLayout';
import Dashboard from '../pages/dashboard/Dashboard';
import Teams from '../pages/teams/Teams';
import TeamDetails from '../pages/teams/TeamDetails';
import Games from '../pages/games/Games';
import GameDetails from '../pages/games/GameDetails';
import GameSimulation from '../pages/games/components/LiveGame';
import NotFound from '../pages/NotFound';

const AppRoutes = () => {
  return (
    <Routes>
      <Route path="/" element={<DashboardLayout />}>
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="dashboard" element={<Dashboard />} />
        <Route path="teams" element={<Teams />} />
        <Route path="teams/:teamId" element={<TeamDetails />} />
        <Route path="games" element={<Games />} />
        <Route path="games/:gameId" element={<GameDetails />} />
        <Route path="games/:gameId/simulate" element={<GameSimulation />} />
        <Route path="*" element={<NotFound />} />
      </Route>

      {/* Fully outside layout — standalone 404 for top-level unknown paths */}
      <Route path="*" element={<NotFound />} />
    </Routes>
  );
};

export default AppRoutes;