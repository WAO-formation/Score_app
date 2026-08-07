# WAO! Website Strategy & Structure

Reference document for rebuilding the WAO! marketing site. Source material: `WAO_Magazine_July_2024.md` (official brand/rules magazine) + audit of the current `wao-web` codebase. Use this to align section-by-section rebuild decisions — content, order, and voice — before writing components.

---

## 1. What WAO! actually is (facts to build from)

- **Company**: Waoherds Limited, founded June 2012 by **Solomon Kyei**, based in Accra, Ghana.
- **Sport**: "Wao!" — a two-ball, hand-controlled, contact sport played on a spherical digitized pitch called the **WaoSphere**. Registered with Copyright Ghana in 2014; conceived ~2013.
- **Vision**: Champion world oneness through innovative sports experiences that blend technology with traditional gameplay.
- **Mission**: Empower individuals through world-class edutainment and sports development.
- **The hook / differentiator**: multi-zone percentage scoring (not points-to-a-target like most sports), built-in storytelling commentary, and a "theme sport" concept where games can be re-skinned to tell real-world stories (e.g., a cancer-awareness game, a jungle-story game).
- **Status as of the magazine (2024)**: still largely a *manual* (non-digitized) sport running clinics and community play in Accra (Cornerstone Baptist Church car park, Dome Pillar II, TBC Court Tesano); the "digitized pitch," smart balls, and WaoScor app are described as **in development / vision**, not yet shipped. Be careful not to overclaim finished tech — frame as roadmap where appropriate.
- **Partners named**: DUNK (Developing Unity, Nurturing Knowledge) — Accra/Tamale youth NGO running the "Playmaker" program.

### Scoring system (core rules, this is WAO!'s signature idea — should get real visual treatment on the site)
Percentage-based; closest team to 100% wins.
| Zone | Weight | What happens |
|---|---|---|
| **Kingdom** | 30% | Invade + bounce the ball in opponent's Kingdom, 1 pt/bounce (≥1/sec rhythm) |
| **Workout** | 30% | Score by spending time displaying skills in your own Workout zone (time-based) |
| **Goalpost (OvalCrown)** | 30% | 4 OvalCrowns total (2 defend, 2 score); regular goal = 1 pt; **Sacrifice** and **Goal-Setting** are special high-value plays |
| **Hi-Court / Judges** | 10% | Enter Hi-Court to "appeal to Judges"; a 6-judge panel scores skill/showmanship |

Special plays: **Sacrifice** (suspending a teammate to score — 3 pts, or 33 pts if a 2nd ball scores within 7 sec), **Goal-Setting** (scoring from opponent's Goal-Setting area transfers a point, net technical +2), **Dominion** (a team's home turf — losing it signals weakness).

Format: 7 players + 5 subs (14 total on pitch across both teams), max 2 balls, max 2 field referees + 6 Hi-Court judges, 4 quarters (17/17/13/13 min = 60 min + possible extra time).

### Player roles (7 named characters — replace numbers)
King (defense/Kingdom), Warrior (offense/combat), Worker (skills/Workout, the "star performer"), Protaque (protagonist, dominion + support), Antaque (antagonist, obstruction), Servitor (support/floor general, "servant to all teammates"), Sacrificer (executes Sacrifice plays). Each has real narrative flavor text in the magazine — good raw material for character-card style bios.

### Technology roadmap (frame as "the future of WAO", not shipped fact)
Digitized pitch, sensor balls (light up / vibrate / sound), WaoScor scoring app, Techthrills (AR/VR narrative overlays), bifocus dual-ball camera, AI/robot sparring partners for safe Sacrifice training.

### Programs / audiences
- Students & Children Program (schools, life-skills, talent pipeline)
- Community clinics (grassroots, e.g. with DUNK)
- Partnership/sponsorship pitch (equipment manufacturers, tech partners, investors, schools)
- Spectators/fans (the "multi-focus, 2-ball" spectator experience is pitched as its own selling point)

---

## 2. Brand voice

**Tone**: bold, proud, motivational, community-first, unapologetically ambitious ("world-class," "world oneness," "global sport"). Speaks like a founder pitching a movement, not a corporate copy deck. African-originated pride is part of the identity (Ghana origin, Ghanaian industry context) — don't sand that off into generic "global sports" boilerplate.

**Recurring rhetorical moves worth reusing**:
- Proverbs/one-liners as section punctuation: *"You never win Wao! with average!"*
- Direct address + rhetorical questions: *"Must we always be employed and entertained by what we came to meet?"*
- Framing the ball/game as a metaphor for life ("Ball Story" — the ball in your hand vs. the ball you don't control = the two sides of life).
- Storytelling-first language: game events are described as "story," "narration," "characters," not just plays.

**Voice do's**: confident, warm, inclusive ("world as one"), instructional clarity when explaining rules (short declarative sentences), a little theatrical when describing Sacrifice/Dunk/skills moments.
**Voice don'ts**: don't sound like a generic SaaS/startup ("streamline," "unlock," "leverage"); don't overclaim shipped technology; don't drop the storytelling angle — it's WAO's actual differentiator, more than "yet another contact sport."

**Naming conventions to keep consistent site-wide**: always "Wao!" or "WAO!" with the exclamation point in body copy per the source doc (use judgment in UI chrome/nav where punctuation gets visually noisy — e.g. nav labels can drop the "!"), "WaoSphere" one word capital S, "Kingdom / Workout / Goalpost (OvalCrown) / Hi-Court" capitalized as proper nouns for zones, "WaoScor."

---

## 3. Audiences (design each page with one of these primarily in mind)

1. **Prospective players / schools / community members** — want to know "what is this, how do I play, where."
2. **Sponsors / investors / technology partners** — want vision, business model, traction, ask.
3. **Fans/spectators** — want games, schedule, results, highlights (this is where the site should bridge into the existing dashboard app's game data).
4. **Media/press** — story angle, founder, origin, differentiators.

---

## 4. Proposed site structure

Current state (per codebase audit): one long single page (Navbar → Hero → carousel "Play" section → CTA banner) with a nav bar promising **Games / About Us / How To Play / Contact Us** links that don't exist yet, plus an unrelated logged-in scorekeeping dashboard (`/dashboard`, `/teams`, `/games`, `/management`) that should stay separate from the marketing site and only be linked to via "Join WAO" / login.

Recommended public route map:

| Route | Purpose | Key magazine content |
|---|---|---|
| `/` (Home) | Hook + orientation + funnel to the 3 things people want (play, watch, partner) | Hero pitch, quick scoring teaser, story angle, program highlights, CTA |
| `/about` | Origin story, founder, vision/mission, timeline | "Our Story," "Then and Now," Waoherds profile, business model |
| `/how-to-play` | The actual rules, explained visually | "Let's Play," scoring zones table, player roles/characters, equipment, basic fouls |
| `/the-experience` (or fold into `/how-to-play`) | What makes WAO different — theme sport, storytelling, tech roadmap | Techthrills, WaoScor, Ball Story, "Luxury of playing/watching 2 balls" |
| `/programs` | Students & Children Program, community clinics, DUNK partnership | Program copy, DUNK profile, clinic photos |
| `/partner` (Partnership Opportunities) | Pitch to sponsors/investors/schools/tech partners | Partnership Opportunities, Industry Analysis (global/African/Ghana), World-Class Mission |
| `/games` (public) | Schedule/results teaser pulling from the real dashboard data | Bridges to the private scorekeeping app |
| `/gallery` | Photos/clinics/press | Gallery, TV3 interview, clinic scenes |
| `/contact` | Contact + join CTA | phone number already in magazine footer; add form |
| `/login` → `/dashboard...` | Existing private app | unchanged, just gate it behind a clear "For Teams & Officials" entry point rather than the primary nav CTA |

This can ship incrementally as a single scrolling `/` page with in-page anchors first (matches the current "section-by-section" build approach) and later split into real routes as content grows — but the nav should never promise a link that isn't live (current bug: About Us/How To Play/Contact Us go nowhere).

### Suggested Home (`/`) section order for the first rebuild pass
1. **Navbar** — fix dead links or make them same-page anchors until real pages exist.
2. **Hero** — keep the energy, fix "Learn More" → should not deep-link into the private `/dashboard`; point it at an anchor/`/how-to-play` instead.
3. **What is WAO!** — 3-4 sentence plain-language explainer + the 4-zone scoring visual (this is currently missing entirely; it's the single most important thing a first-time visitor needs).
4. **How to Play teaser** — zones + player roles, "Learn the full rules" CTA.
5. **The Story/Vision** — world-oneness mission, origin, storytelling angle (differentiator).
6. **Programs/Community** — schools & children program, clinics.
7. **Gallery/carousel** — keep, but give it real captions instead of decorative-only.
8. **Partner/CTA** — sponsor pitch teaser → `/partner`.
9. **Join/Contact CTA** — footer-adjacent, phone/contact.

---

## 5. Current codebase notes (what to keep vs. fix)

- **Stack**: Vite 7 + React 19 + React Router v7 + Tailwind v4 (via `@tailwindcss/vite`, no `tailwind.config.js` yet) + Firebase backend for the dashboard app. Fonts already chosen: **Anton** (headings) + **Oswald** (body) — good fit for a bold sport brand, keep them.
- **`src/config/brand.js`** currently only has `primary: '#c81434'` / `primaryHover` + font stack, applied via inline styles. Recommend formalizing brand colors as CSS variables / Tailwind theme tokens (add a real `tailwind.config.js` or `@theme` block in `index.css` for Tailwind v4) so components stop hand-rolling inline styles. Consider adding secondary colors mapped to the 4 scoring zones (Kingdom/Workout/Goalpost/Judges) for consistent use in diagrams across the site.
- **`src/routes/private.jsx` and `src/routes/public.jsx`** are dead code (unused duplicates of `src/routes/index.jsx`) — safe to delete during cleanup.
- **Existing components to revise rather than discard**: `Hero.jsx` (good bones, fix CTA targets + copy accuracy), `Navbar.jsx` (fix links), `PlaySection.jsx` (carousel mechanism is fine, but currently has zero real content — needs actual rules/zone content, not just decorative images), `CtaSection.jsx` (fine as a pattern, reuse for `/partner` teaser too).
- **Assets on hand**: `Hero.png`, `logo.png`, 11 `card-carosel*.png` images, `wao-ball.png`. No photos yet from the magazine's gallery section (Team Cornerstone, clinic scenes, TV3 interview) — will need those exported from the PDF/magazine if they're wanted on `/gallery`.
- **Don't conflate the two apps**: keep the marketing site and the private scorekeeping/league-management dashboard (`/dashboard`, `/teams`, `/games/:id/simulate`, `/management`) cleanly separated. The public `/games` page (if built) should read from the same data source but present a read-only fan-facing view, not reuse dashboard components directly.

---

## 6. Open questions to settle before building further

- Do we ship `/how-to-play`, `/about`, etc. as real routes now, or keep everything as anchors on one long `/` page for v1 and split later?
- Is there real photography (gallery, team photos, founder photo) beyond what's in `public/assets/` already, or do we need placeholders?
- Should the public site link out to live game schedules/results from the dashboard data, or is that a v2 feature?
- Confirm current contact info to use (magazine footer lists `+233242786261`) — any email/social handles to add?
