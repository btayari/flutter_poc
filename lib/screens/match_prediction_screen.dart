import 'package:flutter/material.dart';
import '../models/match_prediction.dart';
import '../data/match_prediction_data.dart';

class MatchPredictionScreen extends StatelessWidget {
  const MatchPredictionScreen({super.key});

  String _formatMatchDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[date.month - 1];
    final day = date.day;
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$month $day, $hour:$minute';
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebLayout = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF101622),
      body: SafeArea(
        child: isWebLayout ? _buildWebLayout(context) : _buildMobileLayout(context),
      ),
    );
  }


  Widget _buildMobileLayout(BuildContext context) {
    final prediction = MatchPredictionData.getSamplePrediction();

    return Scaffold(
      backgroundColor: const Color(0xFF101622),
      appBar: AppBar(
        backgroundColor: const Color(0xFF101622),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Color(0xFF0d59f2), size: 28),
          onPressed: () => Navigator.of(context).pop(),
        ),
        leadingWidth: 40,
        titleSpacing: 0,
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Text(
                'Edit Lineup',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0d59f2),
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Prediction',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Match Header
              _buildMatchHeader(prediction),
              const SizedBox(height: 24),

              // Win Probability Section
              _buildWinProbabilitySection(prediction),
              const SizedBox(height: 24),

              // Predicted Key Stats
              _buildPredictedStatsSection(prediction),
              const SizedBox(height: 24),

              // Tactical Insight
              _buildTacticalInsight(prediction),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    final prediction = MatchPredictionData.getSamplePrediction();

    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          decoration: const BoxDecoration(
            color: Color(0xFF101622),
            border: Border(
              bottom: BorderSide(color: Color(0xFF374151)),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFF0d59f2), size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const SizedBox(width: 8),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Back to Lineup',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF0d59f2),
                    ),
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                'Match Prediction',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Action Buttons
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Compare Scenarios - Coming Soon')),
                    );
                  },
                  icon: const Icon(Icons.compare_arrows, size: 18),
                  label: const Text('Compare Scenarios'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF374151)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Export Report - Coming Soon')),
                    );
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Export Report'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0d59f2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Content
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Center(
              child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Match Header
                          _buildWebMatchHeader(prediction),
                          const SizedBox(height: 32),

                          // Main Content Grid
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Column - Win Probability
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildWinProbabilitySection(prediction),
                                    const SizedBox(height: 24),
                                    _buildTacticalInsight(prediction),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),

                              // Right Column - Predicted Stats
                              Expanded(
                                flex: 3,
                                child: _buildPredictedStatsSection(prediction),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

  Widget _buildMatchHeader(MatchPrediction prediction) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Home Team
        Expanded(
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1e293b),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.network(
                    prediction.homeTeamLogo,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1e293b),
                        child: const Icon(Icons.shield, color: Colors.white54),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                prediction.homeTeam,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // Match Info
        Expanded(
          child: Column(
            children: [
              const Text(
                'VS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9ca3af),
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _formatMatchDate(prediction.matchDate),
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9ca3af),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF1e293b),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Text(
                  prediction.venue,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF9ca3af),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Away Team
        Expanded(
          child: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1e293b),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.network(
                    prediction.awayTeamLogo,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF1e293b),
                        child: const Icon(Icons.shield, color: Colors.white54),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                prediction.awayTeam,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWebMatchHeader(MatchPrediction prediction) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF374151)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Home Team
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF101622),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      prediction.homeTeamLogo,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF101622),
                          child: const Icon(Icons.shield, color: Colors.white54, size: 48),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  prediction.homeTeam,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          // Match Info
          Expanded(
            flex: 2,
            child: Column(
              children: [
                const Text(
                  'VS',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9ca3af),
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _formatMatchDate(prediction.matchDate),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF9ca3af),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101622),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.stadium,
                        size: 16,
                        color: Color(0xFF9ca3af),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        prediction.venue,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF9ca3af),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10b981).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified,
                        size: 16,
                        color: Color(0xFF10b981),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        prediction.confidenceLevel,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF10b981),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Away Team
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: const Color(0xFF101622),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.1),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.network(
                      prediction.awayTeamLogo,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF101622),
                          child: const Icon(Icons.shield, color: Colors.white54, size: 48),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  prediction.awayTeam,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWinProbabilitySection(MatchPrediction prediction) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1e293b),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF374151)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'WIN PROBABILITY',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9ca3af),
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10b981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified,
                      size: 14,
                      color: Color(0xFF10b981),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      prediction.confidenceLevel,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF10b981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Probability Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 48,
              child: Row(
                children: [
                  // Home Win
                  Expanded(
                    flex: (prediction.winProbability.homeWin * 100).round(),
                    child: Container(
                      color: const Color(0xFF0d59f2),
                      alignment: Alignment.center,
                      child: Text(
                        '${(prediction.winProbability.homeWin * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Draw
                  Expanded(
                    flex: (prediction.winProbability.draw * 100).round(),
                    child: Container(
                      color: const Color(0xFF64748b),
                      alignment: Alignment.center,
                      child: Text(
                        '${(prediction.winProbability.draw * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // Away Win
                  Expanded(
                    flex: (prediction.winProbability.awayWin * 100).round(),
                    child: Container(
                      color: const Color(0xFF38bdf8),
                      alignment: Alignment.center,
                      child: Text(
                        '${(prediction.winProbability.awayWin * 100).round()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLegendItem('Home Win', const Color(0xFF0d59f2)),
              _buildLegendItem('Draw', const Color(0xFF64748b)),
              _buildLegendItem('Away Win', const Color(0xFF38bdf8)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildPredictedStatsSection(MatchPrediction prediction) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.only(left: 4, right: 4, bottom: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Predicted Key Stats',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                prediction.modelVersion,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9ca3af),
                ),
              ),
            ],
          ),
        ),

        // Stats Table
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1e293b),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF374151)),
          ),
          child: Column(
            children: [
              // Header Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF374151).withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: const Row(
                  children: [
                    Expanded(
                      child: Text(
                        'HOME',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9ca3af),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: Text(
                        'METRIC',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9ca3af),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'AWAY',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9ca3af),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Stats Rows
              _buildStatRow(
                prediction.predictedStats.expectedGoals,
                isFirst: true,
              ),
              _buildStatRow(prediction.predictedStats.possession),
              _buildStatRow(prediction.predictedStats.shotsOnTarget),
              _buildStatRow(prediction.predictedStats.passCompletion),
              _buildStatRow(
                prediction.predictedStats.ppda,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(StatComparison stat, {bool isFirst = false, bool isLast = false}) {
    final homeValue = stat.homeValue;
    final awayValue = stat.awayValue;

    // Determine which team has the advantage
    final bool homeAdvantage = homeValue > awayValue;
    final bool awayAdvantage = awayValue > homeValue;

    // Calculate bar widths
    final total = (homeValue is num && awayValue is num)
        ? homeValue + awayValue
        : 100;
    final homeWidth = (homeValue is num && awayValue is num)
        ? (homeValue / total * 100).clamp(0, 100).toDouble()
        : 50.0;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : const BorderSide(color: Color(0xFF374151)),
        ),
      ),
      child: Stack(
        children: [
          // Background indicator bars
          Positioned(
            left: 0,
            bottom: 0,
            child: Container(
              width: homeWidth * 6,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: homeAdvantage
                      ? [const Color(0xFF0d59f2).withOpacity(0.2), Colors.transparent]
                      : [Colors.white.withOpacity(0.05), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: (100 - homeWidth) * 6,
              height: 4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: awayAdvantage
                      ? [Colors.transparent, const Color(0xFF38bdf8).withOpacity(0.2)]
                      : [Colors.transparent, Colors.white.withOpacity(0.05)],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                // Home Value
                Expanded(
                  child: Text(
                    _formatStatValue(homeValue),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: homeAdvantage
                          ? const Color(0xFF0d59f2)
                          : Colors.white,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),

                // Metric Name
                SizedBox(
                  width: 120,
                  child: Text(
                    stat.metric,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF9ca3af),
                    ),
                  ),
                ),

                // Away Value
                Expanded(
                  child: Text(
                    _formatStatValue(awayValue),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: awayAdvantage
                          ? const Color(0xFF38bdf8)
                          : Colors.white,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatStatValue(dynamic value) {
    if (value is int) {
      return value.toString();
    } else if (value is double) {
      if (value >= 10) {
        return '${value.round()}%';
      } else {
        return value.toStringAsFixed(2);
      }
    }
    return value.toString();
  }

  Widget _buildTacticalInsight(MatchPrediction prediction) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0d59f2).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0d59f2).withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.insights,
            color: Color(0xFF0d59f2),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  prediction.tacticalInsight.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0d59f2),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  prediction.tacticalInsight.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9ca3af),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF101622),
        border: Border(
          top: BorderSide(color: Color(0xFF374151)),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compare Scenarios - Coming Soon')),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF374151)),
                  backgroundColor: const Color(0xFF1e293b),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Compare Scenarios',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Export Report - Coming Soon')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF0d59f2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 4,
                  shadowColor: const Color(0xFF0d59f2).withOpacity(0.25),
                ),
                child: const Text(
                  'Export Report',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
