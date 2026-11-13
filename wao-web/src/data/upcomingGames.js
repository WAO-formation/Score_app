// Real upcoming-fixture feed for the public "Upcoming Games" section.
// Pulls from the same `matches` data GamesContext already subscribes to
// (see src/context/GamesContext.jsx) and applies the same "upcoming, not
// past due" filter as the dashboard Games page (src/pages/games/Games.jsx).
import { useGames } from '../context/GamesContext';
import { isPastDue } from '../services/matchesService';

// docToGame (matchesService.js) stores time as 24h "HH:MM"; the public
// cards read better as "4:00 PM".
const formatTime12h = (time24) => {
  if (!time24) return '';
  const [h, m] = time24.split(':').map(Number);
  const period = h >= 12 ? 'PM' : 'AM';
  const h12 = h % 12 || 12;
  return `${h12}:${String(m).padStart(2, '0')} ${period}`;
};

export function useUpcomingGames() {
  const { games, loading } = useGames();
  const upcoming = games
    .filter((g) => g.status === 'upcoming' && !isPastDue(g))
    .sort((a, b) => (a.startTime?.getTime() || 0) - (b.startTime?.getTime() || 0))
    .map((g) => ({ ...g, time: formatTime12h(g.time) }));
  return { games: upcoming, loading };
}
