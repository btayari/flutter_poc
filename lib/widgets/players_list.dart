import 'package:flutter/material.dart';
import '../models/player.dart';
import '../data/data_provider.dart';

class PlayersListWidget extends StatelessWidget {
  final List<Player> players;

  const PlayersListWidget({
    super.key,
    required this.players,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STARTING XI',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ...players.map((player) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1e2736),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: player.isStarPlayer
                    ? const Color(0xFF0d59f2).withOpacity(0.3)
                    : Colors.grey[800]!,
              ),
            ),
            child: Row(
              children: [
                // Player Avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: player.position == PlayerPosition.goalkeeper
                          ? Colors.yellow[700]!
                          : player.isStarPlayer
                              ? const Color(0xFF0d59f2)
                              : Colors.grey[600]!,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      player.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[700],
                          child: Icon(
                            Icons.person,
                            color: Colors.grey[500],
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Player Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DataProvider.getPositionName(player.position),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: player.isStarPlayer
                        ? const Color(0xFF0d59f2)
                        : const Color(0xFF0f172a),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    player.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: player.isStarPlayer
                          ? Colors.white
                          : player.position == PlayerPosition.goalkeeper
                              ? Colors.yellow[700]
                              : Colors.white,
                    ),
                  ),
                ),
                if (player.isStarPlayer) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.star,
                    size: 18,
                    color: Color(0xFF0d59f2),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
}
