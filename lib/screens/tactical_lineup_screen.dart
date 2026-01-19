import 'package:flutter/material.dart';
import '../widgets/side_menu.dart';
import '../widgets/formation_selector.dart';
import '../widgets/players_list.dart';
import '../widgets/team_stats.dart';
import '../widgets/pitch_view.dart';
import '../data/data_provider.dart';

// Content-only widget for use in MainShellScreen (without Scaffold and SideMenu)
class TacticalLineupContent extends StatefulWidget {
  const TacticalLineupContent({super.key});

  @override
  State<TacticalLineupContent> createState() => _TacticalLineupContentState();
}

class _TacticalLineupContentState extends State<TacticalLineupContent> {
  String _selectedFormation = '4-3-3';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebLayout = screenWidth > 900;

    return isWebLayout ? _buildWebContent() : _buildMobileContent();
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
        // Team & Controls Header
        _buildTeamHeader(),

        // Tactical Pitch View
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PitchView(
              players: DataProvider.players,
              formation: DataProvider.formations[_selectedFormation]!,
            ),
          ),
        ),

        // Bottom Action Area
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildWebContent() {
    return Row(
      children: [
        // Center - Team Info Bar & Pitch View
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // Team Info Bar
              _buildWebTeamInfoBar(),
              // Pitch View
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: PitchView(
                    players: DataProvider.players,
                    formation: DataProvider.formations[_selectedFormation]!,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Right Side - Controls & Info
        _buildWebRightPanel(),
      ],
    );
  }

  Widget _buildWebTeamInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HOME TEAM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manchester City',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0d59f2).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF0d59f2).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  size: 20,
                  color: Color(0xFF0d59f2),
                ),
                const SizedBox(width: 8),
                const Text(
                  '86 OVR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0d59f2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebRightPanel() {
    return Container(
      width: 470,
      decoration: BoxDecoration(
        color: const Color(0xFF0d1117),
        border: Border(
          left: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[800]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Match Prediction',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings, size: 24),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormationSelector(
                    formations: DataProvider.formations,
                    selectedFormation: _selectedFormation,
                    onFormationChanged: (String formation) {
                      setState(() {
                        _selectedFormation = formation;
                      });
                    },
                    isWebLayout: true,
                  ),
                  const SizedBox(height: 12),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.auto_awesome, size: 20),
                        label: const Text(
                          'Auto Fill Best XI',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0d59f2).withOpacity(0.15),
                          foregroundColor: const Color(0xFF0d59f2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: const Color(0xFF0d59f2).withOpacity(0.3),
                            ),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const TeamStatsWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFF6CABDD),
            ),
            child: const Icon(Icons.shield, color: Colors.white, size: 30),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Manchester City',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Premier League',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101622),
        border: Border(top: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0d59f2),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save Lineup',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Original full-page widget (kept for backward compatibility)
class TacticalLineupScreen extends StatefulWidget {
  const TacticalLineupScreen({super.key});

  @override
  State<TacticalLineupScreen> createState() => _TacticalLineupScreenState();
}

class _TacticalLineupScreenState extends State<TacticalLineupScreen> {
  String _selectedFormation = '4-3-3';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebLayout = screenWidth > 900;

    return Scaffold(
      drawer: isWebLayout ? null : _buildDrawer(),
      body: SafeArea(
        child: isWebLayout ? _buildWebLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDrawer() {
    return const Drawer(
      backgroundColor: Color(0xFF0d1117),
      child: SideMenu(),
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Top App Bar
        _buildTopAppBar(),

        // Team & Controls Header
        _buildTeamHeader(),

        // Tactical Pitch View
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: PitchView(
              players: DataProvider.players,
              formation: DataProvider.formations[_selectedFormation]!,
            ),
          ),
        ),

        // Bottom Action Area
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [
        // Left Side Menu - User Profile & Navigation
        const SideMenu(),

        // Center - Team Info Bar & Pitch View
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // Team Info Bar
              _buildWebTeamInfoBar(),
              // Pitch View
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: PitchView(
                    players: DataProvider.players,
                    formation: DataProvider.formations[_selectedFormation]!,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Right Side - Controls & Info
        _buildWebRightPanel(),
      ],
    );
  }

  Widget _buildWebTeamInfoBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        children: [
          // Team Name
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HOME TEAM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[500],
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Manchester City',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Team Rating Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0d59f2).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF0d59f2).withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  size: 20,
                  color: const Color(0xFF0d59f2),
                ),
                const SizedBox(width: 8),
                Text(
                  '86 OVR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0d59f2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebRightPanel() {
    return Container(
      width: 470,
      decoration: BoxDecoration(
        color: const Color(0xFF0d1117),
        border: Border(
          left: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Column(
        children: [
          // Header with title and settings
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey[800]!),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Match Prediction',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.settings, size: 24),
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FormationSelector(
                    formations: DataProvider.formations,
                    selectedFormation: _selectedFormation,
                    onFormationChanged: (String formation) {
                      setState(() {
                        _selectedFormation = formation;
                      });
                    },
                    isWebLayout: true,
                  ),
                  const SizedBox(height: 12),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.auto_awesome, size: 20),
                        label: const Text(
                          'Auto Fill Best XI',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0d59f2).withOpacity(0.15),
                          foregroundColor: const Color(0xFF0d59f2),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: const Color(0xFF0d59f2).withOpacity(0.3),
                            ),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PlayersListWidget(players: DataProvider.players),
                  const SizedBox(height: 32),
                  const TeamStatsWidget(),
                ],
              ),
            ),
          ),
          _buildWebActionButton(),
        ],
      ),
    );
  }

  Widget _buildWebActionButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0d59f2),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 8,
              shadowColor: const Color(0xFF0d59f2).withOpacity(0.4),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Make Prediction',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 12),
                Icon(Icons.arrow_forward, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder: (context) {
              return IconButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: const Icon(Icons.menu, size: 24),
                style: IconButton.styleFrom(
                  foregroundColor: Colors.white,
                ),
              );
            },
          ),
          const Text(
            'Match Prediction',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings, size: 24),
            style: IconButton.styleFrom(
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'HOME TEAM',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[500],
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Manchester City',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF0d59f2).withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up,
                      size: 16,
                      color: const Color(0xFF0d59f2),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '86 OVR',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0d59f2),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Formation Selector
              FormationSelector(
                formations: DataProvider.formations,
                selectedFormation: _selectedFormation,
                onFormationChanged: (String formation) {
                  setState(() {
                    _selectedFormation = formation;
                  });
                },
                isWebLayout: false,
              ),
              const SizedBox(width: 12),
              // Auto Button
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0d59f2).withOpacity(0.15),
                  border: Border.all(
                    color: const Color(0xFF0d59f2).withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            size: 20,
                            color: const Color(0xFF0d59f2),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Auto',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0d59f2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'All players fit',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Avg Age: ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                  const Text(
                    '26.4',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0d59f2),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 8,
                shadowColor: const Color(0xFF0d59f2).withOpacity(0.4),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Make Prediction',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
