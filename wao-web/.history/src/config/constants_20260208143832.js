/* eslint-disable no-unused-vars */
import { 
  Home, 
  Users, 
  Gamepad2, 
  Settings, 
  LayoutDashboard,
  Menu,
  X,
  ChevronDown
} from 'lucide-react';
import { href } from 'react-router-dom';


export const menuItems = [
    { name: 'Dashboard', icon: Home, href: '/Dashboard' },
    { name: 'Teams', icon: Users, href: '/Teams' },
    { name: 'Games', icon: Gamepad2, href: '/Games' },
    { name: 'Management', icon: LayoutDashboard, href: '/Management' },
    { name: 'Settings', icon: Settings, href: '/Settings' },
  ];

  export  const sampleGames = [
    {
      id: 1,
      team1: 'UPSA Eagles',
      team2: 'UG Warriors',
      team1Logo: null,
      team2Logo: null,
      time: '02:26',
      date: 'Feb 10',
      venue: 'UPSA Arena',
      championship: 'Championship',
      status: 'Upcoming',
    },
    {
      id: 2,
      team1: 'Thunder Warriors',
      team2: 'Lightning Strikers',
      team1Logo: null,
      team2Logo: null,
      time: '15:00',
      date: 'Feb 12',
      venue: 'Central Stadium',
      championship: 'Premier League',
      status: 'Upcoming',
    },
    {
      id: 3,
      team1: 'Phoenix Rising',
      team2: 'Dragon Force',
      team1Logo: null,
      team2Logo: null,
      time: '18:30',
      date: 'Feb 15',
      venue: 'Sports Complex',
      championship: 'Cup Finals',
      status: 'Upcoming',
    },
  ];

const upcomingEvents = [
    { id: 1, title: 'Team A vs Team B', date: 'Feb 10, 2026', time: '3:00 PM' },
    { id: 2, title: 'Team C vs Team D', date: 'Feb 12, 2026', time: '5:00 PM' },
    { id: 3, title: 'Team E vs Team F', date: 'Feb 15, 2026', time: '2:00 PM' },
    { id: 4, title: 'Team G vs Team H', date: 'Feb 18, 2026', time: '4:00 PM' },
  ];

  const recentTeams = [
    { id: 1, name: 'Thunder Warriors', members: 24, status: 'Active' },
    { id: 2, name: 'Lightning Strikers', members: 22, status: 'Active' },
    { id: 3, name: 'Phoenix Rising', members: 20, status: 'Inactive' },
    { id: 4, name: 'Dragon Force', members: 25, status: 'Active' },
  ];