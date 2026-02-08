import React, { useState } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';

const CompactCalendar = () => {
  const [currentDate, setCurrentDate] = useState(new Date(2026, 1, 8)); // February 8, 2026

  // Sample events (you can pass these as props later)
  const events = {
    5: 2,   // 2 events on Feb 5
    8: 1,   // 1 event on Feb 8 (today)
    12: 3,  // 3 events on Feb 12
    18: 1,  // 1 event on Feb 18
    25: 2   // 2 events on Feb 25
  };

  const monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  const daysInMonth = (date) => {
    return new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
  };

  const firstDayOfMonth = (date) => {
    return new Date(date.getFullYear(), date.getMonth(), 1).getDay();
  };

  const goToPreviousMonth = () => {
    setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1));
  };

  const goToNextMonth = () => {
    setCurrentDate(new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1));
  };

  const totalDays = daysInMonth(currentDate);
  const startDay = firstDayOfMonth(currentDate);
  const today = 8; // Current day
  const currentMonth = currentDate.getMonth();
  const currentYear = currentDate.getFullYear();

  // Create calendar grid
  const calendarDays = [];
  
  // Empty cells for days before month starts
  for (let i = 0; i < startDay; i++) {
    calendarDays.push(null);
  }
  
  // Days of the month
  for (let day = 1; day <= totalDays; day++) {
    calendarDays.push(day);
  }

  return (
    <div className="space-y-3">
      {/* Current Date Display */}
      <div className="text-center py-4 bg-gradient-to-br from-[#011B3B] to-[#022d5f] rounded-lg shadow-sm">
        <p className="text-4xl font-bold text-white">{today}</p>
        <p className="text-sm text-gray-200 mt-1">
          {monthNames[currentMonth]} {currentYear}
        </p>
      </div>

      {/* Month Navigation */}
      <div className="flex items-center justify-between">
        <button
          onClick={goToPreviousMonth}
          className="p-1.5 hover:bg-gray-100 rounded-lg transition-colors"
          aria-label="Previous month"
        >
          <ChevronLeft className="w-4 h-4 text-[#011B3B]" />
        </button>
        <p className="text-sm font-semibold text-[#011B3B]">
          {monthNames[currentMonth]} {currentYear}
        </p>
        <button
          onClick={goToNextMonth}
          className="p-1.5 hover:bg-gray-100 rounded-lg transition-colors"
          aria-label="Next month"
        >
          <ChevronRight className="w-4 h-4 text-[#011B3B]" />
        </button>
      </div>

      {/* Calendar Grid */}
      <div className="grid grid-cols-7 gap-1 text-center text-xs">
        {/* Day Headers */}
        {['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day, i) => (
          <div key={i} className="font-semibold text-gray-500 py-2">
            {day}
          </div>
        ))}
        
        {/* Calendar Days */}
        {calendarDays.map((day, index) => {
          if (day === null) {
            return <div key={`empty-${index}`} className="py-2" />;
          }

          const isToday = day === today;
          const hasEvents = events[day];

          return (
            <div
              key={day}
              className={`
                relative py-2 rounded-lg cursor-pointer transition-all
                ${isToday 
                  ? 'bg-[#D30336] text-white font-bold shadow-sm scale-105' 
                  : 'hover:bg-gray-100 text-gray-700'
                }
              `}
            >
              <span className="relative z-10">{day}</span>
              
              {/* Event Indicator Dots */}
              {hasEvents && (
                <div className="absolute bottom-0.5 left-1/2 transform -translate-x-1/2 flex gap-0.5">
                  {[...Array(Math.min(hasEvents, 3))].map((_, i) => (
                    <div
                      key={i}
                      className={`w-1 h-1 rounded-full ${
                        isToday ? 'bg-white' : 'bg-[#D30336]'
                      }`}
                    />
                  ))}
                </div>
              )}
            </div>
          );
        })}
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-2 gap-2 pt-2 border-t border-gray-100">
        <div className="text-center py-2 bg-gray-50 rounded-lg">
          <p className="text-lg font-bold text-[#D30336]">5</p>
          <p className="text-xs text-gray-600">Events</p>
        </div>
        <div className="text-center py-2 bg-gray-50 rounded-lg">
          <p className="text-lg font-bold text-[#011B3B]">3</p>
          <p className="text-xs text-gray-600">Games</p>
        </div>
      </div>
    </div>
  );
};

export default CompactCalendar;