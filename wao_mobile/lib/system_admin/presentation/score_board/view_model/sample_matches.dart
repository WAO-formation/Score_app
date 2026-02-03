import 'dart:math';
import '../../Teams/model/team_model.dart';
import '../model/live_score.dart';


class SampleLiveMatchGenerator {
  static final Random _random = Random();

  // Create a sample live match with realistic Model
  static LiveMatch createSampleLiveMatch({
    String? matchId,
    Teams? teamA,
    Teams? teamB,
    MatchStatus? status,
    Quarter? quarter,
    Duration? currentTime,
  }) {
    final teams = Teams.getSampleTeams();
    final selectedTeamA = teamA ?? teams[_random.nextInt(teams.length)];
    var availableTeams = teams.where((t) => t.id != selectedTeamA.id).toList();
    final selectedTeamB = teamB ?? availableTeams[_random.nextInt(availableTeams.length)];

    final matchStatus = status ?? _getRandomMatchStatus();
    final currentQuarter = quarter ?? _getRandomQuarter();
    final elapsedTime = currentTime ?? _getRandomElapsedTime(currentQuarter);

    return LiveMatch(
      id: matchId ?? 'live_${DateTime.now().millisecondsSinceEpoch}',
      title: '${selectedTeamA.name} vs ${selectedTeamB.name}',
      teamA: selectedTeamA,
      teamB: selectedTeamB,
      status: matchStatus,
      startTime: DateTime.now().subtract(Duration(minutes: elapsedTime.inMinutes + 5)),
      endTime: matchStatus == MatchStatus.ended ? DateTime.now() : null,
      currentQuarter: currentQuarter,
      currentTime: elapsedTime,
      teamAScore: _generateRealisticScore(selectedTeamA.id, currentQuarter, elapsedTime),
      teamBScore: _generateRealisticScore(selectedTeamB.id, currentQuarter, elapsedTime),
      events: _generateMatchEvents(selectedTeamA, selectedTeamB, currentQuarter, elapsedTime),
      fouls: _generatePlayerFouls(selectedTeamA, selectedTeamB, currentQuarter, elapsedTime),
    );
  }

  // Generate multiple sample matches
  static List<LiveMatch> createMultipleSampleMatches(int count) {
    List<LiveMatch> matches = [];
    final teams = Teams.getSampleTeams();

    for (int i = 0; i < count; i++) {
      // Ensure we don't have duplicate team pairings
      final teamA = teams[i % teams.length];
      final teamB = teams[(i + 1) % teams.length];

      matches.add(createSampleLiveMatch(
        matchId: 'sample_match_${i + 1}',
        teamA: teamA,
        teamB: teamB,
        status: i == 0 ? MatchStatus.live : _getRandomMatchStatus(),
      ));
    }

    return matches;
  }

  // Create a specific live match scenario
  static LiveMatch createLiveMatchScenario({
    required String scenario,
  }) {
    final teams = Teams.getSampleTeams();

    switch (scenario.toLowerCase()) {
      case 'close_game':
        return _createCloseGameScenario(teams[0], teams[1]);
      case 'blowout':
        return _createBlowoutScenario(teams[0], teams[1]);
      case 'overtime':
        return _createOvertimeScenario(teams[2], teams[3]);
      case 'just_started':
        return _createJustStartedScenario(teams[0], teams[2]);
      case 'final_minutes':
        return _createFinalMinutesScenario(teams[1], teams[3]);
      default:
        return createSampleLiveMatch();
    }
  }

  // Helper methods for different scenarios
  static LiveMatch _createCloseGameScenario(Teams teamA, Teams teamB) {
    return LiveMatch(
      id: 'close_game_${DateTime.now().millisecondsSinceEpoch}',
      title: '${teamA.name} vs ${teamB.name} - Close Match',
      teamA: teamA,
      teamB: teamB,
      status: MatchStatus.live,
      startTime: DateTime.now().subtract(const Duration(minutes: 45)),
      currentQuarter: Quarter.fourth,
      currentTime: const Duration(minutes: 10, seconds: 30),
      teamAScore: LiveScore(
        teamId: teamA.id,
        kingdom: 88.5,
        workout: 91.2,
        goalpost: 85.7,
        judges: 89.1,
        bounces: 45,
        workoutSeconds: 1200,
        goals: 8,
        sacrifices3pt: 2,
        sacrifices33pt: 0,
        goalSettings: 3,
      ),
      teamBScore: LiveScore(
        teamId: teamB.id,
        kingdom: 87.8,
        workout: 90.5,
        goalpost: 86.2,
        judges: 89.8,
        bounces: 43,
        workoutSeconds: 1180,
        goals: 8,
        sacrifices3pt: 1,
        sacrifices33pt: 1,
        goalSettings: 2,
      ),
      events: _generateIntenseMatchEvents(teamA, teamB),
      fouls: _generatePlayerFouls(teamA, teamB, Quarter.fourth, const Duration(minutes: 10)),
    );
  }

  static LiveMatch _createBlowoutScenario(Teams teamA, Teams teamB) {
    return LiveMatch(
      id: 'blowout_${DateTime.now().millisecondsSinceEpoch}',
      title: '${teamA.name} vs ${teamB.name} - Dominant Performance',
      teamA: teamA,
      teamB: teamB,
      status: MatchStatus.live,
      startTime: DateTime.now().subtract(const Duration(minutes: 35)),
      currentQuarter: Quarter.third,
      currentTime: const Duration(minutes: 8, seconds: 15),
      teamAScore: LiveScore(
        teamId: teamA.id,
        kingdom: 95.2,
        workout: 94.8,
        goalpost: 92.1,
        judges: 93.5,
        bounces: 58,
        workoutSeconds: 1450,
        goals: 12,
        sacrifices3pt: 4,
        sacrifices33pt: 1,
        goalSettings: 5,
      ),
      teamBScore: LiveScore(
        teamId: teamB.id,
        kingdom: 72.3,
        workout: 75.1,
        goalpost: 68.9,
        judges: 71.7,
        bounces: 28,
        workoutSeconds: 890,
        goals: 4,
        sacrifices3pt: 0,
        sacrifices33pt: 0,
        goalSettings: 1,
      ),
      events: _generateDominantMatchEvents(teamA, teamB),
      fouls: _generatePlayerFouls(teamA, teamB, Quarter.third, const Duration(minutes: 8)),
    );
  }

  static LiveMatch _createOvertimeScenario(Teams teamA, Teams teamB) {
    return LiveMatch(
      id: 'overtime_${DateTime.now().millisecondsSinceEpoch}',
      title: '${teamA.name} vs ${teamB.name} - Overtime Thriller',
      teamA: teamA,
      teamB: teamB,
      status: MatchStatus.live,
      startTime: DateTime.now().subtract(const Duration(minutes: 65)),
      currentQuarter: Quarter.extraTime,
      currentTime: const Duration(minutes: 3, seconds: 45),
      teamAScore: LiveScore(
        teamId: teamA.id,
        kingdom: 89.7,
        workout: 92.3,
        goalpost: 87.8,
        judges: 90.2,
        bounces: 48,
        workoutSeconds: 1320,
        goals: 9,
        sacrifices3pt: 2,
        sacrifices33pt: 1,
        goalSettings: 4,
      ),
      teamBScore: LiveScore(
        teamId: teamB.id,
        kingdom: 89.1,
        workout: 91.8,
        goalpost: 88.3,
        judges: 90.8,
        bounces: 47,
        workoutSeconds: 1305,
        goals: 9,
        sacrifices3pt: 3,
        sacrifices33pt: 0,
        goalSettings: 3,
      ),
      events: _generateOvertimeEvents(teamA, teamB),
      fouls: _generatePlayerFouls(teamA, teamB, Quarter.extraTime, const Duration(minutes: 3)),
    );
  }

  static LiveMatch _createJustStartedScenario(Teams teamA, Teams teamB) {
    return LiveMatch(
      id: 'just_started_${DateTime.now().millisecondsSinceEpoch}',
      title: '${teamA.name} vs ${teamB.name} - Game Just Started',
      teamA: teamA,
      teamB: teamB,
      status: MatchStatus.live,
      startTime: DateTime.now().subtract(const Duration(minutes: 2)),
      currentQuarter: Quarter.first,
      currentTime: const Duration(minutes: 1, seconds: 45),
      teamAScore: LiveScore.empty(teamA.id).copyWith(
        bounces: 3,
        workoutSeconds: 45,
        goals: 0,
      ),
      teamBScore: LiveScore.empty(teamB.id).copyWith(
        bounces: 2,
        workoutSeconds: 38,
        goals: 0,
      ),
      events: [
        MatchEvent(
          id: 'event_start_1',
          type: EventType.skillShow,
          teamId: teamA.id,
          timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
          quarter: Quarter.first,
          matchTime: const Duration(seconds: 45),
          description: 'Opening skill demonstration',
        ),
      ],
      fouls: [],
    );
  }

  static LiveMatch _createFinalMinutesScenario(Teams teamA, Teams teamB) {
    return LiveMatch(
      id: 'final_minutes_${DateTime.now().millisecondsSinceEpoch}',
      title: '${teamA.name} vs ${teamB.name} - Final Minutes',
      teamA: teamA,
      teamB: teamB,
      status: MatchStatus.live,
      startTime: DateTime.now().subtract(const Duration(minutes: 58)),
      currentQuarter: Quarter.fourth,
      currentTime: const Duration(minutes: 11, seconds: 30),
      teamAScore: LiveScore(
        teamId: teamA.id,
        kingdom: 86.4,
        workout: 89.7,
        goalpost: 83.2,
        judges: 87.9,
        bounces: 42,
        workoutSeconds: 1150,
        goals: 7,
        sacrifices3pt: 1,
        sacrifices33pt: 0,
        goalSettings: 2,
      ),
      teamBScore: LiveScore(
        teamId: teamB.id,
        kingdom: 88.1,
        workout: 90.3,
        goalpost: 85.6,
        judges: 88.7,
        bounces: 44,
        workoutSeconds: 1190,
        goals: 8,
        sacrifices3pt: 2,
        sacrifices33pt: 0,
        goalSettings: 3,
      ),
      events: _generateFinalMinutesEvents(teamA, teamB),
      fouls: _generatePlayerFouls(teamA, teamB, Quarter.fourth, const Duration(minutes: 11)),
    );
  }

  // Helper methods for generating realistic Model
  static MatchStatus _getRandomMatchStatus() {
    final statuses = [MatchStatus.live, MatchStatus.paused, MatchStatus.ended];
    return statuses[_random.nextInt(statuses.length)];
  }

  static Quarter _getRandomQuarter() {
    final quarters = [Quarter.first, Quarter.second, Quarter.third, Quarter.fourth];
    return quarters[_random.nextInt(quarters.length)];
  }

  static Duration _getRandomElapsedTime(Quarter quarter) {
    switch (quarter) {
      case Quarter.first:
      case Quarter.second:
        return Duration(minutes: _random.nextInt(17), seconds: _random.nextInt(60));
      case Quarter.third:
      case Quarter.fourth:
        return Duration(minutes: _random.nextInt(13), seconds: _random.nextInt(60));
      case Quarter.extraTime:
        return Duration(minutes: _random.nextInt(10), seconds: _random.nextInt(60));
    }
  }

  static LiveScore _generateRealisticScore(String teamId, Quarter quarter, Duration elapsedTime) {
    final progressFactor = _getProgressFactor(quarter, elapsedTime);

    final bounces = (progressFactor * 50 + _random.nextInt(20)).round();
    final workoutSeconds = (progressFactor * 1500 + _random.nextInt(300)).round();
    final goals = (progressFactor * 10 + _random.nextInt(5)).round();
    final sacrifices3pt = _random.nextInt(3);
    final sacrifices33pt = _random.nextInt(2);
    final goalSettings = (progressFactor * 5 + _random.nextInt(3)).round();

    return LiveScore(
      teamId: teamId,
      kingdom: ScoreCalculator.calculateKingdomScore(bounces),
      workout: ScoreCalculator.calculateWorkoutScore(workoutSeconds),
      goalpost: ScoreCalculator.calculateGoalpostScore(
        goals: goals,
        sacrifices3pt: sacrifices3pt,
        sacrifices33pt: sacrifices33pt,
        goalSettings: goalSettings,
      ),
      judges: 70.0 + _random.nextDouble() * 25, // Random judges score
      bounces: bounces,
      workoutSeconds: workoutSeconds,
      goals: goals,
      sacrifices3pt: sacrifices3pt,
      sacrifices33pt: sacrifices33pt,
      goalSettings: goalSettings,
    );
  }

  static double _getProgressFactor(Quarter quarter, Duration elapsedTime) {
    double quarterProgress = 0.0;

    switch (quarter) {
      case Quarter.first:
        quarterProgress = 0.25 * (elapsedTime.inMinutes / 17.0);
        break;
      case Quarter.second:
        quarterProgress = 0.25 + 0.25 * (elapsedTime.inMinutes / 17.0);
        break;
      case Quarter.third:
        quarterProgress = 0.5 + 0.25 * (elapsedTime.inMinutes / 13.0);
        break;
      case Quarter.fourth:
        quarterProgress = 0.75 + 0.25 * (elapsedTime.inMinutes / 13.0);
        break;
      case Quarter.extraTime:
        quarterProgress = 1.0 + 0.1 * (elapsedTime.inMinutes / 10.0);
        break;
    }

    return quarterProgress.clamp(0.0, 1.1);
  }

  // Generate realistic match events
  static List<MatchEvent> _generateMatchEvents(Teams teamA, Teams teamB, Quarter quarter, Duration elapsedTime) {
    List<MatchEvent> events = [];
    final eventCount = (elapsedTime.inMinutes / 3).round() + _random.nextInt(3);

    for (int i = 0; i < eventCount; i++) {
      final eventTime = Duration(
        minutes: _random.nextInt(elapsedTime.inMinutes + 1),
        seconds: _random.nextInt(60),
      );

      final isTeamA = _random.nextBool();
      final team = isTeamA ? teamA : teamB;
      final eventType = _getRandomEventType();

      events.add(MatchEvent(
        id: 'event_${DateTime.now().millisecondsSinceEpoch}_$i',
        type: eventType,
        teamId: team.id,
        timestamp: DateTime.now().subtract(elapsedTime - eventTime),
        quarter: quarter,
        matchTime: eventTime,
        description: _getEventDescription(eventType, team.name),
      ));
    }

    return events..sort((a, b) => a.matchTime.compareTo(b.matchTime));
  }

  static EventType _getRandomEventType() {
    final types = [
      EventType.goal,
      EventType.bounce,
      EventType.skillShow,
      EventType.sacrifice,
      EventType.goalSetting,
      EventType.foul,
    ];
    return types[_random.nextInt(types.length)];
  }

  static String _getEventDescription(EventType type, String teamName) {
    switch (type) {
      case EventType.goal:
        return '$teamName scores a goal!';
      case EventType.bounce:
        return '$teamName executes a perfect bounce';
      case EventType.skillShow:
        return '$teamName demonstrates exceptional skill';
      case EventType.sacrifice:
        return '$teamName makes a strategic sacrifice';
      case EventType.goalSetting:
        return '$teamName sets up for goal attempt';
      case EventType.foul:
        return '$teamName commits a foul';
      default:
        return '$teamName event';
    }
  }

  // Generate specific event scenarios
  static List<MatchEvent> _generateIntenseMatchEvents(Teams teamA, Teams teamB) {
    return [
      MatchEvent(
        id: 'intense_1',
        type: EventType.goal,
        teamId: teamA.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
        quarter: Quarter.fourth,
        matchTime: const Duration(minutes: 2, seconds: 30),
        description: '${teamA.name} ties the game with a crucial goal!',
      ),
      MatchEvent(
        id: 'intense_2',
        type: EventType.goal,
        teamId: teamB.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        quarter: Quarter.fourth,
        matchTime: const Duration(minutes: 5, seconds: 15),
        description: '${teamB.name} responds immediately with a goal!',
      ),
      MatchEvent(
        id: 'intense_3',
        type: EventType.foul,
        teamId: teamA.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        quarter: Quarter.fourth,
        matchTime: const Duration(minutes: 8, seconds: 45),
        description: '${teamA.name} commits a crucial foul under pressure',
      ),
    ];
  }

  static List<MatchEvent> _generateDominantMatchEvents(Teams teamA, Teams teamB) {
    return [
      MatchEvent(
        id: 'dominant_1',
        type: EventType.goal,
        teamId: teamA.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
        quarter: Quarter.first,
        matchTime: const Duration(minutes: 5),
        description: '${teamA.name} opens scoring early',
      ),
      MatchEvent(
        id: 'dominant_2',
        type: EventType.goal,
        teamId: teamA.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
        quarter: Quarter.second,
        matchTime: const Duration(minutes: 3),
        description: '${teamA.name} extends lead with another goal',
      ),
      MatchEvent(
        id: 'dominant_3',
        type: EventType.skillShow,
        teamId: teamA.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        quarter: Quarter.third,
        matchTime: const Duration(minutes: 2),
        description: '${teamA.name} showcases dominant skill display',
      ),
    ];
  }

  static List<MatchEvent> _generateOvertimeEvents(Teams teamA, Teams teamB) {
    return [
      MatchEvent(
        id: 'overtime_1',
        type: EventType.goal,
        teamId: teamA.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
        quarter: Quarter.extraTime,
        matchTime: const Duration(minutes: 1, seconds: 30),
        description: '${teamA.name} breaks the deadlock in overtime!',
      ),
      MatchEvent(
        id: 'overtime_2',
        type: EventType.goal,
        teamId: teamB.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        quarter: Quarter.extraTime,
        matchTime: const Duration(minutes: 2, seconds: 45),
        description: '${teamB.name} equalizes in dramatic fashion!',
      ),
    ];
  }

  static List<MatchEvent> _generateFinalMinutesEvents(Teams teamA, Teams teamB) {
    return [
      MatchEvent(
        id: 'final_1',
        type: EventType.timeout,
        teamId: teamB.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
        quarter: Quarter.fourth,
        matchTime: const Duration(minutes: 8, seconds: 30),
        description: '${teamB.name} calls timeout to strategize',
      ),
      MatchEvent(
        id: 'final_2',
        type: EventType.goal,
        teamId: teamB.id,
        timestamp: DateTime.now().subtract(const Duration(minutes: 1)),
        quarter: Quarter.fourth,
        matchTime: const Duration(minutes: 10, seconds: 45),
        description: '${teamB.name} takes the lead in final minutes!',
      ),
    ];
  }

  static List<PlayerFoul> _generatePlayerFouls(Teams teamA, Teams teamB, Quarter quarter, Duration elapsedTime) {
    List<PlayerFoul> fouls = [];
    final foulCount = _random.nextInt(3) + 1;

    for (int i = 0; i < foulCount; i++) {
      final isTeamA = _random.nextBool();
      final team = isTeamA ? teamA : teamB;
      final players = team.players;

      if (players.isNotEmpty) {
        final player = players[_random.nextInt(players.length)];
        final foulTime = Duration(
          minutes: _random.nextInt(elapsedTime.inMinutes + 1),
          seconds: _random.nextInt(60),
        );

        fouls.add(PlayerFoul(
          id: 'foul_${DateTime.now().millisecondsSinceEpoch}_$i',
          playerId: player.id,
          playerName: player.name,
          teamId: team.id,
          foulType: _getRandomFoulType(),
          timestamp: DateTime.now().subtract(elapsedTime - foulTime),
          quarter: quarter,
          matchTime: foulTime,
          description: '${player.name} commits ${_getRandomFoulType()}',
          isCardGiven: _random.nextBool(),
          cardType: _random.nextBool() ? 'yellow' : null,
        ));
      }
    }

    return fouls;
  }

  static String _getRandomFoulType() {
    final fouls = ['Technical Foul', 'Personal Foul', 'Unsportsmanlike Conduct', 'Delay of Game'];
    return fouls[_random.nextInt(fouls.length)];
  }
}

// Usage example
void main() async {
  // Create a single sample live match
  LiveMatch sampleMatch = SampleLiveMatchGenerator.createSampleLiveMatch();
  print('Sample Match: ${sampleMatch.displayTitle}');
  print('Status: ${sampleMatch.status}');
  print('Quarter: ${sampleMatch.quarterDisplayString}');
  print('Time: ${sampleMatch.timeDisplayString}');
  print('Score: ${sampleMatch.teamAScore.totalScore.toStringAsFixed(1)} - ${sampleMatch.teamBScore.totalScore.toStringAsFixed(1)}');
  print('Events: ${sampleMatch.events.length}');
  print('');

  // Create multiple sample matches
  List<LiveMatch> multipleMatches = SampleLiveMatchGenerator.createMultipleSampleMatches(4);
  print('Generated ${multipleMatches.length} sample matches:');
  for (var match in multipleMatches) {
    print('- ${match.displayTitle} (${match.status})');
  }
  print('');

  // Create specific scenarios
  LiveMatch closeGame = SampleLiveMatchGenerator.createLiveMatchScenario(scenario: 'close_game');
  print('Close Game Scenario:');
  print('${closeGame.displayTitle}');
  print('Score: ${closeGame.teamAScore.totalScore.toStringAsFixed(1)} - ${closeGame.teamBScore.totalScore.toStringAsFixed(1)}');
  print('Quarter: ${closeGame.quarterDisplayString}');
  print('');

  LiveMatch overtime = SampleLiveMatchGenerator.createLiveMatchScenario(scenario: 'overtime');
  print('Overtime Scenario:');
  print('${overtime.displayTitle}');
  print('Score: ${overtime.teamAScore.totalScore.toStringAsFixed(1)} - ${overtime.teamBScore.totalScore.toStringAsFixed(1)}');
  print('Quarter: ${overtime.quarterDisplayString}');
  print('Time: ${overtime.timeDisplayString}');
}