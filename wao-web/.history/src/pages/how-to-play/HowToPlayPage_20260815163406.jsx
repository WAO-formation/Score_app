import { useState, useLayoutEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../../config/brand';

gsap.registerPlugin(ScrollTrigger);

const TABS = [
  { id: 'zones',   label: 'Zones' },
  { id: 'special', label: 'Special Plays' },
  { id: 'format',  label: 'Format' },
  { id: 'roles',   label: 'Roles' },
  { id: 'winning', label: 'Winning' },
];

const ZONES = [
  { weight: '30%', name: 'Kingdom',              desc: "Invade the opponent's Kingdom and bounce the ball inside it 1 point per bounce, kept to a steady rhythm (at least 1/sec).", color: BRAND.primary },
  { weight: '30%', name: 'Workout',              desc: 'Hold your own Workout zone and score for time spent there showing skill.', color: '#2563eb' },
  { weight: '30%', name: 'Goalpost (OvalCrown)', desc: '4 OvalCrowns on the pitch (2 to defend, 2 to attack). A clean goal = 1 point.', color: '#16a34a' },
  { weight: '10%', name: 'Hi-Court',             desc: 'Enter the Hi-Court and appeal to the Judges a 6-judge panel scores skill and showmanship.', color: '#d97706' },
];

const SPECIALS = [
  { name: 'Sacrifice',    icon: '⚡', desc: 'Suspend a teammate to score: 3 points, or 33 points if a second ball scores within 7 seconds.' },
  { name: 'Goal-Setting', icon: '🎯', desc: "Scoring from the opponent's Goal-Setting area transfers a point a net technical +2." },
  { name: 'Dominion',     icon: '🏰', desc: "A team's home turf. Losing it signals weakness and shifts momentum." },
];

const FORMAT = [
  { label: 'Players per team', value: '7 + 5' },
  { label: 'Balls in play',    value: '2 max' },
  { label: 'Referees',         value: '2 + 6' },
  { label: 'Quarters',         value: '4' },
  { label: 'Match length',     value: '60 min' },
  { label: 'Quarter lengths',  value: '17/17/13/13' },
];

const ROLES = [
  { name: 'King',       focus: 'Defense',       desc: 'Anchors the defense and commands the Kingdom zone.' },
  { name: 'Warrior',    focus: 'Offense',        desc: 'Leads the offensive push first into combat for every ball.' },
  { name: 'Worker',     focus: 'Workout',        desc: 'The star performer racks up Workout points through skill.' },
  { name: 'Protaque',   focus: 'Support',        desc: 'The protagonist holds Dominion and sets up teammates.' },
  { name: 'Antaque',    focus: 'Disruption',     desc: 'The antagonist lives to obstruct and disrupt the opposing play.' },
  { name: 'Servitor',   focus: 'Floor General',  desc: 'Servant to the whole team keeps everyone moving and covered.' },
  { name: 'Sacrificer', focus: 'Special Plays',  desc: "Executes the Sacrifice the sport's highest-risk, highest-reward move." },
];

const FOCUS_COLORS = {
  Defense:      { bg: '#fee2e2', text: '#991b1b' },
  Offense:      { bg: '#fef3c7', text: '#92400e' },
  Workout:      { bg: '#dbeafe', text: '#1e40af' },
  Support:      { bg: '#d1fae5', text: '#065f46' },
  Disruption:   { bg: '#ede9fe', text: '#5b21b6' },
  'Floor General': { bg: '#e0f2fe', text: '#0c4a6e' },
  'Special Plays': { bg: '#fce7f3', text: '#9d174d' },
};

const PANELS = {
  zones: (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
      {ZONES.map((z, i) => (
        <div
          key={z.name}
          className="relative rounded-2xl border p-6 flex flex-col gap-3 overflow-hidden"
          style={{ borderColor: BRAND.border, backgroundColor: '#fff' }}
        >
          {/* Accent bar */}
          <div className="absolute left-0 top-0 h-full w-1 rounded-l-2xl" style={{ backgroundColor: z.color }} />
          <div className="flex items-start justify-between gap-3 pl-2">
            <div>
              <span
                className="text-xs font-semibold uppercase tracking-[0.2em]"
                style={{ fontFamily: BRAND.font.body, color: z.color }}
              >
                Zone {i + 1}
              </span>
              <h3
                className="mt-1 text-xl uppercase leading-tight"
                style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}
              >
                {z.name}
              </h3>
            </div>
            <span
              className="shrink-0 rounded-full px-3 py-1 text-sm font-medium"
              style={{ fontFamily: BRAND.font.heading, backgroundColor: z.color + '18', color: z.color }}
            >
              {z.weight}
            </span>
          </div>
          <p className="pl-2 text-sm leading-relaxed" style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}>
            {z.desc}
          </p>
        </div>
      ))}
    </div>
  ),

  special: (
    <div className="flex flex-col gap-4">
      {SPECIALS.map((s) => (
        <div
          key={s.name}
          className="flex items-start gap-5 rounded-2xl border p-6"
          style={{ borderColor: BRAND.border, backgroundColor: '#fff' }}
        >
          <span className="text-3xl shrink-0 leading-none mt-0.5">{s.icon}</span>
          <div>
            <h3 className="text-xl uppercase" style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}>
              {s.name}
            </h3>
            <p className="mt-2 text-sm leading-relaxed" style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}>
              {s.desc}
            </p>
          </div>
        </div>
      ))}
    </div>
  ),

  format: (
    <div className="grid grid-cols-2 gap-3 sm:grid-cols-3">
      {FORMAT.map((f) => (
        <div
          key={f.label}
          className="rounded-2xl border p-5 text-center flex flex-col items-center justify-center gap-2"
          style={{ borderColor: BRAND.border, backgroundColor: '#fff', minHeight: '100px' }}
        >
          <p className="text-2xl sm:text-3xl leading-none" style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}>
            {f.value}
          </p>
          <p className="text-[11px] uppercase tracking-[0.12em] leading-tight" style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}>
            {f.label}
          </p>
        </div>
      ))}
    </div>
  ),

  roles: (
    <div className="grid grid-cols-1 gap-3 sm:grid-cols-2">
      {ROLES.map((r, i) => {
        const fc = FOCUS_COLORS[r.focus] || { bg: BRAND.surface, text: BRAND.muted };
        return (
          <div
            key={r.name}
            className="flex items-start gap-4 rounded-2xl border p-5"
            style={{ borderColor: BRAND.border, backgroundColor: '#fff' }}
          >
            <span
              className="flex h-9 w-9 shrink-0 items-center justify-center rounded-full text-sm font-bold"
              style={{ fontFamily: BRAND.font.heading, backgroundColor: BRAND.dark, color: '#fff' }}
            >
              {String(i + 1).padStart(2, '0')}
            </span>
            <div className="min-w-0">
              <div className="flex flex-wrap items-center gap-2">
                <h3 className="text-lg uppercase" style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}>
                  {r.name}
                </h3>
                <span
                  className="rounded-full px-2.5 py-0.5 text-[10px] font-semibold uppercase tracking-wide"
                  style={{ fontFamily: BRAND.font.body, backgroundColor: fc.bg, color: fc.text }}
                >
                  {r.focus}
                </span>
              </div>
              <p className="mt-1.5 text-sm leading-relaxed" style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}>
                {r.desc}
              </p>
            </div>
          </div>
        );
      })}
    </div>
  ),

  winning: (
    <div className="flex flex-col gap-4">
      <div
        className="rounded-2xl border p-8 sm:p-12 text-center"
        style={{ borderColor: BRAND.border, backgroundColor: '#fff' }}
      >
        <p className="text-7xl sm:text-9xl leading-none" style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}>
          100%
        </p>
        <p className="mx-auto mt-6 max-w-md text-sm leading-relaxed sm:text-base" style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}>
          Whichever team is closest to <strong style={{ color: BRAND.dark }}>100%</strong> across all four zones when time runs out wins the match.
          There's no fixed score to chase — just more of the pitch than the other team.
        </p>
      </div>
      {/* Quick summary pills */}
      <div className="flex flex-wrap gap-2 justify-center">
        {['Most zones covered wins', 'No fixed target', '60 min match', '4 quarters'].map((tip) => (
          <span
            key={tip}
            className="rounded-full border px-4 py-2 text-xs font-semibold uppercase tracking-wide"
            style={{ fontFamily: BRAND.font.body, borderColor: BRAND.border, color: BRAND.dark, backgroundColor: BRAND.surface }}
          >
            {tip}
          </span>
        ))}
      </div>
    </div>
  ),
};

const HowToPlayPage = () => {
  const [active, setActive] = useState('zones');
  const rootRef  = useRef(null);
  const panelRef = useRef(null);

  useLayoutEffect(() => {
    const mm = gsap.matchMedia();
    mm.add('(prefers-reduced-motion: no-preference)', () => {
      const ctx = gsap.context(() => {
        gsap.set('.htp-heading', { clipPath: 'inset(100% 0% 0% 0%)' });
        gsap.to('.htp-heading', {
          clipPath: 'inset(0% 0% 0% 0%)', duration: 0.85, ease: 'power4.out',
          scrollTrigger: { trigger: rootRef.current, start: 'top 78%' },
        });

        gsap.set(['.htp-tabs', '.htp-panel'], { opacity: 0, y: 24 });
        gsap
          .timeline({ defaults: { ease: 'power3.out' }, scrollTrigger: { trigger: rootRef.current, start: 'top 72%' } })
          .to('.htp-tabs',  { opacity: 1, y: 0, duration: 0.6 }, 0.2)
          .to('.htp-panel', { opacity: 1, y: 0, duration: 0.6 }, 0.35);
      }, rootRef);
      return () => ctx.revert();
    });
    return () => mm.revert();
  }, []);

  const switchTab = (id) => {
    if (id === active) return;
    gsap.to(panelRef.current, {
      opacity: 0, y: 8, duration: 0.15,
      onComplete: () => {
        setActive(id);
        gsap.to(panelRef.current, { opacity: 1, y: 0, duration: 0.3, ease: 'power3.out' });
      },
    });
  };

  return (
    <section id="how-to-play" ref={rootRef} className="w-full bg-white py-20 px-4 sm:px-6 scroll-mt-20">
      <div className="mx-auto max-w-6xl">

        {/* Heading */}
        <div className="htp-heading flex flex-col items-center text-center gap-2 mb-10">
          <p
            className="text-xs font-semibold uppercase tracking-[0.3em]"
            style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}
          >
            The Game
          </p>
          <h2
            className="text-3xl uppercase sm:text-4xl md:text-5xl"
            style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}
          >
            How WAO! Is Played
          </h2>
          <p
            className="mt-2 max-w-xl text-sm leading-relaxed sm:text-base"
            style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}
          >
            A two-ball, hand-controlled contact sport played on the WaoSphere. Teams compete for a share of 100% — the team that covers more of the game wins.
          </p>
        </div>

        {/* Tabs — scrollable pill row on mobile, same on desktop */}
        <div className="htp-tabs mb-8 -mx-4 px-4 sm:mx-0 sm:px-0">
          <div
            className="flex gap-2 overflow-x-auto pb-1 sm:flex-wrap sm:justify-center"
            role="tablist"
            aria-label="How to play sections"
            style={{ scrollbarWidth: 'none' }}
          >
            {TABS.map((tab) => {
              const isActive = active === tab.id;
              return (
                <button
                  key={tab.id}
                  role="tab"
                  aria-selected={isActive}
                  aria-controls={`panel-${tab.id}`}
                  onClick={() => switchTab(tab.id)}
                  className="shrink-0 rounded-full px-5 py-2.5 text-xs font-semibold uppercase tracking-widest transition-all duration-200 focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2"
                  style={{
                    fontFamily: BRAND.font.body,
                    backgroundColor: isActive ? BRAND.dark : BRAND.surface,
                    color: isActive ? '#fff' : BRAND.muted,
                    focusRingColor: BRAND.primary,
                  }}
                >
                  {tab.label}
                </button>
              );
            })}
          </div>
        </div>

        {/* Panel */}
        <div
          ref={panelRef}
          id={`panel-${active}`}
          role="tabpanel"
          className="htp-panel"
        >
          {PANELS[active]}
        </div>

      </div>
    </section>
  );
};

export default HowToPlayPage;
