import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'wao_loading_screen.dart' show WaoBrand;

// ─── States ───────────────────────────────────────────────────────────────────
enum WaoToastType { success, error, info, warning }

// ─── Per-state tokens ─────────────────────────────────────────────────────────
const _kSuccess = _ToastStyle(
  bg:   Color(0xFF0A2E1A),
  icon: Color(0xFF34D399),
  bar:  Color(0xFF34D399),
  iconData: Icons.check_circle_outline_rounded,
);
const _kError = _ToastStyle(
  bg:   Color(0xFF2A0A0E),
  icon: Color(0xFFFC8181),
  bar:  Color(0xFFFC8181),
  iconData: Icons.error_outline_rounded,
);
const _kInfo = _ToastStyle(
  bg:   WaoBrand.navy,
  icon: Color(0xFF93C5FD),
  bar:  Color(0xFF93C5FD),
  iconData: Icons.info_outline_rounded,
);
const _kWarning = _ToastStyle(
  bg:   Color(0xFF3A2A0A),
  icon: Color(0xFFFBBF24),
  bar:  Color(0xFFFBBF24),
  iconData: Icons.warning_amber_rounded,
);

class _ToastStyle {
  final Color bg;
  final Color icon;
  final Color bar;
  final IconData iconData;
  const _ToastStyle({
    required this.bg,
    required this.icon,
    required this.bar,
    required this.iconData,
  });
}

// ─── Public API ───────────────────────────────────────────────────────────────
class WaoToast {
  WaoToast._();

  static void show(
    BuildContext context,
    String message, {
    WaoToastType type = WaoToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          // Negative margin pushes it to the top via the padding trick below
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          elevation: 0,
          backgroundColor: Colors.transparent,
          duration: duration,
          content: _WaoToastContent(message: message, type: type),
        ),
      );
  }

  static void success(BuildContext context, String message) =>
      show(context, message, type: WaoToastType.success);

  static void error(BuildContext context, String message) =>
      show(context, message, type: WaoToastType.error);

  static void info(BuildContext context, String message) =>
      show(context, message, type: WaoToastType.info);

  static void warning(BuildContext context, String message) =>
      show(context, message, type: WaoToastType.warning);
}

// ─── Internal widget ──────────────────────────────────────────────────────────
class _WaoToastContent extends StatelessWidget {
  const _WaoToastContent({required this.message, required this.type});

  final String message;
  final WaoToastType type;

  _ToastStyle get _style {
    switch (type) {
      case WaoToastType.success: return _kSuccess;
      case WaoToastType.error:   return _kError;
      case WaoToastType.info:    return _kInfo;
      case WaoToastType.warning: return _kWarning;
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _style;
    final top = MediaQuery.of(context).padding.top;

    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: EdgeInsets.only(top: top + 12, left: 16, right: 16),
        decoration: BoxDecoration(
          color: s.bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // Left accent bar
              Positioned(
                left: 0, top: 0, bottom: 0,
                child: Container(width: 3, color: s.bar),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(s.iconData, color: s.icon, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: GoogleFonts.oswald(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          height: 1.4,
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
    );
  }
}
