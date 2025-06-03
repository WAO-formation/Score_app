import 'package:flutter/material.dart';
import 'package:wao_mobile/shared/custom_text.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import '../../Teams/model/team_model.dart';
import '../model/live_score.dart' as LiveScore;

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

  @override
  void initState() {
    super.initState();
    currentMatch = LiveScore.LiveMatch.getSampleLiveMatches().firstWhere(
          (m) => m.id == widget.matchId,
      orElse: () => throw Exception('Match not found'),
    );

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (currentMatch.isLive) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _toggleMatchStatus() {
    setState(() {
      if (currentMatch.isLive) {
        currentMatch = currentMatch.copyWith(status: LiveScore.MatchStatus.paused);
        _pulseController.stop();
      } else if (currentMatch.isPaused) {
        currentMatch = currentMatch.copyWith(status: LiveScore.MatchStatus.live);
        _pulseController.repeat(reverse: true);
      }
    });
  }

  void _updateScore(String teamId, String category, double value) {
    setState(() {
      if (currentMatch.teamA.id == teamId) {
        LiveScore.LiveScore updatedScore;
        switch (category.toLowerCase()) {
          case 'kg':
          case 'kingdom':
            updatedScore = currentMatch.teamAScore.copyWith(kingdom: value);
            break;
          case 'wk':
          case 'workout':
            updatedScore = currentMatch.teamAScore.copyWith(workout: value);
            break;
          case 'gp':
          case 'goalpost':
            updatedScore = currentMatch.teamAScore.copyWith(goalpost: value);
            break;
          case 'jg':
          case 'judges':
            updatedScore = currentMatch.teamAScore.copyWith(judges: value);
            break;
          default:
            return;
        }
        currentMatch = currentMatch.copyWith(teamAScore: updatedScore);
      } else if (currentMatch.teamB.id == teamId) {
        LiveScore.LiveScore updatedScore;
        switch (category.toLowerCase()) {
          case 'kg':
          case 'kingdom':
            updatedScore = currentMatch.teamBScore.copyWith(kingdom: value);
            break;
          case 'wk':
          case 'workout':
            updatedScore = currentMatch.teamBScore.copyWith(workout: value);
            break;
          case 'gp':
          case 'goalpost':
            updatedScore = currentMatch.teamBScore.copyWith(goalpost: value);
            break;
          case 'jg':
          case 'judges':
            updatedScore = currentMatch.teamBScore.copyWith(judges: value);
            break;
          default:
            return;
        }
        currentMatch = currentMatch.copyWith(teamBScore: updatedScore);
      }
    });
  }

  void _updateMatchTime(Duration newTime) {
    setState(() {
      currentMatch = currentMatch.copyWith(currentTime: newTime);
    });
  }

  Duration get _remainingTime {
    Duration quarterDuration = currentMatch.quarterDuration;
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

  void _nextQuarter() {
    setState(() {
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
        case LiveScore.Quarter.extraTime:
          currentMatch = currentMatch.copyWith(status: LiveScore.MatchStatus.ended);
          _pulseController.stop();
          return;
      }
      currentMatch = currentMatch.copyWith(
        currentQuarter: nextQuarter,
        currentTime: Duration.zero,
      );
    });
  }

  void _addEvent(LiveScore.EventType type, String teamId, String description) {
    final newEvent = LiveScore.MatchEvent(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: type,
      teamId: teamId,
      timestamp: DateTime.now(),
      quarter: currentMatch.currentQuarter,
      matchTime: currentMatch.currentTime,
      description: description,
    );

    setState(() {
      currentMatch = currentMatch.copyWith(
        events: [...currentMatch.events, newEvent],
      );
    });
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
                  child: Text(
                    currentMatch.isLive ? 'LIVE' : 'PAUSED',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
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
                    child: Text(
                      currentMatch.quarterDisplayString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                  'Time Remaining',
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

  Widget _buildTeamInfo(Teams team, bool isTeamA) {
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

  Widget _buildMatchControls() {
    Duration remaining = _remainingTime;
    bool isLowTime = remaining.inSeconds <= 30 && remaining.inSeconds > 0;

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
          Text(
            'Match Controls',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: lightColorScheme.secondary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildControlButton(
                icon: currentMatch.isLive ? Icons.pause : Icons.play_arrow,
                label: currentMatch.isLive ? 'Pause' : 'Play',
                color: currentMatch.isLive ? Colors.orange : Colors.green,
                onPressed: _toggleMatchStatus,
              ),
              if (isLowTime || remaining == Duration.zero)
                _buildControlButton(
                  icon: Icons.timer,
                  label: 'Add Time',
                  color: Colors.purple,
                  onPressed: () => _showTimeAddDialog(),
                ),
              _buildControlButton(
                icon: Icons.skip_next,
                label: 'Next Quarter',
                color: lightColorScheme.secondary,
                onPressed: _nextQuarter,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
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
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildQuickActionChip('Goal', Icons.sports_soccer, Colors.green),
              _buildQuickActionChip('Bounce', Icons.sports_basketball, Colors.orange),
              _buildQuickActionChip('Foul', Icons.warning, Colors.red),
              _buildQuickActionChip('Timeout', Icons.timer, Colors.blue),
              _buildQuickActionChip('Injury', Icons.local_hospital, Colors.purple),
              _buildQuickActionChip('Substitution', Icons.swap_horiz, Colors.teal),
            ],
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

  void _showTimeAddDialog() {
    final TextEditingController minutesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Extra Time'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Current time remaining: ${_countdownDisplayString}',
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
            onPressed: () {
              final String input = minutesController.text.trim();
              if (input.isNotEmpty) {
                final int? minutesToAdd = int.tryParse(input);
                if (minutesToAdd != null && minutesToAdd > 0) {
                  Duration currentTime = currentMatch.currentTime;
                  Duration newTime = currentTime - Duration(minutes: minutesToAdd);

                  // Ensure we don't go negative
                  if (newTime.isNegative) {
                    newTime = Duration.zero;
                  }

                  _updateMatchTime(newTime);
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
            onPressed: () {
              if (description.isNotEmpty) {
                _addEvent(
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
      default:
        return LiveScore.EventType.skillShow;
    }
  }
}