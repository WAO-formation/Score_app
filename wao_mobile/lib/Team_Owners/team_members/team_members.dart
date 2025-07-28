// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Team_Owners/team_members/player_details_screen.dart';
import 'package:wao_mobile/shared/theme_data.dart';

import '../../provider/Models/coach_team_players.dart';
import '../../provider/services/coach_player_team.dart';

class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  _TeamManagementScreenState createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize with mock data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoachTeamProvider>().initializeMockData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Team Management',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        backgroundColor: lightColorScheme.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: Colors.grey[200],
          ),
        ),
      ),

      body: Consumer<CoachTeamProvider>(
        builder: (context, coachTeamProvider, child) {
          return CustomScrollView(
            slivers: [
              // Team Statistics Header
              SliverToBoxAdapter(
                child: _buildTeamStatistics(coachTeamProvider),
              ),

              // Add Player Section
              SliverToBoxAdapter(
                child: _buildAddPlayerSection(context),
              ),

              // Players List by Role
              SliverToBoxAdapter(
                child: _buildPlayersSection(coachTeamProvider),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTeamStatistics(CoachTeamProvider teamProvider) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[600]!, Colors.blue[800]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Team Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Active Players',
                  '${teamProvider.activePlayers.length}',
                  '/${CoachTeamProvider.MAX_ACTIVE_PLAYERS}',
                  Icons.sports,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Substitutes',
                  '${teamProvider.substitutePlayers.length}',
                  '/${CoachTeamProvider.MAX_SUBSTITUTE_PLAYERS}',
                  Icons.people_outline,
                ),
              ),
              Expanded(
                child: _buildStatItem(
                  'Total Players',
                  '${teamProvider.players.length}',
                  '/${CoachTeamProvider.MAX_TOTAL_PLAYERS}',
                  Icons.group,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, String maxValue, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              TextSpan(
                text: maxValue,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAddPlayerSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: () => _showAddPlayerDialog(context),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blue[300]!,
              width: 2,
              style: BorderStyle.solid,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.add,
                  color: Colors.blue[600],
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Add New Player',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.blue[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersSection(CoachTeamProvider teamProvider) {
    final playersByRole = teamProvider.playersByRole;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Players by Role',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...WAORole.values.map((role) {
            final rolePlayers = playersByRole[role] ?? [];
            return _buildRoleSection(role, rolePlayers);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRoleSection(WAORole role, List<CoachPlayerModel> players) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 20),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getRoleColor(role).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: _getRoleIcon(role),
        ),
        title: Text(
          '${role.toString().split('.').last}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          '${players.length} player${players.length != 1 ? 's' : ''}',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        children: players.isEmpty
            ? [
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  color: Colors.grey[400],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'No players in this role',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ]
            : players.map((player) => _buildPlayerItem(player)).toList(),
      ),
    );
  }

  Widget _buildPlayerItem(CoachPlayerModel player) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _showPlayerDetails(player),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: player.status == CoachPlayerStatus.Active
                      ? Colors.green[500]
                      : Colors.orange[500],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    player.name[0].toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: player.status == CoachPlayerStatus.Active
                            ? Colors.green[100]
                            : Colors.orange[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        player.statusDisplayName,
                        style: TextStyle(
                          color: player.status == CoachPlayerStatus.Active
                              ? Colors.green[700]
                              : Colors.orange[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) => _handlePlayerAction(value, player),
                icon: Icon(
                  Icons.more_vert,
                  color: Colors.grey[600],
                ),
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'view',
                    child: Row(
                      children: [
                        Icon(Icons.visibility, size: 20),
                        SizedBox(width: 12),
                        Text('View Details'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, size: 20),
                        SizedBox(width: 12),
                        Text('Edit Player'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'toggle_status',
                    child: Row(
                      children: [
                        Icon(
                          player.status == CoachPlayerStatus.Active
                              ? Icons.arrow_downward
                              : Icons.arrow_upward,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          player.status == CoachPlayerStatus.Active
                              ? 'Move to Substitute'
                              : 'Make Active',
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 20, color: Colors.red),
                        SizedBox(width: 12),
                        Text('Remove Player', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(WAORole role) {
    switch (role) {
      case WAORole.King:
        return Colors.amber;
      case WAORole.Worker:
        return Colors.brown;
      case WAORole.Servitor:
        return Colors.blue;
      case WAORole.Warrior:
        return Colors.red;
      case WAORole.Protaque:
        return Colors.green;
      case WAORole.Antaque:
        return Colors.purple;
      case WAORole.Sacrificer:
        return Colors.grey;
    }
  }

  void _handlePlayerAction(String action, CoachPlayerModel player) {
    final teamProvider = context.read<CoachTeamProvider>();

    switch (action) {
      case 'view':
        _showPlayerDetails(player);
        break;
      case 'edit':
        _showEditPlayerDialog(player);
        break;
      case 'toggle_status':
        final newStatus = player.status == CoachPlayerStatus.Active
            ? CoachPlayerStatus.Substitute
            : CoachPlayerStatus.Active;
        break;
      case 'remove':
        _showRemovePlayerDialog(player);
        break;
    }
  }

  void _showPlayerDetails(CoachPlayerModel player) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlayerDetailsScreen(player: player),
      ),
    );
  }

  void _showAddPlayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEditPlayerDialog(),
    );
  }

  void _showEditPlayerDialog(CoachPlayerModel player) {
    showDialog(
      context: context,
      builder: (context) => AddEditPlayerDialog(player: player),
    );
  }

  void _showRemovePlayerDialog(CoachPlayerModel player) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Remove Player'),
        content: Text('Are you sure you want to remove ${player.name} from the team?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<CoachTeamProvider>().removePlayer(player.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  Icon _getRoleIcon(WAORole role) {
    switch (role) {
      case WAORole.King:
        return Icon(Icons.crop, color: _getRoleColor(role));
      case WAORole.Worker:
        return Icon(Icons.build, color: _getRoleColor(role));
      case WAORole.Servitor:
        return Icon(Icons.support_agent, color: _getRoleColor(role));
      case WAORole.Warrior:
        return Icon(Icons.sports_martial_arts, color: _getRoleColor(role));
      case WAORole.Protaque:
        return Icon(Icons.shield, color: _getRoleColor(role));
      case WAORole.Antaque:
        return Icon(Icons.flash_on, color: _getRoleColor(role));
      case WAORole.Sacrificer:
        return Icon(Icons.volunteer_activism, color: _getRoleColor(role));
    }
  }
}

// dialogs/add_edit_player_dialog.dart
class AddEditPlayerDialog extends StatefulWidget {
  final CoachPlayerModel? player;

  const AddEditPlayerDialog({this.player});

  @override
  _AddEditPlayerDialogState createState() => _AddEditPlayerDialogState();
}

class _AddEditPlayerDialogState extends State<AddEditPlayerDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late WAORole _selectedRole;
  late CoachPlayerStatus _selectedStatus;

  bool get isEditing => widget.player != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.player?.name ?? '',
    );
    _selectedRole = widget.player?.role ?? WAORole.Worker;
    _selectedStatus = widget.player?.status ?? CoachPlayerStatus.Substitute;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        isEditing ? 'Edit Player' : 'Add New Player',
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Player Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a player name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<WAORole>(
              value: _selectedRole,
              decoration: InputDecoration(
                labelText: 'Role',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: WAORole.values.map((role) {
                return DropdownMenuItem(
                  value: role,
                  child: Text(role.toString().split('.').last),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CoachPlayerStatus>(
              value: _selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              items: CoachPlayerStatus.values.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status == CoachPlayerStatus.Active ? 'Active' : 'Substitute'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _savePlayer,
          style: ElevatedButton.styleFrom(
            backgroundColor: lightColorScheme.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(isEditing ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  void _savePlayer() {
    if (!_formKey.currentState!.validate()) return;

    final teamProvider = context.read<CoachTeamProvider>();

    if (isEditing) {
      // Update existing player
      final updatedPlayer = widget.player!.copyWith(
        name: _nameController.text.trim(),
        role: _selectedRole,
        status: _selectedStatus,
      );

      // Check if status change is valid
      if (widget.player!.status != _selectedStatus) {
        if (!teamProvider.canAddPlayer(_selectedStatus)) {
          _showErrorMessage(
            _selectedStatus == CoachPlayerStatus.Active
                ? 'Cannot make active: Maximum active players reached'
                : 'Cannot make substitute: Maximum substitute players reached',
          );
          return;
        }
      }

      teamProvider.updatePlayer(widget.player!.id, updatedPlayer);
    } else {
      // Add new player
      if (!teamProvider.canAddPlayer(_selectedStatus)) {
        _showErrorMessage(
          _selectedStatus == CoachPlayerStatus.Active
              ? 'Cannot add active player: Maximum reached (${CoachTeamProvider.MAX_ACTIVE_PLAYERS})'
              : 'Cannot add substitute: Maximum reached (${CoachTeamProvider.MAX_SUBSTITUTE_PLAYERS})',
        );
        return;
      }

      final newPlayer = CoachPlayerModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        role: _selectedRole,
        status: _selectedStatus,
        stats: {'matches': 0, 'experience': 'Beginner'},
      );

      teamProvider.addPlayer(newPlayer);
    }

    Navigator.pop(context);
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

