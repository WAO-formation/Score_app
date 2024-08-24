class teamproperties{
  final String teamName;
  final String image;


  teamproperties( {
    required this.teamName,
    required this.image,
  });
}

final List<teamproperties> teams = [

  teamproperties(
      teamName:'Team UI',
      image: 'assets/images/officiate.jpg',

  ),

  teamproperties(
    teamName:'Team FK',
    image: 'assets/images/teams.jpg',

  ),

  teamproperties(
    teamName:'Team GH',
    image: 'assets/images/officiate.jpg',

  ),

  teamproperties(
    teamName:'Team WQ',
    image: 'assets/images/teams.jpg',

  ),

];
