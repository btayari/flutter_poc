enum PlayerPosition {
  goalkeeper,
  defender,
  midfielder,
  forward,
}

class Player {
  final String name;
  final String imageUrl;
  final double rating;
  final PlayerPosition position;
  final bool isStarPlayer;

  const Player({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.position,
    this.isStarPlayer = false,
  });
}
