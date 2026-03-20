import { Trophy } from 'lucide-react';

const QuarterTransition = ({ currentQuarter }) => (
  <div className="fixed inset-0 bg-gradient-to-br from-[#011B3B] to-[#022d5f] flex items-center justify-center z-50">
    <div className="text-center animate-pulse">
      <Trophy className="w-32 h-32 text-[#FFC600] mx-auto mb-6" />
      <h2 className="text-5xl font-black text-white mb-4">End of Q{currentQuarter}</h2>
      <p className="text-2xl text-white/80">Starting Q{currentQuarter + 1}...</p>
    </div>
  </div>
);

export default QuarterTransition;
