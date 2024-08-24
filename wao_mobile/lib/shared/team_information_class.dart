class TeamInformation{
  final String TeamName;
  final String image;
  final int points;
  final int games;
  final int goals;

  TeamInformation({
    required this.points,
    required this.TeamName,
    required this.image,
    required this.games,
    required this.goals,

  });
}

final List<TeamInformation> topTeam = [

  TeamInformation(
      TeamName:'Team A',
      image: 'assets/images/teams.jpg',
    points: 5,
    games: 8,
    goals: 15,
  ),

  TeamInformation(
      TeamName:'Team G',
      image: 'assets/images/officiate.jpg',
    points: 20,
    games: 6,
    goals: 60,
  ),

  TeamInformation(
      TeamName:'Team K',
      image: 'assets/images/teams.jpg',
      points: 10,
    games: 4,
    goals: 30,

  ),

  TeamInformation(
      TeamName:'Team U',
      image: 'assets/images/officiate.jpg',
    points: 15,
    games: 6,
    goals: 50,
  ),
];
