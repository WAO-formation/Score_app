enum GameType {
  friendly,
  league,
  tournament,
}

enum GameStage {
  groupStage,
  roundOf16,
  quarterFinal,
  semiFinal,
  finalStage,
  none,
}


class GameModel {
  final String opponentName;
  final DateTime gameDateTime;
  final String venue;
  final GameType gameType;
  final GameStage gameStage;

  GameModel({
    required this.opponentName,
    required this.gameDateTime,
    required this.venue,
    required this.gameType,
    this.gameStage = GameStage.none,
  });
}


final List<GameModel> upcomingGames = [
  GameModel(
    opponentName: 'Eagle Warriors',
    gameDateTime: DateTime(2025, 8, 3, 15, 30),
    venue: 'Accra Sports Stadium',
    gameType: GameType.league,
  ),
  GameModel(
    opponentName: 'Sky Hawks',
    gameDateTime: DateTime(2025, 8, 5, 17, 00),
    venue: 'Cape Coast Arena',
    gameType: GameType.friendly,
  ),
  GameModel(
    opponentName: 'Black Arrows',
    gameDateTime: DateTime(2025, 8, 10, 16, 00),
    venue: 'Kumasi Central',
    gameType: GameType.tournament,
    gameStage: GameStage.quarterFinal,
  ),
];
