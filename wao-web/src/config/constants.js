import {
  Home,
  Users,
  Gamepad2,
  LayoutDashboard,
  UserCircle,
  ClipboardList,
  Gavel,
} from "lucide-react";

// `roles` restricts a nav item to specific accounts (see AuthContext's
// ALLOWED_ROLES) — omit it for items every signed-in role should see.
export const menuItems = [
  { name: "Dashboard",      icon: Home,            href: "/dashboard" },
  { name: "Teams",          icon: Users,           href: "/teams" },
  { name: "Games",          icon: Gamepad2,        href: "/games" },
  { name: "My Games",       icon: ClipboardList,   href: "/my-games",     roles: ["moderator"] },
  { name: "My Officiating", icon: Gavel,           href: "/officiating",  roles: ["official"] },
  { name: "Management",     icon: LayoutDashboard, href: "/management",   roles: ["admin", "moderator"] },
  { name: "Profile",        icon: UserCircle,      href: "/profile" },
];
