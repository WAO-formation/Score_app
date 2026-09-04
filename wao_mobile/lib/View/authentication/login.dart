import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wao_mobile/core/widgets/wao_auth_scaffold.dart';
import '../../../shared/bottom_nav_bar.dart';
import '../../ViewModel/auth/LoginController.dart';
import 'forgot_password.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onLoginPressed() async {
    final bool success = await _controller.login(context);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNavBar()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return WaoAuthScaffold(
          child: Form(
            key: _controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const WaoAuthHeading(
                  'Sign In',
                  subtitle: "Welcome back — you've been missed.",
                ),
                const SizedBox(height: 28),

                WaoAuthField(
                  controller: _controller.emailController,
                  label: 'Email',
                  hint: 'example@email.com',
                  validator: _controller.validateEmail,
                  enabled: !_controller.isLoading,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),

                WaoAuthField(
                  controller: _controller.passwordController,
                  label: 'Password',
                  hint: 'Enter your password',
                  validator: _controller.validatePassword,
                  enabled: !_controller.isLoading,
                  obscureText: !_controller.passwordVisible,
                  suffix: WaoPasswordToggle(
                    visible: _controller.passwordVisible,
                    onPressed: _controller.isLoading
                        ? null
                        : _controller.togglePasswordVisibility,
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _RememberMeCheckbox(
                      value: _controller.rememberMe,
                      onChanged: _controller.isLoading
                          ? null
                          : _controller.toggleRememberMe,
                    ),
                    WaoAuthLink(
                      'Forgot Password?',
                      onTap: _controller.isLoading
                          ? null
                          : () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const ForgotPasswordEmailScreen(),
                                ),
                              ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                WaoAuthButton(
                  label: 'Sign In',
                  isLoading: _controller.isLoading,
                  onTap: _onLoginPressed,
                ),
                const SizedBox(height: 28),

                WaoAuthFooter(
                  leading: "Don't have an account?",
                  action: 'Sign Up',
                  onTap: _controller.isLoading
                      ? null
                      : () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegistrationScreen(),
                            ),
                          ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Unchecked (default): session lasts a day. Checked: 30 days — see
// SessionService, which is what actually enforces this on top of Firebase
// Auth's own indefinite local persistence.
class _RememberMeCheckbox extends StatelessWidget {
  const _RememberMeCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged == null ? null : () => onChanged!(!value),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              activeColor: kAuthBrand,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              side: const BorderSide(color: kAuthLine, width: 1.5),
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 8),
          Text('Remember me', style: GoogleFonts.oswald(fontSize: 13, color: kAuthSub)),
        ],
      ),
    );
  }
}
