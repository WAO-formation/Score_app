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
  { name: "Dashboard", icon: Home, href: "/dashboard" },
  { name: "Teams", icon: Users, href: "/teams" },
  { name: "Games", icon: Gamepad2, href: "/games" },
  { name: "Management", icon: LayoutDashboard, href: "/management" },
  { name: "Settings", icon: Settings, href: "/settings" },
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
export const venuesData = [
  { id: 1, name: "Main Arena" },
  { id: 2, name: "City Stadium" },
  { id: 3, name: "North Stadium" },
  { id: 4, name: "South Complex" },
  { id: 5, name: "UPSA Arena" },
  { id: 6, name: "Central Stadium" },
  { id: 7, name: "Sports Complex" },
  { id: 8, name: "East Pavilion" },
  { id: 9, name: "West Ground" },
];

export const tournamentsData = [
  { id: 1, name: "Premier League" },
  { id: 2, name: "Cup Tournament" },
  { id: 3, name: "Championship" },
  { id: 4, name: "Cup Finals" },
  { id: 5, name: "Super League" },
  { id: 6, name: "Regional Cup" },
  { id: 7, name: "Invitational" },
];

export const staffData = [
  { id: 1, name: "James Osei",      role: "simulator" },
  { id: 2, name: "Abena Mensah",    role: "simulator" },
  { id: 3, name: "Kwame Asante",    role: "simulator" },
  { id: 4, name: "Ama Boateng",     role: "judge" },
  { id: 5, name: "Kofi Darko",      role: "judge" },
  { id: 6, name: "Efua Adjei",      role: "judge" },
  { id: 7, name: "Yaw Frimpong",    role: "judge" },
  { id: 8, name: "Akosua Owusu",    role: "judge" },
  { id: 9, name: "Nana Appiah",     role: "judge" },
  { id: 10, name: "Serwaa Bonsu",   role: "both" },
  { id: 11, name: "Kojo Antwi",     role: "both" },
];

export const officialsData = [
  { id: 1, name: "James Osei",    role: "Simulator", email: "james@wao.com",   phone: "+233 24 111 2233", status: "active",    gamesOfficiated: 12 },
  { id: 2, name: "Abena Mensah",  role: "Simulator", email: "abena@wao.com",   phone: "+233 24 222 3344", status: "active",    gamesOfficiated: 9  },
  { id: 3, name: "Kwame Asante",  role: "Simulator", email: "kwame@wao.com",   phone: "+233 24 333 4455", status: "suspended", gamesOfficiated: 7  },
  { id: 4, name: "Ama Boateng",   role: "Judge",     email: "ama@wao.com",     phone: "+233 24 444 5566", status: "active",    gamesOfficiated: 15 },
  { id: 5, name: "Kofi Darko",    role: "Judge",     email: "kofi@wao.com",    phone: "+233 24 555 6677", status: "active",    gamesOfficiated: 11 },
  { id: 6, name: "Efua Adjei",    role: "Judge",     email: "efua@wao.com",    phone: "+233 24 666 7788", status: "active",    gamesOfficiated: 8  },
  { id: 7, name: "Yaw Frimpong",  role: "Judge",     email: "yaw@wao.com",     phone: "+233 24 777 8899", status: "inactive",  gamesOfficiated: 4  },
  { id: 8, name: "Serwaa Bonsu",  role: "Both",      email: "serwaa@wao.com",  phone: "+233 24 888 9900", status: "active",    gamesOfficiated: 18 },
  { id: 9, name: "Kojo Antwi",    role: "Both",      email: "kojo@wao.com",    phone: "+233 24 999 0011", status: "active",    gamesOfficiated: 14 },
];

export const playersData = [
  { id: 1,  name: "Alex Rodriguez",  team: "Thunder Lions",    position: "Forward",  status: "active",    fouls: 3, suspendedUntil: null },
  { id: 2,  name: "Michael Brown",   team: "Thunder Lions",    position: "Guard",    status: "suspended", fouls: 6, suspendedUntil: "2026-02-20" },
  { id: 3,  name: "Emma Davis",      team: "Phoenix Warriors", position: "Center",   status: "active",    fouls: 2, suspendedUntil: null },
  { id: 4,  name: "David Wilson",    team: "Ice Wolves",       position: "Forward",  status: "active",    fouls: 4, suspendedUntil: null },
  { id: 5,  name: "Kevin Lee",       team: "Ice Wolves",       position: "Guard",    status: "active",    fouls: 1, suspendedUntil: null },
  { id: 6,  name: "Tom Harris",      team: "Ice Wolves",       position: "Center",   status: "suspended", fouls: 5, suspendedUntil: "2026-02-18" },
  { id: 7,  name: "Lisa Anderson",   team: "Dragon Force",     position: "Forward",  status: "active",    fouls: 2, suspendedUntil: null },
  { id: 8,  name: "Chris Martin",    team: "Dragon Force",     position: "Guard",    status: "active",    fouls: 3, suspendedUntil: null },
  { id: 9,  name: "Sarah Johnson",   team: "Storm Eagles",     position: "Center",   status: "active",    fouls: 0, suspendedUntil: null },
  { id: 10, name: "James Kweku",     team: "Blazing Tigers",   position: "Forward",  status: "active",    fouls: 2, suspendedUntil: null },
];

export const reportsData = [
  { id: 1, type: "Foul Report",       game: "Ice Wolves vs Dragon Force",    date: "2026-02-01", status: "reviewed",  description: "Excessive fouls by home team in Q3." },
  { id: 2, type: "Misconduct",        game: "Storm Eagles vs Blazing Tigers", date: "2026-02-09", status: "pending",   description: "Player altercation after Q2 buzzer." },
  { id: 3, type: "Score Dispute",     game: "Thunder Lions vs Phoenix Warriors", date: "2026-02-15", status: "pending", description: "Away team disputes Q1 kingdom score." },
  { id: 4, type: "Official Complaint",game: "Ice Wolves vs Dragon Force",    date: "2026-02-01", status: "resolved",  description: "Judge Yaw Frimpong arrived 20 mins late." },
  { id: 5, type: "Foul Report",       game: "Storm Eagles vs Blazing Tigers", date: "2026-02-09", status: "reviewed",  description: "Home team accumulated 5 fouls in Q1." },
];

export const notificationsData = [
  { id: 1, title: "Game Starting Soon",      message: "Thunder Lions vs Phoenix Warriors starts in 1 hour.", type: "info",    sent: false, target: "all",     date: "2026-02-15" },
  { id: 2, title: "Player Suspended",        message: "Michael Brown suspended for 2 games due to fouls.",  type: "warning", sent: true,  target: "team",    date: "2026-02-10" },
  { id: 3, title: "Score Update",            message: "Storm Eagles lead Blazing Tigers 24-21 at half time.", type: "info",   sent: true,  target: "all",     date: "2026-02-09" },
  { id: 4, title: "Venue Change",            message: "Game 3 moved from North Stadium to Main Arena.",      type: "warning", sent: false, target: "all",     date: "2026-02-14" },
  { id: 5, title: "New Official Added",      message: "Serwaa Bonsu added as simulator for upcoming games.", type: "info",   sent: true,  target: "officials",date: "2026-02-08" },
];

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
