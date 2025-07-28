
// providers/team_provider.dart
import 'package:flutter/cupertino.dart';

import '../Models/coach_team_players.dart';

class CoachTeamProvider extends ChangeNotifier {
  List<CoachPlayerModel> _players = [];

  // Maximum team limits
  static const int MAX_ACTIVE_PLAYERS = 7;
  static const int MAX_SUBSTITUTE_PLAYERS = 5;
  static const int MAX_TOTAL_PLAYERS = 12;

  List<CoachPlayerModel> get players => _players;

  // Get players by status
  List<CoachPlayerModel> get activePlayers =>
      _players.where((p) => p.status == CoachPlayerStatus.Active).toList();

  List<CoachPlayerModel> get substitutePlayers =>
      _players.where((p) => p.status == CoachPlayerStatus.Substitute).toList();

  // Get players grouped by role
  Map<WAORole, List<CoachPlayerModel>> get playersByRole {
    Map<WAORole, List<CoachPlayerModel>> grouped = {};
    for (var role in WAORole.values) {
      grouped[role] = _players.where((p) => p.role == role).toList();
    }
    return grouped;
  }

  // Check if we can add a player with specific status
  bool canAddPlayer(CoachPlayerStatus status) {
    if (_players.length >= MAX_TOTAL_PLAYERS) return false;

    if (status == CoachPlayerStatus.Active) {
      return activePlayers.length < MAX_ACTIVE_PLAYERS;
    } else {
      return substitutePlayers.length < MAX_SUBSTITUTE_PLAYERS;
    }
  }

  // Add a new player
  bool addPlayer(CoachPlayerModel player) {
    if (!canAddPlayer(player.status)) return false;

    _players.add(player);
    notifyListeners();
    return true;
  }

  // Update existing player
  void updatePlayer(String playerId, CoachPlayerModel updatedPlayer) {
    final index = _players.indexWhere((p) => p.id == playerId);
    if (index != -1) {
      _players[index] = updatedPlayer;
      notifyListeners();
    }
  }

  // Remove player
  void removePlayer(String playerId) {
    _players.removeWhere((p) => p.id == playerId);
    notifyListeners();
  }

  // Change player status (with validation)
  bool changeCoachPlayerStatus(String playerId, CoachPlayerStatus newStatus) {
    final playerIndex = _players.indexWhere((p) => p.id == playerId);
    if (playerIndex == -1) return false;

    final player = _players[playerIndex];
    if (player.status == newStatus) return true; // No change needed

    // Check if we can make this status change
    if (newStatus == CoachPlayerStatus.Active && activePlayers.length >= MAX_ACTIVE_PLAYERS) {
      return false;
    }
    if (newStatus == CoachPlayerStatus.Substitute && substitutePlayers.length >= MAX_SUBSTITUTE_PLAYERS) {
      return false;
    }

    _players[playerIndex] = player.copyWith(status: newStatus);
    notifyListeners();
    return true;
  }

  // Initialize with mock data
  void initializeMockData() {
    _players = [
      CoachPlayerModel(
        id: '1',
        name: 'Alex Thunder',
        role: WAORole.King,
        status: CoachPlayerStatus.Active,
        stats: {'matches': 25, 'wins': 18, 'experience': 'Expert'},
      ),
      CoachPlayerModel(
        id: '2',
        name: 'Sarah Swift',
        role: WAORole.Worker,
        status: CoachPlayerStatus.Active,
        stats: {'matches': 22, 'efficiency': 89, 'experience': 'Advanced'},
      ),
      CoachPlayerModel(
        id: '3',
        name: 'Mike Shield',
        role: WAORole.Protaque,
        status: CoachPlayerStatus.Active,
        stats: {'matches': 20, 'blocks': 145, 'experience': 'Advanced'},
      ),
      CoachPlayerModel(
        id: '4',
        name: 'Emma Blade',
        role: WAORole.Warrior,
        status: CoachPlayerStatus.Active,
        stats: {'matches': 28, 'attacks': 98, 'experience': 'Expert'},
      ),
      CoachPlayerModel(
        id: '5',
        name: 'Jake Helper',
        role: WAORole.Servitor,
        status: CoachPlayerStatus.Active,
        stats: {'matches': 15, 'assists': 67, 'experience': 'Intermediate'},
      ),
      CoachPlayerModel(
        id: '6',
        name: 'Luna Strike',
        role: WAORole.Antaque,
        status: CoachPlayerStatus.Active,
        stats: {'matches': 18, 'counters': 34, 'experience': 'Advanced'},
      ),
      CoachPlayerModel(
        id: '7',
        name: 'Ryan Noble',
        role: WAORole.Sacrificer,
        status: CoachPlayerStatus.Active,
        stats: {'matches': 12, 'sacrifices': 23, 'experience': 'Intermediate'},
      ),
      CoachPlayerModel(
        id: '8',
        name: 'Zoe Reserve',
        role: WAORole.Worker,
        status: CoachPlayerStatus.Substitute,
        stats: {'matches': 8, 'efficiency': 76, 'experience': 'Beginner'},
      ),
      CoachPlayerModel(
        id: '9',
        name: 'Tom Backup',
        role: WAORole.Warrior,
        status: CoachPlayerStatus.Substitute,
        stats: {'matches': 10, 'attacks': 45, 'experience': 'Intermediate'},
      ),
      CoachPlayerModel(
        id: '10',
        name: 'Lisa Support',
        role: WAORole.Servitor,
        status: CoachPlayerStatus.Substitute,
        stats: {'matches': 6, 'assists': 29, 'experience': 'Beginner'},
      ),
    ];
    notifyListeners();
  }

}
