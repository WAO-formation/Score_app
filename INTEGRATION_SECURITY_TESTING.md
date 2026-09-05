# Integration, Security & Role-Based Access Testing — 2026-09-05

This extends `TESTING_RESULTS.md` with the two test types flagged there as
"not done": **integration testing** and **security / auth / RBAC testing**.

## Methodology

`wao-web/scripts/integrationSecurityTest.js` signs in as each real demo
account **against the live production Firebase project**
(`wao-mobile-app-7e3c9`) — not the emulator — and attempts a battery of
reads/writes, asserting each either succeeds or is rejected with
`permission-denied` as expected.

This is deliberately a different kind of test from `npm run test:rules`
(the existing emulator suite): that suite tests the *local* `firestore.rules`
file in isolation. This one proves **the rules actually deployed to
production right now** behave correctly, signed in as real accounts,
against real data. That distinction is not academic — earlier this session,
add/remove-player broke in production because a rules change had been
written and emulator-tested but never deployed. An emulator-only suite can
never catch that category of gap; only testing against the live project can.

**Cleanliness**: every "expect success" check either writes back the exact
value it read (a genuine no-op) or reverts/deletes what it created before
finishing. Verified after the run via `scripts/checkMatches.js` — all 3
real match docs and all 6 teams are unchanged. Every "expect fail" case
is, by construction, rejected by the rules and never persists anything.

**Run it yourself**: `cd wao-web && node scripts/integrationSecurityTest.js`

## Result: 36/36 checks passed

| # | Phase | Check | Expected | Got |
|---|-------|-------|----------|-----|
| 1 | unauthenticated | cannot read `matches` at all | FAIL | ✅ FAIL |
| 2 | fan | can read own profile | SUCCESS | ✅ SUCCESS |
| 3 | fan | cannot read another user's profile | FAIL | ✅ FAIL |
| 4 | fan | cannot self-promote `role` to `admin` | FAIL | ✅ FAIL |
| 5 | fan | cannot create a team | FAIL | ✅ FAIL |
| 6 | fan | cannot edit an existing team's roster | FAIL | ✅ FAIL |
| 7 | fan | can toggle `isFavorite` on a match | SUCCESS | ✅ SUCCESS |
| 8 | fan | cannot edit a match's score | FAIL | ✅ FAIL |
| 9 | fan | cannot read a match's private access code | FAIL | ✅ FAIL |
| 10 | fan | cannot read internal reports | FAIL | ✅ FAIL |
| 11 | fan | cannot create a venue | FAIL | ✅ FAIL |
| 12 | fan | cannot create a news article | FAIL | ✅ FAIL |
| 13 | fan | can follow then unfollow a team | SUCCESS | ✅ SUCCESS |
| 14 | player | own profile has the expected `teamId` | SUCCESS | ✅ SUCCESS |
| 15 | player | cannot reassign own `teamId` | FAIL | ✅ FAIL |
| 16 | player | cannot edit their team's roster (not a coach) | FAIL | ✅ FAIL |
| 17 | coach | can re-save own team's roster (no-op) | SUCCESS | ✅ SUCCESS |
| 18 | coach | cannot edit own team's `name` (outside allowed fields) | FAIL | ✅ FAIL |
| 19 | coach | cannot edit a *different* team's roster | FAIL | ✅ FAIL |
| 20 | coach | cannot create a player pre-assigned to another team | FAIL | ✅ FAIL |
| 21 | coach | can re-save own team's `activePlayers` stat (no-op) | SUCCESS | ✅ SUCCESS |
| 22 | coach | cannot edit own team's `wins`/`losses` | FAIL | ✅ FAIL |
| 23 | coach | cannot create a match | FAIL | ✅ FAIL |
| 24 | unassigned official | cannot grant Judges score on a match they're not assigned to | FAIL | ✅ FAIL |
| 25 | unassigned official | can read internal reports (official-tier) | SUCCESS | ✅ SUCCESS |
| 26 | unassigned official | cannot create a venue (not admin) | FAIL | ✅ FAIL |
| 27 | unassigned official | cannot read a match's private access code | FAIL | ✅ FAIL |
| 28 | official on a legacy match doc | cannot score a match missing `judgeUids`, despite being named in `judges[]` | FAIL | ✅ FAIL |
| 29 | moderator | can read the access code of their assigned match | SUCCESS | ✅ SUCCESS |
| 30 | moderator | cannot read the access code of someone else's match | FAIL | ✅ FAIL |
| 31 | moderator | can edit venue on their assigned match, value genuinely changes | SUCCESS | ✅ SUCCESS |
| 32 | moderator | a second edit within 2s is rejected by the per-doc cooldown | FAIL | ✅ FAIL |
| 33 | moderator | cannot edit a match assigned to a different moderator | FAIL | ✅ FAIL |
| 34 | moderator | cannot create a match (admin-only, even for official-tier) | FAIL | ✅ FAIL |
| 35 | admin | can read any match's access code, including ones they didn't moderate | SUCCESS | ✅ SUCCESS |
| 36 | admin | can create then delete a venue | SUCCESS | ✅ SUCCESS |

Every role/permission boundary this project's rules claim to enforce —
ownership, admin-only actions, coach-scoped-to-own-team, moderator-scoped-
to-assigned-match, judge-scoped-to-assigned-match-while-live, the
2-second write cooldown, and the `matches/{id}/private/access` security
boundary added this session — held up against the real deployed rules.

## Findings (data hygiene, not rule bugs)

Discovered while building the account/match map this testing needed. Rules
enforcement was not compromised by any of these, but they're worth cleaning
up:

### 1. Two `judges[]`-listed officials cannot actually score their matches
`matches/mjwuxBBuNkxejY0xfsKY` and `matches/VFOV4YIXmSb6od7sz4iI` each list
3 officials in their `judges[]` array (shown in the UI as assigned judges),
but neither document has a `judgeUids` array at all — and the judge-scoring
rule requires `'judgeUids' in resource.data`. These are older docs, created
before `matchesService.createMatch()` started writing `judgeUids` alongside
`judges`. Confirmed directly: check #28 above shows a judges[]-listed
official (`ama.boateng@wao-demo.com`) is correctly rejected when trying to
score `mjwuxBBuNkxejY0xfsKY`. Any *new* match created via wao-web today
writes both fields correctly — this only affects these 2 pre-existing docs.
**Fix**: a one-off backfill (`judgeUids: judges.map(j => j.uid)`) on any
match doc missing the field, or just recreate these two test matches.

### 2. A duplicate `users` document for the admin's email
`users` has two separate documents both carrying the email
`afanyuemma2002@gmail.com`:
- `ruboLoW0JRdNSGK46LOZBqbTgQ83` — `role: admin` (this is the one that's
  actually live and used everywhere; confirmed by every script in this
  session signing in successfully as this account).
- `oLa7J4jpdUOwqjNhZz1V78lty193` — **`role` field is missing entirely.**

Firestore doesn't enforce email uniqueness across documents (only Firebase
*Auth* enforces uniqueness of the sign-in email itself), so this is a
harmless leftover — most likely an orphaned profile from an earlier
`seedAdminProfile()` run against a uid that no longer signs in — not a
security issue, since nothing can authenticate as `role: undefined` unless
they also control that specific uid's Auth credential (unknown/unused).
Worth deleting the orphaned doc so a future `users` collection scan doesn't
misread it as a second admin account.

### 3. An unrecognized moderator account
`matches/VFOV4YIXmSb6od7sz4iI` is assigned to moderator uid
`t8rQ35w7BbZc6nguRyHhVtCSesS2`, `moderatorName: "shema"` — not one of the
documented demo accounts in `wao-web/TEST_ACCOUNTS.md`. Also present:
`afanyuemmanueldelonie@gmail.com` with `role: moderator` (this appears to
be the developer's own personal account, used for real testing rather than
as a demo credential). Neither is a security problem — both are real,
correctly-roled accounts — just flagging so nobody's surprised finding an
undocumented name in production data.

## Still not covered

- **Officials seeded via `seed:officials`** (james.osei, kwame.asante,
  kofi.darko) were used as *subjects* of other roles' checks (e.g. "coach
  cannot poach a player", "judge is in `judges[]` but not `judgeUids`") but
  weren't each individually signed into and driven through the full check
  battery — `ama.boateng` stood in for that role tier along with the
  dedicated `judge@wao-demo.com` account, which is representative since
  they share identical rules treatment (`isOfficial()` doesn't distinguish
  between them).
- **UI-level integration testing** (actually clicking through wao-web/
  wao_mobile screens end to end) — this suite tests the Firestore/Auth
  layer directly, not the React/Flutter UI on top of it. A real
  browser/app E2E pass (Playwright / `integration_test/`) is still the
  gap called out in `TESTING_RESULTS.md`.
- **Rate-limit / abuse testing beyond the 2s cooldown** (e.g. sustained
  write floods, quota exhaustion) — out of scope for a one-off script.
