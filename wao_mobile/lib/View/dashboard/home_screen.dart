import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/View/dashboard/widgets/LiveMatchesCarousel.dart';
import 'package:wao_mobile/View/dashboard/widgets/all_teams.dart';
import 'package:wao_mobile/View/dashboard/widgets/news.dart';
import 'package:wao_mobile/View/dashboard/widgets/team_card.dart';
import 'package:wao_mobile/View/dashboard/widgets/upcoming_games.dart';
import 'package:wao_mobile/View/games_details/team_details.dart';
import 'package:wao_mobile/core/widgets/wao_toast.dart';
import '../../Model/teams_games/wao_team.dart';
import '../../ViewModel/teams_games/team_viewmodel.dart';
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && mounted) {
        Provider.of<TeamViewModel>(context, listen: false).initialize(user.uid);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).padding.top + 20, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── Header ────────────────────────────────────────────────
                Row(
                  children: [
                    Expanded(child: _UserGreeting(isDark: isDark)),
                    const SizedBox(width: 12),
                    _NotificationButton(isDark: isDark),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Live Matches ──────────────────────────────────────────
                _SectionHeader(title: 'Live Now', isDark: isDark),
                const SizedBox(height: 12),
                const LiveMatchesCarousel(),

                const SizedBox(height: 28),

                // ── Top Teams ─────────────────────────────────────────────
                _buildTopTeamsSection(context, isDark),

                const SizedBox(height: 28),

                // ── Upcoming Matches ──────────────────────────────────────
                _SectionHeader(title: 'Upcoming Matches', isDark: isDark),
                const SizedBox(height: 12),
                const UpcomingMatchesCarousel(),

                const SizedBox(height: 28),

                // ── WAO News ──────────────────────────────────────────────
                _SectionHeader(title: 'WAO News', isDark: isDark),
                const SizedBox(height: 12),
                NewsSection(isDarkMode: isDark),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopTeamsSection(BuildContext context, bool isDark) {
    return Consumer<TeamViewModel>(
      builder: (context, teamViewModel, _) {
        return StreamBuilder<List<WaoTeam>>(
          stream: teamViewModel.getTopTeams(limit: 5),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final teams = snapshot.data ?? [];
            if (teams.isEmpty) return const SizedBox.shrink();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader(
                  title: 'Top Teams',
                  isDark: isDark,
                  action: 'See All',
                  onAction: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AllTeamsPage()),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 168,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemCount: teams.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final team = teams[index];
                      final isFollowing = teamViewModel.isFollowingTeam(team.id);
                      return TeamCard(
                        team: team,
                        isFollowing: isFollowing,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => TeamDetails(team: team)),
                        ),
                        onFollowToggle: () async {
                          try {
                            await teamViewModel.toggleFollowTeam(team.id);
                            if (context.mounted) {
                              isFollowing
                                  ? WaoToast.info(context, 'Unfollowed ${team.name}')
                                  : WaoToast.success(context, 'Following ${team.name}');
                            }
                          } catch (e) {
                            if (context.mounted) {
                              WaoToast.error(context, 'Failed to update follow status');
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
}

// ── User Greeting ─────────────────────────────────────────────────────────────

class _UserGreeting extends StatelessWidget {
  const _UserGreeting({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnap) {
        final uid = authSnap.data?.uid;
        if (uid == null) return _greeting('User', null, isDark);

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
          builder: (context, snap) {
            String name = 'User';
            String? pic;
            if (snap.hasData && snap.data!.exists) {
              final d = snap.data!.data() as Map<String, dynamic>;
              name = d['displayName'] ?? d['username'] ?? 'User';
              pic = d['profilePicture'] ?? d['photoUrl'];
            }
            return _greeting(name, pic, isDark);
          },
        );
      },
    );
  }

  Widget _greeting(String name, String? pic, bool isDark) {
    return Row(
      children: [
        _Avatar(name: name, imageUrl: pic),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Welcome back',
                style: GoogleFonts.oswald(
                  fontSize: 12,
                  color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.45),
                  letterSpacing: 0.4,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.oswald(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.waoNavy,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────────

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name, this.imageUrl});
  final String name;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.waoNavy,
        border: Border.all(color: AppColors.waoNavy.withOpacity(0.3), width: 2),
      ),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : 'U',
          style: GoogleFonts.oswald(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ── Notification Button ───────────────────────────────────────────────────────

class _NotificationButton extends StatelessWidget {
  const _NotificationButton({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : AppColors.waoNavy.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : AppColors.waoNavy.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            size: 22,
            color: isDark ? Colors.white70 : AppColors.waoNavy,
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.waoRed,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Section Header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.isDark,
    this.action,
    this.onAction,
  });

  final String title;
  final bool isDark;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Left accent bar
        Container(
          width: 3,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.waoRed,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            style: GoogleFonts.oswald(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.waoNavy,
              letterSpacing: 0.3,
            ),
          ),
        ),
        if (action != null && onAction != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              action!,
              style: GoogleFonts.oswald(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.waoRed,
                letterSpacing: 0.3,
              ),
            ),
          ),
      ],
    );
  }
}
