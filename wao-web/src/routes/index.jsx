import React from 'react';
import { Routes, Route, Navigate } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import DashboardLayout from '../layout/DashboardLayout';
import Dashboard from '../pages/dashboard/Dashboard';
import Teams from '../pages/teams/Teams';
import TeamDetails from '../pages/teams/TeamDetails';
import Games from '../pages/games/Games';
import CreateGamePage from '../pages/games/CreateGamePage';
import GameDetails from '../pages/games/GameDetails';
import GameSimulation from '../pages/games/components/LiveGame';
import Management from '../pages/management/management';
import MyGamesPage from '../pages/moderator/MyGamesPage';
import MyOfficiatingPage from '../pages/officiating/MyOfficiatingPage';
import Profile from '../pages/profile/Profile';
import NotFound from '../pages/NotFound';
import Login from '../pages/auth/Login';
import ForgotPassword from '../pages/auth/ForgotPassword';
import VerifyEmail from '../pages/auth/VerifyEmail';
import LandingPage from '../pages/landing/LandingPage';
import HowToPlayPage from '../pages/how-to-play/HowToPlayPage';
import ProtectedRoute from './ProtectedRoute';

const AppRoutes = () => {
  const { user } = useAuth();

  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/how-to-play" element={<HowToPlayPage />} />
      <Route path="/login"           element={user ? <Navigate to="/dashboard" replace /> : <Login />} />
      <Route path="/forgot-password" element={user ? <Navigate to="/dashboard" replace /> : <ForgotPassword />} />
      <Route path="/verify-email"    element={!user ? <Navigate to="/login" replace /> : <VerifyEmail />} />

      <Route element={<ProtectedRoute />}>
        <Route element={<DashboardLayout />}>
          <Route path="dashboard" element={<Dashboard />} />
          <Route path="teams" element={<Teams />} />
          <Route path="teams/:teamId" element={<TeamDetails />} />
          <Route path="games" element={<Games />} />
          <Route path="games/create" element={<CreateGamePage />} />
          <Route path="games/:gameId" element={<GameDetails />} />
          <Route path="games/:gameId/simulate" element={<GameSimulation />} />
          <Route path="management" element={<Management />} />
          <Route path="my-games" element={<MyGamesPage />} />
          <Route path="officiating" element={<MyOfficiatingPage />} />
          <Route path="profile" element={<Profile />} />
        </Route>
      </Route>

      <Route path="*" element={<NotFound />} />
    </Routes>
  );
};

export default AppRoutes;
