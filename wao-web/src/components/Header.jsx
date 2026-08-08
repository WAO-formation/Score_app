import { useState } from 'react';
import { Bell, Search, Menu, X } from 'lucide-react';
import { useLocation, useNavigate } from 'react-router-dom';
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
  const location = useLocation();
  const navigate = useNavigate();

  const segment = location.pathname.split('/')[1] || 'dashboard';
  const pageTitle = PAGE_NAMES[segment] ?? segment.charAt(0).toUpperCase() + segment.slice(1);

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
          <button className="relative p-2 rounded-sm text-gray-500 hover:bg-gray-100 transition-colors">
            <Bell className="w-4 h-4" />
            <span
              className="absolute top-1.5 right-1.5 w-1.5 h-1.5 rounded-full"
              style={{ backgroundColor: BRAND.primary }}
            />
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
    </header>
  );
};

export default Header;
