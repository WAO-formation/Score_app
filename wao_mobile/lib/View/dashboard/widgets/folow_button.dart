import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatefulWidget {
  final bool isFollowing;
  final VoidCallback? onToggle;

  const FollowButton({
    required this.isFollowing,
    this.onToggle,
  });

  @override
  State<FollowButton> createState() => FollowButtonState();
}

class FollowButtonState extends State<FollowButton> {
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