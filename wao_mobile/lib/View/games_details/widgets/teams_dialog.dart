import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class TeamSelectorDialog extends StatefulWidget {
  final List<WaoTeam> allTeams;
  final Set<String> followedTeamIds;

  const TeamSelectorDialog({
    super.key,
    required this.allTeams,
    required this.followedTeamIds,
  });

  @override
  State<TeamSelectorDialog> createState() => _TeamSelectorDialogState();
}

class _TeamSelectorDialogState extends State<TeamSelectorDialog> {
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WaoTeam> get filteredTeams {
    if (searchQuery.isEmpty) {
      return widget.allTeams;
    }
    return widget.allTeams
        .where((team) => team.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final teamViewModel = Provider.of<TeamViewModel>(context, listen: false);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.darkSurface : Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white30 : Colors.black26,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text(
                  'Follow Teams',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close,
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Search teams...',
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white38 : Colors.black38,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white38 : Colors.black38,
                ),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: isDarkMode ? Colors.white38 : Colors.black38,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                )
                    : null,
                filled: true,
                fillColor: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Teams List
          Expanded(
            child: filteredTeams.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: isDarkMode ? Colors.white30 : Colors.black26,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No teams found',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: filteredTeams.length,
              itemBuilder: (context, index) {
                final team = filteredTeams[index];
                final isFollowing = widget.followedTeamIds.contains(team.id);

                return _TeamListItem(
                  team: team,
                  isFollowing: isFollowing,
                  isDarkMode: isDarkMode,
                  onToggle: () async {
                    try {
                      await teamViewModel.toggleFollowTeam(team.id);

                      if (context.mounted) {
                        // Show a brief feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isFollowing
                                  ? 'Unfollowed ${team.name}'
                                  : 'Following ${team.name}',
                            ),
                            duration: const Duration(seconds: 1),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: isFollowing
                                ? Colors.grey[700]
                                : AppColors.waoYellow,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                );
              },
            ),
          ),

          // Bottom info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey.withOpacity(0.1),
              border: Border(
                top: BorderSide(
                  color: isDarkMode ? Colors.white12 : Colors.black12,
                ),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: isDarkMode ? Colors.white54 : Colors.black54,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Following teams shows their matches in your favorites',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamListItem extends StatelessWidget {
  final WaoTeam team;
  final bool isFollowing;
  final bool isDarkMode;
  final VoidCallback onToggle;

  const _TeamListItem({
    required this.team,
    required this.isFollowing,
    required this.isDarkMode,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode
            ? Colors.white.withOpacity(0.05)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isFollowing
              ? AppColors.waoYellow.withOpacity(0.3)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isDarkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.grey.withOpacity(0.1),
            shape: BoxShape.circle,
            image: team.logoUrl.isNotEmpty
                ? DecorationImage(
              image: NetworkImage(team.logoUrl),
              fit: BoxFit.cover,
            )
                : null,
          ),
          child: team.logoUrl.isEmpty
              ? Center(
            child: Text(
              team.name.isNotEmpty ? team.name[0].toUpperCase() : 'T',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white70 : Colors.black54,
              ),
            ),
          )
              : null,
        ),
        title: Text(
          team.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Coach: ${team.coach}',
              style: TextStyle(
                fontSize: 13,
                color: isDarkMode ? Colors.white60 : Colors.black54,
              ),
            ),
            if (team.isTopTeam) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(
                    Icons.emoji_events,
                    size: 14,
                    color: AppColors.waoYellow,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Top Team',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.waoYellow,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        trailing: GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isFollowing
                  ? AppColors.waoYellow
                  : isDarkMode
                  ? Colors.white.withOpacity(0.1)
                  : Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isFollowing
                    ? AppColors.waoYellow
                    : isDarkMode
                    ? Colors.white30
                    : Colors.black26,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isFollowing ? Icons.check : Icons.add,
                  size: 16,
                  color: isFollowing
                      ? const Color(0xFF011B3B)
                      : isDarkMode
                      ? Colors.white70
                      : Colors.black87,
                ),
                const SizedBox(width: 4),
                Text(
                  isFollowing ? 'Following' : 'Follow',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isFollowing
                        ? const Color(0xFF011B3B)
                        : isDarkMode
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}