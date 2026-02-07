import 'package:flutter/material.dart';

import '../../../shared/app_bar.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      appBar: const CustomAppBar(
        title: 'Privacy Policy',
        showBackButton: true,
        showNotification: true,
        hasNotificationDot: true,
      ),


      body: SafeArea(
        child: Column(
          children: [
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Updated: February 7, 2026',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.white54 : Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildSection(
                      isDarkMode: isDarkMode,
                      title: '1. Information We Collect',
                      content:
                      'We collect information you provide directly to us, including:\n\n• Account information (name, email, password)\n• Profile information\n• Team preferences and favorites\n• Match engagement data\n• Device information and usage statistics',
                    ),

                    _buildSection(
                      isDarkMode: isDarkMode,
                      title: '2. How We Use Your Information',
                      content:
                      'We use the information we collect to:\n\n• Provide and improve our services\n• Personalize your experience\n• Send you notifications about matches and updates\n• Analyze usage patterns\n• Ensure security and prevent fraud',
                    ),

                    _buildSection(
                      isDarkMode: isDarkMode,
                      title: '3. Information Sharing',
                      content:
                      'We do not sell your personal information. We may share your information with:\n\n• Service providers who assist us\n• With your consent\n• To comply with legal obligations',
                    ),

                    _buildSection(
                      isDarkMode: isDarkMode,
                      title: '4. Data Security',
                      content:
                      'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction.',
                    ),

                    _buildSection(
                      isDarkMode: isDarkMode,
                      title: '5. Your Rights',
                      content:
                      'You have the right to:\n\n• Access your personal data\n• Correct inaccurate data\n• Request deletion of your data\n• Opt-out of marketing communications\n• Export your data',
                    ),

                    _buildSection(
                      isDarkMode: isDarkMode,
                      title: '6. Cookies and Tracking',
                      content:
                      'We use cookies and similar tracking technologies to collect usage information and improve our services. You can control cookies through your browser settings.',
                    ),

                    _buildSection(
                      isDarkMode: isDarkMode,
                      title: '7. Children\'s Privacy',
                      content:
                      'Our service is not directed to children under 13. We do not knowingly collect personal information from children under 13.',
                    ),

                    _buildSection(
                      isDarkMode: isDarkMode,
                      title: '8. Contact Us',
                      content:
                      'If you have any questions about this Privacy Policy, please contact us at:\n\nprivacy@wao.com',
                    ),

                    const SizedBox(height: 32),

                    Center(
                      child: Text(
                        '© 2026 WAO Sports. All rights reserved.',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white38 : Colors.black38,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required bool isDarkMode,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: isDarkMode ? Colors.white70 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}