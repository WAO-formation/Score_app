import React from 'react';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';
import { CalendarDays } from 'lucide-react';

const MainCalendar = () => {
  return (
    <div className="bg-white rounded-lg shadow-sm p-6 mt-18">
      <div className="flex items-center justify-between mb-4">
        <h3 className="text-lg font-bold text-[#011B3B]">Calendar</h3>
        <CalendarDays className="w-5 h-5 text-[#D30336]" />
      </div>
      
      <div className="calendar-container">
        <FullCalendar
          plugins={[dayGridPlugin, interactionPlugin]}
          initialView="dayGridMonth"
          initialDate="2026-02-08"
          headerToolbar={{
            left: 'prev,next today',
            center: 'title',
            right: 'dayGridMonth,dayGridWeek'
          }}
          dayMaxEvents={true}
          nowIndicator={true}
          editable={true}
          selectable={true}
          eventColor="#D30336"
          height="auto"
        />

        <style jsx global>{`
          /* Customizing the 'Today' cell (Feb 8) with your brand red */
          .fc .fc-day-today {
            background-color: rgba(211, 3, 54, 0.1) !important; 
          }
          
          /* Day number styling */
          .fc .fc-daygrid-day-number {
            color: #011B3B;
            font-weight: 500;
            padding: 8px;
          }
          
          /* Today's date number - highlighted in red */
          .fc .fc-day-today .fc-daygrid-day-number {
            background-color: #D30336;
            color: white;
            font-weight: bold;
            border-radius: 4px;
            padding: 4px 8px;
          }
          
          /* Button styling matching your brand colors */
          .fc .fc-button-primary {
            background-color: #f8fafc;
            border-color: #e2e8f0;
            color: #011B3B;
            text-transform: capitalize;
            font-weight: 500;
          }
          
          .fc .fc-button-primary:hover {
            background-color: #f1f5f9;
            color: #011B3B;
            border-color: #cbd5e1;
          }
          
          .fc .fc-button-active {
            background-color: #D30336 !important;
            border-color: #D30336 !important;
            color: white !important;
          }
          
          /* Title styling */
          .fc .fc-toolbar-title {
            color: #011B3B;
            font-weight: 700;
            font-size: 1.125rem;
          }
          
          /* Day header styling */
          .fc .fc-col-header-cell-cushion {
            color: #6b7280;
            font-weight: 600;
            font-size: 0.75rem;
            text-transform: uppercase;
          }
          
          /* Hover effect on day cells */
          .fc .fc-daygrid-day:hover {
            background-color: #f9fafb;
            cursor: pointer;
          }
          
          /* Event styling */
          .fc-event {
            background-color: #D30336;
            border-color: #D30336;
          }
          
          /* Remove default border */
          .fc .fc-scrollgrid {
            border-color: #e5e7eb;
          }
        `}</style>
      </div>
    </div>
  );
};

export default MainCalendar;