import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'wao_loading_screen.dart' show WaoBrand;

// ─── Token palette ────────────────────────────────────────────────────────────
const Color kAuthInk    = Color(0xFF0D1117); // near-black body text
const Color kAuthSub    = Color(0xFF6B7280); // secondary / hint
const Color kAuthLine   = Color(0xFFE4E7EC); // border idle
const Color kAuthBrand  = WaoBrand.primary;  // WAO red — single accent, matches the buttons/links throughout
const Color kAuthError  = Color(0xFFD32F2F);
const Color kAuthSurface = Color(0xFFF3F4F6); // field fill

// ─── WaoAuthScaffold ──────────────────────────────────────────────────────────
/// Plain white auth canvas: the vertical WAO crest up top, two soft
/// brand-colored blobs for ambient depth (no boxed color panel), then the
/// form content — the whole block sits vertically centered on screen when it
/// fits, and scrolls (still top-anchored) once the keyboard or a longer form
/// pushes past the available height.
class WaoAuthScaffold extends StatelessWidget {
  const WaoAuthScaffold({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    const verticalPadding = 24.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Ambient decoration — soft, low-opacity blobs tucked behind the
          // content, never behind interactive elements.
          Positioned(
            top: -60,
            right: -50,
            child: _Blob(color: kAuthBrand.withOpacity(0.10), size: 220),
          ),
          Positioned(
            top: 40,
            left: -70,
            child: _Blob(color: WaoBrand.navy.withOpacity(0.05), size: 160),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    28,
                    verticalPadding,
                    28,
                    mq.viewInsets.bottom + verticalPadding,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - verticalPadding * 2,
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(WaoBrand.logoAsset, height: 100),
                          ),
                          const SizedBox(height: 28),
                          child,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.color, required this.size});
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
        ),
      ),
    );
  }
}

// ─── WaoAuthHeading ───────────────────────────────────────────────────────────
class WaoAuthHeading extends StatelessWidget {
  const WaoAuthHeading(this.title, {super.key, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.oswald(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: kAuthInk,
            height: 1.1,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: GoogleFonts.oswald(
              fontSize: 13,
              height: 1.55,
              color: kAuthSub,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }
}

// ─── WaoAuthField ─────────────────────────────────────────────────────────────
/// Label above a flat, borderless, filled field — no floating label, no
/// outline, just a soft gray surface like the reference screens.
class WaoAuthField extends StatelessWidget {
  const WaoAuthField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.suffix,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final bool enabled;
  final TextInputType keyboardType;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.oswald(fontSize: 13, color: kAuthInk, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: GoogleFonts.oswald(fontSize: 15, color: kAuthInk),
          cursorColor: kAuthBrand,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.oswald(fontSize: 14, color: kAuthSub.withOpacity(0.6)),
            suffixIcon: suffix,
            filled: true,
            fillColor: enabled ? kAuthSurface : kAuthLine.withOpacity(0.4),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kAuthBrand, width: 1.6),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kAuthError),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: kAuthError, width: 1.6),
            ),
            errorStyle: GoogleFonts.oswald(fontSize: 11, color: kAuthError),
          ),
        ),
      ],
    );
  }
}

// ─── WaoAuthButton ────────────────────────────────────────────────────────────
/// Full pill shape — fully rounded ends, single strong brand-red fill.
class WaoAuthButton extends StatelessWidget {
  const WaoAuthButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    const double height = 54;
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Material(
        color: isLoading ? kAuthBrand.withOpacity(0.6) : kAuthBrand,
        borderRadius: BorderRadius.circular(height / 2),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(height / 2),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    label,
                    style: GoogleFonts.oswald(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─── WaoAuthLink ──────────────────────────────────────────────────────────────
class WaoAuthLink extends StatelessWidget {
  const WaoAuthLink(this.label, {super.key, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.oswald(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: kAuthBrand,
          decoration: TextDecoration.underline,
          decorationColor: kAuthBrand,
        ),
      ),
    );
  }
}

// ─── WaoAuthDivider ───────────────────────────────────────────────────────────
// Kept for any screen that still wants a labeled divider (no social row uses
// it today, but splitting form sections benefits from the same look).
class WaoAuthDivider extends StatelessWidget {
  const WaoAuthDivider({super.key, this.label = 'or'});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: kAuthLine, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(label, style: GoogleFonts.oswald(fontSize: 12, color: kAuthSub)),
        ),
        const Expanded(child: Divider(color: kAuthLine, thickness: 1)),
      ],
    );
  }
}

// ─── WaoAuthFooter ────────────────────────────────────────────────────────────
class WaoAuthFooter extends StatelessWidget {
  const WaoAuthFooter({
    super.key,
    required this.leading,
    required this.action,
    required this.onTap,
  });

  final String leading;
  final String action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Text.rich(
          TextSpan(
            text: '$leading  ',
            style: GoogleFonts.oswald(fontSize: 13, color: kAuthSub),
            children: [
              TextSpan(
                text: action,
                style: GoogleFonts.oswald(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: kAuthBrand,
                  decoration: TextDecoration.underline,
                  decorationColor: kAuthBrand,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── WaoPasswordToggle ────────────────────────────────────────────────────────
class WaoPasswordToggle extends StatelessWidget {
  const WaoPasswordToggle({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  final bool visible;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashRadius: 18,
      icon: Icon(
        visible ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        size: 18,
        color: kAuthSub,
      ),
      onPressed: onPressed,
    );
  }
}
