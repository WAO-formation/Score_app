import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Home } from 'lucide-react';

const NotFound = () => {
  const navigate = useNavigate();

  return (
    <div className="min-h-screen bg-gradient-to-br from-[#011B3B] to-[#022d5f] flex items-center justify-center p-6 relative overflow-hidden">
      {/* Decorative balls */}
      <img src="/assets/design/wao-ball.png" alt="" aria-hidden
        className="absolute -top-24 -left-24 w-72 h-72 object-contain opacity-10 pointer-events-none" />
      <img src="/assets/design/wao-ball.png" alt="" aria-hidden
        className="absolute -bottom-24 -right-24 w-96 h-96 object-contain opacity-10 pointer-events-none" />

      <div className="relative z-10 text-center max-w-md w-full">
        {/* WAO logo mark */}
        <div className="w-16 h-16 bg-[#D30336] rounded-2xl flex items-center justify-center mx-auto mb-8 shadow-2xl">
          <span className="text-white font-black text-2xl">W</span>
        </div>

        {/* 404 */}
        <h1 className="text-8xl sm:text-9xl font-black text-white/10 leading-none select-none mb-2">
          404
        </h1>
        <h2 className="text-2xl font-bold text-white mb-3">Page not found</h2>
        <p className="text-white/50 text-sm mb-10 leading-relaxed">
          The page you're looking for doesn't exist or has been moved.
        </p>

        <div className="flex flex-col sm:flex-row gap-3 justify-center">
          <button
            onClick={() => navigate(-1)}
            className="flex items-center justify-center gap-2 px-6 py-3 border border-white/20 text-white/80 hover:text-white hover:border-white/40 rounded-xl transition-colors text-sm font-semibold"
          >
            <ArrowLeft className="w-4 h-4" />
            Go Back
          </button>
          <button
            onClick={() => navigate('/dashboard')}
            className="flex items-center justify-center gap-2 px-6 py-3 bg-[#D30336] hover:bg-[#b8022e] text-white rounded-xl transition-colors text-sm font-semibold shadow-lg"
          >
            <Home className="w-4 h-4" />
            Back to Dashboard
          </button>
        </div>
      </div>
    </div>
  );
};

export default NotFound;
