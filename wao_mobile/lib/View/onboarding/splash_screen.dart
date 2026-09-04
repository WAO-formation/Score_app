import 'package:flutter/material.dart';
import 'package:wao_mobile/core/widgets/wao_loading_screen.dart';

import '../authentication/login.dart';

/// "Get Started" screen shown to signed-out users. Styled to match the WAO web
/// app: darkened hero image, navy wash, Anton headline, Oswald body and a flat
/// crimson primary action.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _goToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/officiate.jpg', fit: BoxFit.cover),

          // Darkening + brand navy wash — mirrors wao-web AuthLayout overlays.
          const DecoratedBox(
            decoration: BoxDecoration(color: Color(0xB3000000)),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  WaoBrand.navy,
                  Color(0xCC011B3B),
                  Color(0x33011B3B),
                  Colors.transparent,
                ],
                stops: [0.0, 0.35, 0.68, 0.95],
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 24, 28, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 
                  const Spacer(),

                  Text(
                    'WELCOME TO WAO',
                    style: WaoBrand.body(
                      fontSize: 11,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'World As One',
                    style: WaoBrand.heading(fontSize: 40, letterSpacing: 1),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Welcome to the new era of digitised sport, where technology '
                    'meets skill. WAO!',
                    style: WaoBrand.body(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 30),

                  _PrimaryButton(
                    label: 'GET STARTED',
                    onTap: () => _goToLogin(context),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: GestureDetector(
                      onTap: () => _goToLogin(context),
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account?  ',
                          style: WaoBrand.body(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign in',
                              style: WaoBrand.body(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Material(
        color: WaoBrand.primary,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Center(
            child: Text(
              label,
              style: WaoBrand.body(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w600,
                letterSpacing: 3,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
