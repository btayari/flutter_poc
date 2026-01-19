import '../models/player.dart';
import '../models/formation.dart';

class DataProvider {
  static final List<Player> players = [
    // Goalkeeper
    const Player(
      name: 'Ederson',
      imageUrl: 'assets/players/ederson.jpg',
      rating: 8.4,
      position: PlayerPosition.goalkeeper,
    ),
    // Defenders
    const Player(
      name: 'Gvardiol',
      imageUrl: 'assets/players/gvardiol.jpg',
      rating: 7.8,
      position: PlayerPosition.defender,
    ),
    const Player(
      name: 'Dias',
      imageUrl: 'assets/players/dias.jpg',
      rating: 8.1,
      position: PlayerPosition.defender,
    ),
    const Player(
      name: 'Akanji',
      imageUrl: 'assets/players/akanji.jpg',
      rating: 7.5,
      position: PlayerPosition.defender,
    ),
    const Player(
      name: 'Walker',
      imageUrl: 'assets/players/walker.jpg',
      rating: 7.6,
      position: PlayerPosition.defender,
    ),
    // Midfielders
    const Player(
      name: 'Kovačić',
      imageUrl: 'assets/players/kovacic.jpg',
      rating: 7.9,
      position: PlayerPosition.midfielder,
    ),
    const Player(
      name: 'Rodri',
      imageUrl: 'assets/players/rodri.jpg',
      rating: 9.1,
      position: PlayerPosition.midfielder,
      isStarPlayer: true,
    ),
    const Player(
      name: 'Bernardo',
      imageUrl: 'assets/players/bernardo.jpg',
      rating: 8.3,
      position: PlayerPosition.midfielder,
    ),
    // Forwards
    const Player(
      name: 'Doku',
      imageUrl: 'assets/players/doku.jpg',
      rating: 7.7,
      position: PlayerPosition.forward,
    ),
    const Player(
      name: 'Haaland',
      imageUrl: 'assets/players/haaland.jpg',
      rating: 9.4,
      position: PlayerPosition.forward,
      isStarPlayer: true,
    ),
    const Player(
      name: 'Foden',
      imageUrl: 'assets/players/foden.jpg',
      rating: 8.8,
      position: PlayerPosition.forward,
    ),
  ];

  static final Map<String, Formation> formations = {
    '4-3-3': Formation(
      name: '4-3-3',
      displayName: '4-3-3 Attack',
      positions: [
        // Forwards (3)
        PlayerPositionData(playerIndex: 8, x: 0.18, y: 0.24),
        PlayerPositionData(playerIndex: 9, x: 0.5, y: 0.20),
        PlayerPositionData(playerIndex: 10, x: 0.82, y: 0.24),
        // Midfielders (3)
        PlayerPositionData(playerIndex: 5, x: 0.25, y: 0.50),
        PlayerPositionData(playerIndex: 6, x: 0.5, y: 0.55),
        PlayerPositionData(playerIndex: 7, x: 0.75, y: 0.50),
        // Defenders (4)
        PlayerPositionData(playerIndex: 1, x: 0.15, y: 0.76),
        PlayerPositionData(playerIndex: 2, x: 0.38, y: 0.78),
        PlayerPositionData(playerIndex: 3, x: 0.62, y: 0.78),
        PlayerPositionData(playerIndex: 4, x: 0.85, y: 0.76),
        // Goalkeeper (1)
        PlayerPositionData(playerIndex: 0, x: 0.5, y: 0.92),
      ],
    ),
    '4-4-2': Formation(
      name: '4-4-2',
      displayName: '4-4-2 Classic',
      positions: [
        // Forwards (2)
        PlayerPositionData(playerIndex: 9, x: 0.35, y: 0.22),
        PlayerPositionData(playerIndex: 10, x: 0.65, y: 0.22),
        // Midfielders (4)
        PlayerPositionData(playerIndex: 8, x: 0.15, y: 0.45),
        PlayerPositionData(playerIndex: 5, x: 0.38, y: 0.50),
        PlayerPositionData(playerIndex: 6, x: 0.62, y: 0.50),
        PlayerPositionData(playerIndex: 7, x: 0.85, y: 0.45),
        // Defenders (4)
        PlayerPositionData(playerIndex: 1, x: 0.15, y: 0.76),
        PlayerPositionData(playerIndex: 2, x: 0.38, y: 0.78),
        PlayerPositionData(playerIndex: 3, x: 0.62, y: 0.78),
        PlayerPositionData(playerIndex: 4, x: 0.85, y: 0.76),
        // Goalkeeper (1)
        PlayerPositionData(playerIndex: 0, x: 0.5, y: 0.92),
      ],
    ),
  };

  static String getPositionName(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.goalkeeper:
        return 'Goalkeeper';
      case PlayerPosition.defender:
        return 'Defender';
      case PlayerPosition.midfielder:
        return 'Midfielder';
      case PlayerPosition.forward:
        return 'Forward';
    }
  }
}
