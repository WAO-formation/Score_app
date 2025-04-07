import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/custom_text.dart';
import '../../../shared/Welcome_box.dart';
import '../../../shared/custom_appbar.dart';
import '../../../shared/theme_data.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Privacy Policy',
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            }
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Welcome header
              const WelcomeToWAO(title: 'WAO Privacy Policy'),

              const SizedBox(height: 40.0),

              // Privacy Policy section
              Text(
                "PRIVACY POLICY",
                  style: AppStyles.primaryTitle
              ),
              const SizedBox(height: 10.0),
               Text(
                "The sport is fully registered with the Copyright Office of Ghana since 2014, and the Registrar General of Ghana.\n\nTo use WAO Sport for any purpose, contact the WAO office for approval.",
                  style: AppStyles.informationText
              ),

              const SizedBox(height: 25.0),

              // Scope of Policy section
              Text(
                "SCOPE OF POLICY",
                  style: AppStyles.primaryTitle
              ),
              const SizedBox(height: 10.0),
               Text(
                "First, the policy applies to all forms of using of WAO sport, including athletes, coaches, staff, and spectators.",
                  style: AppStyles.informationText
              ),
              const SizedBox(height: 12.0),
               Text(
                "Second, for using WAO Sport for Movie, Music and Entertainment productions.",
                  style: AppStyles.informationText
              ),
              const SizedBox(height: 12.0),
               Text(
                "And third, flamboyant usage of WAO Sport paraphernalia for commercials and events organizations in the name of WAO Sport.",
                  style: AppStyles.informationText
              ),

              const SizedBox(height: 25.0),

              // Rights section
              Text(
                "INTELLECTUAL PROPERTY RIGHTS",
                  style: AppStyles.primaryTitle
              ),
              const SizedBox(height: 10.0),
               Text(
                "All right on the use of logo and emblems of WAO Sport is exclusively reserved to the organization. Any use without approval is prohibited and can lead to suffer of legal consequences.",
                  style: AppStyles.informationText
              ),

              const SizedBox(height: 40.0),


              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "CONTACT US",
                      style: AppStyles.secondaryTitle
                    ),
                    const SizedBox(height: 16.0),

                    // Website
                    Row(
                      children: [
                        Icon(
                          Icons.public,
                          size: 20.0,
                          color: lightColorScheme.secondary,
                        ),
                        const SizedBox(width: 12.0),

                         Text(
                          "www.waosport.com",
                          style: AppStyles.informationText
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),

                    // Email
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 20.0,
                          color: lightColorScheme.secondary,
                        ),
                        const SizedBox(width: 12.0),
                         Text(
                          "waosport@gmail.com",
                            style: AppStyles.informationText
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),

                    // Phone
                    Row(
                      children: [
                        Icon(
                          Icons.phone,
                          size: 20.0,
                          color: lightColorScheme.secondary,
                        ),
                        const SizedBox(width: 12.0),
                         Text(
                          "+233 242 786 261",
                            style: AppStyles.informationText
                        ),
                      ],
                    ),

                    const SizedBox(height: 40.0),

                    // Social Media Icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildSocialIcon(
                          imagePath: 'assets/socials/facebook.png',
                          shadowColor: const Color(0xFF1877F2),
                          onTap: () {
                            print('Facebook icon tapped');
                          },
                        ),
                        _buildSocialIcon(
                          imagePath: 'assets/socials/instagram.png',
                          shadowColor: const Color(0xFFE4405F),
                          onTap: () {
                            print('Instagram  icon tapped');
                          },
                        ),
                        _buildSocialIcon(
                          imagePath: 'assets/socials/tiktok.png',
                          shadowColor: const Color(0xFF000000),
                          onTap: () {
                            print('tiktok icon tapped');
                          },
                        ),

                        _buildSocialIcon(
                          imagePath: 'assets/socials/X.png',
                          shadowColor: const Color(0xFF1DA1F2),
                          onTap: () {
                            print('Facebook icon tapped');
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                  ],
                ),
              ),

              const SizedBox(height: 30.0),

              // Copyright notice
              const Center(
                child: Text(
                  "© 2025 WAO Sport. All Rights Reserved.",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color(0xFF757575),
                  ),
                ),
              ),

              const SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildSocialIcon({
    required String imagePath,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipOval(
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            )),
      ),
    );
  }

}