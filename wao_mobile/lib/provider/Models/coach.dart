
// Coach data model
class CoachModel {
  String id;
  String name;
  String teamName;
  String role;
  String email;
  String phoneNumber;
  String? profileImageUrl;
  int activePlayers;
  int substitutePlayers;
  int totalGamesCoached;
  int wins;
  int losses;
  int teamRank;
  bool notificationsEnabled;
  bool isDarkTheme;

  CoachModel({
    required this.id,
    required this.name,
    required this.teamName,
    required this.role,
    required this.email,
    required this.phoneNumber,
    this.profileImageUrl,
    required this.activePlayers,
    required this.substitutePlayers,
    required this.totalGamesCoached,
    required this.wins,
    required this.losses,
    required this.teamRank,
    this.notificationsEnabled = true,
    this.isDarkTheme = false,
  });

  // Calculate win percentage
  double get winPercentage {
    if (totalGamesCoached == 0) return 0.0;
    return (wins / totalGamesCoached) * 100;
  }
}
