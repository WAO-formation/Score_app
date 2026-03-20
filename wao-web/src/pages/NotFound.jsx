import { useNavigate } from 'react-router-dom';
import { ArrowLeft, Home } from 'lucide-react';

const NotFound = () => {
  const navigate = useNavigate();

  return (
    <div
      style={{ fontFamily: "'Georgia', 'Times New Roman', serif" }}
      className="min-h-screen bg-[#F5F4F0] flex items-center justify-center p-8 relative overflow-hidden"
    >
      {/* Faint ruled lines — editorial texture */}
      <div
        className="absolute inset-0 pointer-events-none"
        style={{
          backgroundImage: 'repeating-linear-gradient(0deg, transparent, transparent 39px, #00000008 39px, #00000008 40px)',
        }}
      />

      {/* Large ghost numerals — background layer */}
      <span
        className="absolute select-none pointer-events-none"
        style={{
          fontSize: 'clamp(220px, 38vw, 480px)',
          fontWeight: 900,
          lineHeight: 1,
          color: 'transparent',
          WebkitTextStroke: '1.5px #00000012',
          letterSpacing: '-0.04em',
          top: '50%',
          left: '50%',
          transform: 'translate(-50%, -50%)',
          fontFamily: "'Georgia', serif",
          userSelect: 'none',
        }}
      >
        404
      </span>

      {/* Content */}
      <div className="relative z-10 max-w-lg w-full">

        {/* Top rule + logo */}
        <div className="flex items-center gap-4 mb-12">
          <div className="h-px flex-1 bg-black/20" />
          <div
            className="w-8 h-8 rounded-md flex items-center justify-center"
            style={{ background: '#1a1a1a' }}
          >
            <span style={{ color: '#F5F4F0', fontWeight: 900, fontSize: 13, fontFamily: 'Georgia, serif' }}>W</span>
          </div>
          <div className="h-px flex-1 bg-black/20" />
        </div>

        {/* Editorial label */}
        <p
          className="text-xs tracking-[0.3em] uppercase mb-5"
          style={{ color: '#00000050', fontFamily: 'system-ui, sans-serif', fontWeight: 500 }}
        >
          Error · Page not found
        </p>

        {/* Headline */}
        <h1
          className="mb-5 leading-tight"
          style={{
            fontSize: 'clamp(36px, 6vw, 64px)',
            fontWeight: 700,
            color: '#1a1a1a',
            letterSpacing: '-0.025em',
            fontFamily: "'Georgia', serif",
          }}
        >
          This page has
          <br />
          gone missing.
        </h1>

        {/* Body */}
        <p
          className="mb-10 leading-relaxed"
          style={{
            fontSize: 15,
            color: '#00000055',
            fontFamily: 'system-ui, sans-serif',
            fontWeight: 400,
            maxWidth: 360,
          }}
        >
          The page you requested doesn't exist or may have been moved. Use the links below to find your way back.
        </p>

        {/* Bottom rule */}
        <div className="h-px bg-black/15 mb-10" />

        {/* Actions */}
        <div className="flex flex-col sm:flex-row gap-3">
          <button
            onClick={() => navigate(-1)}
            className="flex items-center justify-center gap-2 px-6 py-3 rounded-lg transition-all text-sm"
            style={{
              fontFamily: 'system-ui, sans-serif',
              fontWeight: 600,
              color: '#1a1a1a',
              background: 'transparent',
              border: '1.5px solid #00000025',
              letterSpacing: '0.01em',
            }}
            onMouseEnter={e => {
              e.currentTarget.style.background = '#00000008';
              e.currentTarget.style.borderColor = '#00000045';
            }}
            onMouseLeave={e => {
              e.currentTarget.style.background = 'transparent';
              e.currentTarget.style.borderColor = '#00000025';
            }}
          >
            <ArrowLeft size={15} />
            Go Back
          </button>

          <button
            onClick={() => navigate('/dashboard')}
            className="flex items-center justify-center gap-2 px-6 py-3 rounded-lg transition-all text-sm"
            style={{
              fontFamily: 'system-ui, sans-serif',
              fontWeight: 600,
              color: '#F5F4F0',
              background: '#1a1a1a',
              border: '1.5px solid #1a1a1a',
              letterSpacing: '0.01em',
            }}
            onMouseEnter={e => {
              e.currentTarget.style.background = '#333';
            }}
            onMouseLeave={e => {
              e.currentTarget.style.background = '#1a1a1a';
            }}
          >
            <Home size={15} />
            Back to Dashboard
          </button>
        </div>

        {/* Footer caption */}
        <p
          className="mt-10 text-xs"
          style={{
            color: '#00000030',
            fontFamily: 'system-ui, sans-serif',
            letterSpacing: '0.05em',
          }}
        >
          WAO · {new Date().getFullYear()}
        </p>
      </div>
    </div>
  );
};

export default NotFound;