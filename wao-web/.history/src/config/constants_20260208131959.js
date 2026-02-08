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