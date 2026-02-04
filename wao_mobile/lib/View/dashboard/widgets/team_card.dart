import 'package:flutter/material.dart';
import 'package:wao_mobile/Model/teams_games/wao_team.dart';

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
                      _FollowButton(
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

// Separate stateful widget for the follow button
// This ensures only the button rebuilds, not the entire card
class _FollowButton extends StatefulWidget {
  final bool isFollowing;
  final VoidCallback? onToggle;

  const _FollowButton({
    required this.isFollowing,
    this.onToggle,
  });

  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> {
  bool _isLoading = false;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  @override
  void didUpdateWidget(_FollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update local state when parent updates
    if (oldWidget.isFollowing != widget.isFollowing) {
      _isFollowing = widget.isFollowing;
    }
  }

  Future<void> _handleToggle() async {
    if (_isLoading || widget.onToggle == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Optimistically update UI
      setState(() {
        _isFollowing = !_isFollowing;
      });

      // Call the actual toggle function
      widget.onToggle!();
    } catch (e) {
      // Revert on error
      setState(() {
        _isFollowing = !_isFollowing;
      });
      print('Error toggling follow: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isFollowing
              ? const Color(0xFFFFC600)
              : const Color(0xFFFFC600).withOpacity(0.2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xFFFFC600),
            width: 1,
          ),
        ),
        child: _isLoading
            ? const SizedBox(
          width: 14,
          height: 14,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Text(
          _isFollowing ? "Following" : "Follow",
          style: TextStyle(
            color: _isFollowing ? const Color(0xFF011B3B) : Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}