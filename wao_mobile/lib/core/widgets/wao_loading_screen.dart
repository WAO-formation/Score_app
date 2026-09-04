import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Brand palette mirrored from the WAO web app (`wao-web/src/config/brand.js`)
/// so the mobile and web products read as one system.
class WaoBrand {
  WaoBrand._();

  static const Color navy = Color(0xFF011B3B);
  static const Color navyLight = Color(0xFF022D5F);
  static const Color primary = Color(0xFFC81434);
  static const Color primaryHover = Color(0xFFE21E43);
  static const Color yellow = Color(0xFFFFC600);
  static const Color surface = Color(0xFFF5F6F8);

  static const String tagline = 'World Oneness Through Sport';
  static const String logoAsset = 'assets/images/WAO_LOGO.jpg';

  static TextStyle heading(
          {double fontSize = 28,
          Color color = Colors.white,
          double letterSpacing = 2}) =>
      GoogleFonts.anton(
        fontSize: fontSize,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle body(
          {double fontSize = 14,
          Color color = Colors.white,
          FontWeight fontWeight = FontWeight.w400,
          double letterSpacing = 0}) =>
      GoogleFonts.oswald(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      );
}

class WaoLoadingScreen extends StatelessWidget {
  const WaoLoadingScreen({super.key, this.message, this.dark = false});

 
  final String? message;

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final Color ground = dark ? WaoBrand.navy : Colors.white;
    final Color faint =
        dark ? Colors.white.withOpacity(0.15) : Colors.black.withOpacity(0.08);
    final Color label =
        dark ? Colors.white.withOpacity(0.45) : Colors.black.withOpacity(0.35);

    return Scaffold(
      backgroundColor: ground,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(WaoBrand.logoAsset, height: 64),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 160,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  minHeight: 2,
                  backgroundColor: faint,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(WaoBrand.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              (message ?? WaoBrand.tagline).toUpperCase(),
              textAlign: TextAlign.center,
              style: WaoBrand.body(
                fontSize: 10,
                color: label,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class WaoInlineLoader extends StatelessWidget {
  const WaoInlineLoader({super.key, this.size = 24, this.strokeWidth = 2.5});

  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor:
              const AlwaysStoppedAnimation<Color>(WaoBrand.primary),
        ),
      ),
    );
  }
}
