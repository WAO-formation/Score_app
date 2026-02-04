import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../../Model/teams_games/wao_match.dart';
import '../../../ViewModel/teams_games/match_viewmodel.dart';

class UpcomingMatchesCarousel extends StatelessWidget {
  const UpcomingMatchesCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<List<WaoMatch>>(
      stream: Provider.of<MatchViewModel>(context, listen: false).getUpcomingMatches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
              border: Border.all(
                color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFFFFC600)),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          print('Error loading upcoming matches: ${snapshot.error}');
          return _buildEmptyState(isDarkMode);
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildEmptyState(isDarkMode);
        }

        final upcomingMatches = snapshot.data!;

        return CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: false,
            enlargeCenterPage: true,
            viewportFraction: 1.03,
            enableInfiniteScroll: upcomingMatches.length > 1,
          ),
          items: upcomingMatches.asMap().entries.map((entry) {
            int index = entry.key;
            WaoMatch match = entry.value;
            return _buildUpcomingMatchCard(match, isDarkMode);
          }).toList(),
        );
      },
    );
  }

  Widget _buildUpcomingMatchCard(WaoMatch match, bool isDarkMode) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Positioned(
              bottom: -80,
              right: -80,
              child: Opacity(
                opacity: isDarkMode ? 0.03 : 0.05,
                child: Image.asset(
                  "assets/images/wao-ball.png",
                  width: 230,
                  color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: isDarkMode ? Colors.white60 : Colors.grey.shade600,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                match.venue,
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white60 : Colors.grey.shade600,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      _buildUpcomingBadge(isDarkMode),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC600).withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFFC600).withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/logos/default_team.png",
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.shield,
                                      color: isDarkMode ? Colors.white70 : const Color(0xFF011B3B),
                                      size: 25,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              match.teamAName,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC600).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFFFFC600).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'VS',
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _formatMatchDateTime(match.scheduledDate),
                              style: TextStyle(
                                color: isDarkMode ? Colors.white70 : const Color(0xFF011B3B),
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFC600).withOpacity(0.1),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFFFC600).withOpacity(0.3),
                                  width: 1.5,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/logos/default_team.png",
                                  width: 35,
                                  height: 35,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      Icons.shield,
                                      color: isDarkMode ? Colors.white70 : const Color(0xFF011B3B),
                                      size: 25,
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              match.teamBName,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Text(
                    match.type.name.toUpperCase(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white.withOpacity(0.4) : Colors.grey.shade500,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingBadge(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC600).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFFFC600),
          width: 1,
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            color: Color(0xFFFFC600),
            size: 12,
          ),
          SizedBox(width: 6),
          Text(
            "UPCOMING",
            style: TextStyle(
              color: Color(0xFFFFC600),
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDarkMode) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: isDarkMode ? Colors.white.withOpacity(0.05) : Colors.white,
        border: Border.all(
          color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Positioned(
              bottom: -80,
              right: -80,
              child: Opacity(
                opacity: isDarkMode ? 0.03 : 0.05,
                child: Image.asset(
                  "assets/images/wao-ball.png",
                  width: 230,
                  color: isDarkMode ? Colors.white : const Color(0xFF011B3B),
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox();
                  },
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: isDarkMode ? Colors.white.withOpacity(0.3) : Colors.grey.shade400,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No Upcoming Matches',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white.withOpacity(0.5) : Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMatchDateTime(DateTime? date) {
    if (date == null) return 'TBD';

    final now = DateTime.now();
    final difference = date.difference(now);

    if (difference.inDays == 0) {
      return 'Today ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}