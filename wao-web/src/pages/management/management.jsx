import { useState } from 'react';
import Officials from './components/Officials';
import Players from './components/Players';
import VenuesAndTournaments from './components/VenuesAndTournaments';
import Reports from './components/Reports';
import GamesManagement from './components/GamesManagement';
import { BRAND } from '../../config/brand';

const TABS = ['Officials', 'Players', 'Venues & Tournaments', 'Reports', 'Games'];

export default function Management() {
  const [tab, setTab] = useState('Officials');

  return (
    <div className="px-2 py-2 md:p-4">
      <h2
        className="text-2xl md:text-3xl text-[#011B3B] uppercase tracking-widest pt-4 md:pt-6 mb-4"
        style={{ fontFamily: BRAND.font.heading }}
      >
        Management
      </h2>

      {/* Tabs */}
      <div className="flex flex-wrap gap-1 bg-white border border-gray-100 p-1 w-fit mb-2">
        {TABS.map(t => (
          <button
            key={t}
            onClick={() => setTab(t)}
            className={`px-5 py-2 text-sm font-semibold transition-all ${
              tab === t
                ? 'bg-[#011B3B] text-white'
                : 'text-gray-500 hover:text-[#011B3B]'
            }`}
            style={{ fontFamily: BRAND.font.body }}
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
