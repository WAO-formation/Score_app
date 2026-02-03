import 'package:flutter/material.dart';
import 'package:wao_mobile/core/theme/app_typography.dart';
import '../../../core/theme/app_buttons.dart';
import '../../../core/theme/app_colors.dart';
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
    bool success = await _controller.login(context);

    if (success && context.mounted) {
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
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Form(
                  key: _controller.formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      const SizedBox(height: 150),

                      Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: AppTypography.display,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(Theme.of(context).brightness == Brightness.dark),
                          )
                      ),

                      const SizedBox(height: 10),

                      Text(
                          'WAO - World As One',
                          style: TextStyle(
                            fontSize: AppTypography.h2,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary(Theme.of(context).brightness == Brightness.dark),
                          )
                      ),

                      const SizedBox(height: 30),

                      _buildTextField(
                        context: context,
                        controller: _controller.emailController,
                        label: 'Email',
                        validator: _controller.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      const SizedBox(height: 20),

                      _buildPasswordField(context),

                      const SizedBox(height: 12),

                      _buildForgotPassword(context),

                      const SizedBox(height: 30),

                      WaoPrimaryButton(
                        text: "Login",
                        isLoading: _controller.isLoading,
                        onTap: _onLoginPressed,
                      ),

                      const SizedBox(height: 40),

                      _buildRegisterRedirect(context),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // --- View Sub-Widgets ---

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      validator: validator,
      enabled: enabled && !_controller.isLoading,
      keyboardType: keyboardType,
      style: TextStyle(
        color: AppColors.textPrimary(isDark),
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.inputFill(isDark).withOpacity(isDark ? 0.5 : 0.8),
        labelStyle: TextStyle(
          color: AppColors.textSecondary(isDark),
          fontSize: AppTypography.bodyLg,
          fontWeight: FontWeight.w400,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: isDark ? Colors.white : AppColors.waoNavy,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      ),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: _controller.passwordController,
      obscureText: !_controller.passwordVisible,
      validator: _controller.validatePassword,
      enabled: !_controller.isLoading,
      style: TextStyle(
        color: AppColors.textPrimary(isDark),
        fontSize: AppTypography.bodyLg,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: AppColors.inputFill(isDark).withOpacity(isDark ? 0.5 : 0.8),
        labelStyle: TextStyle(
          color: AppColors.textSecondary(isDark),
          fontSize: AppTypography.bodyLg,
          fontWeight: FontWeight.w400,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _controller.passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.textSecondary(isDark),
          ),
          onPressed: _controller.isLoading ? null : _controller.togglePasswordVisibility,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide(
            color: isDark ? Colors.white : AppColors.waoNavy,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: _controller.isLoading
            ? null
            : () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordEmailScreen()),
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8),
        ),
        child: Text(
          'Forgot password?',
          style: TextStyle(
            fontSize: AppTypography.bodyMd,
            fontWeight: FontWeight.w400,
            color: _controller.isLoading
                ? Colors.grey[600]
                : AppColors.waoRed,
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterRedirect(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: TextStyle(
              color: AppColors.textSecondary(isDark),
              fontSize: AppTypography.h2,
              fontWeight: FontWeight.w400,
            ),
          ),
          TextButton(
            onPressed: _controller.isLoading
                ? null
                : () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const RegistrationScreen()),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              'Register',
              style: TextStyle(
                fontSize: AppTypography.h2,
                fontWeight: FontWeight.w400,
                color: _controller.isLoading
                    ? Colors.grey[600]
                    : AppColors.waoRed,
              ),
            ),
          ),
        ],
      ),
    );
  }
}