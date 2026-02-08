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
    { name: 'Dashboard', icon: Home, href: '/' },
    { name: 'Teams', icon: Users, href: '/' },
    { name: 'Games', icon: Gamepad2, href: '/' },
    { name: 'Management', icon: LayoutDashboard, href: '/' },
    { name: 'Settings', icon: Settings, href: '/' },
  ];