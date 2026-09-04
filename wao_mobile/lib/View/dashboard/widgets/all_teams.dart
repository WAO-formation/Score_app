import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/ViewModel/teams_games/team_viewmodel.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'package:wao_mobile/View/dashboard/widgets/folow_button.dart';
import 'package:wao_mobile/core/widgets/wao_toast.dart';
import '../../games_details/team_details.dart';

class AllTeamsPage extends StatefulWidget {
  const AllTeamsPage({super.key});

  @override
  State<AllTeamsPage> createState() => _AllTeamsPageState();
}

class _AllTeamsPageState extends State<AllTeamsPage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  static const _categories = ['All', 'Senior', 'Junior', 'Youth'];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final top = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Inline header ───────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(20, top + 20, 20, 0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(0.06)
                          : AppColors.waoNavy.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(0.08)
                            : AppColors.waoNavy.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16,
                      color: isDark ? Colors.white : AppColors.waoNavy,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  'All Teams',
                  style: GoogleFonts.oswald(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.waoNavy,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Search ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _SearchBar(
              isDark: isDark,
              onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
            ),
          ),

          const SizedBox(height: 16),

          // ── Category chips ──────────────────────────────────────────────
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.waoRed
                          : isDark
                              ? Colors.white.withOpacity(0.06)
                              : AppColors.waoNavy.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.waoRed
                            : isDark
                                ? Colors.white.withOpacity(0.1)
                                : AppColors.waoNavy.withOpacity(0.12),
                        width: 1,
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: GoogleFonts.oswald(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: selected
                            ? Colors.white
                            : isDark
                                ? Colors.white60
                                : AppColors.waoNavy.withOpacity(0.7),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // ── Grid ────────────────────────────────────────────────────────
          Expanded(
            child: _TeamsGrid(
              isDark: isDark,
              selectedCategory: _selectedCategory,
              searchQuery: _searchQuery,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Search Bar ────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.isDark, required this.onChanged});
  final bool isDark;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: GoogleFonts.oswald(
        fontSize: 15,
        color: isDark ? Colors.white : AppColors.waoNavy,
      ),
      decoration: InputDecoration(
        hintText: 'Search teams...',
        hintStyle: GoogleFonts.oswald(
          fontSize: 15,
          color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.35),
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          size: 20,
          color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
        ),
        filled: true,
        fillColor: isDark
            ? Colors.white.withOpacity(0.05)
            : AppColors.waoNavy.withOpacity(0.04),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : AppColors.waoNavy.withOpacity(0.1),
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark
                ? Colors.white.withOpacity(0.08)
                : AppColors.waoNavy.withOpacity(0.1),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white54 : AppColors.waoNavy,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

// ── Teams Grid ────────────────────────────────────────────────────────────────

class _TeamsGrid extends StatelessWidget {
  const _TeamsGrid({
    required this.isDark,
    required this.selectedCategory,
    required this.searchQuery,
  });

  final bool isDark;
  final String selectedCategory;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return Consumer<TeamViewModel>(
      builder: (context, vm, _) {
        return StreamBuilder<List<WaoTeam>>(
          stream: vm.getAllTeams(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return _EmptyState(
                icon: Icons.error_outline_rounded,
                label: 'Error loading teams',
                isDark: isDark,
              );
            }

            var teams = snapshot.data ?? [];

            if (selectedCategory != 'All') {
              final cat = TeamCategory.values.firstWhere(
                (e) => e.name == selectedCategory.toLowerCase(),
                orElse: () => TeamCategory.senior,
              );
              teams = teams.where((t) => t.category == cat).toList();
            }

            if (searchQuery.isNotEmpty) {
              teams = teams.where((t) => t.name.toLowerCase().contains(searchQuery)).toList();
            }

            if (teams.isEmpty) {
              return _EmptyState(
                icon: searchQuery.isNotEmpty
                    ? Icons.search_off_rounded
                    : Icons.groups_outlined,
                label: searchQuery.isNotEmpty ? 'No teams found' : 'No teams available',
                isDark: isDark,
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.82,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: teams.length,
              itemBuilder: (context, index) {
                final team = teams[index];
                return _TeamGridCard(
                  team: team,
                  isFollowing: vm.isFollowingTeam(team.id),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TeamDetails(team: team)),
                  ),
                  onFollowToggle: () async {
                    final wasFollowing = vm.isFollowingTeam(team.id);
                    try {
                      await vm.toggleFollowTeam(team.id);
                      if (context.mounted) {
                        wasFollowing
                            ? WaoToast.info(context, 'Unfollowed ${team.name}')
                            : WaoToast.success(context, 'Following ${team.name}');
                      }
                    } catch (_) {
                      if (context.mounted) {
                        WaoToast.error(context, 'Failed to update follow status');
                      }
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}

// ── Team Grid Card ────────────────────────────────────────────────────────────

class _TeamGridCard extends StatelessWidget {
  const _TeamGridCard({
    required this.team,
    required this.isFollowing,
    required this.onTap,
    required this.onFollowToggle,
  });

  final WaoTeam team;
  final bool isFollowing;
  final VoidCallback onTap;
  final VoidCallback onFollowToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF011B3B), Color(0xFF02264D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.waoRed.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Watermark ball
              Positioned(
                right: -20,
                bottom: -20,
                child: Opacity(
                  opacity: 0.06,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      AppColors.waoYellow,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/images/wao-ball.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                ),
              ),

              // Category badge
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.15),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    team.category.name.toUpperCase(),
                    style: GoogleFonts.oswald(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: Colors.white70,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),

              // Content — fully centred
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 28, 12, 14),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _TeamLogo(logoUrl: team.logoUrl),
                      const SizedBox(height: 12),
                      Text(
                        team.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.oswald(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.3,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FollowButton(
                        isFollowing: isFollowing,
                        onToggle: onFollowToggle,
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
}

// ── Team Logo ─────────────────────────────────────────────────────────────────

class _TeamLogo extends StatelessWidget {
  const _TeamLogo({required this.logoUrl});
  final String logoUrl;

  @override
  Widget build(BuildContext context) {
    final hasLogo = logoUrl.isNotEmpty && logoUrl.startsWith('http');
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: ClipOval(
        child: hasLogo
            ? Image.network(
                logoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const Center(
                        child: SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white54,
                          ),
                        ),
                      ),
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.shield_outlined,
                  color: Colors.white54,
                  size: 28,
                ),
              )
            : const Icon(Icons.shield_outlined, color: Colors.white54, size: 28),
      ),
    );
  }
}

// ── Empty State ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.label, required this.isDark});
  final IconData icon;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 56, color: isDark ? Colors.white24 : AppColors.waoNavy.withOpacity(0.2)),
          const SizedBox(height: 14),
          Text(
            label,
            style: GoogleFonts.oswald(
              fontSize: 15,
              color: isDark ? Colors.white38 : AppColors.waoNavy.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }
}
