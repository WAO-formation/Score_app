import 'package:flutter/material.dart';
import 'package:wao_mobile/core/widgets/wao_auth_scaffold.dart';
import '../../ViewModel/auth/RegistrationController.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationController _controller = RegistrationController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    final bool success = await _controller.signUp(context);

    if (success && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return WaoAuthScaffold(
          showBack: true,
          // Login navigates here with pushReplacement, so there's no real
          // stack entry to pop back to — send the person to Login directly,
          // matching the footer link's own navigation below.
          onBack: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          ),
          child: Form(
            key: _controller.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const WaoAuthHeading(
                  'Create Account',
                  subtitle: 'Set up your free WAO account.',
                ),
                const SizedBox(height: 28),

                WaoAuthField(
                  controller: _controller.usernameController,
                  label: 'Full Name',
                  hint: 'John Doe',
                  validator: _controller.validateUsername,
                  enabled: !_controller.isLoading,
                ),
                const SizedBox(height: 16),

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
                  hint: 'At least 6 characters, one number',
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
                const SizedBox(height: 16),

                WaoAuthField(
                  controller: _controller.confirmPasswordController,
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  validator: _controller.validateConfirmPassword,
                  enabled: !_controller.isLoading,
                  obscureText: !_controller.confirmPasswordVisible,
                  suffix: WaoPasswordToggle(
                    visible: _controller.confirmPasswordVisible,
                    onPressed: _controller.isLoading
                        ? null
                        : _controller.toggleConfirmVisibility,
                  ),
                ),
                const SizedBox(height: 20),

                WaoAuthButton(
                  label: 'Create Account',
                  isLoading: _controller.isLoading,
                  onTap: _onRegisterPressed,
                ),
                const SizedBox(height: 28),

                WaoAuthFooter(
                  leading: 'Already have an account?',
                  action: 'Sign In',
                  onTap: _controller.isLoading
                      ? null
                      : () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
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


