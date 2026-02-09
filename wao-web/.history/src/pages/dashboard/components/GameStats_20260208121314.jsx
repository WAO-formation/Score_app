import React from 'react';
import { Calendar, Trophy, CheckCircle } from 'lucide-react';

const StatCard = ({ type, count, subtitle }) => {
  const cardConfig = {
    upcoming: {
      gradient: 'from-[#FFC600] to-[#FF6B35]',
      icon: Calendar,
      title: 'Upcoming Games',
    },
    live: {
      gradient: 'from-[#D30336] to-[#FF3366]',
      icon: Trophy,
      title: 'Live Games',
    },
    completed: {
      gradient: 'from-[#011B3B] to-[#D30336]',
      icon: CheckCircle,
      title: 'Completed Games',
    },
  };

  const config = cardConfig[type];
  const Icon = config.icon;

  return (
    <div className={`shadow-sm py-6 px-6 bg-gradient-to-br ${config.gradient} rounded-xl relative overflow-hidden`}>
      {/* Ball image positioned at bottom right */}
      <div className="absolute -right-8 -bottom-8 opacity-15">
        <img
          src="/assets/design/wao-ball.png"
          alt="ball gradient"
          className="w-50 h-50 object-contain"
        />
      </div>

      {/* Content */}
      <div className="relative z-10">
        <div className="flex gap-3 items-center mb-6">
          <div className="bg-white/30 backdrop-blur-sm p-3 rounded-xl shadow-sm">
            <Icon className="w-5 h-5 text-white" />
          </div>
          <h4 className="font-semibold text-white/90 text-base">
            {config.title}
          </h4>
        </div>

        <div className="space-y-1">
          <h2 className="text-4xl font-bold text-white drop-shadow-sm">{count}</h2>
          <p className="text-white/80 text-sm font-medium">{subtitle}</p>
        </div>
      </div>
    </div>
  );
};

export default StatCard