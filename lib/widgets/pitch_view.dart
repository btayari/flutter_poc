import 'package:flutter/material.dart';
import '../widgets/pitch_background.dart';
import '../widgets/player_node.dart';
import '../models/player.dart';
import '../models/formation.dart';

class PitchView extends StatelessWidget {
  final List<Player> players;
  final Formation formation;

  const PitchView({
    super.key,
    required this.players,
    required this.formation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[800]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Pitch Background
                const PitchBackground(),

                // Players positioned on pitch
                _buildPlayersOnPitch(constraints),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlayersOnPitch(BoxConstraints constraints) {
    return Stack(
      children: formation.positions.map((posData) {
        return _positionPlayer(
          players[posData.playerIndex],
          posData.x,
          posData.y,
          constraints,
        );
      }).toList(),
    );
  }

  Widget _positionPlayer(
    Player player,
    double leftPercent,
    double topPercent,
    BoxConstraints constraints,
  ) {
    return Positioned(
      left: constraints.maxWidth * leftPercent,
      top: constraints.maxHeight * topPercent,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: PlayerNode(player: player),
      ),
    );
  }
}
