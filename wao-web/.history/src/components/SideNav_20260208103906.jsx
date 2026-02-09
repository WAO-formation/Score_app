import React from "react";
import { menuItems } from "../config/constants";
import { X, ChevronDown } from "lucide-react";

const SideNav = ({
  isSidebarOpen,
  setIsSidebarOpen,
  setCurrentPage,
  userName = "John Doe",
}) => {
  const [activeItem, setActiveItem] = React.useState("Dashboard");

  // Function to get user initials
  const getInitials = (name) => {
    if (!name) return "U";
    const names = name.trim().split(" ");
    if (names.length === 1) {
      return names[0].charAt(0).toUpperCase();
    }
    return (
      names[0].charAt(0) + names[names.length - 1].charAt(0)
    ).toUpperCase();
  };

  const userInitials = getInitials(userName);

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
          ${isSidebarOpen ? "translate-x-0" : "-translate-x-full lg:translate-x-0"} 
          ${isSidebarOpen ? "lg:w-64" : "lg:w-20"}
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
          {isSidebarOpen && (
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
                      // Update current page in parent component
                      if (setCurrentPage) {
                        setCurrentPage(item.name);
                      }
                      // Close mobile menu after selecting
                      if (window.innerWidth < 1024) {
                        setIsSidebarOpen(false);
                      }
                    }}
                    className={`
                      w-full flex items-center space-x-3 px-4 py-3 rounded-lg
                      transition-all duration-200
                      ${
                        active
                          ? "bg-white/20 text-white shadow-lg shadow-[#D30336]/20"
                          : "text-white/70 hover:bg-white/10 hover:text-white"
                      }
                    `}
                  >
                    <Icon className="w-5 h-5 flex-shrink-0" />
                    <span
                      className={`font-medium ${!isSidebarOpen && "lg:hidden"}`}
                    >
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
                <span className="text-[#011B3B] font-bold ">
                  {userInitials}
                </span>
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-white text-sm font-medium truncate">
                  {userName}
                </p>
                <p className="text-white/60 text-xs truncate">Admin</p>
              </div>
              <ChevronDown className="w-4 h-4 text-white/60 flex-shrink-0" />
            </div>
          </div>
        )}

        {/* Collapsed Profile Section - Desktop Only */}
        {!isSidebarOpen && (
          <div className="hidden lg:block p-4 border-t border-white/10">
            <div className="flex items-center justify-center">
              <div className="w-10 h-10 bg-[#FFC600] rounded-full flex items-center justify-center cursor-pointer hover:ring-2 hover:ring-white/20 transition-all">
                <span className="text-[#011B3B] font-semibold text-sm">
                  {userInitials}
                </span>
              </div>
            </div>
          </div>
        )}
      </aside>
    </>
  );
};

export default SideNav;