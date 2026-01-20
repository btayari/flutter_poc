import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../models/player.dart';
import '../models/recent_transfer.dart';
import '../data/data_provider.dart';
import 'dart:math' as math;

// Custom scroll behavior for smooth scrolling on web
class SmoothScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.stylus,
    PointerDeviceKind.trackpad,
  };
}

class TransfersScreen extends StatefulWidget {
  const TransfersScreen({super.key});

  @override
  State<TransfersScreen> createState() => _TransfersScreenState();
}

class _TransfersScreenState extends State<TransfersScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _selectedPosition = 'All';
  String _selectedClub = 'All';
  String _sortBy = 'rating';
  List<Player> _shortlistedPlayers = [];
  late TabController _tabController;
  bool _isGridView = true; // Grid view for web by default

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this); // Always 3 tabs now
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  List<Player> get _filteredPlayers {
    var players = DataProvider.suggestedPlayers;

    // Filter by search term
    if (_searchController.text.isNotEmpty) {
      players = players
          .where((p) =>
              p.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
              p.club.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }

    // Filter by position
    if (_selectedPosition != 'All') {
      final position = _getPositionFromString(_selectedPosition);
      players = players.where((p) => p.position == position).toList();
    }

    // Filter by club
    if (_selectedClub != 'All') {
      players = players.where((p) => p.club == _selectedClub).toList();
    }

    // Sort
    switch (_sortBy) {
      case 'rating':
        players.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'age':
        players.sort((a, b) => a.age.compareTo(b.age));
        break;
      case 'name':
        players.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    return players;
  }

  PlayerPosition _getPositionFromString(String pos) {
    switch (pos) {
      case 'Goalkeeper':
        return PlayerPosition.goalkeeper;
      case 'Defender':
        return PlayerPosition.defender;
      case 'Midfielder':
        return PlayerPosition.midfielder;
      case 'Forward':
        return PlayerPosition.forward;
      default:
        return PlayerPosition.midfielder;
    }
  }

  List<String> get _availableClubs {
    final clubs = DataProvider.suggestedPlayers.map((p) => p.club).toSet().toList();
    clubs.sort();
    return ['All', ...clubs];
  }

  void _toggleShortlist(Player player) {
    setState(() {
      if (_shortlistedPlayers.contains(player)) {
        _shortlistedPlayers.remove(player);
      } else {
        _shortlistedPlayers.add(player);
      }
    });
  }

  bool _isShortlisted(Player player) {
    return _shortlistedPlayers.contains(player);
  }

  double _calculateWinProbability() {
    if (_shortlistedPlayers.isEmpty) {
      return 72.5; // Base probability
    }

    double totalRatingBoost = 0;
    for (var player in _shortlistedPlayers) {
      totalRatingBoost += (player.rating - 7.0) * 2;
    }

    return math.min(98.0, 72.5 + totalRatingBoost);
  }

  double _calculateSquadStrength() {
    final currentSquad = DataProvider.squadPlayers;
    final combinedSquad = [...currentSquad, ..._shortlistedPlayers];

    double avgRating = combinedSquad.fold(0.0, (sum, p) => sum + p.rating) / combinedSquad.length;
    return avgRating;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWeb = constraints.maxWidth > 1200;
        final isTablet = constraints.maxWidth > 768 && constraints.maxWidth <= 1200;

        if (isWeb) {
          return _buildWebLayout();
        } else if (isTablet) {
          return _buildTabletLayout();
        } else {
          return _buildMobileLayout();
        }
      },
    );
  }

  Widget _buildWebLayout() {
    return Container(
      color: const Color(0xFF101622),
      child: Row(
        children: [
          // Main content
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildHeader(isWeb: true),
                _buildTabBar(),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTransferMarket(isWeb: true),
                      _buildShortlist(isWeb: true),
                      _buildLastTransfers(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Stats panel - right sidebar
          Container(
            width: 400,
            decoration: BoxDecoration(
              color: const Color(0xFF0d1117),
              border: Border(left: BorderSide(color: Colors.grey[800]!, width: 1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(-2, 0),
                ),
              ],
            ),
            child: _buildStatsPanel(isCompact: false),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      color: const Color(0xFF101622),
      child: Column(
        children: [
          _buildHeader(isWeb: false),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTransferMarket(isWeb: false),
                _buildShortlist(isWeb: false),
                _buildLastTransfers(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout() {
    return Container(
      color: const Color(0xFF101622),
      child: Column(
        children: [
          _buildHeader(isWeb: false, isTablet: true),
          _buildTabBar(),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTransferMarket(isWeb: false, isTablet: true),
                      _buildShortlist(isWeb: false, isTablet: true),
                      _buildLastTransfers(),
                    ],
                  ),
                ),
                Container(
                  width: 320,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0d1117),
                    border: Border(left: BorderSide(color: Colors.grey[800]!, width: 1)),
                  ),
                  child: _buildStatsPanel(isCompact: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader({required bool isWeb, bool isTablet = false}) {
    final showViewToggle = isWeb || isTablet;
    final showQuickStats = isWeb;
    final isMobile = !isWeb && !isTablet;

    return Container(
      padding: EdgeInsets.all(isWeb ? 24 : (isTablet ? 20 : 12)),
      decoration: BoxDecoration(
        color: const Color(0xFF101622),
        border: Border(bottom: BorderSide(color: Colors.grey[800]!, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Compact mobile header
          if (isMobile)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0d59f2), Color(0xFF0a47c4)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Transfer Market',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.trending_up, size: 12, color: Colors.grey[500]),
                          const SizedBox(width: 4),
                          Text(
                            '${_filteredPlayers.length} players available',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            // Desktop/Tablet header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0d59f2).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.swap_horiz_rounded,
                    color: Color(0xFF0d59f2),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Transfer Market',
                        style: TextStyle(
                          fontSize: isWeb ? 24 : (isTablet ? 22 : 20),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Scout and recruit world-class talent',
                        style: TextStyle(
                          fontSize: isWeb ? 14 : 13,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                if (showViewToggle) ...[
                  _buildViewToggle(),
                  const SizedBox(width: 16),
                ],
                if (showQuickStats) _buildQuickStats(),
              ],
            ),
          SizedBox(height: isMobile ? 12 : 20),
          _buildSearchAndFilters(isWeb: isWeb, isTablet: isTablet),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        _buildStatChip(
          label: 'Shortlisted',
          value: '${_shortlistedPlayers.length}',
          color: const Color(0xFF0d59f2),
        ),
        const SizedBox(width: 12),
        _buildStatChip(
          label: 'Win Probability',
          value: '${_calculateWinProbability().toStringAsFixed(1)}%',
          color: const Color(0xFF22c55e),
        ),
      ],
    );
  }

  Widget _buildViewToggle() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildViewToggleButton(
            icon: Icons.grid_view,
            isSelected: _isGridView,
            onTap: () => setState(() => _isGridView = true),
            tooltip: 'Grid View',
          ),
          Container(width: 1, height: 24, color: Colors.grey[800]),
          _buildViewToggleButton(
            icon: Icons.view_list,
            isSelected: !_isGridView,
            onTap: () => setState(() => _isGridView = false),
            tooltip: 'List View',
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggleButton({
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0d59f2).withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isSelected ? const Color(0xFF0d59f2) : Colors.grey[500],
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({required String label, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[400],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters({required bool isWeb, bool isTablet = false}) {
    final isMobile = !isWeb && !isTablet;

    if (isMobile) {
      return Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white, fontSize: 14),
            decoration: InputDecoration(
              hintText: 'Search players or clubs...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
              prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[400], size: 20),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF1e2736),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF0d59f2), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          const SizedBox(height: 12),
          // Compact filters row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildCompactFilterChip(
                  label: _selectedPosition,
                  icon: Icons.sports_soccer,
                  onTap: () => _showPositionPicker(),
                ),
                const SizedBox(width: 8),
                _buildCompactFilterChip(
                  label: _selectedClub == 'All' ? 'All Clubs' : _selectedClub,
                  icon: Icons.shield,
                  onTap: () => _showClubPicker(),
                ),
                const SizedBox(width: 8),
                _buildCompactFilterChip(
                  label: 'Sort: ${_sortBy.substring(0, 1).toUpperCase()}${_sortBy.substring(1)}',
                  icon: Icons.sort,
                  onTap: () => _showSortPicker(),
                ),
                const SizedBox(width: 8),
                if (_searchController.text.isNotEmpty || _selectedPosition != 'All' || _selectedClub != 'All' || _sortBy != 'rating')
                  _buildClearFiltersChip(),
              ],
            ),
          ),
        ],
      );
    }

    // Desktop/Tablet filters
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        // Search bar
        SizedBox(
          width: isWeb ? 400 : (isTablet ? 300 : double.infinity),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search players or clubs...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500]),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color(0xFF1e2736),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey[800]!, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF0d59f2), width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ),
        // Position filter
        _buildFilterDropdown(
          value: _selectedPosition,
          items: ['All', 'Goalkeeper', 'Defender', 'Midfielder', 'Forward'],
          onChanged: (value) => setState(() => _selectedPosition = value!),
          icon: Icons.sports_soccer,
        ),
        // Club filter
        _buildFilterDropdown(
          value: _selectedClub,
          items: _availableClubs,
          onChanged: (value) => setState(() => _selectedClub = value!),
          icon: Icons.shield,
        ),
        // Sort by
        _buildFilterDropdown(
          value: _sortBy,
          items: const ['rating', 'age', 'name'],
          onChanged: (value) => setState(() => _sortBy = value!),
          icon: Icons.sort,
          label: 'Sort',
        ),
      ],
    );
  }

  Widget _buildCompactFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isActive = (icon == Icons.sports_soccer && _selectedPosition != 'All') ||
                     (icon == Icons.shield && _selectedClub != 'All') ||
                     (icon == Icons.sort && _sortBy != 'rating');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0d59f2).withOpacity(0.15) : const Color(0xFF1e2736),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF0d59f2) : Colors.grey[800]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? const Color(0xFF0d59f2) : Colors.grey[400],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                color: isActive ? const Color(0xFF0d59f2) : Colors.grey[300],
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: isActive ? const Color(0xFF0d59f2) : Colors.grey[500],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearFiltersChip() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchController.clear();
          _selectedPosition = 'All';
          _selectedClub = 'All';
          _sortBy = 'rating';
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFef4444).withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFef4444),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.clear_all,
              size: 16,
              color: Color(0xFFef4444),
            ),
            const SizedBox(width: 6),
            const Text(
              'Clear',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFef4444),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showPositionPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1e2736),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.sports_soccer, color: Color(0xFF0d59f2), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Select Position',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFF2d3748)),
              ...['All', 'Goalkeeper', 'Defender', 'Midfielder', 'Forward'].map((position) {
                final isSelected = _selectedPosition == position;
                return ListTile(
                  leading: Icon(
                    _getPositionIcon(position),
                    color: isSelected ? const Color(0xFF0d59f2) : Colors.grey[400],
                  ),
                  title: Text(
                    position,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF0d59f2) : Colors.white,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Color(0xFF0d59f2))
                      : null,
                  onTap: () {
                    setState(() => _selectedPosition = position);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showClubPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1e2736),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.shield, color: Color(0xFF0d59f2), size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        'Select Club',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Color(0xFF2d3748)),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: _availableClubs.length,
                    itemBuilder: (context, index) {
                      final club = _availableClubs[index];
                      final isSelected = _selectedClub == club;
                      return ListTile(
                        leading: Icon(
                          Icons.shield,
                          color: isSelected ? const Color(0xFF0d59f2) : Colors.grey[400],
                        ),
                        title: Text(
                          club,
                          style: TextStyle(
                            color: isSelected ? const Color(0xFF0d59f2) : Colors.white,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: Color(0xFF0d59f2))
                            : null,
                        onTap: () {
                          setState(() => _selectedClub = club);
                          Navigator.pop(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSortPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1e2736),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.sort, color: Color(0xFF0d59f2), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Sort By',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(color: Color(0xFF2d3748)),
              ...[
                {'value': 'rating', 'label': 'Rating', 'icon': Icons.star},
                {'value': 'age', 'label': 'Age', 'icon': Icons.cake},
                {'value': 'name', 'label': 'Name', 'icon': Icons.sort_by_alpha},
              ].map((sort) {
                final isSelected = _sortBy == sort['value'];
                return ListTile(
                  leading: Icon(
                    sort['icon'] as IconData,
                    color: isSelected ? const Color(0xFF0d59f2) : Colors.grey[400],
                  ),
                  title: Text(
                    sort['label'] as String,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF0d59f2) : Colors.white,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: Color(0xFF0d59f2))
                      : null,
                  onTap: () {
                    setState(() => _sortBy = sort['value'] as String);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  IconData _getPositionIcon(String position) {
    switch (position) {
      case 'Goalkeeper':
        return Icons.sports_handball;
      case 'Defender':
        return Icons.shield;
      case 'Midfielder':
        return Icons.directions_run;
      case 'Forward':
        return Icons.sports_soccer;
      default:
        return Icons.sports;
    }
  }


  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required IconData icon,
    String? label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: DropdownButton<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        }).toList(),
        onChanged: onChanged,
        underline: const SizedBox(),
        icon: Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
        dropdownColor: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(10),
        style: const TextStyle(color: Colors.white),
        hint: Row(
          children: [
            Icon(icon, size: 18, color: Colors.grey[400]),
            const SizedBox(width: 8),
            Text(
              label ?? value,
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 600;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0d1117),
            border: Border(bottom: BorderSide(color: Colors.grey[800]!, width: 1)),
          ),
          child: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFF0d59f2),
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[500],
            labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            isScrollable: isNarrow, // Scrollable on narrow screens
            tabAlignment: isNarrow ? TabAlignment.start : TabAlignment.fill,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.public, size: 18),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        isNarrow ? 'Market' : 'Transfer Market',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_filteredPlayers.length}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 18),
                    const SizedBox(width: 6),
                    const Flexible(
                      child: Text(
                        'Shortlist',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (_shortlistedPlayers.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0d59f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          '${_shortlistedPlayers.length}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.history, size: 18),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        isNarrow ? 'Recent' : 'Recent Transfers',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        '10',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTransferMarket({required bool isWeb, bool isTablet = false}) {
    final players = _filteredPlayers;

    if (players.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[700]),
            const SizedBox(height: 16),
            Text(
              'No players found',
              style: TextStyle(fontSize: 18, color: Colors.grey[500], fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your filters',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Grid view for web/tablet, list view for mobile
    if ((isWeb || isTablet) && _isGridView) {
      int crossAxisCount = 3;
      double childAspectRatio = 0.85;

      if (isTablet) {
        crossAxisCount = 2;
        childAspectRatio = 0.9;
      }

      return ScrollConfiguration(
        behavior: SmoothScrollBehavior(),
        child: GridView.builder(
          padding: EdgeInsets.all(isWeb ? 32 : (isTablet ? 20 : 16)),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: isWeb ? 24 : 16,
            mainAxisSpacing: isWeb ? 24 : 16,
          ),
          itemCount: players.length,
          itemBuilder: (context, index) {
            return _buildPlayerGridCard(players[index]);
          },
        ),
      );
    }

    return ScrollConfiguration(
      behavior: SmoothScrollBehavior(),
      child: ListView.builder(
        padding: EdgeInsets.all(isWeb ? 32 : (isTablet ? 20 : 16)),
        itemCount: players.length,
        itemBuilder: (context, index) {
          return _buildPlayerCard(players[index], isWeb: isWeb, isTablet: isTablet);
        },
      ),
    );
  }

  Widget _buildPlayerCard(Player player, {required bool isWeb, bool isTablet = false}) {
    final positionColor = _getPositionColor(player.position);
    final isShortlisted = _isShortlisted(player);
    final isLargeScreen = isWeb || isTablet;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isShortlisted
              ? const Color(0xFF0d59f2).withOpacity(0.5)
              : Colors.grey[800]!,
          width: isShortlisted ? 2 : 1,
        ),
        boxShadow: isShortlisted
            ? [
                BoxShadow(
                  color: const Color(0xFF0d59f2).withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _showPlayerDetails(player),
          child: Padding(
            padding: EdgeInsets.all(isLargeScreen ? 16 : 12),
            child: Row(
              children: [
                // Player avatar
                Stack(
                  children: [
                    Container(
                      width: isLargeScreen ? 70 : 60,
                      height: isLargeScreen ? 70 : 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: positionColor, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: positionColor.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
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
                                size: isLargeScreen ? 35 : 30,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    // Rating badge
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getRatingColor(player.rating),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF1e2736), width: 2),
                        ),
                        child: Text(
                          player.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: isLargeScreen ? 20 : 12),
                // Player info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              player.name,
                              style: TextStyle(
                                fontSize: isLargeScreen ? 16 : 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          if (player.rating >= 9.0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFfbbf24), Color(0xFFf59e0b)],
                                ),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.emoji_events, size: 12, color: Colors.white),
                                  SizedBox(width: 4),
                                  Text(
                                    'ELITE',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          _buildInfoChip(
                            icon: Icons.shield,
                            label: player.club,
                            color: Colors.grey[600]!,
                          ),
                          _buildInfoChip(
                            icon: Icons.sports_soccer,
                            label: player.displayPosition,
                            color: positionColor,
                          ),
                          _buildInfoChip(
                            icon: Icons.cake,
                            label: '${player.age} yrs',
                            color: Colors.grey[600]!,
                          ),
                        ],
                      ),
                      if (isLargeScreen) ...[
                        const SizedBox(height: 8),
                        _buildPlayerStats(player),
                      ],
                    ],
                  ),
                ),
                // Action buttons
                Column(
                  children: [
                    IconButton(
                      onPressed: () => _toggleShortlist(player),
                      icon: Icon(
                        isShortlisted ? Icons.star : Icons.star_border,
                        color: isShortlisted ? const Color(0xFFfbbf24) : Colors.grey[500],
                      ),
                      tooltip: isShortlisted ? 'Remove from shortlist' : 'Add to shortlist',
                    ),
                    if (isLargeScreen)
                      IconButton(
                        onPressed: () => _showPlayerDetails(player),
                        icon: Icon(Icons.info_outline, color: Colors.grey[500]),
                        tooltip: 'Player details',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerGridCard(Player player) {
    final positionColor = _getPositionColor(player.position);
    final isShortlisted = _isShortlisted(player);

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isShortlisted
              ? const Color(0xFF0d59f2).withOpacity(0.5)
              : Colors.grey[800]!,
          width: isShortlisted ? 2 : 1,
        ),
        boxShadow: isShortlisted
            ? [
                BoxShadow(
                  color: const Color(0xFF0d59f2).withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showPlayerDetails(player),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with avatar and rating
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: positionColor, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: positionColor.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
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
                                    size: 45,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        // Rating badge
                        Positioned(
                          bottom: -5,
                          right: -5,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getRatingColor(player.rating),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: const Color(0xFF1e2736), width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: _getRatingColor(player.rating).withOpacity(0.3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: Text(
                              player.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        // Shortlist star
                        Positioned(
                          top: -5,
                          right: -5,
                          child: IconButton(
                            onPressed: () => _toggleShortlist(player),
                            icon: Icon(
                              isShortlisted ? Icons.star : Icons.star_border,
                              color: isShortlisted ? const Color(0xFFfbbf24) : Colors.grey[600],
                              size: 24,
                            ),
                            tooltip: isShortlisted ? 'Remove from shortlist' : 'Add to shortlist',
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Player name
                    Text(
                      player.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Club name
                    Text(
                      player.club,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[400],
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Stats section
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101622),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Position and Age
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildGridStatItem(
                            icon: Icons.sports_soccer,
                            label: player.displayPosition,
                            color: positionColor,
                          ),
                          Container(width: 1, height: 30, color: Colors.grey[800]),
                          _buildGridStatItem(
                            icon: Icons.cake,
                            label: '${player.age} yrs',
                            color: Colors.grey[600]!,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Elite badge if applicable
                      if (player.rating >= 9.0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFfbbf24), Color(0xFFf59e0b)],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.emoji_events, size: 14, color: Colors.white),
                              SizedBox(width: 6),
                              Text(
                                'ELITE PLAYER',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (player.rating < 9.0)
                        // Action button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _showPlayerDetails(player),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0d59f2),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'View Details',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridStatItem({required IconData icon, required String label, required Color color}) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip({required IconData icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerStats(Player player) {
    return Row(
      children: [
        _buildStatBar('Attack', player.rating >= 8.5 ? 0.9 : player.rating / 10),
        const SizedBox(width: 12),
        _buildStatBar('Defense', player.position == PlayerPosition.defender ? 0.85 : 0.6),
        const SizedBox(width: 12),
        _buildStatBar('Physical', player.age < 28 ? 0.8 : 0.65),
      ],
    );
  }

  Widget _buildStatBar(String label, double value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(2),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: value,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF0d59f2),
                      const Color(0xFF0d59f2).withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShortlist({required bool isWeb, bool isTablet = false}) {
    if (_shortlistedPlayers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star_border, size: 64, color: Colors.grey[700]),
            const SizedBox(height: 16),
            Text(
              'No players in shortlist',
              style: TextStyle(fontSize: 18, color: Colors.grey[500], fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Add players from the transfer market',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        if (!isWeb && !isTablet) _buildMobileStatsCard(),
        Expanded(
          child: ScrollConfiguration(
            behavior: SmoothScrollBehavior(),
            child: ListView.builder(
              padding: EdgeInsets.all(isWeb ? 24 : (isTablet ? 20 : 16)),
              itemCount: _shortlistedPlayers.length,
              itemBuilder: (context, index) {
                return _buildPlayerCard(_shortlistedPlayers[index], isWeb: isWeb, isTablet: isTablet);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileStatsCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0d59f2), Color(0xFF0a47c4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMobileStatItem(
                'Win Probability',
                '${_calculateWinProbability().toStringAsFixed(1)}%',
                Icons.trending_up,
              ),
              Container(width: 1, height: 40, color: Colors.white24),
              _buildMobileStatItem(
                'Squad Strength',
                _calculateSquadStrength().toStringAsFixed(1),
                Icons.shield,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsPanel({bool isCompact = false}) {
    final winProbability = _calculateWinProbability();
    final squadStrength = _calculateSquadStrength();

    return ScrollConfiguration(
      behavior: SmoothScrollBehavior(),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isCompact ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
            'IMPACT ANALYSIS',
            style: TextStyle(
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: isCompact ? 16 : 20),
          // Win Probability Card
          _buildStatCard(
            title: 'League Win Probability',
            value: '${winProbability.toStringAsFixed(1)}%',
            change: _shortlistedPlayers.isEmpty ? 0 : winProbability - 72.5,
            icon: Icons.emoji_events,
            color: const Color(0xFF22c55e),
            isCompact: isCompact,
          ),
          SizedBox(height: isCompact ? 12 : 16),
          // Squad Strength Card
          _buildStatCard(
            title: 'Squad Strength',
            value: squadStrength.toStringAsFixed(2),
            change: _shortlistedPlayers.isEmpty
                ? 0
                : squadStrength -
                    (DataProvider.squadPlayers.fold(0.0, (sum, p) => sum + p.rating) /
                        DataProvider.squadPlayers.length),
            icon: Icons.shield,
            color: const Color(0xFF0d59f2),
            isCompact: isCompact,
          ),
          SizedBox(height: isCompact ? 12 : 16),
          // Top Competitions Card
          _buildStatCard(
            title: 'Champions League Chance',
            value: '${math.min(95, winProbability + 5).toStringAsFixed(1)}%',
            change: _shortlistedPlayers.isEmpty ? 0 : (_shortlistedPlayers.length * 1.5),
            icon: Icons.public,
            color: const Color(0xFF8b5cf6),
            isCompact: isCompact,
          ),
          SizedBox(height: isCompact ? 16 : 24),
          const Divider(color: Colors.grey),
          SizedBox(height: isCompact ? 16 : 24),
          // Shortlisted Players
          Text(
            'SHORTLISTED PLAYERS',
            style: TextStyle(
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: isCompact ? 12 : 16),
          if (_shortlistedPlayers.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'No players shortlisted yet',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            )
          else
            ..._shortlistedPlayers.map((player) {
              return _buildShortlistItem(player);
            }).toList(),
          SizedBox(height: isCompact ? 16 : 24),
          const Divider(color: Colors.grey),
          SizedBox(height: isCompact ? 16 : 24),
          // Position needs
          Text(
            'POSITION NEEDS',
            style: TextStyle(
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: isCompact ? 12 : 16),
          _buildPositionNeed('Striker', 'High Priority', Colors.red),
          _buildPositionNeed('Midfielder', 'Medium Priority', Colors.orange),
          _buildPositionNeed('Defender', 'Low Priority', Colors.green),
        ],
      ),
    ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required double change,
    required IconData icon,
    required Color color,
    bool isCompact = false,
  }) {
    final isPositive = change > 0;
    final hasChange = change != 0;

    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isCompact ? 6 : 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: isCompact ? 18 : 20),
              ),
              SizedBox(width: isCompact ? 8 : 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[400],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 8 : 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isCompact ? 22 : 28,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              if (hasChange) ...[
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive
                        ? const Color(0xFF22c55e).withOpacity(0.2)
                        : const Color(0xFFef4444).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 12,
                        color: isPositive ? const Color(0xFF22c55e) : const Color(0xFFef4444),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${change.abs().toStringAsFixed(1)}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isPositive ? const Color(0xFF22c55e) : const Color(0xFFef4444),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShortlistItem(Player player) {
    final positionColor = _getPositionColor(player.position);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: positionColor, width: 2),
            ),
            child: ClipOval(
              child: Image.asset(
                player.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[700],
                    child: Icon(Icons.person, color: Colors.grey[500], size: 20),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  player.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  player.displayPosition,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: _getRatingColor(player.rating),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              player.rating.toStringAsFixed(1),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            color: Colors.grey[500],
            onPressed: () => _toggleShortlist(player),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildPositionNeed(String position, String priority, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  priority,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getPositionColor(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.goalkeeper:
        return const Color(0xFFeab308);
      case PlayerPosition.defender:
        return const Color(0xFF3b82f6);
      case PlayerPosition.midfielder:
        return const Color(0xFF22c55e);
      case PlayerPosition.forward:
        return const Color(0xFFef4444);
    }
  }

  Color _getRatingColor(double rating) {
    if (rating >= 9.0) return const Color(0xFFfbbf24);
    if (rating >= 8.0) return const Color(0xFF22c55e);
    if (rating >= 7.0) return const Color(0xFF0d59f2);
    return Colors.grey[600]!;
  }

  void _showPlayerDetails(Player player) {
    showDialog(
      context: context,
      builder: (context) => _PlayerDetailsDialog(
        player: player,
        onShortlistToggle: () => _toggleShortlist(player),
        isShortlisted: _isShortlisted(player),
      ),
    );
  }

  Widget _buildLastTransfers() {
    final transfers = DataProvider.recentTransfers;

    return Container(
      color: const Color(0xFF101622),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1e2736),
              border: Border(bottom: BorderSide(color: Colors.grey[800]!, width: 1)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8b5cf6).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.history,
                    color: Color(0xFF8b5cf6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Last Premier League Transfers',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Recent high-profile moves',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Transfer List
          Expanded(
            child: ScrollConfiguration(
              behavior: SmoothScrollBehavior(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: transfers.length,
                itemBuilder: (context, index) {
                  final transfer = transfers[index];
                  return _buildTransferCard(transfer, index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransferCard(RecentTransfer transfer, int index) {
    final positionColor = _getPositionColorForString(transfer.position);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1e2736),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!, width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Player name and position
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: positionColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: positionColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        transfer.position,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: positionColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        transfer.playerName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF22c55e).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        transfer.fee,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF22c55e),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Transfer direction
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF101622),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'FROM',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transfer.fromClub,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward,
                        color: Colors.grey[600],
                        size: 20,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0d59f2).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF0d59f2).withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TO',
                              style: TextStyle(
                                fontSize: 9,
                                color: Colors.grey[400],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transfer.toClub,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF0d59f2),
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Date
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      transfer.date,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPositionColorForString(String position) {
    if (position == 'GK') return const Color(0xFFeab308);
    if (position.contains('B') || position.contains('D')) return const Color(0xFF3b82f6);
    if (position.contains('M') || position.contains('AM') || position.contains('DM')) {
      return const Color(0xFF22c55e);
    }
    return const Color(0xFFef4444); // Forwards
  }
}

class _PlayerDetailsDialog extends StatelessWidget {
  final Player player;
  final VoidCallback onShortlistToggle;
  final bool isShortlisted;

  const _PlayerDetailsDialog({
    required this.player,
    required this.onShortlistToggle,
    required this.isShortlisted,
  });

  @override
  Widget build(BuildContext context) {
    final positionColor = _getPositionColor(player.position);

    return Dialog(
      backgroundColor: const Color(0xFF1e2736),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: positionColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: positionColor.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 2,
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
                          child: Icon(Icons.person, color: Colors.grey[500], size: 40),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        player.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.shield, size: 14, color: Colors.grey[400]),
                          const SizedBox(width: 4),
                          Text(
                            player.club,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Colors.grey[400]),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Stats
            Row(
              children: [
                _buildDetailStat('Rating', player.rating.toStringAsFixed(1), positionColor),
                const SizedBox(width: 12),
                _buildDetailStat('Age', '${player.age}', Colors.grey[600]!),
                const SizedBox(width: 12),
                _buildDetailStat('Position', player.displayPosition, positionColor),
              ],
            ),
            const SizedBox(height: 24),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      onShortlistToggle();
                      Navigator.pop(context);
                    },
                    icon: Icon(isShortlisted ? Icons.star : Icons.star_border),
                    label: Text(isShortlisted ? 'Remove from Shortlist' : 'Add to Shortlist'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isShortlisted
                          ? Colors.grey[700]
                          : const Color(0xFF0d59f2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailStat(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPositionColor(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.goalkeeper:
        return const Color(0xFFeab308);
      case PlayerPosition.defender:
        return const Color(0xFF3b82f6);
      case PlayerPosition.midfielder:
        return const Color(0xFF22c55e);
      case PlayerPosition.forward:
        return const Color(0xFFef4444);
    }
  }
}
