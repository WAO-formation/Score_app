import React from 'react';
import FullCalendar from '@fullcalendar/react';
import dayGridPlugin from '@fullcalendar/daygrid';
import interactionPlugin from '@fullcalendar/interaction';

const MainCalendar = () => {
  return (
    <div className="calendar-container p-4 bg-white rounded-2xl shadow-sm border border-slate-100">
      <FullCalendar
        plugins={[dayGridPlugin, interactionPlugin]}
        initialView="dayGridMonth"
        headerToolbar={{
          left: 'prev,next today',
          center: 'title',
          right: 'dayGridMonth,dayGridWeek'
        }}
        // Theming the "Today" highlight and general look
        dayMaxEvents={true}
        nowIndicator={true}
        editable={true}
        selectable={true}
        
        /* Using Tailwind-like colors for the calendar interface */
        eventColor="#FDE047" // Faint yellow for future events
        height="75vh"
      />

      <style jsx global>{`
        /* Customizing the 'Today' cell to match your faint yellow highlight */
        .fc .fc-day-today {
          background-color: rgba(250, 204, 21, 0.1) !important; 
        }
        .fc .fc-button-primary {
          background-color: #f8fafc;
          border-color: #e2e8f0;
          color: #475569;
          text-transform: capitalize;
        }
        .fc .fc-button-primary:hover {
          background-color: #f1f5f9;
          color: #1e293b;
        }
        .fc .fc-button-active {
          background-color: #fefce8 !important;
          border-color: #facc15 !important;
          color: #a16207 !important;
        }
      `}</style>
    </div>
  );
};

export default MainCalendar;