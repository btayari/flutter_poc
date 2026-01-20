class MatchPrediction {
  final String homeTeam;
  final String awayTeam;
  final String homeTeamLogo;
  final String awayTeamLogo;
  final DateTime matchDate;
  final String venue;
  final WinProbability winProbability;
  final PredictedStats predictedStats;
  final TacticalInsight tacticalInsight;
  final String confidenceLevel;
  final String modelVersion;

  MatchPrediction({
    required this.homeTeam,
    required this.awayTeam,
    required this.homeTeamLogo,
    required this.awayTeamLogo,
    required this.matchDate,
    required this.venue,
    required this.winProbability,
    required this.predictedStats,
    required this.tacticalInsight,
    required this.confidenceLevel,
    required this.modelVersion,
  });
}

class WinProbability {
  final double homeWin;
  final double draw;
  final double awayWin;

  WinProbability({
    required this.homeWin,
    required this.draw,
    required this.awayWin,
  });
}

class PredictedStats {
  final StatComparison expectedGoals;
  final StatComparison possession;
  final StatComparison shotsOnTarget;
  final StatComparison passCompletion;
  final StatComparison ppda;

  PredictedStats({
    required this.expectedGoals,
    required this.possession,
    required this.shotsOnTarget,
    required this.passCompletion,
    required this.ppda,
  });
}

class StatComparison {
  final dynamic homeValue;
  final dynamic awayValue;
  final String metric;

  StatComparison({
    required this.homeValue,
    required this.awayValue,
    required this.metric,
  });
}

class TacticalInsight {
  final String title;
  final String description;

  TacticalInsight({
    required this.title,
    required this.description,
  });
}
