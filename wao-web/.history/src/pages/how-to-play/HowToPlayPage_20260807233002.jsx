import { useState, useLayoutEffect, useRef } from 'react';
import { Apple, Play, ChevronDown } from 'lucide-react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { BRAND } from '../../config/brand';

gsap.registerPlugin(ScrollTrigger);

const TABS = [
  { id: 'zones',   label: 'Scoring Zones' },
  { id: 'special', label: 'Special Plays' },
  { id: 'format',  label: 'Format' },
  { id: 'roles',   label: 'Player Roles' },
  { id: 'winning', label: 'Winning' },
];

const ZONES = [
  { weight: '30%', name: 'Kingdom',             desc: "Invade the opponent's Kingdom and bounce the ball inside it — 1 point per bounce, kept to a steady rhythm (at least 1/sec)." },
  { weight: '30%', name: 'Workout',             desc: 'Hold your own Workout zone and score for time spent there showing skill.' },
  { weight: '30%', name: 'Goalpost (OvalCrown)', desc: '4 OvalCrowns on the pitch (2 to defend, 2 to attack). A clean goal = 1 point.' },
  { weight: '10%', name: 'Hi-Court',            desc: 'Enter the Hi-Court and appeal to the Judges — a 6-judge panel scores skill and showmanship.' },
];

const SPECIALS = [
  { name: 'Sacrifice',    desc: 'Suspend a teammate to score: 3 points, or 33 points if a second ball scores within 7 seconds.' },
  { name: 'Goal-Setting', desc: "Scoring from the opponent's Goal-Setting area transfers a point — a net technical +2." },
  { name: 'Dominion',     desc: "A team's home turf. Losing it signals weakness and shifts momentum." },
];

const FORMAT = [
  { label: 'Players per team', value: '7 + 5 subs' },
  { label: 'Balls in play',    value: '2 max' },
  { label: 'Referees',         value: '2 field + 6 judges' },
  { label: 'Quarters',         value: '4' },
  { label: 'Match length',     value: '60 min' },
  { label: 'Quarter lengths',  value: '17 / 17 / 13 / 13 min' },
];

const ROLES = [
  { name: 'King',       focus: 'Defense',      desc: 'Anchors the defense and commands the Kingdom zone.' },
  { name: 'Warrior',    focus: 'Offense',       desc: 'Leads the offensive push — first into combat for every ball.' },
  { name: 'Worker',     focus: 'Workout',       desc: 'The star performer — racks up Workout points through skill.' },
  { name: 'Protaque',   focus: 'Support',       desc: 'The protagonist — holds Dominion and sets up teammates.' },
  { name: 'Antaque',    focus: 'Disruption',    desc: 'The antagonist — lives to obstruct and disrupt the opposing play.' },
  { name: 'Servitor',   focus: 'Floor General', desc: 'Servant to the whole team — keeps everyone moving and covered.' },
  { name: 'Sacrificer', focus: 'Special Plays', desc: "Executes the Sacrifice — the sport's highest-risk, highest-reward move." },
];

const STORE_BADGES = [
  { key: 'ios',     Icon: Apple, eyebrow: 'Coming soon to the', label: 'App Store' },
  { key: 'android', Icon: Play,  eyebrow: 'Coming soon on',     label: 'Google Play' },
];

const Card = ({ title, sub, desc, value }) => (
  <div className="rounded-2xl border p-6 flex flex-col gap-2" style={{ borderColor: BRAND.border, backgroundColor: BRAND.surface }}>
    {value && <span className="text-4xl sm:text-5xl" style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}>{value}</span>}
    <h3 className="text-xl uppercase" style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}>{title}</h3>
    {sub && <p className="text-[11px] font-semibold uppercase tracking-[0.12em]" style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}>{sub}</p>}
    <p className="text-sm leading-relaxed" style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}>{desc}</p>
  </div>
);

const PANELS = {
  zones: (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
      {ZONES.map((z) => <Card key={z.name} value={z.weight} title={z.name} desc={z.desc} />)}
    </div>
  ),
  special: (
    <div className="grid grid-cols-1 gap-4">
      {SPECIALS.map((s) => <Card key={s.name} title={s.name} desc={s.desc} />)}
    </div>
  ),
  format: (
    <div className="grid grid-cols-2 gap-4 sm:grid-cols-3">
      {FORMAT.map((f) => (
        <div key={f.label} className="rounded-2xl border p-6 text-center" style={{ borderColor: BRAND.border, backgroundColor: BRAND.surface }}>
          <p className="text-3xl sm:text-4xl" style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}>{f.value}</p>
          <p className="mt-2 text-xs uppercase tracking-[0.12em]" style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}>{f.label}</p>
        </div>
      ))}
    </div>
  ),
  roles: (
    <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
      {ROLES.map((r) => <Card key={r.name} title={r.name} sub={r.focus} desc={r.desc} />)}
    </div>
  ),
  winning: (
    <div className="rounded-2xl border p-8 sm:p-12 text-center" style={{ borderColor: BRAND.border, backgroundColor: BRAND.surface }}>
      <p className="text-6xl sm:text-8xl" style={{ fontFamily: BRAND.font.heading, color: BRAND.dark }}>100%</p>
      <p className="mt-4 text-sm leading-relaxed" style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}>
        Whichever team is closest to <strong>100%</strong> across all four zones when time runs out wins the match.
        There's no fixed score to chase — just more of the pitch than the other team.
      </p>
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
        gsap.set(['.htp-heading', '.htp-sidebar', '.htp-panel'], { opacity: 0, y: 20 });
        gsap
          .timeline({ defaults: { ease: 'power3.out' }, scrollTrigger: { trigger: rootRef.current, start: 'top 75%' } })
          .to('.htp-heading', { opacity: 1, y: 0, duration: 0.6 })
          .to('.htp-sidebar', { opacity: 1, y: 0, duration: 0.5 }, '-=0.3')
          .to('.htp-panel',   { opacity: 1, y: 0, duration: 0.5 }, '-=0.3');
      }, rootRef);
      return () => ctx.revert();
    });
    return () => mm.revert();
  }, []);

  const switchTab = (id) => {
    if (id === active) return;
    gsap.to(panelRef.current, {
      opacity: 0, y: 10, duration: 0.15,
      onComplete: () => {
        setActive(id);
        gsap.to(panelRef.current, { opacity: 1, y: 0, duration: 0.3, ease: 'power3.out' });
      },
    });
  };

  return (
    <section id="how-to-play" ref={rootRef} className="w-full bg-white py-20 px-6 scroll-mt-20">
      <div className="mx-auto max-w-6xl">

        {/* Heading */}
        <div className="htp-heading flex flex-col items-center text-center gap-2 mb-12">
          <p className="text-xs font-medium uppercase tracking-[0.3em]" style={{ fontFamily: BRAND.font.body, color: BRAND.primary }}>
            The Game
          </p>
          <h2 className="text-3xl uppercase text-[#011B3B] sm:text-4xl md:text-5xl" style={{ fontFamily: BRAND.font.heading }}>
            How WAO! Is Played
          </h2>
          <p className="mt-2 max-w-xl text-sm leading-relaxed" style={{ fontFamily: BRAND.font.body, color: BRAND.muted }}>
            A two-ball, hand-controlled contact sport played on the WaoSphere. Teams compete for a share of 100% — the team that covers more of the game wins.
          </p>
        </div>

        {/* Mobile select */}
        <div className="htp-sidebar relative md:hidden mb-6">
          <select
            value={active}
            onChange={(e) => switchTab(e.target.value)}
            className="w-full appearance-none rounded-xl border px-4 py-3 pr-10 text-sm font-semibold uppercase tracking-widest focus:outline-none"
            style={{ borderColor: BRAND.border, backgroundColor: BRAND.surface, fontFamily: BRAND.font.body, color: BRAND.dark }}
          >
            {TABS.map((t) => <option key={t.id} value={t.id}>{t.label}</option>)}
          </select>
          <ChevronDown className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4" style={{ color: BRAND.muted }} />
        </div>

        {/* Desktop: sidebar + content */}
        <div className="flex gap-8 items-start">

          {/* Sidebar */}
          <aside className="htp-sidebar hidden md:flex flex-col w-52 shrink-0 sticky top-24 gap-1">
            {TABS.map((tab) => {
              const isActive = active === tab.id;
              return (
                <button
                  key={tab.id}
                  onClick={() => switchTab(tab.id)}
                  className="text-left px-4 py-3 rounded-xl text-sm font-medium uppercase tracking-wider transition-all duration-200 border"
                  style={{
                    fontFamily: BRAND.font.body,
                    backgroundColor: isActive ? BRAND.dark : 'transparent',
                    color: isActive ? '#fff' : BRAND.muted,
                    borderColor: isActive ? BRAND.dark : 'transparent',
                  }}
                >
                  {tab.label}
                </button>
              );
            })}
          </aside>

          {/* Content */}
          <div ref={panelRef} className="htp-panel flex-1 min-w-0">
            {PANELS[active]}
          </div>

        </div>
      </div>
    </section>
  );
};

export default HowToPlayPage;
