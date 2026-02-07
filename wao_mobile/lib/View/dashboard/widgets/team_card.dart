import 'package:flutter/material.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';

import 'folow_button.dart';

class TeamCard extends StatelessWidget {
  final WaoTeam team;
  final VoidCallback? onTap;
  final double? width;
  final bool showCategoryBadge;
  final bool isFollowing;
  final VoidCallback? onFollowToggle;

  const TeamCard({
    super.key,
    required this.team,
    this.onTap,
    this.width = 160,
    this.showCategoryBadge = true,
    this.isFollowing = false,
    this.onFollowToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        decoration: _buildCardDecoration(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Background ball pattern - positioned at bottom right
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Transform.translate(
                    offset: const Offset(40, 40),
                    child: Opacity(
                      opacity: 0.06, // More subtle opacity
                      child: ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Color(0xFFFFC600), // waoYellow as watermark
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          "assets/images/wao-ball.png",
                          width: 130,
                          height: 130,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const SizedBox();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Main content - centered
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildTeamLogo(),
                      const SizedBox(height: 12.0),
                      _buildTeamName(),
                      const SizedBox(height: 10.0),
                      // Stateful follow button that rebuilds independently
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

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      gradient: const LinearGradient(
        colors: [
          Color(0xFF011B3B),
          Color(0xFF02264D),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFD30336).withOpacity(0.15), // Subtle red border
        width: 1,
      ),
    );
  }

  Widget _buildTeamLogo() {
    final hasValidLogo = team.logoUrl.isNotEmpty &&
        team.logoUrl.startsWith('http');

    return ClipOval(
      child: hasValidLogo
          ? Image.network(
        team.logoUrl,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildLoadingIndicator();
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallbackIcon();
        },
      )
          : _buildFallbackIcon(),
    );
  }

  Widget _buildTeamName() {
    return Text(
      team.name,
      textAlign: TextAlign.center,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.3,
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        team.category.name.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.shield,
        color: Colors.white,
        size: 30,
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}


