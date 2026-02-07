import 'package:flutter/material.dart';
import '../../../shared/app_bar.dart';
import '../../../shared/theme_data.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'About WAO!',
        showBackButton: true,
        showNotification: true,
        hasNotificationDot: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Logo/Brand
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF011B3B), Color(0xFFD30336)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD30336).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'WAO',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Waoherds Limited',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Championing World Oneness Through Sport',
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.white60 : Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Overview
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                        ),
                      ),
                      child: Text(
                        'Founded in June 2012 by Solomon Kyei, Waoherds Limited pioneers an innovative sport that blends physical gameplay with digital storytelling. We revolutionize sports by integrating technology, community engagement, and entertainment to foster global unity and individual empowerment.',
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.8,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 24),

                    _buildValueCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.visibility,
                      title: 'Our Vision',
                      description: 'To champion world oneness through innovative sports experiences that blend technology with traditional gameplay.',
                    ),

                    const SizedBox(height: 16),

                    _buildValueCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.flag,
                      title: 'Our Mission',
                      description: 'Empowering individuals through world-class edutainment and sports development, leveraging success as a catalyst for broader life achievements.',
                    ),

                    const SizedBox(height: 16),

                    _buildValueCard(
                      isDarkMode: isDarkMode,
                      icon: Icons.sports_basketball,
                      title: 'The Sport',
                      description: 'WAO! – a two-ball hand-controlled sport played on the WaoSphere, blending dynamic gameplay with storytelling.',
                    ),

                    const SizedBox(height: 24),

                    Text(
                      'Contact Us',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildContactItem(isDarkMode, Icons.public, 'www.waosport.com'),
                    const SizedBox(height: 8),
                    _buildContactItem(isDarkMode, Icons.email, 'waosport@gmail.com'),
                    const SizedBox(height: 8),
                    _buildContactItem(isDarkMode, Icons.phone, '+233 242 786 261'),

                    const SizedBox(height: 24),

                    // Social Media
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildSocialIcon(Icons.facebook),
                        _buildSocialIcon(Icons.sports_basketball),
                        _buildSocialIcon(Icons.camera_alt),
                        _buildSocialIcon(Icons.play_circle_fill),
                      ],
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

  Widget _buildValueCard({
    required bool isDarkMode,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF011B3B), Color(0xFFD30336)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDarkMode ? Colors.white60 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(bool isDarkMode, IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 18,
          color: isDarkMode ? Colors.white60 : Colors.black54,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.white70 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialIcon(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD30336)),
      ),
      child: Icon(icon, size: 20, color: const Color(0xFFD30336)),
    );
  }
}