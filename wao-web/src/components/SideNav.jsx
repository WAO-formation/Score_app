import { useNavigate, useLocation } from 'react-router-dom';
import { menuItems } from '../config/constants';
import { X, LogOut } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { BRAND } from '../config/brand';

const FONTS = `@import url('https://fonts.googleapis.com/css2?family=Anton&family=Oswald:wght@400;500;600&display=swap');`;

const getInitials = (name) => {
  if (!name) return 'U';
  const parts = name.trim().split(' ');
  return parts.length === 1
    ? parts[0][0].toUpperCase()
    : (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
};

const SideNav = ({ isSidebarOpen, setIsSidebarOpen, userName = 'Account', roleLabel = 'Admin' }) => {
  const navigate = useNavigate();
  const location = useLocation();
  const { logout } = useAuth();

  const activeSegment = location.pathname.split('/')[1] || 'dashboard';

  const handleNav = (item) => {
    navigate(item.href);
    if (window.innerWidth < 1024) setIsSidebarOpen(false);
  };

  const handleLogout = async () => {
    await logout();
    navigate('/login', { replace: true });
  };

  return (
    <>
      <style>{FONTS}</style>

      {/* Mobile overlay */}
      {isSidebarOpen && (
        <div
          className="lg:hidden fixed inset-0 z-40 bg-black/60 backdrop-blur-sm"
          onClick={() => setIsSidebarOpen(false)}
        />
      )}

      <aside
        className={`
          fixed left-0 top-0 z-50 h-screen flex flex-col
          bg-[#0a0a0a] border-r border-white/5
          transition-all duration-300 ease-in-out
          ${isSidebarOpen ? 'w-64 translate-x-0' : '-translate-x-full lg:translate-x-0 lg:w-20'}
        `}
      >
        {/* Logo */}
        <div className="h-16 flex items-center justify-between px-4 border-b border-white/5 shrink-0">
          <div className={`flex items-center gap-3 overflow-hidden ${!isSidebarOpen && 'lg:justify-center lg:w-full'}`}>
            <img
              src="/assets/logo.png"
              alt="WAO"
              className={`shrink-0 transition-all duration-300 ${isSidebarOpen ? 'h-8 w-auto' : 'h-7 w-auto'}`}
            />
            {isSidebarOpen && (
              <span
                className="text-white text-lg font-semibold tracking-widest uppercase whitespace-nowrap"
                style={{ fontFamily: BRAND.font.heading }}
              >
                WAO
              </span>
            )}
          </div>
          <button
            onClick={() => setIsSidebarOpen(false)}
            className="lg:hidden p-1 text-white/40 hover:text-white transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Nav items */}
        <nav className="flex-1 py-4 overflow-y-auto scrollbar-hide">
          <ul className="space-y-1 px-2">
            {menuItems.map((item) => {
              const Icon = item.icon;
              const active = activeSegment === item.href.replace('/', '');

              return (
                <li key={item.name}>
                  <button
                    onClick={() => handleNav(item)}
                    className={`
                      w-full flex items-center gap-3 px-3 py-2.5 rounded-sm transition-all duration-150 group relative
                      ${active
                        ? 'bg-white/10 text-white'
                        : 'text-white/40 hover:text-white hover:bg-white/5'
                      }
                    `}
                  >
                    {/* Active indicator bar */}
                    {active && (
                      <span
                        className="absolute left-0 top-1/2 -translate-y-1/2 w-0.5 h-5 rounded-r"
                        style={{ backgroundColor: BRAND.primary }}
                      />
                    )}

                    <Icon className="w-4 h-4 shrink-0" />

                    <span
                      className={`text-sm font-medium whitespace-nowrap transition-all duration-300 ${!isSidebarOpen && 'lg:hidden'}`}
                      style={{ fontFamily: BRAND.font.body }}
                    >
                      {item.name}
                    </span>

                    {/* Tooltip when collapsed */}
                    {!isSidebarOpen && (
                      <span
                        className="hidden lg:block absolute left-full ml-3 px-2 py-1 text-xs text-white bg-[#1a1a1a] border border-white/10 rounded whitespace-nowrap opacity-0 group-hover:opacity-100 pointer-events-none transition-opacity z-50"
                        style={{ fontFamily: BRAND.font.body }}
                      >
                        {item.name}
                      </span>
                    )}
                  </button>
                </li>
              );
            })}
          </ul>
        </nav>

        {/* User section */}
        <div className="shrink-0 border-t border-white/5 p-3">
          {isSidebarOpen ? (
            <div
              className="flex items-center gap-3 p-2 rounded-sm hover:bg-white/5 cursor-pointer transition-colors group"
              onClick={() => navigate('/profile')}
            >
              <div
                className="w-8 h-8 rounded-sm flex items-center justify-center shrink-0 text-white text-xs font-bold"
                style={{ backgroundColor: BRAND.primary, fontFamily: BRAND.font.body }}
              >
                {getInitials(userName)}
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-white text-xs font-semibold truncate" style={{ fontFamily: BRAND.font.body }}>
                  {userName}
                </p>
                <p className="text-white/30 text-xs truncate" style={{ fontFamily: BRAND.font.body }}>
                  {roleLabel}
                </p>
              </div>
              <button
                onClick={(e) => { e.stopPropagation(); handleLogout(); }}
                className="p-1.5 text-white/25 hover:text-red-400 transition-colors rounded"
                title="Logout"
              >
                <LogOut className="w-3.5 h-3.5" />
              </button>
            </div>
          ) : (
            <div className="hidden lg:flex flex-col items-center gap-2">
              <div
                className="w-8 h-8 rounded-sm flex items-center justify-center cursor-pointer text-white text-xs font-bold hover:opacity-80 transition-opacity"
                style={{ backgroundColor: BRAND.primary, fontFamily: BRAND.font.body }}
                onClick={() => navigate('/profile')}
              >
                {getInitials(userName)}
              </div>
              <button
                onClick={handleLogout}
                className="p-1.5 text-white/25 hover:text-red-400 transition-colors"
                title="Logout"
              >
                <LogOut className="w-3.5 h-3.5" />
              </button>
            </div>
          )}
        </div>
      </aside>
    </>
  );
};

export default SideNav;
