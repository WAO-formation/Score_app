import { createContext, useContext, useState } from 'react';

const AuthContext = createContext(null);

// Temporary credentials — replace with Firebase when backend is ready
const USERS = [
  { email: 'admin@wao.com', password: 'wao@admin', name: 'WAO Admin', role: 'Administrator' },
];

export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    const saved = sessionStorage.getItem('wao_user');
    return saved ? JSON.parse(saved) : null;
  });

  const login = (email, password) => {
    const match = USERS.find(u => u.email === email && u.password === password);
    if (!match) return Promise.reject({ code: 'auth/invalid-credential' });
    const { password: _, ...safeUser } = match;
    sessionStorage.setItem('wao_user', JSON.stringify(safeUser));
    setUser(safeUser);
    return Promise.resolve(safeUser);
  };

  const logout = () => {
    sessionStorage.removeItem('wao_user');
    setUser(null);
    return Promise.resolve();
  };

  const resetPassword = (email) => {
    const exists = USERS.find(u => u.email === email);
    if (!exists) return Promise.reject({ code: 'auth/user-not-found' });
    // No-op for now — will trigger Firebase email when backend is ready
    return Promise.resolve();
  };

  return (
    <AuthContext.Provider value={{ user, login, logout, resetPassword }}>
      {children}
    </AuthContext.Provider>
  );
}

export const useAuth = () => {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used inside AuthProvider');
  return ctx;
};
