import 'package:flutter/material.dart';

/// A reusable widget for displaying stat comparisons between home and away teams
class StatComparisonRow extends StatelessWidget {
  final String homeValue;
  final String awayValue;
  final String metric;
  final bool homeAdvantage;
  final bool awayAdvantage;

  const StatComparisonRow({
    super.key,
    required this.homeValue,
    required this.awayValue,
    required this.metric,
    this.homeAdvantage = false,
    this.awayAdvantage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Home Value
          Expanded(
            child: Text(
              homeValue,
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
              metric,
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
              awayValue,
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
    );
  }
}
