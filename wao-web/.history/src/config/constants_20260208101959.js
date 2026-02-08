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