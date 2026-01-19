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
  final String displayPosition; // e.g., GK, CB, CAM
  final int age;
  final bool isStarPlayer;
  final int shirtNumber;
  final String club; // Current club (e.g., "Manchester City", "Liverpool")
  final bool isSuggested; // Is this a suggested player from another club?

  const Player({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.position,
    required this.displayPosition,
    required this.age,
    this.isStarPlayer = false,
    this.shirtNumber = 0,
    this.club = 'Manchester City',
    this.isSuggested = false,
  });

  Player copyWith({
    String? name,
    String? imageUrl,
    double? rating,
    PlayerPosition? position,
    String? displayPosition,
    int? age,
    bool? isStarPlayer,
    int? shirtNumber,
    String? club,
    bool? isSuggested,
  }) {
    return Player(
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      rating: rating ?? this.rating,
      position: position ?? this.position,
      displayPosition: displayPosition ?? this.displayPosition,
      age: age ?? this.age,
      isStarPlayer: isStarPlayer ?? this.isStarPlayer,
      shirtNumber: shirtNumber ?? this.shirtNumber,
      club: club ?? this.club,
      isSuggested: isSuggested ?? this.isSuggested,
    );
  }
}
