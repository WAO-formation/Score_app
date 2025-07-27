import 'package:flutter/material.dart';

class TopSnackBar {
  static OverlayEntry? _currentOverlay;

  static void show(
      BuildContext context, {
        required String title,
        required String message,
        required IconData icon,
        Color backgroundColor = Colors.green,
        Color textColor = Colors.white,
        Color iconColor = Colors.white,
        Duration duration = const Duration(seconds: 5),
        Duration animationDuration = const Duration(milliseconds: 1200),
      }) {
    // Remove any existing snackbar
    dismiss();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => TopSnackBarWidget(
        title: title,
        message: message,
        icon: icon,
        backgroundColor: backgroundColor,
        textColor: textColor,
        iconColor: iconColor,
        duration: duration,
        animationDuration: animationDuration,
        onDismiss: () {
          overlayEntry.remove();
          _currentOverlay = null;
        },
      ),
    );

    _currentOverlay = overlayEntry;
    overlay?.insert(overlayEntry);
  }

  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

class TopSnackBarWidget extends StatefulWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color backgroundColor;
  final Color textColor;
  final Color iconColor;
  final Duration duration;
  final Duration animationDuration;
  final VoidCallback onDismiss;

  const TopSnackBarWidget({
    Key? key,
    required this.title,
    required this.message,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
    required this.iconColor,
    required this.duration,
    required this.animationDuration,
    required this.onDismiss,
  }) : super(key: key);

  @override
  State<TopSnackBarWidget> createState() => _TopSnackBarWidgetState();
}

class _TopSnackBarWidgetState extends State<TopSnackBarWidget>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Slide animation controller
    _slideController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    // Fade animation controller
    _fadeController = AnimationController(
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds ~/ 2),
      vsync: this,
    );

    // Slide animation (from top)
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Fade animation
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    // Scale animation for icon
    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.elasticOut,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();

    // Auto dismiss after duration
    Future.delayed(widget.duration, () {
      _dismiss();
    });
  }

  void _dismiss() async {
    await _fadeController.reverse();
    await _slideController.reverse();
    widget.onDismiss();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SafeArea(
        child: AnimatedBuilder(
          animation: Listenable.merge([_slideController, _fadeController]),
          builder: (context, child) {
            return SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.transparent,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.backgroundColor,
                            widget.backgroundColor.withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: widget.backgroundColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          children: [
                            // Animated background pattern
                            Positioned.fill(
                              child: CustomPaint(
                                painter: BackgroundPatternPainter(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                            ),
                            // Main content
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Animated Icon
                                  ScaleTransition(
                                    scale: _scaleAnimation,
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        widget.icon,
                                        color: widget.iconColor,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Text Content
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          widget.title,
                                          style: TextStyle(
                                            color: widget.textColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.message,
                                          style: TextStyle(
                                            color: widget.textColor.withOpacity(0.9),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Dismiss button
                                  GestureDetector(
                                    onTap: _dismiss,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.close,
                                        color: widget.iconColor,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class BackgroundPatternPainter extends CustomPainter {
  final Color color;

  BackgroundPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Draw subtle pattern
    for (int i = 0; i < size.width; i += 40) {
      for (int j = 0; j < size.height; j += 40) {
        canvas.drawCircle(
          Offset(i.toDouble(), j.toDouble()),
          2,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

