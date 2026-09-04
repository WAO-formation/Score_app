import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import Officials from './components/Officials';
import Players from './components/Players';
import VenuesAndTournaments from './components/VenuesAndTournaments';
import Reports from './components/Reports';
import GamesManagement from './components/GamesManagement';
import Users from './components/Users';
import { useAuth } from '../../context/AuthContext';
import { BRAND } from '../../config/brand';

const ADMIN_TABS = ['Officials', 'Players', 'Venues & Tournaments', 'Reports', 'Games', 'Users'];
// Officials and Venues & Tournaments are admin-only concerns (staffing and
// venue/championship setup) — a moderator only needs their own roster-facing
// and game-facing tools here.
const MODERATOR_TABS = ['Players', 'Reports', 'Games'];

export default function Management() {
  const navigate = useNavigate();
  const { user } = useAuth();
  const isAdmin = user?.role === 'admin';
  const TABS = isAdmin ? ADMIN_TABS : MODERATOR_TABS;
  const [tab, setTab] = useState(TABS[0]);

  // This is admin/moderator back-office tooling — a judge has their own
  // scoped surface at /officiating and no business here, even if they guess
  // the URL (the nav link is already hidden for them — see constants.js).
  if (user?.role !== 'admin' && user?.role !== 'moderator') {
    return (
      <section className="flex flex-col items-center justify-center gap-3 py-24">
        <p className="text-gray-500 text-sm" style={{ fontFamily: BRAND.font.body }}>This page is for admin/moderator accounts.</p>
        <button onClick={() => navigate('/dashboard')} className="text-sm text-[#011B3B] underline" style={{ fontFamily: BRAND.font.body }}>
          Back to Dashboard
        </button>
      </section>
    );
  }

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
      {tab === 'Users' && isAdmin     && <Users />}
    </div>
  );
}
