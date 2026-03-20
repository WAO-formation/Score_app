import { useState } from 'react';
import Officials from './components/Officials';
import Players from './components/Players';
import VenuesAndTournaments from './components/VenuesAndTournaments';
import Reports from './components/Reports';
import GamesManagement from './components/GamesManagement';

const TABS = ['Officials', 'Players', 'Venues & Tournaments', 'Reports', 'Games'];

export default function Management() {
  const [tab, setTab] = useState('Officials');

  return (
    <div className="px-2 py-2 md:p-4">
      {/* Tabs */}
      <div className="flex flex-wrap gap-1 bg-white rounded-xl shadow-sm p-1 w-fit mt-4 md:mt-6 mb-2">
        {TABS.map(t => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={`px-5 py-2 rounded-lg text-sm font-semibold transition-all ${
              tab === t
                ? 'bg-gradient-to-br from-[#011B3B] to-[#022d5f] text-white shadow'
                : 'text-gray-500 hover:text-[#011B3B]'
            }`}
          >
            {t}
          </button>
        ))}
      </div>

      {tab === 'Officials'            && <Officials />}
      {tab === 'Players'              && <Players />}
      {tab === 'Venues & Tournaments' && <VenuesAndTournaments />}
      {tab === 'Reports'              && <Reports />}
      {tab === 'Games'                && <GamesManagement />}
    </div>
  );
}
