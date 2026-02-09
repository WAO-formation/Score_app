/* eslint-disable no-unused-vars */
import {
  Home,
  Users,
  Gamepad2,
  Settings,
  LayoutDashboard,
  Menu,
  X,
  ChevronDown,
} from "lucide-react";
import { href } from "react-router-dom";

export const menuItems = [
  { name: "Dashboard", icon: Home, href: "/Dashboard" },
  { name: "Teams", icon: Users, href: "/Teams" },
  { name: "Games", icon: Gamepad2, href: "/Games" },
  { name: "Management", icon: LayoutDashboard, href: "/Management" },
  { name: "Settings", icon: Settings, href: "/Settings" },
];

export const sampleGames = [
  {
    id: 1,
    team1: "UPSA Eagles",
    team2: "UG Warriors",
    team1Logo: null,
    team2Logo: null,
    time: "02:26",
    date: "Feb 10",
    venue: "UPSA Arena",
    championship: "Championship",
    status: "Upcoming",
  },
  {
    id: 2,
    team1: "Thunder Warriors",
    team2: "Lightning Strikers",
    team1Logo: null,
    team2Logo: null,
    time: "15:00",
    date: "Feb 12",
    venue: "Central Stadium",
    championship: "Premier League",
    status: "Upcoming",
  },
  {
    id: 3,
    team1: "Phoenix Rising",
    team2: "Dragon Force",
    team1Logo: null,
    team2Logo: null,
    time: "18:30",
    date: "Feb 15",
    venue: "Sports Complex",
    championship: "Cup Finals",
    status: "Upcoming",
  },
];

export const upcomingEvents = [
  { id: 1, title: "Team A vs Team B", date: "Feb 10, 2026", time: "3:00 PM" },
  { id: 2, title: "Team C vs Team D", date: "Feb 12, 2026", time: "5:00 PM" },
  { id: 3, title: "Team E vs Team F", date: "Feb 15, 2026", time: "2:00 PM" },
  { id: 4, title: "Team G vs Team H", date: "Feb 18, 2026", time: "4:00 PM" },
];

export const recentTeams = [
  { id: 1, name: "Thunder Warriors", members: 24, status: "Active" },
  { id: 2, name: "Lightning Strikers", members: 22, status: "Active" },
  { id: 3, name: "Phoenix Rising", members: 20, status: "Inactive" },
  { id: 4, name: "Dragon Force", members: 25, status: "Active" },
];

 export const teamsData = [
    {
      id: 1,
      name: "Thunder Lions",
      coach: "John Smith",
      category: "Senior",
      gamesPlayed: 15,
      icon: "TL"
    },
    {
      id: 2,
      name: "Phoenix Warriors",
      coach: "Sarah Johnson",
      category: "Junior",
      gamesPlayed: 12,
      icon: "PW"
    },
    {
      id: 3,
      name: "Storm Eagles",
      coach: "Michael Brown",
      category: "Youth",
      gamesPlayed: 8,
      icon: "SE"
    },
    {
      id: 4,
      name: "Blazing Tigers",
      coach: "Emma Davis",
      category: "Senior",
      gamesPlayed: 20,
      icon: "BT"
    },
    {
      id: 5,
      name: "Ice Wolves",
      coach: "David Wilson",
      category: "Junior",
      gamesPlayed: 10,
      icon: "IW"
    },
    {
      id: 6,
      name: "Dragon Force",
      coach: "Lisa Anderson",
      category: "Youth",
      gamesPlayed: 14,
      icon: "DF"
    },
    {
      id: 7,
      name: "Mighty Sharks",
      coach: "Robert Taylor",
      category: "Senior",
      gamesPlayed: 18,
      icon: "MS"
    },
    {
      id: 8,
      name: "Golden Hawks",
      coach: "Jennifer Lee",
      category: "Junior",
      gamesPlayed: 11,
      icon: "GH"
    },
    {
      id: 9,
      name: "Steel Panthers",
      coach: "Chris Martin",
      category: "Youth",
      gamesPlayed: 9,
      icon: "SP"
    },
    {
      id: 10,
      name: "Blazing Comets",
      coach: "Amanda White",
      category: "Senior",
      gamesPlayed: 16,
      icon: "BC"
    },
    {
      id: 11,
      name: "Wild Mustangs",
      coach: "Kevin Harris",
      category: "Junior",
      gamesPlayed: 13,
      icon: "WM"
    },
    {
      id: 12,
      name: "Royal Falcons",
      coach: "Michelle Clark",
      category: "Youth",
      gamesPlayed: 7,
      icon: "RF"
    }
  ];

  // Add to src/config/constants.js
export const gamesData = [
  {
    id: 1,
    homeTeam: "Thunder Lions",
    awayTeam: "Phoenix Warriors",
    date: "2026-02-15",
    time: "15:00",
    venue: "Main Arena",
    championship: "Premier League",
    status: "upcoming",
    accessCode: "A3B7F9",
    currentQuarter: "Q1",
    timeRemaining: "17:00",
    homeScore: 0,
    awayScore: 0,
    quarters: {
      q1: { home: 0, away: 0 },
      q2: { home: 0, away: 0 },
      q3: { home: 0, away: 0 },
      q4: { home: 0, away: 0 }
    },
    scoring: {
      kingdom: { home: 0, away: 0 },
      workout: { home: 0, away: 0 },
      goalSetting: { home: 0, away: 0 },
      judges: { home: 0, away: 0 }
    },
    fouls: {
      home: [],
      away: []
    },
    events: []
  },
  {
    id: 2,
    homeTeam: "Storm Eagles",
    awayTeam: "Blazing Tigers",
    date: "2026-02-09",
    time: "18:00",
    venue: "City Stadium",
    championship: "Cup Tournament",
    status: "live",
    accessCode: "K9M2P5",
    currentQuarter: "Q2",
    timeRemaining: "08:45",
    homeScore: 24,
    awayScore: 21,
    quarters: {
      q1: { home: 12, away: 11 },
      q2: { home: 12, away: 10 },
      q3: { home: 0, away: 0 },
      q4: { home: 0, away: 0 }
    },
    scoring: {
      kingdom: { home: 8, away: 7 },
      workout: { home: 7, away: 6 },
      goalSetting: { home: 7, away: 6 },
      judges: { home: 2, away: 2 }
    },
    fouls: {
      home: [
        { player: "Alex Rodriguez", minute: 5, quarter: "Q1" },
        { player: "Michael Brown", minute: 13, quarter: "Q2" }
      ],
      away: [
        { player: "Emma Davis", minute: 9, quarter: "Q1" }
      ]
    },
    events: []
  },
  {
    id: 3,
    homeTeam: "Ice Wolves",
    awayTeam: "Dragon Force",
    date: "2026-02-01",
    time: "16:00",
    venue: "North Stadium",
    championship: "Premier League",
    status: "completed",
    accessCode: "X7Y4Z1",
    currentQuarter: "FT",
    timeRemaining: "00:00",
    homeScore: 48,
    awayScore: 45,
    quarters: {
      q1: { home: 12, away: 11 },
      q2: { home: 11, away: 12 },
      q3: { home: 13, away: 11 },
      q4: { home: 12, away: 11 }
    },
    scoring: {
      kingdom: { home: 15, away: 14 },
      workout: { home: 14, away: 13 },
      goalSetting: { home: 14, away: 13 },
      judges: { home: 5, away: 5 }
    },
    fouls: {
      home: [
        { player: "David Wilson", minute: 8, quarter: "Q1" },
        { player: "Kevin Lee", minute: 15, quarter: "Q2" },
        { player: "Tom Harris", minute: 5, quarter: "Q3" }
      ],
      away: [
        { player: "Lisa Anderson", minute: 12, quarter: "Q1" },
        { player: "Chris Martin", minute: 3, quarter: "Q4" }
      ]
    },
    events: []
  }
];
