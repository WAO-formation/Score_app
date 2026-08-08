import { Navigate, Outlet } from 'react-router-dom';
import { useAuth } from '../context/AuthContext';
import ForcePasswordChange from '../pages/auth/ForcePasswordChange';

export default function ProtectedRoute() {
  const { user } = useAuth();
  if (!user) return <Navigate to="/login" replace />;
  if (user.mustChangePassword) return <ForcePasswordChange />;
  return <Outlet />;
}
