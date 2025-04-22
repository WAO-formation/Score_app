import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/system_admin/presentation/registrations/refree_registration.dart';
import 'package:wao_mobile/system_admin/presentation/registrations/team_registration.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/theme_data.dart';
import '../match_sheduling/models/match_models.dart';
import '../match_sheduling/models/match_models.dart' as registration;
import '../match_sheduling/models/match_models.dart' as match_models;
import 'judges_registration.dart';

class OfficialsAndTeams extends StatefulWidget {
  const OfficialsAndTeams({super.key});

  @override
  State<OfficialsAndTeams> createState() => _OfficialsAndTeamsState();
}

class _OfficialsAndTeamsState extends State<OfficialsAndTeams> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  List<TeamModel> _teams = [];
  List<RefereeModel> _referees = [];
  List<JudgeModel> _judges = [];
  List<LocationModel> _locations = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    /// Show title in AppBar when scrolled past 140 pixels
    if (_scrollController.offset > 140 && !_showAppBarTitle) {
      setState(() => _showAppBarTitle = true);
    } else if (_scrollController.offset <= 140 && _showAppBarTitle) {
      setState(() => _showAppBarTitle = false);
    }
  }

  /// Initialize sample data
  void _loadData() {
    // Load teams
    _teams = [
      TeamModel(
          id: 1,
          name: 'Team A',
          logo: 'assets/images/WAO_LOGO.jpg',
          ownerName: 'John Doe',
          email: 'teamA@example.com',
          phone: '123-456-7890'),
      TeamModel(
          id: 2,
          name: 'Team B',
          logo: 'assets/images/WAO_LOGO.jpg',
          ownerName: 'Jane Smith',
          email: 'teamB@example.com',
          phone: '234-567-8901'),
      TeamModel(
          id: 3,
          name: 'Team C',
          logo: 'assets/images/WAO_LOGO.jpg',
          ownerName: 'Mark Wilson',
          email: 'teamC@example.com',
          phone: '345-678-9012'),
      TeamModel(
          id: 4,
          name: 'Team D',
          logo: 'assets/images/WAO_LOGO.jpg',
          ownerName: 'Sarah Johnson',
          email: 'teamD@example.com',
          phone: '456-789-0123'),
    ];

    /// Load referees
    _referees = [
      RefereeModel(
          id: 1,
          name: 'John Smith',
          color: Colors.red,
          email: 'john@example.com',
          phone: '111-222-3333'),
      RefereeModel(
          id: 2,
          name: 'Sarah Lee',
          color: Colors.blue,
          email: 'sarah@example.com',
          phone: '222-333-4444'),
      RefereeModel(
          id: 3,
          name: 'Mike Brown',
          color: Colors.green,
          email: 'mike@example.com',
          phone: '333-444-5555'),
      RefereeModel(
          id: 4,
          name: 'Lisa Wong',
          color: Colors.yellow,
          email: 'lisa@example.com',
          phone: '444-555-6666'),
    ];

    /// Load judges
    _judges = [
      JudgeModel(
          id: 1,
          name: 'Judge One',
          email: 'judge1@example.com',
          phone: '111-111-1111'),
      JudgeModel(
          id: 2,
          name: 'Judge Two',
          email: 'judge2@example.com',
          phone: '222-222-2222'),
      JudgeModel(
          id: 3,
          name: 'Judge Three',
          email: 'judge3@example.com',
          phone: '333-333-3333'),
      JudgeModel(
          id: 4,
          name: 'Judge Four',
          email: 'judge4@example.com',
          phone: '444-444-4444'),
      JudgeModel(
          id: 5,
          name: 'Judge Five',
          email: 'judge5@example.com',
          phone: '555-555-5555'),
      JudgeModel(
          id: 6,
          name: 'Judge Six',
          email: 'judge6@example.com',
          phone: '666-666-6666'),
    ];

    /// Load locations
    _locations = [
      LocationModel(id: 1, name: 'WaoSphere Alpha'),
      LocationModel(id: 2, name: 'WaoSphere Beta'),
      LocationModel(id: 3, name: 'WaoSphere Gamma'),
    ];
  }

  void _deleteTeam(TeamModel team) {
    setState(() {
      _teams.removeWhere((t) => t.id == team.id);
    });
    _showSuccessMessage('Team deleted successfully');
  }

  void _deleteReferee(RefereeModel referee) {
    setState(() {
      _referees.removeWhere((r) => r.id == referee.id);
    });
    _showSuccessMessage('Referee deleted successfully');
  }

  void _deleteJudge(JudgeModel judge) {
    setState(() {
      _judges.removeWhere((j) => j.id == judge.id);
    });
    _showSuccessMessage('Judge deleted successfully');
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppStyles.informationText.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: _showAppBarTitle ? 2 : 0,
        scrolledUnderElevation: 0,
        backgroundColor:
            _showAppBarTitle ? lightColorScheme.secondary : Colors.transparent,
        title: AnimatedOpacity(
          opacity: _showAppBarTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: Text(
            'Officials & Teams',
            style: AppStyles.secondaryTitle.copyWith(
              color: lightColorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          /// Header section
          SliverToBoxAdapter(
            child: _buildHeader(),
          ),

          /// Teams Section
          _buildSectionHeader('Teams'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return TeamCard(
                  team: _teams[index],
                  onViewDetails: () => _showTeamDetails(_teams[index]),
                  onDelete: () => _showDeleteConfirmation(context, 'Team',
                      _teams[index].name, () => _deleteTeam(_teams[index])),
                );
              },
              childCount: _teams.length,
            ),
          ),

          /// Referees Section
          _buildSectionHeader('Referees'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return RefereeCard(
                  referee: _referees[index],
                  onViewDetails: () => _showRefereeDetails(_referees[index]),
                  onDelete: () => _showDeleteConfirmation(
                      context,
                      'Referee',
                      _referees[index].name,
                      () => _deleteReferee(_referees[index])),
                );
              },
              childCount: _referees.length,
            ),
          ),

          /// Judges Section
          _buildSectionHeader('Judges'),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return JudgeCard(
                  judge: _judges[index],
                  onViewDetails: () => _showJudgeDetails(_judges[index]),
                  onDelete: () => _showDeleteConfirmation(context, 'Judge',
                      _judges[index].name, () => _deleteJudge(_judges[index])),
                );
              },
              childCount: _judges.length,
            ),
          ),

          // Bottom spacing
          const SliverToBoxAdapter(
            child: SizedBox(height: 30),
          ),
        ],
      ),
    );
  }

  /// Show team details dialog
  void _showTeamDetails(TeamModel team) {
    showDialog(
      context: context,
      builder: (context) => _buildTeamDetailsDialog(context, team),
    );
  }

  /// Show referee details dialog
  void _showRefereeDetails(RefereeModel referee) {
    showDialog(
      context: context,
      builder: (context) => _buildRefereeDetailsDialog(context, referee),
    );
  }

  /// Show judge details dialog
  void _showJudgeDetails(JudgeModel judge) {
    showDialog(
      context: context,
      builder: (context) => _buildJudgeDetailsDialog(context, judge),
    );
  }

  /// Build team details dialog
  Widget _buildTeamDetailsDialog(BuildContext context, TeamModel team) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Team Details',
        style: AppStyles.secondaryTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey[200],
              backgroundImage: AssetImage(team.logo),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow(Icons.group, 'Team Name', team.name),
          _buildDetailRow(
              Icons.person, 'Owner', team.ownerName ?? 'Not specified'),
          _buildDetailRow(Icons.email, 'Email', team.email ?? 'Not specified'),
          _buildDetailRow(Icons.phone, 'Phone', team.phone ?? 'Not specified'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: lightColorScheme.secondary),
          ),
        ),
      ],
    );
  }

  /// Build referee details dialog
  Widget _buildRefereeDetailsDialog(
      BuildContext context, RefereeModel referee) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Referee Details',
        style: AppStyles.secondaryTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: referee.color,
              child: Text(
                referee.name.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow(Icons.person, 'Name', referee.name),
          _buildDetailRow(
              Icons.email, 'Email', referee.email ?? 'Not specified'),
          _buildDetailRow(
              Icons.phone, 'Phone', referee.phone ?? 'Not specified'),
          _buildDetailRow(Icons.color_lens, 'Color', ''),
          Center(
            child: Container(
              width: 50,
              height: 20,
              decoration: BoxDecoration(
                color: referee.color,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: lightColorScheme.secondary),
          ),
        ),
      ],
    );
  }

  /// Build judge details dialog
  Widget _buildJudgeDetailsDialog(BuildContext context, JudgeModel judge) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Judge Details',
        style: AppStyles.secondaryTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: lightColorScheme.primary,
              child: Text(
                judge.name.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildDetailRow(Icons.person, 'Name', judge.name),
          _buildDetailRow(Icons.email, 'Email', judge.email ?? 'Not specified'),
          _buildDetailRow(Icons.phone, 'Phone', judge.phone ?? 'Not specified'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: lightColorScheme.secondary),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: lightColorScheme.secondary, size: 20),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteConfirmation(
      BuildContext context, String type, String name, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Delete $type',
          style: AppStyles.secondaryTitle,
        ),
        content: Text('Are you sure you want to delete $name?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  /// Build section header
  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    color: lightColorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                switch (title) {
                  case 'Teams':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TeamRegistrationScreen(
                                  onTeamRegistered: (TeamModel team) {
                                    setState(() {
                                      _teams.add(team);
                                    });
                                  },
                                )));


                    break;
                  case 'Referees':
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RefereeRegistrationScreen(
                                  onRefereeRegistered: (RefereeModel referee) {
                                    setState(() {
                                      _referees.add(referee);
                                    });
                                  },
                                )));

                    break;
                  case 'Judges':

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Navigate to add judge screen')),
                    );
                    break;
                }
              },
              icon: const Icon(Icons.add, color: Colors.white, size: 16),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor: lightColorScheme.secondary,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build header widget
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 70, bottom: 30),
      decoration: BoxDecoration(
        color: lightColorScheme.secondary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: lightColorScheme.onPrimary.withOpacity(0.3),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              Icons.people_alt_rounded,
              size: 50,
              color: lightColorScheme.secondary,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Officials & Teams',
            style: TextStyle(
              color: lightColorScheme.onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Manage teams, referees, and judges',
            style: TextStyle(
              color: lightColorScheme.onPrimary.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

/// Team Card Widget
class TeamCard extends StatelessWidget {
  final TeamModel team;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const TeamCard({
    super.key,
    required this.team,
    required this.onViewDetails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Team Logo
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              backgroundImage: AssetImage(team.logo),
            ),
            const SizedBox(width: 15),

            // Team Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    team.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (team.ownerName != null)
                    Text(
                      'Owner: ${team.ownerName}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),

            // Actions
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: lightColorScheme.secondary,
                  ),
                  onPressed: onViewDetails,
                  tooltip: 'View details',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Delete team',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Referee Card Widget
class RefereeCard extends StatelessWidget {
  final RefereeModel referee;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const RefereeCard({
    super.key,
    required this.referee,
    required this.onViewDetails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Referee Avatar with Color
            CircleAvatar(
              radius: 30,
              backgroundColor: referee.color,
              child: Text(
                referee.name.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Referee Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    referee.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (referee.email != null)
                    Text(
                      referee.email!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),

            // Color indicator
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: referee.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),

            // Actions
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: lightColorScheme.secondary,
                  ),
                  onPressed: onViewDetails,
                  tooltip: 'View details',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Delete referee',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Judge Card Widget
class JudgeCard extends StatelessWidget {
  final JudgeModel judge;
  final VoidCallback onViewDetails;
  final VoidCallback onDelete;

  const JudgeCard({
    super.key,
    required this.judge,
    required this.onViewDetails,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Judge Avatar
            CircleAvatar(
              radius: 30,
              backgroundColor: lightColorScheme.primary,
              child: Text(
                judge.name.substring(0, 1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 15),

            // Judge Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judge.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (judge.email != null)
                    Text(
                      judge.email!,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),

            // Actions
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.info_outline,
                    color: lightColorScheme.secondary,
                  ),
                  onPressed: onViewDetails,
                  tooltip: 'View details',
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                  onPressed: onDelete,
                  tooltip: 'Delete judge',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
