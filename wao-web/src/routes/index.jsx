import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import DashboardLayout from '../layout/DashboardLayout';
import Dashboard from '../pages/dashboard/Dashboard';
import Teams from '../pages/teams/Teams';
import TeamDetails from '../pages/teams/TeamDetails';
import Games from '../pages/games/Games';
import GameDetails from '../pages/games/GameDetails';
import GameSimulation from '../pages/games/components/LiveGame';
import Management from '../pages/management/management';
import Profile from '../pages/profile/Profile';
import NotFound from '../pages/NotFound';
import Login from '../pages/auth/Login';
import ForgotPassword from '../pages/auth/ForgotPassword';
import LandingPage from '../pages/landing/LandingPage';
import HowToPlayPage from '../pages/how-to-play/HowToPlayPage';
import ProtectedRoute from './ProtectedRoute';

const AppRoutes = () => {
  const { user } = useAuth();

  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/how-to-play" element={<HowToPlayPage />} />
      <Route path="/login" element={user ? <Navigate to="/dashboard" replace /> : <Login />} />
      <Route path="/forgot-password" element={user ? <Navigate to="/dashboard" replace /> : <ForgotPassword />} />

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

      <Route path="*" element={<NotFound />} />
    </Routes>
  );
};

export default AppRoutes;
