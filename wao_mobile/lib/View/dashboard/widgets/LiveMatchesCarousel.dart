import 'dart:async';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';

import '../../../Model/teams_games/wao_match.dart';
import '../../../ViewModel/teams_games/match_viewmodel.dart';
import '../../games_details/live_game_details.dart';

class LiveMatchesCarousel extends StatelessWidget {
  const LiveMatchesCarousel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<List<WaoMatch>>(
      stream: Provider.of<MatchViewModel>(context, listen: false).getLiveMatches(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF011B3B), Color(0xFF022D62)],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFC600)),
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return _buildPromoCard(isDarkMode);
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _buildPromoCard(isDarkMode);
        }

        final liveMatches = snapshot.data!;
        // Only auto-scroll when there is more than one live game
        final shouldAutoPlay = liveMatches.length > 1;

        return CarouselSlider(
          options: CarouselOptions(
            height: 180,
            autoPlay: shouldAutoPlay,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration: const Duration(milliseconds: 1500),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            viewportFraction: 1.03,
            enableInfiniteScroll: liveMatches.length > 1,
          ),
          items: [
            ...liveMatches.asMap().entries.map((entry) {
              final bool useRedYellow = entry.key % 2 == 1;
              return _buildLiveMatchCard(entry.value, isDarkMode, useRedYellow, context);
            }).toList(),
            _buildPromoCard(isDarkMode),
          ],
        );
      },
    );
  }

  Widget _buildLiveMatchCard(WaoMatch match, bool isDarkMode, bool useRedYellow, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LiveGamesDetails(match: match)),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: useRedYellow
                ? [const Color(0xFFD30336), const Color(0xFFFF6B35)]
                : [const Color(0xFF011B3B), const Color(0xFFD30336)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
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
                  opacity: 0.1,
                  child: Image.asset(
                    "assets/images/wao-ball.png",
                    width: 230,
                    errorBuilder: (_, __, ___) => const SizedBox(),
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
                              const Icon(Icons.location_on, color: Colors.white70, size: 12),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  match.venue,
                                  style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        _LiveBadge(startTime: match.startTime, isPlaying: match.isPlaying),
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
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/logos/default_team.png",
                                    width: 35, height: 35, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white, size: 25),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                match.teamAName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, height: 1.2),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Row(
                            children: [
                              Text('${match.scoreA}', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Text(':', style: TextStyle(color: Colors.white70, fontSize: 22, fontWeight: FontWeight.bold)),
                              ),
                              Text('${match.scoreB}', style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
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
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    "assets/logos/default_team.png",
                                    width: 35, height: 35, fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.shield, color: Colors.white, size: 25),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                match.teamBName,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600, height: 1.2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Text(
                      match.type.name.toUpperCase(),
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPromoCard(bool isDarkMode) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF011B3B), Color(0xFF022D62)],
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: Stack(
          children: [
            Positioned(
              bottom: -80, right: -80,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset("assets/images/wao-ball.png", width: 230, errorBuilder: (_, __, ___) => const SizedBox()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFC600).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("JOIN NOW", style: TextStyle(color: Color(0xFFFFC600), fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("JOIN US", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(
                              'Get notified whenever WAO training is on',
                              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16, height: 1.4),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(color: const Color(0xFFFFC600), borderRadius: BorderRadius.circular(12)),
                        child: const Text("Notify Me", style: TextStyle(color: Color(0xFF011B3B), fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Live badge that shows a ticking elapsed timer (mm:ss) next to the pulsing dot
class _LiveBadge extends StatefulWidget {
  final DateTime startTime;
  final bool isPlaying;
  const _LiveBadge({required this.startTime, required this.isPlaying});

  @override
  State<_LiveBadge> createState() => _LiveBadgeState();
}

class _LiveBadgeState extends State<_LiveBadge> {
  late Timer _timer;
  late Duration _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = DateTime.now().difference(widget.startTime);
    if (_elapsed.isNegative) _elapsed = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _elapsed = DateTime.now().difference(widget.startTime);
          if (_elapsed.isNegative) _elapsed = Duration.zero;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String get _timeLabel {
    final m = _elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = _elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFC600).withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFC600), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PulsingDot(),
          const SizedBox(width: 5),
          const Text("LIVE", style: TextStyle(color: Color(0xFFFFC600), fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(width: 5),
          Text(
            _timeLabel,
            style: const TextStyle(color: Color(0xFFFFC600), fontSize: 10, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// Pulsing dot animation for LIVE badge
class _PulsingDot extends StatefulWidget {
  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        width: 6, height: 6,
        decoration: const BoxDecoration(color: Color(0xFFFFC600), shape: BoxShape.circle),
      ),
    );
  }
}
