import {
  Home,
  Users,
  Gamepad2,
  LayoutDashboard,
  UserCircle,
} from "lucide-react";

export const menuItems = [
  { name: "Dashboard",  icon: Home,            href: "/dashboard" },
  { name: "Teams",      icon: Users,           href: "/teams" },
  { name: "Games",      icon: Gamepad2,        href: "/games" },
  { name: "Management", icon: LayoutDashboard, href: "/management" },
  { name: "Profile",    icon: UserCircle,      href: "/profile" },
];
