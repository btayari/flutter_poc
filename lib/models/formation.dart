class Formation {
  final String name;
  final String displayName;
  final List<PlayerPositionData> positions;

  const Formation({
    required this.name,
    required this.displayName,
    required this.positions,
  });
}

class PlayerPositionData {
  final int playerIndex;
  final double x;
  final double y;

  const PlayerPositionData({
    required this.playerIndex,
    required this.x,
    required this.y,
  });
}
