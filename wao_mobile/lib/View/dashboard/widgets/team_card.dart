import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';
import 'folow_button.dart';

class TeamCard extends StatelessWidget {
  final WaoTeam team;
  final VoidCallback? onTap;
  final double? width;
  final bool isFollowing;
  final VoidCallback? onFollowToggle;

  const TeamCard({
    super.key,
    required this.team,
    this.onTap,
    this.width = 160,
    this.isFollowing = false,
    this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF011B3B), Color(0xFF02264D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.waoRed.withOpacity(0.15),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            children: [
              // Watermark
              Positioned(
                right: -18,
                bottom: -18,
                child: Opacity(
                  opacity: 0.06,
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      AppColors.waoYellow,
                      BlendMode.srcIn,
                    ),
                    child: Image.asset(
                      'assets/images/wao-ball.png',
                      width: 110,
                      height: 110,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const SizedBox(),
                    ),
                  ),
                ),
              ),

              // Content — fully centred
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _TeamLogo(logoUrl: team.logoUrl, size: 58),
                      const SizedBox(height: 10),
                      Text(
                        team.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.oswald(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.3,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 10),
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

// ── Shared team logo widget ───────────────────────────────────────────────────

class _TeamLogo extends StatelessWidget {
  const _TeamLogo({required this.logoUrl, this.size = 60});
  final String logoUrl;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasLogo = logoUrl.isNotEmpty && logoUrl.startsWith('http');
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.08),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1.5),
      ),
      child: ClipOval(
        child: hasLogo
            ? Image.network(
                logoUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Center(
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.shield_outlined,
                  color: Colors.white54,
                  size: 26,
                ),
              )
            : const Icon(Icons.shield_outlined, color: Colors.white54, size: 26),
      ),
    );
  }
}
