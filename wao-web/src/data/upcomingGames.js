// Placeholder fixtures for the public "Upcoming Games" section.
// The dashboard app already models games in Firestore (see src/context/GamesProvider
// or equivalent) — once the public schedule is ready to go live, swap the body of
// useUpcomingGames() for a Firestore query and keep the { games, loading } shape
// so UpcomingGamesSection doesn't need to change.

export const MOCK_UPCOMING_GAMES = [
  {
    id: 'sample-1',
    homeTeam: 'Team Green',
    awayTeam: 'Team Yellow',
    date: '2026-08-16',
    time: '4:00 PM',
    venue: 'Cornerstone Baptist Church Court, Dome',
  },
  {
    id: 'sample-2',
    homeTeam: 'Team Blue',
    awayTeam: 'Team White',
    date: '2026-08-23',
    time: '3:30 PM',
    venue: 'TBC Court, Tesano',
  },
  {
    id: 'sample-3',
    homeTeam: 'Team Green',
    awayTeam: 'Team Blue',
    date: '2026-08-30',
    time: '4:00 PM',
    venue: 'Cornerstone Baptist Church Court, Dome',
  },
];

export function useUpcomingGames() {
  return { games: MOCK_UPCOMING_GAMES, loading: false };
}
