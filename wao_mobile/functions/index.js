const {onDocumentUpdated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore, FieldValue, Timestamp} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();
const db = getFirestore();
const messaging = getMessaging();

/**
 * Fires whenever a match document is written. Runs with the Admin SDK, so
 * it bypasses firestore.rules entirely — the security boundary for this
 * feature is that only an official/moderator can move scoreA/scoreB in the
 * first place (enforced in firestore.rules), not anything in here.
 */
exports.notifyOnGoal = onDocumentUpdated("matches/{matchId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (!before || !after) return;

  const matchId = event.params.matchId;
  const goals = [];

  if ((after.scoreA ?? 0) > (before.scoreA ?? 0)) {
    goals.push({
      teamId: after.teamAId,
      teamName: after.teamAName,
      opponentName: after.teamBName,
    });
  }
  if ((after.scoreB ?? 0) > (before.scoreB ?? 0)) {
    goals.push({
      teamId: after.teamBId,
      teamName: after.teamBName,
      opponentName: after.teamAName,
    });
  }
  if (goals.length === 0) return;

  for (const goal of goals) {
    if (!goal.teamId) continue;
    await notifyFollowersOfGoal(goal, after, matchId);
  }
});

/** Looks up who follows the scoring team and pushes them a goal alert. */
async function notifyFollowersOfGoal(goal, match, matchId) {
  const followersSnap = await db
      .collection("teams")
      .doc(goal.teamId)
      .collection("followers")
      .get();
  if (followersSnap.empty) return;

  const uids = followersSnap.docs.map((doc) => doc.id);
  const tokens = await fetchFcmTokens(uids);
  if (tokens.length === 0) return;

  const message = {
    notification: {
      title: `Goal! ${goal.teamName}`,
      body: `${goal.teamName} ${match.scoreA} - ${match.scoreB} ${goal.opponentName}`,
    },
    data: {
      type: "live",
      matchId,
    },
    tokens,
  };

  const response = await messaging.sendEachForMulticast(message);
  await pruneDeadTokens(response, tokens);
}

/** Firestore.getAll() takes doc refs, not a where-in — batched to be safe
 * for large follower counts (getAll itself has no hard cap, but keeping
 * requests bounded avoids one oversized RPC). */
async function fetchFcmTokens(uids) {
  const tokens = [];
  for (const batch of chunk(uids, 300)) {
    const refs = batch.map((uid) => db.collection("users").doc(uid));
    const snaps = await db.getAll(...refs);
    for (const snap of snaps) {
      const token = snap.get("fcmToken");
      if (token) tokens.push(token);
    }
  }
  return tokens;
}

/** Best-effort cleanup: a token FCM reports as dead (app uninstalled, etc.)
 * is worth clearing so the next goal doesn't keep re-sending to it — not
 * critical to the feature working, so failures here are swallowed. */
async function pruneDeadTokens(response, tokens) {
  const deadTokens = [];
  response.responses.forEach((r, i) => {
    if (!r.success) {
      const code = r.error && r.error.code;
      if (
        code === "messaging/invalid-registration-token" ||
        code === "messaging/registration-token-not-registered"
      ) {
        deadTokens.push(tokens[i]);
      }
    }
  });
  if (deadTokens.length === 0) return;

  try {
    for (const batch of chunk(deadTokens, 10)) {
      const snap = await db
          .collection("users")
          .where("fcmToken", "in", batch)
          .get();
      if (snap.empty) continue;
      const writeBatch = db.batch();
      snap.forEach((doc) => writeBatch.update(doc.ref, {fcmToken: FieldValue.delete()}));
      await writeBatch.commit();
    }
  } catch (_) {
    // Cleanup is a nice-to-have; a failure here shouldn't surface as an
    // error for what is otherwise a successful notification send.
  }
}

function chunk(arr, size) {
  const out = [];
  for (let i = 0; i < arr.length; i += size) out.push(arr.slice(i, i + size));
  return out;
}

/**
 * On the upcoming/live -> finished transition: bumps gamesPlayed for every
 * rostered player on both teams, and updates each team's teamStatistics doc
 * (wins/draws/losses, goals for/against, recent-games list). This is the
 * only per-player stat derivable from the current data model — scoring in
 * WAO is logged per zone/category on the match doc (Kingdom/Workout/
 * Oval-Crown/Judges), not attributed to an individual player, so
 * goalsScored/assists on the player doc aren't touched here.
 */
exports.onMatchFinished = onDocumentUpdated("matches/{matchId}", async (event) => {
  const before = event.data.before.data();
  const after = event.data.after.data();
  if (!before || !after) return;
  if (before.status === "finished" || after.status !== "finished") return;

  const matchId = event.params.matchId;
  const teamIds = [after.teamAId, after.teamBId].filter(Boolean);
  if (teamIds.length === 0) return;

  const playerIds = new Set();
  for (const teamId of teamIds) {
    const teamSnap = await db.collection("teams").doc(teamId).get();
    if (!teamSnap.exists) continue;
    const roster = teamSnap.data().roster || {};
    for (const ids of Object.values(roster)) {
      if (Array.isArray(ids)) ids.forEach((id) => playerIds.add(id));
    }
  }

  for (const ids of chunk([...playerIds], 400)) {
    const batch = db.batch();
    ids.forEach((id) => {
      // set+merge rather than update — a stale roster id pointing at a
      // deleted player doc would otherwise throw NOT_FOUND and fail the
      // whole batch.
      batch.set(
          db.collection("players").doc(id),
          {gamesPlayed: FieldValue.increment(1), updatedAt: FieldValue.serverTimestamp()},
          {merge: true},
      );
    });
    await batch.commit();
  }

  const playedAt = after.startTime || Timestamp.now();
  if (after.teamAId) {
    await updateTeamStats(after.teamAId, after.teamBId, after.teamBName, after.scoreA, after.scoreB, matchId, playedAt);
  }
  if (after.teamBId) {
    await updateTeamStats(after.teamBId, after.teamAId, after.teamAName, after.scoreB, after.scoreA, matchId, playedAt);
  }
});

/** Updates one team's teamStatistics doc after a finished match — win/draw/
 * loss and goals derived straight from the final score, no separate input
 * needed. recentGames is capped at 10 (a read-modify-write since Firestore
 * has no "push and cap" primitive). */
async function updateTeamStats(teamId, opponentId, opponentName, ourScore, theirScore, matchId, playedAt) {
  const statsRef = db.collection("teamStatistics").doc(teamId);
  const statsSnap = await statsRef.get();
  const prevGames = statsSnap.exists ? (statsSnap.data().recentGames || []) : [];

  const isWin = ourScore > theirScore;
  const isDraw = ourScore === theirScore;

  const recentGames = [
    {
      gameId: matchId,
      opponentTeamId: opponentId || "",
      opponentTeamName: opponentName || "",
      teamScore: ourScore,
      opponentScore: theirScore,
      playedAt,
      isHomeGame: true,
    },
    ...prevGames,
  ].slice(0, 10);

  await statsRef.set({
    teamId,
    totalGamesPlayed: FieldValue.increment(1),
    wins: FieldValue.increment(isWin ? 1 : 0),
    draws: FieldValue.increment(isDraw ? 1 : 0),
    losses: FieldValue.increment(!isWin && !isDraw ? 1 : 0),
    goalsScored: FieldValue.increment(ourScore),
    goalsConceded: FieldValue.increment(theirScore),
    recentGames,
    lastGameDate: playedAt,
    updatedAt: FieldValue.serverTimestamp(),
  }, {merge: true});
}
