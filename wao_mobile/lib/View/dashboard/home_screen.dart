import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/View/dashboard/widgets/LiveMatchesCarousel.dart';
import 'package:wao_mobile/View/dashboard/widgets/all_teams.dart';
import 'package:wao_mobile/View/dashboard/widgets/news.dart';
import 'package:wao_mobile/View/dashboard/widgets/team_card.dart';
import 'package:wao_mobile/View/dashboard/widgets/upcoming_games.dart';
import 'package:wao_mobile/View/games_details/team_details.dart';
import 'package:wao_mobile/core/theme/app_typography.dart';
import '../../Model/teams_games/wao_team.dart';
import '../../ViewModel/teams_games/match_viewmodel.dart';
import '../../ViewModel/teams_games/team_viewmodel.dart';
import '../../core/services/Seeding_service.dart';
import '../../core/services/news/news_service.dart';
import '../../core/theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _initializeViewModel();
  }

  void _initializeViewModel() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final teamViewModel = Provider.of<TeamViewModel>(context, listen: false);
          teamViewModel.initialize(user.uid);
          print('TeamViewModel initialized with user ID: ${user.uid}');
        }
      });
    } else {
      print('Warning: No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          String name = "User";
                          String? profilePic;

                          if (snapshot.hasData && snapshot.data!.exists) {
                            final data = snapshot.data!.data() as Map<String, dynamic>;
                            name = data['username'] ?? "User";
                            profilePic = data['profilePicture'];
                          }

                          return Row(
                            children: [
                              _buildUserAvatar(name, profilePic),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Welcome Back!",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildNotificationBell(isDarkMode),
                  ],
                ),

                const SizedBox(height: 25.0),

                const LiveMatchesCarousel(),

                const SizedBox(height: 25.0),

                _buildTopTeamsSection(context, isDarkMode),

                const SizedBox(height: 25.0),

                Text(
                  'Upcoming Matches',
                  style: TextStyle(
                    fontSize: AppTypography.h2,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                  ),
                ),

                const SizedBox(height: 10.0),

                const UpcomingMatchesCarousel(),

                const SizedBox(height: 25.0),

                Text(
                  'WAO News',
                  style: TextStyle(
                    fontSize: AppTypography.h2,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                  ),
                ),

                const SizedBox(height: 10.0,),

                NewsSection(isDarkMode: isDarkMode),

                const SizedBox(height: 25.0,),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopTeamsSection(BuildContext context, bool isDarkMode) {
    return Consumer<TeamViewModel>(
      builder: (context, teamViewModel, child) {
        return StreamBuilder<List<WaoTeam>>(
          stream: teamViewModel.getTopTeams(limit: 5),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'Error loading teams',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              );
            }

            final teams = snapshot.data ?? [];

            if (teams.isEmpty) {
              return const SizedBox.shrink();
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Teams',
                      style: TextStyle(
                        fontSize: AppTypography.h2,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AllTeamsPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'See All',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: AppColors.waoYellow,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                SizedBox(
                  height: 168,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: teams.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      final isFollowing = teamViewModel.isFollowingTeam(team.id);

                      return TeamCard(
                        team: team,
                        isFollowing: isFollowing,
                        onTap: () => _handleTeamTap(context, team),
                        onFollowToggle: () async {
                          try {
                            await teamViewModel.toggleFollowTeam(team.id);

                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFollowing
                                        ? 'Unfollowed ${team.name}'
                                        : 'Following ${team.name}',
                                  ),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: isFollowing
                                      ? Colors.grey[700]
                                      : const Color(0xFFFFC600),
                                ),
                              );
                            }
                          } catch (e) {
                            print('Error toggling follow: $e');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to update follow status: $e'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleTeamTap(BuildContext context, WaoTeam team) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeamDetails(team: team),
      ),
    );
  }


  Widget _buildNotificationBell(bool isDarkMode) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: isDarkMode ? const Color(0xFFFFC600) : const Color(0xFF011B3B),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFE0000),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(String name, String? imageUrl) {
    String initial = name.isNotEmpty ? name[0].toUpperCase() : "U";

    return CircleAvatar(
      radius: 22.0,
      backgroundColor: const Color(0xFFFFC600).withOpacity(0.15),
      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
          ? NetworkImage(imageUrl)
          : null,
      child: imageUrl == null || imageUrl.isEmpty
          ? Text(
        initial,
        style: const TextStyle(
          color: Color(0xFFFFC600),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      )
          : null,
    );
  }

}