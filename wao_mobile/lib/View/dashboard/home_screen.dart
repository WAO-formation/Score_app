import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wao_mobile/View/dashboard/widgets/LiveMatchesCarousel.dart';
import 'package:wao_mobile/core/theme/app_typography.dart';

import '../../ViewModel/teams_games/match_viewmodel.dart';
import '../../ViewModel/teams_games/team_viewmodel.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: StreamBuilder<DocumentSnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .doc(currentUser?.uid)
                            .snapshots(),
                        builder: (context, snapshot) {
                          String name = "User";
                          String? profilePic;

                          if (snapshot.hasData && snapshot.data!.exists) {
                            final data = snapshot.data!.data() as Map<String, dynamic>;
                            name = data['username'] ?? "User";
                            profilePic = data['profilePicture'];
                          }

                          return Row(
                            children: [
                              _buildUserAvatar(name, profilePic),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Welcome Back!",
                                      style: TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 2.0),
                                    Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildNotificationBell(isDarkMode),
                  ],
                ),

                const SizedBox(height: 25.0),

                // promo card
                const LiveMatchesCarousel(),

                const SizedBox(height: 25.0),

                // upcoming matches

                // Add this button to seed data
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Seed teams first
                      await context.read<TeamViewModel>().seedWaoTeams();

                      // Then seed matches
                      await context.read<MatchViewModel>().seedMatches();

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✅ Database seeded successfully!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('❌ Error: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: const Text('Seed Database'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationBell(bool isDarkMode) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            color: isDarkMode ? const Color(0xFFFFC600) : const Color(0xFF011B3B),
          ),
        ),
        Positioned(
          right: 10,
          top: 10,
          child: Container(
            height: 8,
            width: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFFE0000),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserAvatar(String name, String? imageUrl) {
    String initial = name.isNotEmpty ? name[0].toUpperCase() : "U";

    return CircleAvatar(
      radius: 22.0,
      backgroundColor: const Color(0xFFFFC600).withOpacity(0.15),
      backgroundImage: imageUrl != null && imageUrl.isNotEmpty
          ? NetworkImage(imageUrl)
          : null,
      child: imageUrl == null || imageUrl.isEmpty
          ? Text(
        initial,
        style: const TextStyle(
          color: Color(0xFFFFC600),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      )
          : null,
    );
  }
}