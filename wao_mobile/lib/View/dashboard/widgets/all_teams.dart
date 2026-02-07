import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'package:wao_mobile/View/dashboard/widgets/folow_button.dart';

import '../../../core/theme/app_typography.dart';
import '../../../shared/app_bar.dart';
import '../../games_details/team_details.dart'; // Import your FollowButton

class AllTeamsPage extends StatefulWidget {
  const AllTeamsPage({super.key});

  @override
  State<AllTeamsPage> createState() => _AllTeamsPageState();
}

class _AllTeamsPageState extends State<AllTeamsPage> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Men', 'Women', 'Mixed'];
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      appBar: CustomAppBar(
        title: 'All Teams',
        showBackButton: true,
        showNotification: true,
        hasNotificationDot: false,
        onNotificationPressed: () {
          // Navigate to notifications
        },
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildSearchBar(isDarkMode),
          ),

          const SizedBox(height: 16),

          // Category Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildCategoryFilter(isDarkMode),
          ),

          const SizedBox(height: 20),

          // Teams Grid
          Expanded(
            child: _buildTeamsGrid(isDarkMode),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
      ),
      child: TextField(
        onChanged: (value) {
          setState(() {
            searchQuery = value.toLowerCase();
          });
        },
        style: TextStyle(
          color: AppColors.textPrimary(isDarkMode),
          fontSize: AppTypography.bodyLg,
          fontWeight: FontWeight.w400,
        ),
        decoration: InputDecoration(
          hintText: 'Search teams...',
          hintStyle: TextStyle(
            color: AppColors.textSecondary(isDarkMode),
            fontSize: AppTypography.bodyLg,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppColors.textSecondary(isDarkMode),
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.white : AppColors.waoNavy,
              width: 1.5,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(bool isDarkMode) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? const LinearGradient(
                  colors: [Color(0xFF011B3B), Color(0xFFD30336)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
                    : null,
                color: isSelected ? null : isDarkMode ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),

              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : isDarkMode
                      ? Colors.white70
                      : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTeamsGrid(bool isDarkMode) {
    return Consumer<TeamViewModel>(
      builder: (context, teamViewModel, child) {
        return StreamBuilder<List<WaoTeam>>(
          stream: teamViewModel.getAllTeams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.waoYellow,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: isDarkMode ? Colors.white30 : Colors.black26,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading teams',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            var teams = snapshot.data ?? [];

            // Apply category filter
            if (selectedCategory != 'All') {
              teams = teams.where((team) {
                switch (selectedCategory) {
                  case 'Men':
                    return team.category == TeamCategory.men;
                  case 'Women':
                    return team.category == TeamCategory.women;
                  case 'Mixed':
                    return team.category == TeamCategory.mixed;
                  default:
                    return true;
                }
              }).toList();
            }

            // Apply search filter
            if (searchQuery.isNotEmpty) {
              teams = teams.where((team) {
                return team.name.toLowerCase().contains(searchQuery);
              }).toList();
            }

            if (teams.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      searchQuery.isNotEmpty ? Icons.search_off : Icons.groups_outlined,
                      size: 64,
                      color: isDarkMode ? Colors.white30 : Colors.black26,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      searchQuery.isNotEmpty ? 'No teams found' : 'No teams available',
                      style: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                final isFollowing = teamViewModel.isFollowingTeam(team.id);

                return _buildTeamGridCard(team, isFollowing, teamViewModel, isDarkMode);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTeamGridCard(WaoTeam team, bool isFollowing, TeamViewModel teamViewModel, bool isDarkMode) {
    return GestureDetector(
      onTap: () {
       Navigator.push(context,
       MaterialPageRoute(builder: (context) => TeamDetails(team: team)));
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF011B3B), Color(0xFF02264D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD30336).withOpacity(0.15),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background pattern
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Transform.translate(
                    offset: const Offset(30, 30),
                    child: Opacity(
                      opacity: 0.06,
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFC600),
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          "assets/images/wao-ball.png",
                          width: 100,
                          height: 100,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const SizedBox(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Category badge
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.waoYellow.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    team.category.name.toUpperCase(),
                    style: const TextStyle(
                      color: Color(0xFF011B3B),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Main content - Centralized
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Team logo
                      _buildTeamLogo(team),

                      const SizedBox(height: 12),

                      // Team name
                      Text(
                        team.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Follow button - Using your FollowButton widget
                      FollowButton(
                        isFollowing: isFollowing,
                        onToggle: () async {
                          try {
                            await teamViewModel.toggleFollowTeam(team.id);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFollowing ? 'Unfollowed ${team.name}' : 'Following ${team.name}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: isFollowing ? Colors.grey[700] : AppColors.waoYellow,
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Failed to update follow status'),
                                  backgroundColor: Colors.red,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamLogo(WaoTeam team) {
    final hasValidLogo = team.logoUrl.isNotEmpty && team.logoUrl.startsWith('http');

    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.1),
        border: Border.all(
          color: AppColors.waoYellow.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: hasValidLogo
            ? Image.network(
          team.logoUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.shield, color: Colors.white, size: 35);
          },
        )
            : const Icon(Icons.shield, color: Colors.white, size: 35),
      ),
    );
  }
}