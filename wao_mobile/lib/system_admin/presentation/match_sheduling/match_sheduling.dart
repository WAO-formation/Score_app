
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/system_admin/presentation/match_sheduling/widgets/create_match.dart';
import 'package:wao_mobile/system_admin/presentation/match_sheduling/widgets/edit_match.dart';
import '../../../shared/custom_text.dart';
import '../../../shared/theme_data.dart';
import 'models/match_models.dart';


class MatchManagement extends StatefulWidget {
  const MatchManagement({super.key});

  @override
  State<MatchManagement> createState() => _MatchManagementState();
}

class _MatchManagementState extends State<MatchManagement> {
  final ScrollController _scrollController = ScrollController();
  bool _showAppBarTitle = false;

  /// Lists of Model
  List<MatchModel> _matches = [];
  final List<TeamModel> _teams = [];
  final List<RefereeModel> _referees = [];
  final List<JudgeModel> _judges = [];
  final List<LocationModel> _locations = [];

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

  /// Initialize sample Model
  void _loadData() {
    // Load teams
    _teams.addAll([
      TeamModel(id: 1, name: 'Team A', logo: 'assets/images/WAO_LOGO.jpg'),
      TeamModel(id: 2, name: 'Team B', logo: 'assets/images/WAO_LOGO.jpg'),
      TeamModel(id: 3, name: 'Team C', logo: 'assets/images/WAO_LOGO.jpg'),
      TeamModel(id: 4, name: 'Team D', logo: 'assets/images/WAO_LOGO.jpg'),
    ]);

    /// Load referees
    _referees.addAll([
      RefereeModel(id: 1, name: 'John Smith', color: Colors.red),
      RefereeModel(id: 2, name: 'Sarah Lee', color: Colors.blue),
      RefereeModel(id: 3, name: 'Mike Brown', color: Colors.green),
      RefereeModel(id: 4, name: 'Lisa Wong', color: Colors.yellow),
    ]);

    /// Load judges
    _judges.addAll([
      JudgeModel(id: 1, name: 'Judge One'),
      JudgeModel(id: 2, name: 'Judge Two'),
      JudgeModel(id: 3, name: 'Judge Three'),
      JudgeModel(id: 4, name: 'Judge Four'),
      JudgeModel(id: 5, name: 'Judge Five'),
      JudgeModel(id: 6, name: 'Judge Six'),
    ]);

    /// Load locations
    _locations.addAll([
      LocationModel(id: 1, name: 'WaoSphere Alpha',),
      LocationModel(id: 2, name: 'WaoSphere Beta',),
      LocationModel(id: 3, name: 'WaoSphere Gamma',),
    ]);

    /// Load matches
    _matches = [
      MatchModel(
          id: 1,
          date: DateTime.now().add(const Duration(days: 2)),
          time: '14:00',
          location: _locations[0],
          team1: _teams[0],
          team2: _teams[1],
          referees: [_referees[0], _referees[1]],
          judges: _judges.sublist(0, 6),
          status: MatchStatus.upcoming
      ),
      MatchModel(
          id: 2,
          date: DateTime.now().add(const Duration(days: 5)),
          time: '16:30',
          location: _locations[1],
          team1: _teams[2],
          team2: _teams[3],
          referees: [_referees[2], _referees[3]],
          judges: _judges.sublist(0, 6),
          status: MatchStatus.upcoming
      ),
      MatchModel(
          id: 3,
          date: DateTime.now().subtract(const Duration(days: 1)),
          time: '10:00',
          location: _locations[2],
          team1: _teams[0],
          team2: _teams[2],
          referees: [_referees[0], _referees[2]],
          judges: _judges.sublist(0, 6),
          status: MatchStatus.completed
      ),
    ];
  }

  /// Add match to the list
  void _addMatch(MatchModel match) {
    setState(() {
      _matches.add(match);
    });

    /// Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Match scheduled successfully!', style: AppStyles.informationText.copyWith(color: Colors.white),),
        backgroundColor: Colors.green[600],
      ),
    );
  }

  /// Remove match from the list
  void _removeMatch(MatchModel match) {
    setState(() {
      _matches.removeWhere((m) => m.id == match.id);
    });
  }

  // Edit match
  void _editMatch(MatchModel match) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditMatchScreen(match: match),
      ),
    ).then((value) {
      if (value == true) {
        /// Refresh list if match was updated
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: _showAppBarTitle ? 2 : 0,
        scrolledUnderElevation: 0,
        backgroundColor: _showAppBarTitle ? lightColorScheme.secondary : Colors.transparent,
        title: AnimatedOpacity(
          opacity: _showAppBarTitle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 250),
          child: Text(
            'Match Management',
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

          /// Section title for Create Match
          _buildSectionHeader('Create New Match'),

          /// Create Match Form
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
               child: CreateMatchForm(
                 teams: _teams,
                 referees: _referees,
                 judges: _judges,
                locations: _locations,
                onMatchCreated: _addMatch,
               ),
            ),
          ),

          /// Section title for Scheduled Matches
          _buildSectionHeader('Scheduled Matches'),

          /// List of matches
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return MatchCard(
                  match: _matches[index],
                  onEdit: () => _editMatch(_matches[index]),
                  onCancel: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildCancelDialog(context, _matches[index]),
                    );
                  },
                );
              },
              childCount: _matches.length,
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

  /// Build section header
  Widget _buildSectionHeader(String title) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 15),
        child: Row(
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
      ),
    );
  }

  /// Build header widget
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 70,
          bottom: 30
      ),
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
              Icons.sports_basketball_rounded,
              size: 50,
              color: lightColorScheme.secondary,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Match Management',
            style: TextStyle(
              color: lightColorScheme.onPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Create and manage WAO matches',
            style: TextStyle(
              color: lightColorScheme.onPrimary.withOpacity(0.8),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  /// Build cancel confirmation dialog
  Widget _buildCancelDialog(BuildContext context, MatchModel match) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        'Cancel Match',
        style: AppStyles.secondaryTitle,
      ),
      content: const Text('Are you sure you want to cancel this match?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'No',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            _removeMatch(match);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            'Yes, Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final VoidCallback onEdit;
  final VoidCallback onCancel;

  const MatchCard({
    super.key,
    required this.match,
    required this.onEdit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, left: 20, right: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Match header with date and status
          _buildHeader(context),

          // Match details
          _buildDetails(context),

          /// Actions
          if (match.status == MatchStatus.upcoming)
            _buildActions(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: lightColorScheme.secondary.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.event,
                size: 18,
                color: lightColorScheme.secondary,
              ),
              const SizedBox(width: 5),
              Text(
                DateFormat('MMM dd, yyyy').format(match.date),
                style: TextStyle(
                  color: lightColorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.access_time,
                size: 18,
                color: lightColorScheme.secondary,
              ),
              const SizedBox(width: 5),
              Text(
                match.time,
                style: TextStyle(
                  color: lightColorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          _buildStatusBadge(),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color bgColor;
    Color textColor;
    String statusText;

    switch (match.status) {
      case MatchStatus.upcoming:
        bgColor = Colors.blue[100]!;
        textColor = Colors.blue[800]!;
        statusText = 'Upcoming';
        break;
      case MatchStatus.inProgress:
        bgColor = Colors.orange[100]!;
        textColor = Colors.orange[800]!;
        statusText = 'In Progress';
        break;
      case MatchStatus.completed:
        bgColor = Colors.green[100]!;
        textColor = Colors.green[800]!;
        statusText = 'Completed';
        break;
      case MatchStatus.cancelled:
        bgColor = Colors.red[100]!;
        textColor = Colors.red[800]!;
        statusText = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          // Teams
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: AssetImage(match.team1.logo),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      match.team1.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                child:  Text(
                  'VS',
                  style: AppStyles.informationText.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: AssetImage(match.team2.logo),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      match.team2.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),


          // Location
          Row(
            children: [
              Icon(Icons.location_on, color: lightColorScheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Location: ',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  match.location.name,
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// Referees
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.sports, color: lightColorScheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Referees: ',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  match.referees.map((ref) => ref.name).join(', '),
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Judges count
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.people, color: lightColorScheme.secondary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Judges: ',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              Expanded(
                child: Text(
                  '${match.judges.length} assigned',
                  style: TextStyle(
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton.icon(
            icon: Icon(Icons.edit, color: lightColorScheme.secondary, size: 18),
            label: Text(
              'Edit',
              style: TextStyle(
                color: lightColorScheme.secondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: onEdit,
          ),
          const SizedBox(width: 10),
          TextButton.icon(
            icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
            label: const Text(
              'Cancel',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}
