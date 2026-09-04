import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wao_mobile/core/theme/app_colors.dart';

class FollowButton extends StatefulWidget {
  final bool isFollowing;
  final VoidCallback? onToggle;

  const FollowButton({
    super.key,
    required this.isFollowing,
    this.onToggle,
  });

  @override
  State<FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<FollowButton> {
  bool _isLoading = false;
  late bool _isFollowing;

  @override
  void initState() {
    super.initState();
    _isFollowing = widget.isFollowing;
  }

  @override
  void didUpdateWidget(FollowButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFollowing != widget.isFollowing) {
      _isFollowing = widget.isFollowing;
    }
  }

  Future<void> _handleToggle() async {
    if (_isLoading || widget.onToggle == null) return;
    setState(() {
      _isLoading = true;
      _isFollowing = !_isFollowing;
    });
    try {
      widget.onToggle!();
    } catch (_) {
      setState(() => _isFollowing = !_isFollowing);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _isFollowing ? AppColors.waoRed : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _isFollowing
                ? AppColors.waoRed
                : Colors.white.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: _isLoading
            ? SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: _isFollowing ? Colors.white : Colors.white54,
                ),
              )
            : Text(
                _isFollowing ? 'Following' : 'Follow',
                style: GoogleFonts.oswald(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
              ),
      ),
    );
  }
}
