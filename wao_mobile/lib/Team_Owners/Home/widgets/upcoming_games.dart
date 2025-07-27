import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wao_mobile/shared/theme_data.dart';
import '../../../provider/Models/coach_model.dart';
import '../../../shared/custom_text.dart';

class UpcomingGameCard extends StatelessWidget {
  final GameModel game;

  const UpcomingGameCard({super.key, required this.game});

  String formatGameStage(GameStage stage) {
    switch (stage) {
      case GameStage.groupStage:
        return 'Group Stage';
      case GameStage.roundOf16:
        return 'Round of 16';
      case GameStage.quarterFinal:
        return 'Quarter Final';
      case GameStage.semiFinal:
        return 'Semi Final';
      case GameStage.finalStage:
        return 'Final';
      case GameStage.none:
        return game.gameType == GameType.friendly
            ? 'Friendly'
            : 'League';
    }
  }

  Color getStageColor(GameStage stage) {
    switch (stage) {
      case GameStage.groupStage:
        return Colors.blue;
      case GameStage.roundOf16:
        return Colors.purple;
      case GameStage.quarterFinal:
        return Colors.deepOrange;
      case GameStage.semiFinal:
        return Colors.amber;
      case GameStage.finalStage:
        return Colors.redAccent;
      case GameStage.none:
        return game.gameType == GameType.friendly
            ? Colors.grey
            : Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('EEE, MMM d • hh:mm a').format(game.gameDateTime);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: lightColorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Opponent and Stage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                game.opponentName,
                style: AppStyles.secondaryTitle.copyWith(fontSize: 16.0, color: Colors.grey[100]),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: getStageColor(game.gameStage).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  formatGameStage(game.gameStage),
                  style: AppStyles.informationText.copyWith(
                    fontSize: 12.0,
                    color: getStageColor(game.gameStage),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          // Date
          Row(
            children: [
              Icon(Icons.calendar_today, size: 16, color: Colors.grey[200]),
              const SizedBox(width: 6),
              Text(
                formattedDate,
                style: AppStyles.informationText.copyWith(fontSize: 12, color: Colors.grey[100]),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Venue
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[200]),
              const SizedBox(width: 6),
              Text(
                game.venue,
                style: AppStyles.informationText.copyWith(fontSize: 12, color: Colors.grey[100]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
