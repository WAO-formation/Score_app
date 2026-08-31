import React from 'react';
import Venues from './Venues';
import Tournaments from './Tournaments';

export default function VenuesAndTournaments() {
  return (
    <section className="px-2 py-2 md:p-4">
      <div className="py-4 md:py-8">
        <h2 className="text-lg md:text-2xl font-bold text-[#011B3B]">Venues & Tournaments</h2>
      </div>
      <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
        <div className="bg-white rounded-lg shadow-sm px-4 py-6 md:px-6">
          <Venues />
        </div>
        <div className="bg-white rounded-lg shadow-sm px-4 py-6 md:px-6">
          <Tournaments />
        </div>
      </div>
    </section>
  );
}
