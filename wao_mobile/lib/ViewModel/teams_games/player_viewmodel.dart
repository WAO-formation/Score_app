import 'package:flutter/material.dart';

import '../../Model/teams_games/team/wao_player.dart';
import '../../core/services/match_team_service/player_service.dart';

/// Provider-facing wrapper around PlayerService, mirroring the
/// MatchViewModel/TeamViewModel pattern. Exists so Views that only need
/// player data (a roster tab, a player-lookup widget) can go through the
/// same Provider-mediated path everything else already uses instead of
/// instantiating PlayerService directly — see MOBILE_ARCHITECTURE_REVIEW.md
/// finding #4 for why that inconsistency mattered.
///
/// This file previously contained a second, divergent copy of PlayerService
/// itself (not a ViewModel at all) that TeamService was accidentally
/// importing instead of the real one in core/services — see finding #4 in
/// MOBILE_ARCHITECTURE_REVIEW.md. That duplicate has been removed; every
/// caller now points at the single real PlayerService.
class PlayerViewModel extends ChangeNotifier {
  PlayerViewModel({PlayerService? playerService}) : _playerService = playerService ?? PlayerService();

  final PlayerService _playerService;

  Stream<List<WaoPlayer>> getPlayersByTeam(String teamId) => _playerService.getPlayersByTeam(teamId);

  Stream<List<WaoPlayer>> getAvailablePlayers() => _playerService.getAvailablePlayers();

  Future<WaoPlayer?> getPlayerById(String playerId) => _playerService.getPlayerById(playerId);

  Future<WaoPlayer?> getPlayerByEmail(String email) => _playerService.getPlayerByEmail(email);

  Future<String> createPlayer(WaoPlayer player) async {
    final id = await _playerService.createPlayer(player);
    notifyListeners();
    return id;
  }

  Future<void> updatePlayerStatus(String playerId, PlayerStatus status) async {
    await _playerService.updatePlayerStatus(playerId, status);
    notifyListeners();
  }

  Future<void> updatePlayerRole(String playerId, PlayerRole role) async {
    await _playerService.updatePlayerRole(playerId, role);
    notifyListeners();
  }
}
