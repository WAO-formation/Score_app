import 'dart:async';
import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/custom_text.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import '../../Teams/model/team_model.dart';
import '../model/live_score.dart' as LiveScore;
import '../view_model/match-state.dart';
import '../view_model/secure_storage.dart';

class ScoreBoard extends StatefulWidget {
  final String matchId;

  const ScoreBoard({Key? key, required this.matchId}) : super(key: key);

  @override
  State<ScoreBoard> createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard>
    with TickerProviderStateMixin {
  late LiveScore.LiveMatch currentMatch;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _countdownTimer;
  late MatchStateManager _matchManager;
  StreamSubscription<LiveScore.LiveMatch>? _matchSubscription;

  // Track if extra time has been added to current quarter
  bool _extraTimeAdded = false;

  // Track original quarter duration for comparison
  Duration? _originalQuarterDuration;

  @override
  void initState() {
    super.initState();
    _matchManager = MatchStateManager();
    _initializeMatch();

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  Future<void> _initializeMatch() async {
    // Try to get match from state manager first
    final match = _matchManager.getMatchById(widget.matchId);
    if (match != null) {
      currentMatch = match;
    } else {
      // Fallback to sample data if not found
      currentMatch = LiveScore.LiveMatch.getSampleLiveMatches().firstWhere(
            (m) => m.id == widget.matchId,
        orElse: () => throw Exception('Match not found'),
      );
    }

    // Initialize original quarter duration tracking
    _originalQuarterDuration = currentMatch.quarterDuration;

    // Subscribe to match updates
    _matchSubscription = _matchManager.getMatchStream(widget.matchId).listen(
          (updatedMatch) {
        if (mounted) {
          setState(() {
            currentMatch = updatedMatch;
          });
          _updateAnimationState();
        }
      },
    );

    _updateAnimationState();

    if (mounted) {
      setState(() {});
    }
  }

  void _updateAnimationState() {
    if (currentMatch.isLive) {
      _pulseController.repeat(reverse: true);
      _startCountdownTimer();
    } else {
      _pulseController.stop();
      _stopCountdownTimer();
    }
  }

  void _stopCountdownTimer() {
    _countdownTimer?.cancel();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countdownTimer?.cancel();
    _matchSubscription?.cancel();
    super.dispose();
  }

  Future<void> _toggleMatchStatus() async {
    LiveScore.MatchStatus newStatus;
    if (currentMatch.isLive) {
      newStatus = LiveScore.MatchStatus.paused;
    } else if (currentMatch.isPaused) {
      newStatus = LiveScore.MatchStatus.live;
    } else {
      return; // Can't toggle if match is ended
    }

    final updatedMatch = currentMatch.copyWith(status: newStatus);
    await _matchManager.updateMatch(updatedMatch);

    // Save to secure storage
    await SecureStorageService.storeMatches([updatedMatch]);
  }

  Future<void> _updateScore(String teamId, String category, double value) async {
    await _matchManager.updateMatchScore(widget.matchId, teamId, category, value);
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (currentMatch.isLive && _remainingTime.inSeconds > 0) {
        final updatedMatch = currentMatch.copyWith(
          currentTime: currentMatch.currentTime + const Duration(seconds: 1),
        );
        _matchManager.updateMatch(updatedMatch);
      } else if (_remainingTime.inSeconds <= 0) {
        // Time's up - handle based on quarter and extra time status
        timer.cancel();
        _handleTimeUp();
      }
    });
  }

  Future<void> _handleTimeUp() async {
    // Pause the match when time is up
    final pausedMatch = currentMatch.copyWith(status: LiveScore.MatchStatus.paused);
    await _matchManager.updateMatch(pausedMatch);

    if (mounted) {
      // Show appropriate dialog based on quarter and extra time status
      if (currentMatch.currentQuarter == LiveScore.Quarter.fourth) {
        // End of 4th quarter
        if (_extraTimeAdded) {
          // Extra time was added and now expired - automatically end match
          await _endMatch();
        } else {
          // Regular 4th quarter end - show add time or end match options
          _showFourthQuarterEndDialog();
        }
      } else {
        // End of quarters 1, 2, or 3
        if (_extraTimeAdded) {
          // Extra time was added and now expired - only show next quarter option
          _showNextQuarterDialog();
        } else {
          // Regular quarter end - show add time or next quarter options
          _showQuarterEndDialog();
        }
      }
    }
  }

  void _showQuarterEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('${currentMatch.quarterDisplayString} Ended'),
        content: Text('What would you like to do?'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.timer_outlined),
            label: const Text('Add Extra Time'),
            onPressed: () {
              Navigator.of(context).pop();
              _showAddExtraTimeDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.skip_next),
            label: const Text('Next Quarter'),
            onPressed: () {
              Navigator.of(context).pop();
              _moveToNextQuarter();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showFourthQuarterEndDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('4th Quarter Ended'),
        content: const Text('What would you like to do?'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.timer_outlined),
            label: const Text('Add Extra Time'),
            onPressed: () {
              Navigator.of(context).pop();
              _showAddExtraTimeDialog();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.stop),
            label: const Text('End Match'),
            onPressed: () {
              Navigator.of(context).pop();
              _endMatch();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showNextQuarterDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Extra Time Ended'),
        content: Text('Extra time has expired. Ready to start the next quarter?'),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Next Quarter'),
            onPressed: () {
              Navigator.of(context).pop();
              _moveToNextQuarter();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _showAddExtraTimeDialog() {
    final TextEditingController minutesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Extra Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Add extra time to ${currentMatch.quarterDisplayString}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: minutesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Minutes to add',
                hintText: 'Enter number of minutes',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final String input = minutesController.text.trim();
              if (input.isNotEmpty) {
                final int? minutesToAdd = int.tryParse(input);
                if (minutesToAdd != null && minutesToAdd > 0) {
                  await _addExtraTime(minutesToAdd);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid number of minutes')),
                  );
                }
              }
            },
            child: const Text('Add Time'),
          ),
        ],
      ),
    );
  }

  Future<void> _addExtraTime(int minutes) async {
    // Reset current time to the added extra time
    final extraTime = Duration(minutes: minutes);

    // Mark that extra time has been added
    _extraTimeAdded = true;

    final updatedMatch = currentMatch.copyWith(
      currentTime: Duration.zero, // Reset to start of extra time
      status: LiveScore.MatchStatus.live, // Resume the match
    );

    await _matchManager.updateMatch(updatedMatch);

    // Add event for extra time
    await _addEvent(
      LiveScore.EventType.timeout,
      currentMatch.teamA.id, // Neutral event
      'Extra time added: $minutes minutes',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $minutes minutes of extra time'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _moveToNextQuarter() async {
    LiveScore.Quarter nextQuarter;

    switch (currentMatch.currentQuarter) {
      case LiveScore.Quarter.first:
        nextQuarter = LiveScore.Quarter.second;
        break;
      case LiveScore.Quarter.second:
        nextQuarter = LiveScore.Quarter.third;
        break;
      case LiveScore.Quarter.third:
        nextQuarter = LiveScore.Quarter.fourth;
        break;
      case LiveScore.Quarter.fourth:
        nextQuarter = LiveScore.Quarter.extraTime;
        break;
      default:
      // If already in extra time, end the match
        await _endMatch();
        return;
    }

    // Reset extra time flag for new quarter
    _extraTimeAdded = false;

    final nextQuarterMatch = currentMatch.copyWith(
      currentQuarter: nextQuarter,
      currentTime: Duration.zero,
      status: LiveScore.MatchStatus.paused, // Pause between quarters
    );

    await _matchManager.updateMatch(nextQuarterMatch);

    // Add event for quarter change
    await _addEvent(
      LiveScore.EventType.timeout,
      currentMatch.teamA.id, // Neutral event
      'Quarter changed to ${nextQuarter.name}',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Moved to ${nextQuarter.name.toUpperCase()}'),
          backgroundColor: Colors.blue,
        ),
      );
    }
  }

  Future<void> _endMatch() async {
    final endedMatch = currentMatch.copyWith(
      status: LiveScore.MatchStatus.ended,
      endTime: DateTime.now(),
    );

    await _matchManager.updateMatch(endedMatch);

    // Add event for match end
    await _addEvent(
      LiveScore.EventType.timeout,
      currentMatch.teamA.id, // Neutral event
      'Match ended',
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Match has ended'),
          backgroundColor: Colors.red,
        ),
      );

      // Navigate back to live scores page after a delay
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pop();
        }
      });
    }
  }

  Duration get _remainingTime {
    Duration quarterDuration;

    if (_extraTimeAdded) {
      // If extra time was added, calculate based on the extra time duration
      // This would need to be tracked separately or calculated differently
      // For now, using a default extra time duration
      quarterDuration = const Duration(minutes: 5); // Default extra time
    } else {
      quarterDuration = currentMatch.quarterDuration;
    }

    Duration elapsed = currentMatch.currentTime;
    Duration remaining = quarterDuration - elapsed;
    return remaining.isNegative ? Duration.zero : remaining;
  }

  String get _countdownDisplayString {
    Duration remaining = _remainingTime;
    int minutes = remaining.inMinutes;
    int seconds = remaining.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Future<void> _addEvent(LiveScore.EventType type, String teamId, String description) async {
    final newEvent = LiveScore.MatchEvent(
      id: '${DateTime.now().millisecondsSinceEpoch}_${widget.matchId}',
      type: type,
      teamId: teamId,
      timestamp: DateTime.now(),
      quarter: currentMatch.currentQuarter,
      matchTime: currentMatch.currentTime,
      description: description,
    );

    await _matchManager.addEventToMatch(widget.matchId, newEvent);

    // Update goals if it's a goal event
    if (type == LiveScore.EventType.goal) {
      if (teamId == currentMatch.teamA.id) {
        final updatedScore = currentMatch.teamAScore.copyWith(
          goals: currentMatch.teamAScore.goals + 1,
        );
        final updatedMatch = currentMatch.copyWith(teamAScore: updatedScore);
        await _matchManager.updateMatch(updatedMatch);
      } else {
        final updatedScore = currentMatch.teamBScore.copyWith(
          goals: currentMatch.teamBScore.goals + 1,
        );
        final updatedMatch = currentMatch.copyWith(teamBScore: updatedScore);
        await _matchManager.updateMatch(updatedMatch);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMatchHeader(),
            _buildScoreBoard(),
            _buildMatchControls(),
            _buildQuickActions(),
            _buildEventsList(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        currentMatch.displayTitle,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      backgroundColor: lightColorScheme.secondary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        // Save button
        IconButton(
          icon: const Icon(Icons.save),
          onPressed: () async {
            await SecureStorageService.storeMatches([currentMatch]);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Match data saved securely')),
            );
          },
        ),
        if (currentMatch.isLive || currentMatch.isPaused)
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: currentMatch.isLive ? _pulseAnimation.value : 1.0,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: currentMatch.isLive ? Colors.red : Colors.orange,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        currentMatch.isLive ? 'LIVE' : 'PAUSED',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      if (_extraTimeAdded) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.add_circle,
                          color: Colors.white,
                          size: 12,
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildMatchHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [lightColorScheme.secondary, lightColorScheme.secondary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // Match ID display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Match ID: ${currentMatch.id}',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTeamInfo(currentMatch.teamA, true),
              Column(
                children: [
                  const Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          currentMatch.quarterDisplayString,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_extraTimeAdded)
                          Text(
                            'EXTRA TIME',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              _buildTeamInfo(currentMatch.teamB, false),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              children: [
                Text(
                  _countdownDisplayString,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  _extraTimeAdded ? 'Extra Time Remaining' : 'Time Remaining',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(LiveScore.Teams team, bool isTeamA) {
    final score = isTeamA ? currentMatch.teamAScore : currentMatch.teamBScore;
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          child: Text(
            team.name.substring(0, 2).toUpperCase(),
            style: TextStyle(
              color: lightColorScheme.secondary,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          team.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          score.totalScore.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Goals display
        Container(
          margin: const EdgeInsets.only(top: 4),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            'Goals: ${score.goals}',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Icon(Icons.scoreboard, color: lightColorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Detailed Scores',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  'Auto-saved',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildDetailedScoreColumn(
                    currentMatch.teamAScore,
                    currentMatch.teamA.name,
                    currentMatch.teamA.id,
                  ),
                ),
                Container(
                  width: 1,
                  height: 200,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildDetailedScoreColumn(
                    currentMatch.teamBScore,
                    currentMatch.teamB.name,
                    currentMatch.teamB.id,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedScoreColumn(LiveScore.LiveScore score, String teamName, String teamId) {
    return Column(
      children: [
        Text(
          teamName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: lightColorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        _buildScoreRow('Kg', score.kingdom, Colors.purple, teamId),
        _buildScoreRow('Wk', score.workout, Colors.orange, teamId),
        _buildScoreRow('Gp', score.goalpost, Colors.green, teamId),
        _buildScoreRow('Jg', score.judges, Colors.blue, teamId),
        const Divider(),
        const SizedBox(height: 10.0),
        Row(
          children: [
            Text(
              'Total :',
              style: AppStyles.secondaryTitle,
            ),
            const SizedBox(width: 5.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: lightColorScheme.secondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                score.totalScore.toStringAsFixed(1),
                style: TextStyle(
                  color: lightColorScheme.secondary,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScoreRow(String label, double value, Color color, String teamId, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Row(
            children: [
              Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 20),
                    onPressed: () => _updateScore(teamId, label, (value - 1).clamp(0, 100)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 20),
                    onPressed: () => _updateScore(teamId, label, (value + 1).clamp(0, 100)),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.toStringAsFixed(1),
                  style: TextStyle(
                    color: color,
                    fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                    fontSize: isTotal ? 16 : 14,
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }

  // UPDATED: Match controls with specific button logic
  Widget _buildMatchControls() {
    Duration remaining = _remainingTime;
    bool isTimeUp = remaining.inSeconds <= 0;
    bool isLastQuarter = currentMatch.currentQuarter == LiveScore.Quarter.fourth ||
        currentMatch.currentQuarter == LiveScore.Quarter.extraTime;
    bool isExtraTime = currentMatch.currentQuarter == LiveScore.Quarter.extraTime;
    bool canAddExtraTime = !_extraTimeAdded || (isTimeUp && !isExtraTime);
    bool canStartMatch = !isTimeUp || !isLastQuarter;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Match Controls',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: lightColorScheme.secondary,
                ),
              ),
              const Spacer(),
              if (_extraTimeAdded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'EXTRA TIME',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple[700],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Status information
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isTimeUp
                        ? (isLastQuarter
                        ? 'Last quarter time is up!'
                        : 'Quarter time is up!')
                        : 'Match is ${currentMatch.isLive ? "running" : "paused"}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isTimeUp ? Colors.red[600] : Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Scrollable control buttons with specific logic
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Pause/Start Button
                _buildControlButton(
                  label: currentMatch.isLive ? 'Pause' : 'Start',
                  color: currentMatch.isLive ? Colors.orange : Colors.green,
                  onPressed: canStartMatch ? _toggleMatchStatus : null,
                  isDisabled: !canStartMatch,
                  disabledReason: isTimeUp && isLastQuarter
                      ? 'Cannot start - last quarter is over'
                      : null,
                  icon: currentMatch.isLive ? Icons.pause : Icons.play_arrow,
                ),
                const SizedBox(width: 8),

                // End Match Button (only show in last quarter)
                if (isLastQuarter)
                  _buildControlButton(
                    label: 'End Match',
                    color: Colors.red,
                    onPressed: () => _showManualEndMatchDialog(),
                    icon: Icons.stop,
                  ),
                if (isLastQuarter) const SizedBox(width: 8),

                // Add Extra Time Button
                _buildControlButton(
                  label: _extraTimeAdded ? 'Add More Time' : 'Add Extra Time',
                  color: Colors.purple,
                  onPressed: canAddExtraTime ? () => _showAddExtraTimeDialog() : null,
                  isDisabled: !canAddExtraTime,
                  disabledReason: _extraTimeAdded && isExtraTime && isTimeUp
                      ? 'Extra time is over'
                      : _extraTimeAdded && !isTimeUp
                      ? 'Extra time is running'
                      : null,
                  icon: Icons.timer_outlined,
                ),
                const SizedBox(width: 8),

                // Next Quarter Button (only if not in last quarter and time is up)
                if (!isLastQuarter && isTimeUp)
                  _buildControlButton(
                    label: 'Next Quarter',
                    color: Colors.blue,
                    onPressed: () => _moveToNextQuarter(),
                    icon: Icons.skip_next,
                  ),
                if (!isLastQuarter && isTimeUp) const SizedBox(width: 8),

                // Save Match Button
                _buildControlButton(
                  label: 'Save Match',
                  color: Colors.teal,
                  onPressed: () async {
                    await SecureStorageService.storeMatches([currentMatch]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Match data saved securely'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  icon: Icons.save,
                ),
              ],
            ),
          ),

          // Additional information based on state
          if (isTimeUp) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber[50],
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.amber[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, size: 16, color: Colors.amber[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isLastQuarter
                          ? 'Match can be ended or extra time can be added'
                          : 'Quarter ended - add extra time or move to next quarter',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.amber[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // NEW: Enhanced control button with disabled state support
  Widget _buildControlButton({
    required String label,
    required Color color,
    required VoidCallback? onPressed,
    bool isDisabled = false,
    String? disabledReason,
    IconData? icon,
  }) {
    return Tooltip(
      message: isDisabled && disabledReason != null ? disabledReason : label,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled ? Colors.grey[300] : color,
          foregroundColor: isDisabled ? Colors.grey[600] : Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: isDisabled ? 0 : 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // UPDATED: Enhanced manual end match dialog
  void _showManualEndMatchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            const Text('End Match'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Are you sure you want to end this match?'),
            const SizedBox(height: 8),
            Text(
              'Current Status:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            Text(
              '• Quarter: ${currentMatch.quarterDisplayString}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(
              '• Time: ${_countdownDisplayString}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            if (_extraTimeAdded)
              Text(
                '• Extra time was added',
                style: TextStyle(fontSize: 12, color: Colors.purple[600]),
              ),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.red[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await _endMatch();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('End Match'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: lightColorScheme.secondary,
            ),
          ),
          const SizedBox(height: 16),
          // Make quick action chips horizontally scrollable
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildQuickActionChip('Goal', Icons.sports_soccer, Colors.green),
                const SizedBox(width: 8),
                _buildQuickActionChip('Bounce', Icons.sports_basketball, Colors.orange),
                const SizedBox(width: 8),
                _buildQuickActionChip('Foul', Icons.warning, Colors.red),
                const SizedBox(width: 8),
                _buildQuickActionChip('Timeout', Icons.timer, Colors.blue),
                const SizedBox(width: 8),
                _buildQuickActionChip('Injury', Icons.local_hospital, Colors.purple),
                const SizedBox(width: 8),
                _buildQuickActionChip('Substitution', Icons.swap_horiz, Colors.teal),
                const SizedBox(width: 8),
                _buildQuickActionChip('Skill Show', Icons.star, Colors.amber),
                const SizedBox(width: 8),
                _buildQuickActionChip('Sacrifice', Icons.flash_on, Colors.deepOrange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionChip(String label, IconData icon, Color color) {
    return ActionChip(
      avatar: Icon(icon, color: color, size: 18),
      label: Text(label),
      onPressed: () => _showEventDialog(label),
      backgroundColor: color.withOpacity(0.1),
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildEventsList() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              children: [
                Icon(Icons.event_note, color: lightColorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Match Events',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: lightColorScheme.secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${currentMatch.events.length} events',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: currentMatch.events.isEmpty
                ? Center(
              child: Text(
                'No events recorded yet',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            )
                : ListView.builder(
              itemCount: currentMatch.events.length,
              itemBuilder: (context, index) {
                final event = currentMatch.events[index];
                return _buildEventTile(event);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTile(LiveScore.MatchEvent event) {
    final time = "${event.matchTime.inMinutes}:${(event.matchTime.inSeconds % 60).toString().padLeft(2, '0')}";
    final teamName = event.teamId == currentMatch.teamA.id
        ? currentMatch.teamA.name
        : currentMatch.teamB.name;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _getEventColor(event.type).withOpacity(0.1),
        child: Icon(
          _getEventIcon(event.type),
          color: _getEventColor(event.type),
          size: 20,
        ),
      ),
      title: Text(
        event.type.name.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(event.description),
          Text(
            '$teamName • ${event.quarter.name.toUpperCase()} • $time',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          Text(
            'Event ID: ${event.id}',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
      trailing: Text(
        time,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: lightColorScheme.secondary,
        ),
      ),
    );
  }

  IconData _getEventIcon(LiveScore.EventType type) {
    switch (type) {
      case LiveScore.EventType.goal:
        return Icons.sports_soccer;
      case LiveScore.EventType.bounce:
        return Icons.sports_basketball;
      case LiveScore.EventType.foul:
        return Icons.warning;
      case LiveScore.EventType.timeout:
        return Icons.timer;
      case LiveScore.EventType.injury:
        return Icons.local_hospital;
      case LiveScore.EventType.substitution:
        return Icons.swap_horiz;
      case LiveScore.EventType.skillShow:
        return Icons.star;
      case LiveScore.EventType.sacrifice:
        return Icons.flash_on;
      case LiveScore.EventType.goalSetting:
        return Icons.flag;
      default:
        return Icons.event;
    }
  }

  Color _getEventColor(LiveScore.EventType type) {
    switch (type) {
      case LiveScore.EventType.goal:
        return Colors.green;
      case LiveScore.EventType.bounce:
        return Colors.orange;
      case LiveScore.EventType.foul:
        return Colors.red;
      case LiveScore.EventType.timeout:
        return Colors.blue;
      case LiveScore.EventType.injury:
        return Colors.purple;
      case LiveScore.EventType.substitution:
        return Colors.teal;
      case LiveScore.EventType.skillShow:
        return Colors.amber;
      case LiveScore.EventType.sacrifice:
        return Colors.deepOrange;
      case LiveScore.EventType.goalSetting:
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }

  void _showEventDialog(String eventType) {
    String selectedTeam = currentMatch.teamA.id;
    String description = '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add $eventType Event'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedTeam,
                  decoration: const InputDecoration(labelText: 'Team'),
                  items: [
                    DropdownMenuItem(
                      value: currentMatch.teamA.id,
                      child: Text(currentMatch.teamA.name),
                    ),
                    DropdownMenuItem(
                      value: currentMatch.teamB.id,
                      child: Text(currentMatch.teamB.name),
                    ),
                  ],
                  onChanged: (value) => setState(() => selectedTeam = value!),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter event description...',
                  ),
                  onChanged: (value) => description = value,
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (description.isNotEmpty) {
                await _addEvent(
                  _getEventTypeFromString(eventType),
                  selectedTeam,
                  description,
                );
                Navigator.of(context).pop();
              }
            },
            child: const Text('Add Event'),
          ),
        ],
      ),
    );
  }

  LiveScore.EventType _getEventTypeFromString(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'goal':
        return LiveScore.EventType.goal;
      case 'bounce':
        return LiveScore.EventType.bounce;
      case 'foul':
        return LiveScore.EventType.foul;
      case 'timeout':
        return LiveScore.EventType.timeout;
      case 'injury':
        return LiveScore.EventType.injury;
      case 'substitution':
        return LiveScore.EventType.substitution;
      case 'skill show':
        return LiveScore.EventType.skillShow;
      case 'sacrifice':
        return LiveScore.EventType.sacrifice;
      default:
        return LiveScore.EventType.skillShow;
    }
  }
}