import React, { useState } from 'react';
import { ChevronLeft, ChevronRight } from 'lucide-react';

const CompactCalendar = () => {
  const [currentDate, setCurrentDate] = useState(new Date(2026, 1, 8)); // February 8, 2026

  // Sample events (you can pass these as props later)
  const events = {
    5: true,   // has event
    8: true,   // has event (today)
    12: true,  // has event
    18: true,  // has event
    25: true   // has event
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
    <div className="space-y-2 bg-gray-50 rounded-lg px-4 py-2">
      {/* Current Date Display */}
      <div className="text-center py-4 ">
        <p className="text-3xl font-bold text-[#011B3B]">{today}</p>
        <p className="text-sm text-gray-600">
          {monthNames[currentMonth]} {currentYear}
        </p>
      </div>

      {/* Month Navigation */}
      <div className="flex items-center justify-between px-2 py-1">
        <button
          onClick={goToPreviousMonth}
          className="p-1 hover:bg-gray-100 rounded transition-colors"
          aria-label="Previous month"
        >
          <ChevronLeft className="w-4 h-4 text-gray-600" />
        </button>
        <button
          onClick={goToNextMonth}
          className="p-1 hover:bg-gray-100 rounded transition-colors"
          aria-label="Next month"
        >
          <ChevronRight className="w-4 h-4 text-gray-600" />
        </button>
      </div>

      {/* Calendar Grid */}
      <div className="grid grid-cols-7 gap-1 text-center text-xs mt-4">
        {/* Day Headers */}
        {['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day, i) => (
          <div key={i} className="font-semibold text-gray-600 py-2">
            {day}
          </div>
        ))}
        
        {/* Calendar Days */}
        {calendarDays.map((day, index) => {
          if (day === null) {
            return <div key={`empty-${index}`} />;
          }

          const isToday = day === today;
          const hasEvent = events[day];

          return (
            <div
              key={day}
              className={`relative py-2 rounded cursor-pointer ${
                isToday
                  ? 'bg-[#D30336] text-white font-bold'
                  : 'hover:bg-gray-100 text-gray-700'
              }`}
            >
              {day}
              
              {/* Event Indicator Dot */}
              {hasEvent && !isToday && (
                <div className="absolute bottom-0.5 left-1/2 transform -translate-x-1/2">
                  <div className="w-1 h-1 rounded-full bg-[#D30336]" />
                </div>
              )}
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default CompactCalendar;