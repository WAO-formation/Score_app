import React from 'react';
import { 
  Home, 
  Users, 
  Gamepad2, 
  Settings, 
  LayoutDashboard,
  Menu,
  X,
  ChevronDown
} from 'lucide-react';

const SideNav = ({ isSidebarOpen, setIsSidebarOpen }) => {
  const [activeItem, setActiveItem] = React.useState('Dashboard');

  const menuItems = [
    { name: 'Dashboard', icon: Home },
    { name: 'Teams', icon: Users },
    { name: 'Games', icon: Gamepad2 },
    { name: 'Management', icon: LayoutDashboard },
    { name: 'Settings', icon: Settings },
  ];

  return (
    <>
      {/* Mobile Overlay */}
      {isSidebarOpen && (
        <div 
          className="lg:hidden fixed inset-0 bg-black bg-opacity-50 z-40"
          onClick={() => setIsSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside 
        className={`
          ${isSidebarOpen ? 'translate-x-0' : '-translate-x-full lg:translate-x-0'} 
          ${isSidebarOpen ? 'lg:w-64' : 'lg:w-20'}
          w-64
          bg-gradient-to-b from-[#011B3B] via-[#012a5a] to-[#011B3B]
          transition-all duration-300 ease-in-out
          flex flex-col
          h-screen
          fixed
          left-0
          top-0
          z-50
        `}
      >
        {/* Logo Section */}
        <div className="h-16 flex items-center justify-between px-4 border-b border-white/10">
          {(isSidebarOpen) && (
            <div className="flex items-center space-x-2">
              <div className="w-8 h-8 bg-[#D30336] rounded-lg flex items-center justify-center">
                <span className="text-white font-bold text-lg">W</span>
              </div>
              <span className="text-white font-semibold text-xl">WAO</span>
            </div>
          )}
          {!isSidebarOpen && (
            <div className="hidden lg:flex w-8 h-8 bg-[#D30336] rounded-lg items-center justify-center mx-auto">
              <span className="text-white font-bold text-lg">W</span>
            </div>
          )}
          
          {/* Close button for mobile */}
          <button
            onClick={() => setIsSidebarOpen(false)}
            className="lg:hidden p-1 text-white/70 hover:text-white"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        {/* Navigation Items */}
        <nav className="flex-1 py-6">
          <ul className="space-y-2 px-3">
            {menuItems.map((item) => {
              const Icon = item.icon;
              const active = activeItem === item.name;
              
              return (
                <li key={item.name}>
                  <button
                    onClick={() => {
                      setActiveItem(item.name);
                      // Close mobile menu after selecting
                      if (window.innerWidth < 1024) {
                        setIsSidebarOpen(false);
                      }
                    }}
                    className={`
                      w-full flex items-center space-x-3 px-4 py-3 rounded-lg
                      transition-all duration-200
                      ${active 
                        ? 'bg-[#D30336] text-white shadow-lg' 
                        : 'text-white/70 hover:bg-white/10 hover:text-white'
                      }
                    `}
                  >
                    <Icon className="w-5 h-5 flex-shrink-0" />
                    <span className={`font-medium ${!isSidebarOpen && 'lg:hidden'}`}>
                      {item.name}
                    </span>
                  </button>
                </li>
              );
            })}
          </ul>
        </nav>

        {/* User Profile Section */}
        {isSidebarOpen && (
          <div className="p-4 border-t border-white/10">
            <div className="flex items-center space-x-3 p-3 rounded-lg hover:bg-white/10 cursor-pointer transition-colors">
              <div className="w-10 h-10 bg-[#FFC600] rounded-full flex items-center justify-center flex-shrink-0">
                <span className="text-[#011B3B] font-semibold">JD</span>
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-white text-sm font-medium truncate">John Doe</p>
                <p className="text-white/60 text-xs truncate">Admin</p>
              </div>
              <ChevronDown className="w-4 h-4 text-white/60 flex-shrink-0" />
            </div>
          </div>
        )}

        {/* Toggle Button - Desktop Only */}
        <button
          onClick={() => setIsSidebarOpen(!isSidebarOpen)}
          className="hidden lg:flex absolute -right-3 top-20 w-6 h-6 bg-white rounded-full shadow-lg items-center justify-center hover:bg-gray-100 transition-colors"
        >
          {isSidebarOpen ? (
            <X className="w-3 h-3 text-[#011B3B]" />
          ) : (
            <Menu className="w-3 h-3 text-[#011B3B]" />
          )}
        </button>
      </aside>
    </>
  );
};

export default SideNav;