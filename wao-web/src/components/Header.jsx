import { useState } from 'react';
import { Bell, Search, Menu, X, Radio, Calendar, CheckCircle2 } from 'lucide-react';
import { useLocation, useNavigate } from 'react-router-dom';
import { useGames } from '../context/GamesContext';
import { BRAND } from '../config/brand';

const PAGE_NAMES = {
  dashboard:  'Dashboard',
  teams:      'Teams',
  games:      'Games',
  management: 'Management',
  profile:    'Profile',
};

const getInitials = (name) => {
  if (!name) return 'U';
  const parts = name.trim().split(' ');
  return parts.length === 1
    ? parts[0][0].toUpperCase()
    : (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
};

const Header = ({ onMenuClick, userName = 'Account', roleLabel = 'Admin' }) => {
  const [mobileSearch, setMobileSearch] = useState(false);
  const [showNotifications, setShowNotifications] = useState(false);
  const location = useLocation();
  const navigate = useNavigate();
  const { games } = useGames();

  const segment = location.pathname.split('/')[1] || 'dashboard';
  const pageTitle = PAGE_NAMES[segment] ?? segment.charAt(0).toUpperCase() + segment.slice(1);

  const isToday = (dateStr) => {
    const d = new Date(dateStr);
    const today = new Date();
    return d.toDateString() === today.toDateString();
  };

  const notifications = [
    ...games.filter(g => g.status === 'live').map(g => ({
      id: `live-${g.id}`,
      icon: Radio,
      iconStyle: 'bg-emerald-100 text-emerald-600',
      title: `${g.homeTeam} vs ${g.awayTeam} is live`,
      meta: `${g.currentQuarter || ''} · ${g.timeRemaining || ''}`.trim(),
      gameId: g.id,
    })),
    ...games.filter(g => g.status === 'upcoming' && isToday(g.date)).map(g => ({
      id: `today-${g.id}`,
      icon: Calendar,
      iconStyle: 'bg-blue-100 text-blue-600',
      title: `${g.homeTeam} vs ${g.awayTeam} starts today`,
      meta: `${g.time || ''} · ${g.venue || ''}`.trim(),
      gameId: g.id,
    })),
  ];

  const goToNotification = (n) => {
    setShowNotifications(false);
    navigate(`/games/${n.gameId}`);
  };

  return (
    <header className="h-16 bg-white border-b border-gray-100 flex items-center justify-between px-4 md:px-6 shrink-0">

      {/* Left */}
      <div className="flex items-center gap-3">
        <button
          onClick={onMenuClick}
          className="p-2 rounded-sm text-gray-500 hover:bg-gray-100 hover:text-gray-900 transition-colors"
        >
          <Menu className="w-5 h-5" />
        </button>

        {!mobileSearch && (
          <h1
            className="text-base font-semibold text-gray-900 uppercase tracking-widest"
            style={{ fontFamily: BRAND.font.body }}
          >
            {pageTitle}
          </h1>
        )}
      </div>

      {/* Mobile search expanded */}
      {mobileSearch && (
        <div className="md:hidden flex-1 mx-3">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search..."
              autoFocus
              className="w-full pl-9 pr-4 py-2 text-sm border border-gray-200 rounded-sm focus:outline-none focus:border-gray-400 transition-colors"
              style={{ fontFamily: BRAND.font.body }}
            />
          </div>
        </div>
      )}

      {/* Right */}
      <div className="flex items-center gap-2">
        {/* Desktop search */}
        <div className="hidden md:flex items-center">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input
              type="text"
              placeholder="Search..."
              className="w-48 lg:w-64 pl-9 pr-4 py-2 text-sm border border-gray-200 rounded-sm focus:outline-none focus:border-gray-400 transition-colors bg-gray-50"
              style={{ fontFamily: BRAND.font.body }}
            />
          </div>
        </div>

        {/* Mobile search toggle */}
        <button
          onClick={() => setMobileSearch(!mobileSearch)}
          className="md:hidden p-2 rounded-sm text-gray-500 hover:bg-gray-100 transition-colors"
        >
          {mobileSearch ? <X className="w-4 h-4" /> : <Search className="w-4 h-4" />}
        </button>

        {/* Notifications */}
        {!mobileSearch && (
          <button
            onClick={() => setShowNotifications(true)}
            className="relative p-2 rounded-sm text-gray-500 hover:bg-gray-100 transition-colors"
          >
            <Bell className="w-4 h-4" />
            {notifications.length > 0 && (
              <span
                className="absolute top-1.5 right-1.5 w-1.5 h-1.5 rounded-full"
                style={{ backgroundColor: BRAND.primary }}
              />
            )}
          </button>
        )}

        {/* User */}
        {!mobileSearch && (
          <button
            onClick={() => navigate('/profile')}
            className="flex items-center gap-2.5 pl-3 border-l border-gray-100 hover:opacity-80 transition-opacity"
          >
            <div
              className="w-8 h-8 rounded-sm flex items-center justify-center text-white text-xs font-bold shrink-0"
              style={{ backgroundColor: BRAND.primary, fontFamily: BRAND.font.body }}
            >
              {getInitials(userName)}
            </div>
            <div className="hidden lg:block text-left">
              <p className="text-xs font-semibold text-gray-900 leading-tight" style={{ fontFamily: BRAND.font.body }}>
                {userName}
              </p>
              <p className="text-xs text-gray-400 leading-tight" style={{ fontFamily: BRAND.font.body }}>
                {roleLabel}
              </p>
            </div>
          </button>
        )}
      </div>

      {/* Notifications modal */}
      {showNotifications && (
        <div className="fixed inset-0 bg-black/50 flex items-start justify-center z-50 p-4 pt-20">
          <div className="bg-white shadow-xl w-full max-w-sm relative max-h-[70vh] flex flex-col">
            <div className="flex items-center justify-between px-5 py-4 border-b border-gray-100">
              <h3 className="text-sm font-semibold text-gray-900 uppercase tracking-widest" style={{ fontFamily: BRAND.font.body }}>
                Notifications
              </h3>
              <button onClick={() => setShowNotifications(false)} className="text-gray-400 hover:text-gray-600">
                <X className="w-4 h-4" />
              </button>
            </div>

            <div className="overflow-y-auto">
              {notifications.length > 0 ? (
                <div className="divide-y divide-gray-50">
                  {notifications.map((n) => {
                    const Icon = n.icon;
                    return (
                      <button
                        key={n.id}
                        onClick={() => goToNotification(n)}
                        className="w-full flex items-start gap-3 px-5 py-3.5 text-left hover:bg-gray-50 transition-colors"
                      >
                        <div className={`w-8 h-8 rounded-sm flex items-center justify-center shrink-0 ${n.iconStyle}`}>
                          <Icon className="w-4 h-4" />
                        </div>
                        <div className="min-w-0">
                          <p className="text-sm font-medium text-gray-900 truncate" style={{ fontFamily: BRAND.font.body }}>{n.title}</p>
                          {n.meta && <p className="text-xs text-gray-400 mt-0.5" style={{ fontFamily: BRAND.font.body }}>{n.meta}</p>}
                        </div>
                      </button>
                    );
                  })}
                </div>
              ) : (
                <div className="flex flex-col items-center text-center py-12 px-5">
                  <div className="w-12 h-12 rounded-sm bg-gray-100 flex items-center justify-center mb-3">
                    <CheckCircle2 className="w-6 h-6 text-gray-300" />
                  </div>
                  <p className="text-sm font-semibold text-gray-500" style={{ fontFamily: BRAND.font.body }}>You're all caught up</p>
                  <p className="text-xs text-gray-400 mt-1" style={{ fontFamily: BRAND.font.body }}>Live games and today's schedule will show up here.</p>
                </div>
              )}
            </div>
          </div>
        </div>
      )}
    </header>
  );
};

export default Header;
