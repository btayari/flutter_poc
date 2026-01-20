import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../data/data_provider.dart';
import '../models/player.dart';
import 'main_shell_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showNotImplementedToast() {
    Fluttertoast.showToast(
      msg: "This feature is not developed yet",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
      fontSize: 14.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;

        if (isWeb) {
          return _buildWebLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;
    final padding = isMobile ? 16.0 : 24.0;
    final spacing = isMobile ? 16.0 : 24.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          SizedBox(height: spacing),
          _buildQuickStats(),
          SizedBox(height: spacing),
          _buildRecentForm(),
          SizedBox(height: spacing),
          _buildUpcomingFixtures(context),
          SizedBox(height: spacing),
          _buildQuickActions(context),
          SizedBox(height: spacing),
          _buildTeamPerformance(),
        ],
      ),
    );
  }

  Widget _buildWebLayout(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 32),
          _buildQuickStats(),
          const SizedBox(height: 32),
          // Two column layout for web
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildQuickActions(context),
                    const SizedBox(height: 32),
                    _buildRecentForm(),

                  ],
                ),
              ),
              const SizedBox(width: 32),
              // Right column
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUpcomingFixtures(context),
                    const SizedBox(height: 32),
                    _buildTeamPerformance(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manchester City FC - Season 2025/26',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final isMobile = constraints.maxWidth <= 600;

        // Calculate proper width for mobile
        final double cardWidth;
        if (isWide) {
          cardWidth = (constraints.maxWidth - 48) / 4;
        } else if (isMobile) {
          // On very small screens, make cards slightly larger
          cardWidth = (constraints.maxWidth - 12) / 2;
        } else {
          cardWidth = (constraints.maxWidth - 16) / 2;
        }

        return Wrap(
          spacing: isMobile ? 12 : 16,
          runSpacing: isMobile ? 12 : 16,
          children: [
            _buildStatCard(
              icon: Icons.emoji_events,
              title: 'League Position',
              value: '1st',
              subtitle: 'Premier League',
              color: const Color(0xFF0d59f2),
              width: cardWidth,
              isMobile: isMobile,
            ),
            _buildStatCard(
              icon: Icons.trending_up,
              title: 'Points',
              value: '54',
              subtitle: '22 matches',
              color: const Color(0xFF10b981),
              width: cardWidth,
              isMobile: isMobile,
            ),
            _buildStatCard(
              icon: Icons.sports_soccer,
              title: 'Goals Scored',
              value: '58',
              subtitle: '2.64 per match',
              color: const Color(0xFFf59e0b),
              width: cardWidth,
              isMobile: isMobile,
            ),
            _buildStatCard(
              icon: Icons.shield,
              title: 'Clean Sheets',
              value: '12',
              subtitle: '54.5% of matches',
              color: const Color(0xFF8b5cf6),
              width: cardWidth,
              isMobile: isMobile,
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
    required double width,
    bool isMobile = false,
  }) {
    return Container(
      width: width,
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
            ),
            child: Icon(icon, color: color, size: isMobile ? 20 : 24),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            title,
            style: TextStyle(
              fontSize: isMobile ? 11 : 13,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isMobile ? 6 : 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isMobile ? 24 : 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isMobile ? 10 : 12,
              color: Colors.grey[500],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentForm() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 600;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1e2736),
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recent Form',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isMobile ? 12 : 16),
              isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildFormIndicator('W', Colors.green),
                            _buildFormIndicator('W', Colors.green),
                            _buildFormIndicator('D', Colors.orange),
                            _buildFormIndicator('W', Colors.green),
                            _buildFormIndicator('W', Colors.green),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                          ),
                          child: const Text(
                            '13 pts from last 5',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _buildFormIndicator('W', Colors.green),
                              _buildFormIndicator('W', Colors.green),
                              _buildFormIndicator('D', Colors.orange),
                              _buildFormIndicator('W', Colors.green),
                              _buildFormIndicator('W', Colors.green),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                          ),
                          child: const Text(
                            '13 pts from last 5',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormIndicator(String result, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Center(
        child: Text(
          result,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingFixtures(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 600;

        return Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1e2736),
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Upcoming Fixtures',
                    style: TextStyle(
                      fontSize: isMobile ? 18 : 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  TextButton(
                    onPressed: _showNotImplementedToast,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey[600],
                      padding: EdgeInsets.symmetric(
                        horizontal: isMobile ? 8 : 12,
                        vertical: isMobile ? 4 : 8,
                      ),
                    ),
                    child: Text(
                      'View All',
                      style: TextStyle(fontSize: isMobile ? 12 : 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 12 : 16),
              _buildFixtureItem(
                opponent: 'Liverpool',
                date: 'Jan 25, 2026',
                time: '17:30',
                venue: 'Home',
                competition: 'Premier League',
                isMobile: isMobile,
              ),
              Divider(height: isMobile ? 24 : 32, color: const Color(0xFF2a3647)),
              _buildFixtureItem(
                opponent: 'Arsenal',
                date: 'Jan 29, 2026',
                time: '20:00',
                venue: 'Away',
                competition: 'Premier League',
                isMobile: isMobile,
              ),
              Divider(height: isMobile ? 24 : 32, color: const Color(0xFF2a3647)),
              _buildFixtureItem(
                opponent: 'Chelsea',
                date: 'Feb 1, 2026',
                time: '15:00',
                venue: 'Home',
                competition: 'FA Cup',
                isMobile: isMobile,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFixtureItem({
    required String opponent,
    required String date,
    required String time,
    required String venue,
    required String competition,
    bool isMobile = false,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 6 : 8,
                      vertical: isMobile ? 3 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: venue == 'Home'
                          ? const Color(0xFF0d59f2).withValues(alpha: 0.15)
                          : Colors.orange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      venue.toUpperCase(),
                      style: TextStyle(
                        color: venue == 'Home' ? const Color(0xFF0d59f2) : Colors.orange,
                        fontSize: isMobile ? 9 : 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      competition,
                      style: TextStyle(
                        fontSize: isMobile ? 11 : 12,
                        color: Colors.grey[500],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isMobile ? 6 : 8),
              Text(
                opponent,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$date • $time',
                style: TextStyle(
                  fontSize: isMobile ? 12 : 13,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 600;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: isMobile ? 12 : 16),
            LayoutBuilder(
              builder: (context, innerConstraints) {
                final isWide = innerConstraints.maxWidth > 800;
                final columns = isWide ? 4 : 2;
                final spacing = isMobile ? 12.0 : 16.0;
                final totalSpacing = spacing * (columns - 1);
                final itemWidth = (innerConstraints.maxWidth - totalSpacing) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: [
                    _buildActionButton(
                      context: context,
                      icon: Icons.sports_soccer,
                      label: 'Tactical Lineup',
                      color: const Color(0xFF0d59f2),
                      enabled: true,
                      screenIndex: 1,
                      width: itemWidth,
                      isMobile: isMobile,
                    ),
                    _buildActionButton(
                      context: context,
                      icon: Icons.people_rounded,
                      label: 'Squad Management',
                      color: const Color(0xFF10b981),
                      enabled: true,
                      screenIndex: 2,
                      width: itemWidth,
                      isMobile: isMobile,
                    ),
                    _buildActionButton(
                      context: context,
                      icon: Icons.swap_horiz_rounded,
                      label: 'Transfers',
                      color: const Color(0xFF6b7280),
                      enabled: false,
                      width: itemWidth,
                      isMobile: isMobile,
                    ),
                    _buildActionButton(
                      context: context,
                      icon: Icons.search_rounded,
                      label: 'Scouting',
                      color: const Color(0xFF6b7280),
                      enabled: false,
                      width: itemWidth,
                      isMobile: isMobile,
                    ),
                    _buildActionButton(
                      context: context,
                      icon: Icons.bar_chart_rounded,
                      label: 'Statistics',
                      color: const Color(0xFF6b7280),
                      enabled: false,
                      width: itemWidth,
                      isMobile: isMobile,
                    ),
                    _buildActionButton(
                      context: context,
                      icon: Icons.event_note_rounded,
                      label: 'Fixtures',
                      color: const Color(0xFF6b7280),
                      enabled: false,
                      width: itemWidth,
                      isMobile: isMobile,
                    ),
                    _buildActionButton(
                      context: context,
                      icon: Icons.lightbulb_outline,
                      label: 'Training',
                      color: const Color(0xFF6b7280),
                      enabled: false,
                      width: itemWidth,
                      isMobile: isMobile,
                    ),
                    _buildActionButton(
                      context: context,
                      icon: Icons.psychology_rounded,
                      label: 'AI Analysis',
                      color: const Color(0xFF6b7280),
                      enabled: false,
                      width: itemWidth,
                      isMobile: isMobile,
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required bool enabled,
    int? screenIndex,
    required double width,
    bool isMobile = false,
  }) {
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: SizedBox(
        width: width,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              if (enabled && screenIndex != null) {
                // Navigate to the screen by updating MainShellScreen state
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => MainShellScreen(initialIndex: screenIndex),
                  ),
                );
              } else {
                _showNotImplementedToast();
              }
            },
            borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
            child: Container(
              padding: EdgeInsets.all(isMobile ? 16 : 20),
              decoration: BoxDecoration(
                color: const Color(0xFF1e2736),
                borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                border: Border.all(
                  color: enabled ? color.withValues(alpha: 0.3) : Colors.grey[800]!,
                  width: enabled ? 2 : 1,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(isMobile ? 10 : 12),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(isMobile ? 10 : 12),
                    ),
                    child: Icon(icon, color: color, size: isMobile ? 24 : 28),
                  ),
                  SizedBox(height: isMobile ? 10 : 12),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: enabled ? Colors.white : Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamPerformance() {
    final topPlayers = DataProvider.players
        .where((p) => p.rating >= 8.0)
        .toList()
      ..sort((a, b) => b.rating.compareTo(a.rating));

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth <= 600;

        return Container(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          decoration: BoxDecoration(
            color: const Color(0xFF1e2736),
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Top Performers',
                style: TextStyle(
                  fontSize: isMobile ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isMobile ? 16 : 20),
              ...topPlayers.take(5).map((player) => Padding(
                    padding: EdgeInsets.only(bottom: isMobile ? 12 : 16),
                    child: _buildPlayerPerformanceRow(player, isMobile),
                  )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPlayerPerformanceRow(Player player, [bool isMobile = false]) {
    return Row(
      children: [
        Container(
          width: isMobile ? 45 : 50,
          height: isMobile ? 45 : 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: player.isStarPlayer
                  ? const Color(0xFFf59e0b)
                  : Colors.grey[700]!,
              width: 2,
            ),
            image: DecorationImage(
              image: AssetImage(player.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: isMobile ? 12 : 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      player.name,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (player.isStarPlayer) ...[
                    const SizedBox(width: 6),
                    Icon(
                      Icons.star,
                      color: const Color(0xFFf59e0b),
                      size: isMobile ? 14 : 16,
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                player.displayPosition,
                style: TextStyle(
                  fontSize: isMobile ? 11 : 13,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 10 : 12,
            vertical: isMobile ? 5 : 6,
          ),
          decoration: BoxDecoration(
            color: _getRatingColor(player.rating).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _getRatingColor(player.rating).withValues(alpha: 0.3),
            ),
          ),
          child: Text(
            player.rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              fontWeight: FontWeight.bold,
              color: _getRatingColor(player.rating),
            ),
          ),
        ),
      ],
    );
  }

  Color _getRatingColor(double rating) {
    if (rating >= 9.0) return const Color(0xFF10b981);
    if (rating >= 8.5) return const Color(0xFF0d59f2);
    if (rating >= 8.0) return const Color(0xFF8b5cf6);
    return Colors.grey;
  }
}
