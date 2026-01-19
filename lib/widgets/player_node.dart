import 'package:flutter/material.dart';
import '../models/player.dart';

class PlayerNode extends StatelessWidget {
  final Player player;

  const PlayerNode({
    super.key,
    required this.player,
  });

  @override
  Widget build(BuildContext context) {
    final isGoalkeeper = player.position == PlayerPosition.goalkeeper;
    final borderColor = isGoalkeeper
        ? Colors.yellow[700]!
        : player.isStarPlayer
            ? const Color(0xFF0d59f2)
            : Colors.white;

    final avatarSize = player.isStarPlayer && !isGoalkeeper ? 48.0 : 40.0;

    return GestureDetector(
      onTap: () {
        // Handle player tap
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Player avatar
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: player.isStarPlayer
                          ? borderColor.withOpacity(0.3)
                          : Colors.black.withOpacity(0.3),
                      blurRadius: player.isStarPlayer ? 12 : 8,
                      spreadRadius: player.isStarPlayer ? 2 : 0,
                    ),
                  ],
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
                          size: avatarSize * 0.6,
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Rating badge
              Positioned(
                top: -4,
                right: -8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: player.isStarPlayer
                        ? const Color(0xFF0d59f2)
                        : const Color(0xFF0f172a),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: player.isStarPlayer
                          ? const Color(0xFF0d59f2).withOpacity(0.3)
                          : isGoalkeeper
                              ? Colors.yellow[700]!.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    player.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: player.isStarPlayer ? 11 : 10,
                      fontWeight: FontWeight.bold,
                      color: player.isStarPlayer
                          ? Colors.white
                          : isGoalkeeper
                              ? Colors.yellow[700]
                              : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Player name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
              ),
            ),
            child: Text(
              player.name,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
