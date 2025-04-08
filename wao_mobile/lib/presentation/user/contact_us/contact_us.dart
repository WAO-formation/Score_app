import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/custom_appbar.dart';
import '../../../shared/theme_data.dart';


class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      extendBodyBehindAppBar: true,

      appBar: CustomAppBar(title: 'Contact Us', leading: IconButton(onPressed: (){ Navigator.pop(context);}, icon: const Icon(Icons.arrow_back, color: Colors.white,)),),

      body: Column(
        children: [

          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 70,
              bottom: 30,
            ),
            decoration: BoxDecoration(
              color: lightColorScheme.secondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.headset_mic_rounded,
                  size: 70,
                  color: Colors.white,
                ),
                const SizedBox(height: 20),
                const Text(
                  'We\'re here to help!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Reach out to us through any of these channels',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20.0,),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Website Card
                _buildContactCard(
                  icon: Icons.language,
                  title: 'Visit our website',
                  subtitle: 'www.waosport.com',
                ),

                const SizedBox(height: 16),


                _buildContactCard(
                  icon: Icons.email_outlined,
                  title: 'Email us',
                  subtitle: 'waosport@gmail.com',
                ),

                const SizedBox(height: 16),


                _buildContactCard(
                  icon: Icons.phone_outlined,
                  title: 'Call us',
                  subtitle: '+233 242 786 261',
                ),

                const SizedBox(height: 30),


                Text(
                  'Connect with us',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),

                const SizedBox(height: 20),

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
        ],
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: lightColorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: lightColorScheme.secondary,
              ),
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
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 15,
                      color: lightColorScheme.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
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