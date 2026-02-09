import React, { useState } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";

const CompactCalendar = () => {
  const realToday = new Date(); // Get actual current date
  const [currentDate, setCurrentDate] = useState(realToday);

  // Sample events (you can pass these as props later)
  const events = {
    5: true,
    8: true,
    12: true,
    18: true,
    25: true,
  };

  const monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  const daysInMonth = (date) => {
    return new Date(date.getFullYear(), date.getMonth() + 1, 0).getDate();
  };

  const firstDayOfMonth = (date) => {
    return new Date(date.getFullYear(), date.getMonth(), 1).getDay();
  };

  const goToPreviousMonth = () => {
    setCurrentDate(
      new Date(currentDate.getFullYear(), currentDate.getMonth() - 1, 1),
    );
  };

  const goToNextMonth = () => {
    setCurrentDate(
      new Date(currentDate.getFullYear(), currentDate.getMonth() + 1, 1),
    );
  };

  const totalDays = daysInMonth(currentDate);
  const startDay = firstDayOfMonth(currentDate);

  // Get today's actual date
  const today = realToday.getDate();
  const todayMonth = realToday.getMonth();
  const todayYear = realToday.getFullYear();

  const currentMonth = currentDate.getMonth();
  const currentYear = currentDate.getFullYear();

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
    <div className="space-y-2 bg-gray-50 rounded-lg  shadow-sm px-4 py-4 relative overflow-hidden">
      {/* Ball image positioned at bottom right */}
      <div className="absolute -right-38 -bottom-45 opacity-45">
        <img
          src="/assets/design/wao-ball.png"
          alt="ball gradient"
          className="w-80 h-80 object-contain"
        />
      </div>

      {/* Current Date Display */}
      <div className="flex justify-between items-center">
        <p className="text-[14px] font-bold text-gray-600">
          {monthNames[currentMonth]} {currentYear}
        </p>

        {/* Month Navigation */}
        <div className="flex items-center justify-center items-center">
          <button
            onClick={goToPreviousMonth}
            className="p-1 bg-yellow-300/50 hover:bg-yellow-300  rounded transition-colors"
            aria-label="Previous month"
          >
            <ChevronLeft className="w-5 h-5 text-yellow-500 hover:text-yellow-100" />
          </button>

          <button
            onClick={goToNextMonth}
            className="p-1 bg-yellow-300/50 hover:bg-yellow-300 ml-5 rounded transition-colors"
            aria-label="Next month"
          >
            <ChevronRight className="w-5 h-5 text-yellow-500 hover:text-yellow-100" />
          </button>
        </div>
      </div>

      {/* Calendar Grid */}
      <div className="grid grid-cols-7 gap-1 text-center text-xs mt-4">
        {/* Day Headers */}
        {["S", "M", "T", "W", "T", "F", "S"].map((day, i) => (
          <div key={i} className="font-semibold text-gray-600 py-2">
            {day}
          </div>
        ))}

        {/* Calendar Days */}
        {calendarDays.map((day, index) => {
          if (day === null) {
            return <div key={`empty-${index}`} />;
          }

          // Check if this day is today (must be same day, month, and year)
          const isToday =
            day === today &&
            currentMonth === todayMonth &&
            currentYear === todayYear;
          const hasEvent = events[day];

          return (
            <div
              key={day}
              className={`relative py-2 rounded cursor-pointer ${
                isToday
                  ? "bg-gradient-to-br from-[#011B3B] to-[#D30336] text-white font-bold"
                  : "hover:bg-gray-100 text-gray-700"
              }`}
            >
              {day}

              {/* Event Indicator Dot */}
              {hasEvent && !isToday && (
                <div className="absolute bottom-0.5 left-1/2 transform -translate-x-1/2">
                  <div className="w-1 h-1 rounded-full bg-gradient-to-br from-[#FFC600] to-[#FF6B35]" />
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
