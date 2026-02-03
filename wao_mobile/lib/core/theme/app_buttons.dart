import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';


class AppButtonStyles {
  static const double borderRadius = 28.0;
  static const double height = 56.0;
  static const EdgeInsets padding = EdgeInsets.symmetric(horizontal: 24);
}

// 2. Primary Button (Stand-alone class)
class WaoPrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;

  const WaoPrimaryButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: AppButtonStyles.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: isLoading ? AppColors.waoRed.withOpacity(0.6) : AppColors.waoRed,
          borderRadius: BorderRadius.circular(AppButtonStyles.borderRadius),
          boxShadow: [
            BoxShadow(
              color: AppColors.waoRed.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
          )
              : Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// 3. Secondary Button (Stand-alone class)
class WaoSecondaryButton extends StatelessWidget {
  final String text;
  final Widget? icon;
  final VoidCallback onTap;

  const WaoSecondaryButton({
    super.key,
    required this.text,
    this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppButtonStyles.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.inputFill(isDark).withOpacity(isDark ? 0.5 : 0.1),
          borderRadius: BorderRadius.circular(AppButtonStyles.borderRadius),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.black.withOpacity(0.05),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary(isDark),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}