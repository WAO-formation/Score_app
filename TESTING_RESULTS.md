# Testing Results — 2026-09-05

Every automated test type feasible for this stack (Flutter mobile + React
web + Firestore, no separate backend) was run. Two real issues were found
and fixed along the way — see **Findings** below. Net result: **everything
that can currently be tested is green.**

## Summary

| Test type | Project | Result |
|---|---|---|
| Unit tests (models/utils) | wao_mobile | ✅ 51/51 passed *(50 new, added this pass)* |
| Static analysis (`flutter analyze`) | wao_mobile | ✅ 0 errors *(537 pre-existing style-only infos/warnings)* |
| Unit tests (services/hooks) | wao-web | ✅ 49/49 passed |
| Firestore security rules tests (emulator) | wao-web | ✅ 49/49 passed |
| Production build (`vite build`) | wao-web | ✅ succeeds, 424 kB main bundle |
| ESLint | wao-web | ⚠️ 12 errors, 7 warnings (real, pre-existing, non-blocking — see below) |
| Integration testing (real Firebase project, not emulator) | both | ✅ 36/36 passed — see `INTEGRATION_SECURITY_TESTING.md` |
| Security / auth / role-based access testing | both | ✅ 36/36 passed — see `INTEGRATION_SECURITY_TESTING.md` |
| Widget/UI tests | wao_mobile | ⛔ not done — no harness for Firebase-backed screens yet |
| Service-layer tests (Firestore read/write logic) | wao_mobile | ⛔ not done — needs a fake-Firestore dependency, not added |
| Browser/app E2E (click-through UI) | both | ⛔ not done — no Playwright/`integration_test/` harness exists on either side |
| Manual cross-role QA in the actual UI | both | ⛔ not done — requires a live human session per role |

## 1. wao_mobile — unit tests (new)

`wao_mobile/test/` had exactly one file before this pass:
`widget_test.dart`, the untouched Flutter-template counter-app test. It
pumped `MyApp()` (which needs `Firebase.initializeApp()` and every
`Provider` wired up) looking for a `+` button and a counter that don't
exist in this app — it would have failed immediately had anyone run it.
**Deleted.**

Added real coverage for the pure-Dart layer (models + one security-relevant
utility) — the biggest gap identified in this project. No new dependencies;
these run in plain `flutter test`, no emulator or device needed.

| File | Covers |
|---|---|
| `test/models/wao_player_test.dart` | `WaoPlayer` parsing, role/status defaults, `isAvailable`, round-trip, the FieldValue finding below |
| `test/models/wao_team_test.dart` | `TeamRoster` (all 8 role buckets incl. servitor/substitute), `WaoTeam` category fallback, squad-size limits |
| `test/models/wao_match_test.dart` | `MatchStatus` incl. the newer postponed/suspended/cancelled values, judges/quarters/fouls/events round-trip, `getFinalScores`/`getWinner` weighting (30/30/30/10) |
| `test/models/user_model_test.dart` | `AccountRole` incl. player/coach, role-fallback safety, `isOfficial`/`isAdmin`, `teamId`, `initials` |
| `test/models/team_stat_test.dart` | `GameResult` win/draw/loss, `TeamStatistics` points/win-%/goal-diff math, zero-games edge case |
| `test/utils/drive_image_test.dart` | `DriveImage.resolve` (all 3 Drive URL shapes, host allowlist), `isSafeToLoad` (rejects `javascript:`/`data:`) |

**Run:** `cd wao_mobile && flutter test` → **51 passed, 0 failed.**

## 2. wao_mobile — static analysis

`flutter analyze` → **0 errors.** 537 remaining items are all `info`/
`warning` severity — `deprecated_member_use` (`withOpacity`, `background`
theme fields), `avoid_print`, missing `const` — pre-existing style debt
unrelated to this session's changes, not correctness issues.

## 3. wao-web — unit tests

Already existed, re-run to confirm still green: `matchesService.test.js`,
`teamsService.test.js`, `useGameSimulation.test.js`.

**Run:** `npm test` → **49 passed, 0 failed.**

## 4. wao-web — Firestore rules tests

Spins up the real Firestore emulator and exercises `firestore.rules`
directly — the most valuable test type in this project, since the rules
file is the actual security boundary (there's no separate backend).
Covers admin/moderator/official/coach/fan permission boundaries.

**Run:** `npm run test:rules` → **49 passed, 0 failed.**

## 5. wao-web — production build

**Run:** `npx vite build --mode development` → succeeds in ~14s, no
warnings besides normal chunk-size notices.

## 6. wao-web — ESLint

First run reported **393 errors, 44 warnings** — almost all noise. 269 of
281 flagged files were under `wao-web/.history/`, a local-history
editor-backup directory full of timestamped, sometimes mid-edit snapshots
(e.g. `SideNav_20260208101808.jsx`) that isn't real source and was never
excluded from lint. It was drowning out every genuine finding. **Fixed** by
adding it to `eslint.config.js`'s `globalIgnores`.

Re-run against real `src/` only: **12 errors, 7 warnings** — a normal,
non-blocking amount of pre-existing lint debt:
- 4× unused `Icon` import/`err` variable (`Dashboard.jsx`, `LiveGame.jsx`, `Reports.jsx`, `Profile.jsx`, `CreateTeam.jsx`)
- 4× `react-refresh/only-export-components` (a file exports both a component and a constant/hook — `Pagination.jsx`, `AuthContext.jsx`, `GamesContext.jsx`)
- 3× `setState` called synchronously inside a `useEffect` body (`Navbar.jsx`, `GameDetails.jsx`, `Teams.jsx`) — works today, flagged by React's newer compiler-era lint rule as a cascading-render risk
- 7× `react-hooks/exhaustive-deps` warnings, all in `useGameSimulation.js`

None of these block the build or are exercised as failures by the unit/rules
suites above — recorded here as a to-do list, not urgent.

## Findings (bugs caught by this pass)

### 1. `.history/` was making `npm run lint` useless (fixed)
See above — `eslint.config.js` now ignores it. Recommend also adding
`.history/` to a `.gitignore` (none exists at the repo root today) so it
stops accumulating in `git status` noise too — not done here since deleting
or ignoring local editor history wasn't asked for and touches your editor
tooling, not the app.

### 2. `WaoPlayer`/`WaoTeam.toFirestore()` writes a sentinel that their own `fromFirestore()` can't parse (documented, not fixed)
When `updatedAt` is null, `toFirestore()` emits `FieldValue.serverTimestamp()`
instead of a real `Timestamp`. This is **safe in production** — Firestore
always resolves that sentinel to a real Timestamp before any listener or
`get()` sees the document, so no live code path hits this. It only breaks
if something ever calls `fromFirestore(x.toFirestore(), id)` locally without
a real server round-trip (exactly what a naive round-trip unit test does —
this is how it was caught). Left as-is with a regression test documenting
the exact behavior (`wao_player_test.dart`, "Known issue" group) rather than
changed, since fixing it means deciding what `fromFirestore` *should* do
with an unresolved sentinel (treat as `null`? as `now()`?) — a product
decision, not a mechanical fix.

## Recommended next steps (not done this pass)

1. **Flutter widget tests** for at least the highest-traffic screens
   (`TeamActivitiesPage`, login) — needs a test harness that fakes
   `Provider`/`Firebase` rather than hitting them for real.
2. **Service-layer tests** (`TeamService.addPlayerToTeam`,
   `PlayerService`, `MatchService`) against a fake Firestore — would need
   the `fake_cloud_firestore` package added to `pubspec.yaml`'s
   `dev_dependencies`. Not added here to avoid touching dependency
   resolution in the same pass as everything else (recall this project has
   hit real version-conflict issues before, e.g. `firebase_messaging`
   vs `firebase_core`).
3. **Browser/app E2E** (Playwright for wao-web, `integration_test/` for
   mobile) to catch UI-layer regressions — `INTEGRATION_SECURITY_TESTING.md`
   now covers the Firestore/Auth layer directly (role permissions, the
   2s write cooldown, the private-access-code boundary) against the real
   deployed project, but doesn't click through any actual screens.
4. **Manual QA pass** through each of the 7 demo accounts in the real UI
   (see `wao-web/TEST_ACCOUNTS.md`) after any `firestore.rules` change —
   `npm run test:integration` (see `INTEGRATION_SECURITY_TESTING.md`) now
   covers the same accounts at the data layer and can be re-run any time
   for a quick regression check without a human at the keyboard.
