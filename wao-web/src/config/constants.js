import {
  Home,
  Users,
  Gamepad2,
  LayoutDashboard,
  UserCircle,
  ClipboardList,
} from "lucide-react";

// `roles` restricts a nav item to specific accounts (see AuthContext's
// ALLOWED_ROLES) — omit it for items every signed-in role should see.
export const menuItems = [
  { name: "Dashboard",  icon: Home,            href: "/dashboard" },
  { name: "Teams",      icon: Users,           href: "/teams" },
  { name: "Games",      icon: Gamepad2,        href: "/games" },
  { name: "My Games",   icon: ClipboardList,   href: "/my-games", roles: ["moderator"] },
  { name: "Management", icon: LayoutDashboard, href: "/management" },
  { name: "Profile",    icon: UserCircle,      href: "/profile" },
];
