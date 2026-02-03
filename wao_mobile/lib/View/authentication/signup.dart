import 'package:flutter/material.dart';
import 'package:wao_mobile/core/theme/app_typography.dart';
import '../../ViewModel/auth/RegistrationController.dart';
import '../../core/theme/app_buttons.dart';
import '../../core/theme/app_colors.dart';
import 'login.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final RegistrationController _controller = RegistrationController();

  @override
  void initState() {
    super.initState();
    _controller.passwordController.addListener(_controller.updatePasswordValidation);
    _controller.confirmPasswordController.addListener(_controller.updatePasswordValidation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onRegisterPressed() async {
    bool success = await _controller.signUp(context);

    if (success && context.mounted) {
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
        return  Scaffold(
            body: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Form(
                    key: _controller.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      children: [
                        const SizedBox(height: 100),

                        Text(
                            'Register',
                            style: TextStyle(
                              fontSize: AppTypography.display,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(Theme.of(context).brightness == Brightness.dark),
                            )
                        ),

                        const SizedBox(height: 10),

                        Text(
                            'Join Us Lets Play WAO',
                            style: TextStyle(
                              fontSize: AppTypography.h2,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary(Theme.of(context).brightness == Brightness.dark),
                            )
                        ),

                        const SizedBox(height: 30,),

                        _buildTextField(
                          context: context,
                          controller: _controller.usernameController,
                          label: 'Username',
                          validator: _controller.validateUsername,
                        ),

                        const SizedBox(height: 20,),

                        _buildTextField(
                          controller: _controller.emailController,
                          label: 'Email',
                          validator: _controller.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                          context: context,
                        ),

                        const SizedBox(height: 20,),

                        // Password Field with internal validation hints
                        _buildPasswordField(context),
                        const SizedBox(height: 20),

                        // Confirm Password Field
                        _buildConfirmPasswordField(context),

                        const SizedBox(height: 30),

                        WaoPrimaryButton(
                          text: "Create Account",
                          isLoading: _controller.isLoading,
                          onTap: _onRegisterPressed,
                        ),

                        const SizedBox(height: 40),

                        _buildLoginRedirect(context),

                        const SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
              ),
            )
        );
      },
    );
  }

  // --- View Sub-Widgets to keep build method clean ---



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
      enabled: enabled,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller.passwordController,
          obscureText: !_controller.passwordVisible,
          validator: _controller.validatePassword,
          enabled: !_controller.isLoading,
          style: TextStyle(
            color: AppColors.textPrimary(isDark),
            fontSize: AppTypography.bodyLg,
            fontWeight: FontWeight.w400,
          ),
          decoration: _buildInputDecoration(
            context: context,
            label: 'Password',
            isDark: isDark,
            suffixIcon: IconButton(
              icon: Icon(
                _controller.passwordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textSecondary(isDark),
              ),
              onPressed: _controller.isLoading ? null : _controller.togglePasswordVisibility,
            ),
          ),
        ),
        _buildValidationHint(
          context,
          _controller.passwordLengthValid,
          'At least 6 characters with one number',
        ),
      ],
    );
  }


  Widget _buildConfirmPasswordField(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller.confirmPasswordController,
          obscureText: !_controller.confirmPasswordVisible,
          validator: _controller.validateConfirmPassword,
          enabled: !_controller.isLoading,
          style: TextStyle(
            color: AppColors.textPrimary(isDark),
            fontSize: AppTypography.bodyLg,
            fontWeight: FontWeight.w400,
          ),
          decoration: _buildInputDecoration(
            context: context,
            label: 'Confirm Password',
            isDark: isDark,
            suffixIcon: IconButton(
              icon: Icon(
                _controller.confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textSecondary(isDark),
              ),
              onPressed: _controller.isLoading ? null : _controller.toggleConfirmVisibility,
            ),
          ),
        ),
        _buildValidationHint(
          context,
          _controller.passwordsMatch,
          'Passwords must match',
        ),
      ],
    );
  }

// Reusable decoration to keep code clean
  InputDecoration _buildInputDecoration({
    required BuildContext context,
    required String label,
    required bool isDark,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: AppColors.inputFill(isDark).withOpacity(isDark ? 0.5 : 0.8),
      labelStyle: TextStyle(color: AppColors.textSecondary(isDark)),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      // Standard Border
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide.none,
      ),
      // Validation Error Border
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
      errorStyle: const TextStyle(fontSize: 12, color: Colors.redAccent),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(28),
        borderSide: BorderSide(
          color: isDark ? Colors.white : AppColors.waoNavy,
          width: 1.5,
        ),
      ),
    );
  }

  Widget _buildValidationHint(BuildContext context, bool isValid, String text) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final successColor = Colors.greenAccent[400]!;
    final neutralColor = AppColors.textTertiary(isDark);

    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 12.0),
      child: Row(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.info_outline,
            size: 14,
            color: isValid ? successColor : neutralColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: AppTypography.caption,
              fontWeight: FontWeight.w400,
              color: isValid ? successColor : neutralColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginRedirect(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
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
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            ),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 8),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: AppTypography.h2,
                fontWeight: FontWeight.w400,
                color: _controller.isLoading
                    ? Colors.grey[600]
                    : AppColors.waoRed, // Using the Pretty Red
              ),
            ),
          ),
        ],
      ),
    );
  }
}