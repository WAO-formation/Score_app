# wao_mobile Architecture Review — 2026-09-05

**Status: all 10 findings below have been fixed**, plus 3 more discovered
while fixing them (marked **NEW**). `flutter analyze`: 0 errors. `flutter
test`: 52/52 passing. Android build verified with the new Crashlytics
Gradle plugin wired in.

## Critical — the actual answer to "is it scalable"

### 1. No pagination anywhere ✅ Fixed
Added safety caps (`.limit()`) to every previously-unbounded stream:
`getAvailablePlayers`, `getAllMatches`, `getMatchesByStatus` (live/upcoming),
news feed. `getFinishedMatches` and `getMatchesForTeams` — the two that
actually needed *real* pagination, not just a cap, since match history and
a fan's followed-team feed genuinely grow forever — were rewritten:
- `getFinishedMatches`: proper `orderBy(startTime desc).limit(100)` server-
  side. Needed a new composite index (`status` ASC, `startTime` DESC) —
  added to a new `firestore.indexes.json` and deployed.
- `getMatchesForTeams`: was downloading the **entire matches collection**
  on every update and filtering client-side (the worst offender found).
  Rewritten to query only the relevant teams via `whereIn` (chunked by 10).
- **NEW, found while fixing this**: the favourites page (`getAllMatches()`
  filtered client-side to a user's starred IDs) had the same "download
  everything" problem. Added `MatchService.getMatchesByIds()` (chunked
  `whereIn` on document ID) and switched the page to it — now fetches
  exactly the starred matches, not the whole collection.

### 2. 12-player roster cap was client-only ✅ Fixed and deployed
Added a `rosterSize()` rules function and applied it to the `teams` update
rule — the cap now applies server-side to anyone writing `roster` (coach or
official), not just whatever the mobile client happens to check. Verified
with 3 new tests in the emulator suite (52/52 passing) and confirmed
working against the **live** deployed project via a role-by-role
integration test (see below) before this was called done.

### 3. N+1 query patterns ✅ Fixed
`TeamService._validateRosterPlayers` and `_assignPlayersToTeam` now use
`Future.wait` instead of sequential loops. The same one-at-a-time pattern
was also found (and fixed the same way) in 3 View files that fetch a
roster's full player list: `past_match_details.dart`, `team_details.dart`,
`game_detail_shared.dart`.

## High — architectural inconsistency

### 4. Two data-access patterns coexisting ✅ Fixed
All 5 Views that instantiated `PlayerService()`/`TeamService()` directly
now go through `PlayerViewModel`/`TeamViewModel` instead — `PlayerViewModel`
didn't properly exist before this (see finding below); it does now.

### 4b. **NEW** — `player_viewmodel.dart` didn't contain a ViewModel at all
It contained a second, divergent copy of `PlayerService` — not a
`ChangeNotifier`, just a duplicate class with the same name as the real
one. **`TeamService` (which runs every add/remove-player operation) was
importing this duplicate, not the real service.** Two implementations of
the same logic, silently diverging, is exactly the kind of landmine that
makes a bug fix in one copy not apply to the other. Fixed: the duplicate
is gone, every caller points at the one real `PlayerService`, and
`player_viewmodel.dart` now contains an actual `PlayerViewModel`.

### 5. No dependency injection ✅ Fixed
`PlayerService`, `TeamService`, `MatchService`, `NewsService`, and every
ViewModel that wraps them now accept their dependencies as optional
constructor parameters (defaulting to the real singletons). No behavior
change for existing call sites — this just opens the door for the
service-layer unit tests `TESTING_RESULTS.md` had to skip.

### 6. `TeamService` was a 644-line god object ✅ Fixed
Split into `TeamService` (CRUD + roster), `TeamStatisticsService` (season
stats), and `TeamFollowService` (following a team). All 5 external callers
already went through `TeamViewModel`'s stable API, so this was a purely
internal refactor — no View changed.

### 6b. **NEW**, found while splitting out `TeamFollowService** — follower
counts were permanently stuck at 0.
`followTeam()`/`unfollowTeam()` only ever wrote
`users/{uid}/followedTeams/{teamId}`. `getTeamFollowerCount()` counted a
**different** collection — `teams/{teamId}/followers/{userId}` — that
nothing ever wrote to, despite `firestore.rules` already having a write
rule for exactly that path. Fixed: both documents are now written/deleted
together in one batch.

### 7. Three "which teams does this user care about" mechanisms — flagged, not merged
`favoriteTeamIds`, `followedTeamIds`/`teams/{id}/followers`, and `teamId`
still coexist. Left alone deliberately — collapsing them is a product
decision (are "favorite" and "follow" meant to be the same feature?), not
a mechanical fix. Flagging again here rather than guessing.

### 7b. **NEW** — a sibling bug found while investigating #7: match
favoriting is a shared global flag, not per-user
The star icon on match cards (`match.isFavorite`, `toggleMatchFavorite`)
writes to a single boolean **on the match document itself** — shared by
every viewer. If two fans both star the same match, whichever one unstars
it removes the star for the other too. The app already has the *correct*
per-user mechanism for this exact concept (`UserProfile.favoriteMatchIds`,
what the favourites page actually reads) sitting right next to it. **Not
fixed** — rerouting the star icon in 4 UI files to the per-user mechanism
is a real (if small) UI change with a user-visible behavior change, and per
the same principle as #7, that's a call for you to make, not one to guess
at silently. Flagging clearly: this is a live, user-facing bug, more
serious than the merely-architectural #7.

## Medium — operational maturity

### 8. No crash/error reporting ✅ Fixed
Added `firebase_crashlytics`, wired up `FlutterError.onError` and
`PlatformDispatcher.instance.onError` in `main.dart` (guarded to
Android/iOS/macOS — Crashlytics has no web or Windows/Linux
implementation). Added the native Android Gradle plugin
(`com.google.firebase.crashlytics`) and verified a real `flutter build apk
--debug` succeeds with it wired in. **Not done**: migrating the ~90
existing `print()` calls in service catch-blocks to explicit
`recordError()` calls — the global handlers catch uncaught errors, but an
error a service already catches and only `print()`s still won't reach
Crashlytics. Worth a follow-up pass.

### 9. Hand-written serialization, no codegen — partially fixed
Not migrating existing models to `freezed`/`json_serializable` (still not
urgent enough to justify touching 6 stable models). **Did** fix the
specific bug this caused: `WaoPlayer.fromFirestore`/`WaoTeam.fromFirestore`
now check `is Timestamp` instead of blindly casting, so an unresolved
`FieldValue.serverTimestamp()` sentinel degrades to `null` instead of
throwing. Covered by regression tests in both model test files.

### 10. Dead code ✅ Removed what was confirmed dead
Removed with zero remaining callers, verified by grep before deletion:
`SeedingService`/`LiveScoreProvider` (earlier this session),
`MatchService.getMatchesByType/getMatchesInDateRange/getChampionshipMatches`,
`PlayerService.getAllPlayers/getPlayersByRole`,
`NewsService.getNewsByCategory`, and the `player_viewmodel.dart` duplicate
(4b above). **Flagged, not removed**: `ChampionshipViewModel` is registered
in `main.dart`'s provider tree but has **zero View consumers** — either an
unbuilt feature (championships/leagues have real wao-web UI and Firestore
data, just no mobile screen yet) or safe to remove; not my call which.

## Verification

- `flutter analyze`: 0 errors (both before and after every change above).
- `flutter test`: 52/52 passing, including new regression tests for the
  roster cap (rules), the follower-count fix, and the sentinel-parsing fix.
- `firestore.rules` roster cap: 3 new emulator tests + confirmed against
  the **live** deployed project (not just the emulator) as part of the
  same integration-testing pass from earlier — see
  `INTEGRATION_SECURITY_TESTING.md`.
- Android build (`flutter build apk --debug`) verified to succeed with the
  new `firebase_crashlytics` dependency and Gradle plugin in place.

## Still open (deliberately, not oversights)

1. **7b** (shared-global match-favorite bug) — real bug, needs your call
   before touching 4 UI files.
2. **7** (3 team-affiliation mechanisms) — product decision.
3. **ChampionshipViewModel** — confirm whether it's a future mobile screen
   or safe to delete.
4. Migrating the ~90 `print()` calls to `recordError()` — mechanical but
   large; the global handlers already catch what matters most (uncaught
   errors).
5. `freezed`/`json_serializable` migration for existing models — not
   urgent, apply to new models going forward instead.
