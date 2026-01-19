import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tactical Lineup Editor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF101622),
        primaryColor: const Color(0xFF0d59f2),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      ),
      home: const TacticalLineupScreen(),
    );
  }
}

// Player Model
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

enum PlayerPosition {
  goalkeeper,
  defender,
  midfielder,
  forward,
}

// Formation Model
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

// Player Position Data for formations
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

// Main Screen
class TacticalLineupScreen extends StatefulWidget {
  const TacticalLineupScreen({super.key});

  @override
  State<TacticalLineupScreen> createState() => _TacticalLineupScreenState();
}

class _TacticalLineupScreenState extends State<TacticalLineupScreen> {
  String _selectedFormation = '4-3-3';

  // Available formations
  final Map<String, Formation> _formations = {
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

  final List<Player> players = [
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

  // Drawer for mobile
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0d1117),
      child: Column(
        children: [
          // User Profile Section
          _buildUserProfile(),

          const SizedBox(height: 24),

          // Navigation Menu
          Expanded(
            child: _buildNavigationMenu(),
          ),

          // Footer
          _buildSideMenuFooter(),
        ],
      ),
    );
  }

  // Mobile/Tablet Layout (Vertical)
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Top App Bar
        _buildTopAppBar(),

        // Team & Controls Header
        _buildTeamHeader(),

        // Tactical Pitch View
        Expanded(
          child: _buildPitchView(),
        ),

        // Bottom Action Area
        _buildBottomActions(),
      ],
    );
  }

  // Web Layout (Horizontal with sidebar)
  Widget _buildWebLayout() {
    return Row(
      children: [
        // Left Side Menu - User Profile & Navigation
        _buildSideMenu(),

        // Center - Team Info Bar & Pitch View
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // Team Info Bar
              Container(
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
              ),
              // Pitch View
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: _buildPitchView(),
                ),
              ),
            ],
          ),
        ),

        // Right Side - Controls & Info
        Container(
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
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.settings, size: 24),
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.grey[400],
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
                      _buildWebFormationSelector(),
                      const SizedBox(height: 24),
                      _buildWebPlayersList(),
                      const SizedBox(height: 32),
                      _buildWebStats(),
                    ],
                  ),
                ),
              ),
              _buildWebActionButton(),
            ],
          ),
        ),
      ],
    );
  }

  // Side Menu Widget
  Widget _buildSideMenu() {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF0d1117),
        border: Border(
          right: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Column(
        children: [
          // User Profile Section
          _buildUserProfile(),

          const SizedBox(height: 24),

          // Navigation Menu
          Expanded(
            child: _buildNavigationMenu(),
          ),

          // Footer
          _buildSideMenuFooter(),
        ],
      ),
    );
  }

  // User Profile Widget
  Widget _buildUserProfile() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Column(
        children: [
          // User Avatar
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF0d59f2),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0d59f2).withOpacity(0.3),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/user_avatar.jpg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[800],
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 16),

          // User Name
          const Text(
            'John Manager',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),

          // Email
          Text(
            'john.manager@mancity.com',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 12),

          // Club Badge & Name
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1e2736),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[800]!),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6CABDD),
                  ),
                  child: const Icon(
                    Icons.shield,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Manchester City',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Navigation Menu Widget
  Widget _buildNavigationMenu() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildMenuItem(
          icon: Icons.home_rounded,
          label: 'Home',
          isActive: false,
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.assessment_rounded,
          label: 'Prediction',
          isActive: true,
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.swap_horiz_rounded,
          label: 'Transfers',
          isActive: false,
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.search_rounded,
          label: 'Scouting',
          isActive: false,
          onTap: () {},
        ),

        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'TEAM MANAGEMENT',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.2,
            ),
          ),
        ),

        _buildMenuItem(
          icon: Icons.people_rounded,
          label: 'Squad',
          isActive: false,
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.bar_chart_rounded,
          label: 'Statistics',
          isActive: false,
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.event_note_rounded,
          label: 'Fixtures',
          isActive: false,
          onTap: () {},
        ),

        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            'SETTINGS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
              letterSpacing: 1.2,
            ),
          ),
        ),

        _buildMenuItem(
          icon: Icons.settings_rounded,
          label: 'Settings',
          isActive: false,
          onTap: () {},
        ),
        _buildMenuItem(
          icon: Icons.help_rounded,
          label: 'Help & Support',
          isActive: false,
          onTap: () {},
        ),
      ],
    );
  }

  // Menu Item Widget
  Widget _buildMenuItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF0d59f2).withOpacity(0.15)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isActive
            ? Border.all(
                color: const Color(0xFF0d59f2).withOpacity(0.3),
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 22,
                  color: isActive
                      ? const Color(0xFF0d59f2)
                      : Colors.grey[400],
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    color: isActive
                        ? const Color(0xFF0d59f2)
                        : Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Side Menu Footer
  Widget _buildSideMenuFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      size: 20,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Web: Team Info Section
  Widget _buildWebTeamInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'HOME TEAM',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: Text(
                'Manchester City',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0d59f2).withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFF0d59f2).withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 18,
                    color: const Color(0xFF0d59f2),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '86 OVR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0d59f2),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Web: Formation Selector
  Widget _buildWebFormationSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'FORMATION',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        PopupMenuButton<String>(
          offset: const Offset(0, 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: const Color(0xFF1e2736),
          elevation: 8,
          shadowColor: Colors.black.withOpacity(0.5),
          onSelected: (String value) {
            setState(() {
              _selectedFormation = value;
            });
          },
          itemBuilder: (BuildContext context) {
            return _formations.entries.map((entry) {
              final isSelected = entry.key == _selectedFormation;
              return PopupMenuItem<String>(
                value: entry.key,
                padding: EdgeInsets.zero,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF0d59f2).withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: isSelected
                        ? Border.all(
                            color: const Color(0xFF0d59f2).withOpacity(0.3),
                          )
                        : null,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.value.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? const Color(0xFF0d59f2)
                                  : Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            entry.value.displayName,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: Color(0xFF0d59f2),
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }).toList();
          },
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1e2736),
              border: Border.all(color: Colors.grey[800]!),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formations[_selectedFormation]!.displayName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
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
      ],
    );
  }

  // Web: Players List
  Widget _buildWebPlayersList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STARTING XI',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        ...players.map((player) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1e2736),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: player.isStarPlayer
                    ? const Color(0xFF0d59f2).withOpacity(0.3)
                    : Colors.grey[800]!,
              ),
            ),
            child: Row(
              children: [
                // Player Avatar
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: player.position == PlayerPosition.goalkeeper
                          ? Colors.yellow[700]!
                          : player.isStarPlayer
                              ? const Color(0xFF0d59f2)
                              : Colors.grey[600]!,
                      width: 2,
                    ),
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
                            size: 20,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Player Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _getPositionName(player.position),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                // Rating
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: player.isStarPlayer
                        ? const Color(0xFF0d59f2)
                        : const Color(0xFF0f172a),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    player.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: player.isStarPlayer
                          ? Colors.white
                          : player.position == PlayerPosition.goalkeeper
                              ? Colors.yellow[700]
                              : Colors.white,
                    ),
                  ),
                ),
                if (player.isStarPlayer) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.star,
                    size: 18,
                    color: Color(0xFF0d59f2),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  // Web: Stats Section
  Widget _buildWebStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Team Status',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[300],
                ),
              ),
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
                      fontSize: 13,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: Colors.grey[800]),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Average Age',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '26.4',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Team Rating',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '86',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0d59f2),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Web: Action Button
  Widget _buildWebActionButton() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[800]!),
        ),
      ),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
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
    );
  }

  String _getPositionName(PlayerPosition position) {
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
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1e2736),
                    border: Border.all(color: Colors.grey[800]!),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _showFormationPicker,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'FORMATION',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[500],
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _formations[_selectedFormation]!.displayName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
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

  Widget _buildPitchView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[800]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Pitch Background
                  const PitchBackground(),

                  // Players positioned on pitch
                  _buildPlayersOnPitch(constraints),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildPlayersOnPitch(BoxConstraints constraints) {
    final formation = _formations[_selectedFormation]!;

    return Stack(
      children: formation.positions.map((posData) {
        return _positionPlayer(
          players[posData.playerIndex],
          posData.x,
          posData.y,
          constraints,
        );
      }).toList(),
    );
  }

  void _showFormationPicker() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebLayout = screenWidth > 900;

    if (isWebLayout) {
      // Web: Show nothing - using custom dropdown instead
      return;
    }

    // Mobile: Show bottom sheet
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1e2736),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Formation',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ..._formations.entries.map((entry) {
                  final isSelected = entry.key == _selectedFormation;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0d59f2).withOpacity(0.15)
                          : const Color(0xFF101622),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF0d59f2)
                            : Colors.grey[800]!,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedFormation = entry.key;
                          });
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.value.name,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected
                                          ? const Color(0xFF0d59f2)
                                          : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    entry.value.displayName,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                ],
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_circle,
                                  color: Color(0xFF0d59f2),
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _positionPlayer(
    Player player,
    double leftPercent,
    double topPercent,
    BoxConstraints constraints,
  ) {
    return Positioned(
      left: constraints.maxWidth * leftPercent,
      top: constraints.maxHeight * topPercent,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: PlayerNode(player: player),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
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

// Pitch Background Widget
class PitchBackground extends StatelessWidget {
  const PitchBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1e3a28),
        image: DecorationImage(
          image: const AssetImage('assets/pitch_pattern.png'),
          fit: BoxFit.cover,
          opacity: 0.03,
          onError: (error, stackTrace) {
            // Fallback if image doesn't exist
          },
        ),
      ),
      child: CustomPaint(
        painter: PitchPainter(),
      ),
    );
  }
}

// Custom Painter for Pitch Markings
class PitchPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Center line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      paint,
    );

    // Center circle
    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width * 0.12,
      paint,
    );

    // Penalty box top
    final penaltyBoxWidth = size.width * 0.6;
    final penaltyBoxHeight = size.height * 0.15;
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyBoxWidth) / 2,
        0,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      paint,
    );

    // Penalty box bottom
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - penaltyBoxWidth) / 2,
        size.height - penaltyBoxHeight,
        penaltyBoxWidth,
        penaltyBoxHeight,
      ),
      paint,
    );

    // Goal box top
    final goalBoxWidth = size.width * 0.33;
    final goalBoxHeight = size.height * 0.06;
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - goalBoxWidth) / 2,
        0,
        goalBoxWidth,
        goalBoxHeight,
      ),
      paint,
    );

    // Goal box bottom
    canvas.drawRect(
      Rect.fromLTWH(
        (size.width - goalBoxWidth) / 2,
        size.height - goalBoxHeight,
        goalBoxWidth,
        goalBoxHeight,
      ),
      paint,
    );

    // Corner arcs
    final cornerRadius = size.width * 0.08;

    // Top-left corner
    canvas.drawArc(
      Rect.fromLTWH(0, 0, cornerRadius * 2, cornerRadius * 2),
      0,
      1.57,
      false,
      paint,
    );

    // Top-right corner
    canvas.drawArc(
      Rect.fromLTWH(size.width - cornerRadius * 2, 0, cornerRadius * 2, cornerRadius * 2),
      1.57,
      1.57,
      false,
      paint,
    );

    // Bottom-left corner
    canvas.drawArc(
      Rect.fromLTWH(0, size.height - cornerRadius * 2, cornerRadius * 2, cornerRadius * 2),
      4.71,
      1.57,
      false,
      paint,
    );

    // Bottom-right corner
    canvas.drawArc(
      Rect.fromLTWH(
        size.width - cornerRadius * 2,
        size.height - cornerRadius * 2,
        cornerRadius * 2,
        cornerRadius * 2,
      ),
      3.14,
      1.57,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Player Node Widget
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
