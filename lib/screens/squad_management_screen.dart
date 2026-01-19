import 'package:flutter/material.dart';
import 'dart:async';
import '../models/player.dart';
import '../data/data_provider.dart';
import '../widgets/side_menu.dart';

// Content-only widget for use in MainShellScreen (without Scaffold and SideMenu)
class SquadManagementContent extends StatefulWidget {
  const SquadManagementContent({super.key});

  @override
  State<SquadManagementContent> createState() => _SquadManagementContentState();
}

class _SquadManagementContentState extends State<SquadManagementContent> {
  String _selectedFilter = 'All Players';

  final ScrollController _scrollController = ScrollController();
  bool _isDragging = false;
  Offset _lastDragPosition = Offset.zero;
  Timer? _scrollTimer;

  late List<Player> _squadPlayers;
  late List<Player> _suggestedPlayers;
  final Set<String> _transferListedPlayers = {};

  @override
  void initState() {
    super.initState();
    _squadPlayers = List.from(DataProvider.squadPlayers);
    _suggestedPlayers = List.from(DataProvider.suggestedPlayers);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  List<Player> _sortPlayers(List<Player> players) {
    List<Player> sortedPlayers = List.from(players);
    switch (_selectedFilter) {
      case 'Sort by Rating':
        sortedPlayers.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Sort by Age':
        sortedPlayers.sort((a, b) => a.age.compareTo(b.age));
        break;
      case 'Transfer Listed':
        sortedPlayers = sortedPlayers
            .where((p) => _transferListedPlayers.contains(p.name))
            .toList();
        break;
      default:
        break;
    }
    return sortedPlayers;
  }

  void _toggleTransferListed(Player player) {
    setState(() {
      if (_transferListedPlayers.contains(player.name)) {
        _transferListedPlayers.remove(player.name);
      } else {
        _transferListedPlayers.add(player.name);
      }
    });
  }

  void _startAutoScroll(DragUpdateDetails details, BuildContext context) {
    _lastDragPosition = details.globalPosition;
    if (_scrollTimer != null && _scrollTimer!.isActive) return;

    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isDragging) {
        timer.cancel();
        return;
      }
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;
      final localPosition = renderBox.globalToLocal(_lastDragPosition);
      const scrollThreshold = 50.0;
      if (localPosition.dy < scrollThreshold) {
        _scrollController.jumpTo(_scrollController.offset - 20);
      } else if (localPosition.dy > renderBox.size.height - scrollThreshold) {
        _scrollController.jumpTo(_scrollController.offset + 20);
      }
    });
  }

  List<Player> get _filteredPlayers => _squadPlayers;

  Map<PlayerPosition, List<Player>> get _playersByPosition {
    final Map<PlayerPosition, List<Player>> grouped = {};
    for (var player in _filteredPlayers) {
      if (!grouped.containsKey(player.position)) {
        grouped[player.position] = [];
      }
      grouped[player.position]!.add(player);
    }
    return grouped;
  }

  void _movePlayerToSquad(Player player, PlayerPosition targetPosition) {
    setState(() {
      _suggestedPlayers.remove(player);
      final updatedPlayer = player.copyWith(
        position: targetPosition,
        isSuggested: false,
      );
      _squadPlayers.add(updatedPlayer);
    });
  }

  void _movePlayerToSuggested(Player player) {
    setState(() {
      _squadPlayers.remove(player);
      final updatedPlayer = player.copyWith(isSuggested: true);
      _suggestedPlayers.add(updatedPlayer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebLayout = screenWidth > 900;
    return isWebLayout ? _buildWebContent() : _buildMobileContent();
  }

  Widget _buildMobileContent() {
    return Column(
      children: [
        _buildTeamHeader(),
        _buildFilterChips(),
        Expanded(child: _buildPlayersList()),
      ],
    );
  }

  Widget _buildWebContent() {
    return Column(
      children: [
        _buildWebTopBar(),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildTeamHeader(),
                    _buildFilterChips(),
                    Expanded(child: _buildWebSquadList()),
                  ],
                ),
              ),
              Container(width: 1, color: Colors.grey[800]),
              Expanded(flex: 2, child: _buildWebRightPanel()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWebTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Row(
        children: [
          const Text(
            'Squad Management',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF0d59f2).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF0d59f2).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.people, size: 20, color: Color(0xFF0d59f2)),
                const SizedBox(width: 8),
                Text(
                  '${_squadPlayers.length} Players',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0d59f2)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebSquadList() {
    final groupedPlayers = _playersByPosition;
    final orderedPositions = [
      PlayerPosition.goalkeeper,
      PlayerPosition.defender,
      PlayerPosition.midfielder,
      PlayerPosition.forward,
    ];

    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 6,
      radius: const Radius.circular(3),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: orderedPositions.length,
        itemBuilder: (context, index) {
          final position = orderedPositions[index];
          final players = groupedPlayers[position] ?? [];
          if (players.isEmpty) return const SizedBox.shrink();
          return _buildPositionSection(position, players);
        },
      ),
    );
  }

  Widget _buildWebRightPanel() {
    return Container(
      color: const Color(0xFF0d1117),
      child: Column(
        children: [
          _buildWebSquadStats(),
          Expanded(child: _buildWebSuggestedPlayersPanel()),
        ],
      ),
    );
  }

  Widget _buildWebSquadStats() {
    final totalPlayers = _squadPlayers.length;
    final avgRating = _squadPlayers.isNotEmpty
        ? _squadPlayers.map((p) => p.rating).reduce((a, b) => a + b) / totalPlayers
        : 0.0;
    final avgAge = _squadPlayers.isNotEmpty
        ? _squadPlayers.map((p) => p.age).reduce((a, b) => a + b) / totalPlayers
        : 0.0;
    final transferListedCount = _transferListedPlayers.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1c2433),
        border: Border(bottom: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SQUAD OVERVIEW', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard('Total', '$totalPlayers', Icons.groups, const Color(0xFF0d59f2)),
              const SizedBox(width: 12),
              _buildStatCard('Avg Rating', avgRating.toStringAsFixed(1), Icons.star, const Color(0xFF22c55e)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard('Avg Age', avgAge.toStringAsFixed(1), Icons.cake, const Color(0xFFeab308)),
              const SizedBox(width: 12),
              _buildStatCard('Listed', '$transferListedCount', Icons.sell, const Color(0xFFef4444)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                  Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 11), overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebSuggestedPlayersPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[800]!))),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFFc41e3a).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.star_rounded, color: Color(0xFFc41e3a), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SUGGESTED', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1), overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('From Liverpool FC', style: TextStyle(color: Colors.grey[400], fontSize: 11), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFFc41e3a).withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                child: Text('${_suggestedPlayers.length}', style: const TextStyle(color: Color(0xFFc41e3a), fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        Expanded(
          child: DragTarget<Player>(
            onWillAcceptWithDetails: (details) => !details.data.isSuggested,
            onAcceptWithDetails: (details) => _movePlayerToSuggested(details.data),
            builder: (context, candidateData, rejectedData) {
              final isHighlighted = candidateData.isNotEmpty;
              return Container(
                decoration: BoxDecoration(
                  color: isHighlighted ? const Color(0xFFc41e3a).withOpacity(0.05) : Colors.transparent,
                  border: isHighlighted ? Border.all(color: const Color(0xFFc41e3a), width: 2) : null,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _suggestedPlayers.length,
                  itemBuilder: (context, index) => _buildDraggablePlayerItem(_suggestedPlayers[index], false),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF1c2433), border: Border(top: BorderSide(color: Colors.grey[800]!))),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 16),
                  label: const Text('Scout', overflow: TextOverflow.ellipsis),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0d59f2), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, size: 16),
                  label: const Text('Filter', overflow: TextOverflow.ellipsis),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.grey[400], padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8), side: BorderSide(color: Colors.grey[700]!), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1c2433),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!.withOpacity(0.5), width: 1),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFF1e3a5f)),
                ),
                Positioned(
                  bottom: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFF0d59f2), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1c2433), width: 2)),
                    child: const Text('1st', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Manchester Blue', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.groups, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text('${_squadPlayers.length}/28', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      const SizedBox(width: 12),
                      Container(width: 1, height: 12, color: Colors.grey[600]),
                      const SizedBox(width: 12),
                      const Icon(Icons.account_balance_wallet, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      const Text('£15.5m', style: TextStyle(color: Color(0xFF4ade80), fontSize: 14, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = ['All Players', 'Sort by Rating', 'Sort by Age', 'Transfer Listed'];
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(filter, style: TextStyle(color: isSelected ? Colors.white : Colors.grey[400], fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500)),
                  if (filter.contains('Sort')) Padding(padding: const EdgeInsets.only(left: 4), child: Icon(Icons.sort, size: 16, color: isSelected ? Colors.white : Colors.grey[400])),
                ],
              ),
              selected: isSelected,
              onSelected: (value) => setState(() => _selectedFilter = filter),
              backgroundColor: const Color(0xFF1c2433),
              selectedColor: const Color(0xFF0d59f2),
              side: BorderSide(color: isSelected ? const Color(0xFF0d59f2) : Colors.grey[700]!, width: 1),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayersList() {
    final groupedPlayers = _playersByPosition;
    final orderedPositions = [PlayerPosition.goalkeeper, PlayerPosition.defender, PlayerPosition.midfielder, PlayerPosition.forward];
    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 6,
      radius: const Radius.circular(3),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: orderedPositions.length + (_suggestedPlayers.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < orderedPositions.length) {
            final position = orderedPositions[index];
            final players = groupedPlayers[position] ?? [];
            if (players.isEmpty) return const SizedBox.shrink();
            return _buildPositionSection(position, players);
          } else {
            return Column(children: [const SizedBox(height: 24), _buildSuggestedPlayersSection()]);
          }
        },
      ),
    );
  }

  Widget _buildPositionSection(PlayerPosition position, List<Player> players) {
    final sortedPlayers = _sortPlayers(players);
    if (sortedPlayers.isEmpty && _selectedFilter == 'Transfer Listed') return const SizedBox.shrink();

    return DragTarget<Player>(
      onWillAcceptWithDetails: (details) => details.data.isSuggested,
      onAcceptWithDetails: (details) => _movePlayerToSquad(details.data, position),
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;
        final displayPlayers = sortedPlayers;
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isHighlighted ? _getPositionColor(position).withOpacity(0.1) : const Color(0xFF101622),
            border: isHighlighted ? Border.all(color: _getPositionColor(position), width: 2) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF101622).withOpacity(0.95),
                  border: Border(bottom: BorderSide(color: Colors.grey[800]!.withOpacity(0.5), width: 1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(width: 4, height: 16, decoration: BoxDecoration(color: _getPositionColor(position), borderRadius: BorderRadius.circular(2))),
                        const SizedBox(width: 8),
                        Text(_getPositionName(position).toUpperCase(), style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(4)),
                      child: Text('${displayPlayers.length}', style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
              ...displayPlayers.map((player) => _buildDraggablePlayerItem(player, false)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestedPlayersSection() {
    return DragTarget<Player>(
      onWillAcceptWithDetails: (details) => !details.data.isSuggested,
      onAcceptWithDetails: (details) => _movePlayerToSuggested(details.data),
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isHighlighted ? const Color(0xFFc41e3a).withOpacity(0.1) : const Color(0xFF1c2433),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isHighlighted ? const Color(0xFFc41e3a) : Colors.grey[800]!.withOpacity(0.5), width: isHighlighted ? 2 : 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[800]!.withOpacity(0.5), width: 1))),
                child: Row(
                  children: [
                    Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFc41e3a).withOpacity(0.2), borderRadius: BorderRadius.circular(8)), child: const Icon(Icons.star_rounded, color: Color(0xFFc41e3a), size: 20)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('SUGGESTED PLAYERS', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
                          const SizedBox(height: 2),
                          Text('From Liverpool FC • Drag to add to squad', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFc41e3a).withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
                      child: Text('${_suggestedPlayers.length}', style: const TextStyle(color: Color(0xFFc41e3a), fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              ..._suggestedPlayers.map((player) => _buildDraggablePlayerItem(player, false)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggablePlayerItem(Player player, bool isCompact) {
    final positionColor = _getPositionColor(player.position);
    return LongPressDraggable<Player>(
      data: player,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () => setState(() => _isDragging = true),
      onDragUpdate: (details) {
        _lastDragPosition = details.globalPosition;
        final renderBox = context.findRenderObject() as RenderBox?;
        if (renderBox != null) {
          final localPosition = renderBox.globalToLocal(details.globalPosition);
          const scrollThreshold = 50.0;
          if (localPosition.dy < scrollThreshold || localPosition.dy > renderBox.size.height - scrollThreshold) {
            _startAutoScroll(details, context);
          }
        }
      },
      onDragEnd: (details) {
        setState(() => _isDragging = false);
        _scrollTimer?.cancel();
        _scrollTimer = null;
      },
      onDraggableCanceled: (velocity, offset) {
        setState(() => _isDragging = false);
        _scrollTimer?.cancel();
        _scrollTimer = null;
      },
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: const Color(0xFF1c2433), borderRadius: BorderRadius.circular(12), border: Border.all(color: positionColor, width: 2)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(radius: 16, backgroundImage: AssetImage(player.imageUrl)),
              const SizedBox(width: 8),
              Flexible(child: Text(player.name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _buildPlayerItem(player)),
      child: _buildPlayerItem(player),
    );
  }

  Widget _buildPlayerItem(Player player) {
    final positionColor = _getPositionColor(player.position);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[800]!.withOpacity(0.5), width: 1))),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[700]!, width: 1)),
                child: ClipOval(
                  child: Image.asset(player.imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[800], child: Icon(Icons.person, color: Colors.grey[600], size: 24))),
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(color: positionColor, shape: BoxShape.circle, border: Border.all(color: const Color(0xFF101622), width: 2)),
                  child: Center(child: Text('${player.shirtNumber}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(player.name, style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    if (_transferListedPlayers.contains(player.name)) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFFef4444).withOpacity(0.2), borderRadius: BorderRadius.circular(3)),
                        child: const Text('LISTED', style: TextStyle(color: Color(0xFFef4444), fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                    if (player.isSuggested) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFFc41e3a).withOpacity(0.2), borderRadius: BorderRadius.circular(3)),
                        child: Text(player.club, style: const TextStyle(color: Color(0xFFc41e3a), fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: positionColor.withOpacity(0.2), borderRadius: BorderRadius.circular(3)),
                      child: Text(player.displayPosition, style: TextStyle(color: positionColor, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    Text('${player.age} yrs', style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(player.rating.toStringAsFixed(1), style: TextStyle(color: player.rating >= 8.5 ? const Color(0xFF0d59f2) : Colors.grey[400], fontSize: 14, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text('RATING', style: TextStyle(color: Colors.grey[500], fontSize: 10)),
            ],
          ),
          const SizedBox(width: 12),
          if (!player.isSuggested)
            GestureDetector(
              onTap: () => _toggleTransferListed(player),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _transferListedPlayers.contains(player.name) ? const Color(0xFFef4444).withOpacity(0.2) : Colors.transparent,
                  border: Border.all(color: _transferListedPlayers.contains(player.name) ? const Color(0xFFef4444) : Colors.grey[700]!, width: 1),
                ),
                child: Icon(_transferListedPlayers.contains(player.name) ? Icons.sell : Icons.sell_outlined, color: _transferListedPlayers.contains(player.name) ? const Color(0xFFef4444) : Colors.grey[600], size: 14),
              ),
            ),
          if (!player.isSuggested) const SizedBox(width: 8),
          Icon(Icons.drag_indicator, color: Colors.grey[600], size: 20),
        ],
      ),
    );
  }

  String _getPositionName(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.goalkeeper: return 'Goalkeepers';
      case PlayerPosition.defender: return 'Defenders';
      case PlayerPosition.midfielder: return 'Midfielders';
      case PlayerPosition.forward: return 'Forwards';
    }
  }

  Color _getPositionColor(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.goalkeeper: return const Color(0xFFeab308);
      case PlayerPosition.defender: return const Color(0xFF3b82f6);
      case PlayerPosition.midfielder: return const Color(0xFF22c55e);
      case PlayerPosition.forward: return const Color(0xFFef4444);
    }
  }
}

// Original full-page widget (kept for backward compatibility)
class SquadManagementScreen extends StatefulWidget {
  const SquadManagementScreen({super.key});

  @override
  State<SquadManagementScreen> createState() => _SquadManagementScreenState();
}

class _SquadManagementScreenState extends State<SquadManagementScreen> {
  String _selectedFilter = 'All Players';
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Add ScrollController for the list
  final ScrollController _scrollController = ScrollController();

  // Add drag position tracking
  bool _isDragging = false;
  Offset _lastDragPosition = Offset.zero;
  Timer? _scrollTimer;

  // Mutable lists for drag and drop
  late List<Player> _squadPlayers;
  late List<Player> _suggestedPlayers;

  // Track transfer listed players
  final Set<String> _transferListedPlayers = {};

  @override
  void initState() {
    super.initState();
    _squadPlayers = List.from(DataProvider.squadPlayers);
    _suggestedPlayers = List.from(DataProvider.suggestedPlayers);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollTimer?.cancel();
    super.dispose();
  }

  // Sort players based on selected filter
  List<Player> _sortPlayers(List<Player> players) {
    List<Player> sortedPlayers = List.from(players);

    switch (_selectedFilter) {
      case 'Sort by Rating':
        sortedPlayers.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'Sort by Age':
        sortedPlayers.sort((a, b) => a.age.compareTo(b.age));
        break;
      case 'Transfer Listed':
        sortedPlayers = sortedPlayers
            .where((p) => _transferListedPlayers.contains(p.name))
            .toList();
        break;
      default:
        // All Players - no sorting
        break;
    }

    return sortedPlayers;
  }

  // Toggle transfer listed status
  void _toggleTransferListed(Player player) {
    setState(() {
      if (_transferListedPlayers.contains(player.name)) {
        _transferListedPlayers.remove(player.name);
      } else {
        _transferListedPlayers.add(player.name);
      }
    });
  }

  // Method to handle auto-scrolling during drag
  void _startAutoScroll(DragUpdateDetails details, BuildContext context) {
    _lastDragPosition = details.globalPosition;

    if (_scrollTimer != null && _scrollTimer!.isActive) {
      return;
    }

    _scrollTimer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_isDragging) {
        timer.cancel();
        return;
      }

      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox == null) return;

      final localPosition = renderBox.globalToLocal(_lastDragPosition);
      final scrollThreshold = 50.0;

      // Check if we're near the top
      if (localPosition.dy < scrollThreshold) {
        // Scroll up
        _scrollController.jumpTo(
          _scrollController.offset - 20,
        );
      }
      // Check if we're near the bottom
      else if (localPosition.dy > renderBox.size.height - scrollThreshold) {
        // Scroll down
        _scrollController.jumpTo(
          _scrollController.offset + 20,
        );
      }
    });
  }


  List<Player> get _filteredPlayers {
    return _squadPlayers;
  }

  Map<PlayerPosition, List<Player>> get _playersByPosition {
    final Map<PlayerPosition, List<Player>> grouped = {};
    for (var player in _filteredPlayers) {
      if (!grouped.containsKey(player.position)) {
        grouped[player.position] = [];
      }
      grouped[player.position]!.add(player);
    }
    return grouped;
  }

  void _movePlayerToSquad(Player player, PlayerPosition targetPosition) {
    setState(() {
      _suggestedPlayers.remove(player);
      // Update the player's position to match the target section
      final updatedPlayer = player.copyWith(
        position: targetPosition,
        isSuggested: false,
      );
      _squadPlayers.add(updatedPlayer);
    });
  }

  void _movePlayerToSuggested(Player player) {
    setState(() {
      _squadPlayers.remove(player);
      final updatedPlayer = player.copyWith(isSuggested: true);
      _suggestedPlayers.add(updatedPlayer);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebLayout = screenWidth > 900;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF101622),
      drawer: isWebLayout ? null : _buildDrawer(),
      body: SafeArea(
        child: isWebLayout ? _buildWebLayout() : _buildMobileLayout(),
      ),
      // floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildDrawer() {
    return const Drawer(
      backgroundColor: Color(0xFF0d1117),
      child: SideMenu(),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [
        // Left Side Menu
        const SideMenu(),
        // Main Content - Two Column Layout
        Expanded(
          child: Column(
            children: [
              _buildWebTopBar(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left Column - Squad Players
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          _buildTeamHeader(),
                          _buildFilterChips(),
                          Expanded(
                            child: _buildWebSquadList(),
                          ),
                        ],
                      ),
                    ),
                    // Divider
                    Container(
                      width: 1,
                      color: Colors.grey[800],
                    ),
                    // Right Column - Suggested Players & Stats
                    Expanded(
                      flex: 2,
                      child: _buildWebRightPanel(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWebSquadList() {
    final groupedPlayers = _playersByPosition;
    final orderedPositions = [
      PlayerPosition.goalkeeper,
      PlayerPosition.defender,
      PlayerPosition.midfielder,
      PlayerPosition.forward,
    ];

    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 6,
      radius: const Radius.circular(3),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 24),
        itemCount: orderedPositions.length,
        itemBuilder: (context, index) {
          final position = orderedPositions[index];
          final players = groupedPlayers[position] ?? [];
          if (players.isEmpty) return const SizedBox.shrink();
          return _buildPositionSection(position, players);
        },
      ),
    );
  }

  Widget _buildWebRightPanel() {
    return Container(
      color: const Color(0xFF0d1117),
      child: Column(
        children: [
          // Squad Stats Header
          _buildWebSquadStats(),
          // Suggested Players Section
          Expanded(
            child: _buildWebSuggestedPlayersPanel(),
          ),
        ],
      ),
    );
  }

  Widget _buildWebSquadStats() {
    final totalPlayers = _squadPlayers.length;
    final avgRating = _squadPlayers.isNotEmpty
        ? _squadPlayers.map((p) => p.rating).reduce((a, b) => a + b) / totalPlayers
        : 0.0;
    final avgAge = _squadPlayers.isNotEmpty
        ? _squadPlayers.map((p) => p.age).reduce((a, b) => a + b) / totalPlayers
        : 0.0;
    final transferListedCount = _transferListedPlayers.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1c2433),
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SQUAD OVERVIEW',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildStatCard(
                'Total',
                '$totalPlayers',
                Icons.groups,
                const Color(0xFF0d59f2),
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Avg Rating',
                avgRating.toStringAsFixed(1),
                Icons.star,
                const Color(0xFF22c55e),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatCard(
                'Avg Age',
                avgAge.toStringAsFixed(1),
                Icons.cake,
                const Color(0xFFeab308),
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Listed',
                '$transferListedCount',
                Icons.sell,
                const Color(0xFFef4444),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebSuggestedPlayersPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[800]!),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFc41e3a).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.star_rounded,
                  color: Color(0xFFc41e3a),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SUGGESTED',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'From Liverpool FC',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFc41e3a).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_suggestedPlayers.length}',
                  style: const TextStyle(
                    color: Color(0xFFc41e3a),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Suggested Players List
        Expanded(
          child: DragTarget<Player>(
            onWillAcceptWithDetails: (details) {
              return !details.data.isSuggested;
            },
            onAcceptWithDetails: (details) {
              _movePlayerToSuggested(details.data);
            },
            builder: (context, candidateData, rejectedData) {
              final isHighlighted = candidateData.isNotEmpty;

              return Container(
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? const Color(0xFFc41e3a).withOpacity(0.05)
                      : Colors.transparent,
                  border: isHighlighted
                      ? Border.all(color: const Color(0xFFc41e3a), width: 2)
                      : null,
                ),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _suggestedPlayers.length,
                  itemBuilder: (context, index) {
                    return _buildDraggablePlayerItem(_suggestedPlayers[index], false);
                  },
                ),
              );
            },
          ),
        ),
        // Quick Actions
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1c2433),
            border: Border(
              top: BorderSide(color: Colors.grey[800]!),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.search, size: 16),
                  label: const Text('Scout', overflow: TextOverflow.ellipsis),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0d59f2),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, size: 16),
                  label: const Text('Filter', overflow: TextOverflow.ellipsis),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                    side: BorderSide(color: Colors.grey[700]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWebTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[800]!),
        ),
      ),
      child: Row(
        children: [
          const Text(
            'Squad Management',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
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
                  Icons.people,
                  size: 20,
                  color: Color(0xFF0d59f2),
                ),
                const SizedBox(width: 8),
                Text(
                  '${_squadPlayers.length} Players',
                  style: const TextStyle(
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

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildTopAppBar(),
        _buildTeamHeader(),
        _buildFilterChips(),
        Expanded(
          child: _buildPlayersList(),
        ),
      ],
    );
  }

  Widget _buildTopAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101622).withOpacity(0.95),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _scaffoldKey.currentState?.openDrawer(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
              ),
              child: const Icon(
                Icons.menu,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          const Expanded(
            child: Text(
              'Squad Management',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent,
              ),
              child: const Icon(
                Icons.more_horiz,
                color: Color(0xFF0d59f2),
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1c2433),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[800]!.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Team Logo
            Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFF1e3a5f),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://upload.wikimedia.org/wikipedia/en/e/eb/Manchester_City_FC_badge.svg',
                      ),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -8,
                  right: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0d59f2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFF1c2433),
                        width: 2,
                      ),
                    ),
                    child: const Text(
                      '1st',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            // Team Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Manchester Blue',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.groups,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${_squadPlayers.length}/28',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 1,
                        height: 12,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.account_balance_wallet,
                        color: Colors.grey,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '£15.5m',
                        style: TextStyle(
                          color: Color(0xFF4ade80),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      'All Players',
      'Sort by Rating',
      'Sort by Age',
      'Transfer Listed',
    ];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[400],
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  if (filter.contains('Sort'))
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.sort,
                        size: 16,
                        color: isSelected ? Colors.white : Colors.grey[400],
                      ),
                    ),
                ],
              ),
              selected: isSelected,
              onSelected: (value) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              backgroundColor: const Color(0xFF1c2433),
              selectedColor: const Color(0xFF0d59f2),
              side: BorderSide(
                color: isSelected ? const Color(0xFF0d59f2) : Colors.grey[700]!,
                width: 1,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPlayersList() {
    final groupedPlayers = _playersByPosition;
    final orderedPositions = [
      PlayerPosition.goalkeeper,
      PlayerPosition.defender,
      PlayerPosition.midfielder,
      PlayerPosition.forward,
    ];

    return RawScrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      thickness: 6,
      radius: const Radius.circular(3),
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: orderedPositions.length + (_suggestedPlayers.isNotEmpty ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < orderedPositions.length) {
            final position = orderedPositions[index];
            final players = groupedPlayers[position] ?? [];
            if (players.isEmpty) return const SizedBox.shrink();
            return _buildPositionSection(position, players);
          } else {
            return Column(
              children: [
                const SizedBox(height: 24),
                _buildSuggestedPlayersSection(),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildPositionSection(PlayerPosition position, List<Player> players) {
    // Apply sorting/filtering to this section's players
    final sortedPlayers = _sortPlayers(players);

    // Don't show section if no players after filtering
    if (sortedPlayers.isEmpty && _selectedFilter == 'Transfer Listed') {
      return const SizedBox.shrink();
    }

    return DragTarget<Player>(
      onWillAcceptWithDetails: (details) {
        // Accept players from suggested list
        return details.data.isSuggested;
      },
      onAcceptWithDetails: (details) {
        _movePlayerToSquad(details.data, position);
      },
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;
        final displayPlayers = _selectedFilter == 'Transfer Listed' ? sortedPlayers : sortedPlayers;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: isHighlighted
                ? _getPositionColor(position).withOpacity(0.1)
                : const Color(0xFF101622),
            border: isHighlighted
                ? Border.all(color: _getPositionColor(position), width: 2)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Section Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF101622).withOpacity(0.95),
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[800]!.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 4,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _getPositionColor(position),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _getPositionName(position).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${displayPlayers.length}',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Players
              ...displayPlayers.map((player) => _buildDraggablePlayerItem(player, false)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestedPlayersSection() {
    return DragTarget<Player>(
      onWillAcceptWithDetails: (details) {
        // Accept players from squad (non-suggested)
        return !details.data.isSuggested;
      },
      onAcceptWithDetails: (details) {
        _movePlayerToSuggested(details.data);
      },
      builder: (context, candidateData, rejectedData) {
        final isHighlighted = candidateData.isNotEmpty;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isHighlighted
                ? const Color(0xFFc41e3a).withOpacity(0.1)
                : const Color(0xFF1c2433),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHighlighted
                  ? const Color(0xFFc41e3a)
                  : Colors.grey[800]!.withOpacity(0.5),
              width: isHighlighted ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey[800]!.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFc41e3a).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFc41e3a),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'SUGGESTED PLAYERS',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'From Liverpool FC • Drag to add to squad',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFc41e3a).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${_suggestedPlayers.length}',
                        style: const TextStyle(
                          color: Color(0xFFc41e3a),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Suggested Players List
              ...(_suggestedPlayers.map((player) =>
                _buildDraggablePlayerItem(player, false)
              ).toList()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDraggablePlayerItem(Player player, bool isCompact) {
    final positionColor = _getPositionColor(player.position);

    return LongPressDraggable<Player>(
      data: player,
      dragAnchorStrategy: pointerDragAnchorStrategy,
      onDragStarted: () {
        setState(() {
          _isDragging = true;
        });
      },
      onDragUpdate: (details) {
        _lastDragPosition = details.globalPosition;

        // Start auto-scroll check when near edges
        final context = _scaffoldKey.currentContext;
        if (context != null) {
          final renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox != null) {
            final localPosition = renderBox.globalToLocal(details.globalPosition);
            const scrollThreshold = 50.0;

            if (localPosition.dy < scrollThreshold ||
                localPosition.dy > renderBox.size.height - scrollThreshold) {
              _startAutoScroll(details, context);
            }
          }
        }
      },
      onDragEnd: (details) {
        setState(() {
          _isDragging = false;
        });
        _scrollTimer?.cancel();
        _scrollTimer = null;
      },
      onDraggableCanceled: (velocity, offset) {
        setState(() {
          _isDragging = false;
        });
        _scrollTimer?.cancel();
        _scrollTimer = null;
      },
      feedback: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: isCompact ? 100 : 200,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1c2433),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: positionColor,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(player.imageUrl),
              ),
              if (!isCompact) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    player.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: isCompact
            ? _buildCompactPlayerCard(player, positionColor)
            : _buildPlayerItem(player),
      ),
      child: isCompact
          ? _buildCompactPlayerCard(player, positionColor)
          : _buildPlayerItem(player),
    );
  }

  Widget _buildCompactPlayerCard(Player player, Color positionColor) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF101622),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.grey[800]!.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: positionColor,
                    width: 2,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    player.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: positionColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    player.displayPosition,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            player.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            player.rating.toStringAsFixed(1),
            style: TextStyle(
              color: player.rating >= 8.5
                  ? const Color(0xFF0d59f2)
                  : Colors.grey[400],
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerItem(Player player) {
    final positionColor = _getPositionColor(player.position);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[800]!.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // Player Avatar with Jersey Number
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[700]!,
                    width: 1,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    player.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: Icon(
                          Icons.person,
                          color: Colors.grey[600],
                          size: 24,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: positionColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF101622),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${player.shirtNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Player Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      player.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_transferListedPlayers.contains(player.name)) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFef4444).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Text(
                          'LISTED',
                          style: TextStyle(
                            color: Color(0xFFef4444),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    if (player.isSuggested) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(
                          color: const Color(0xFFc41e3a).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Text(
                          player.club,
                          style: const TextStyle(
                            color: Color(0xFFc41e3a),
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: positionColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: Text(
                        player.displayPosition,
                        style: TextStyle(
                          color: positionColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${player.age} yrs',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Rating
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                player.rating.toStringAsFixed(1),
                style: TextStyle(
                  color: player.rating >= 8.5
                      ? const Color(0xFF0d59f2)
                      : Colors.grey[400],
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'RATING',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Transfer List Toggle (only for squad players, not suggested)
          if (!player.isSuggested)
            GestureDetector(
              onTap: () => _toggleTransferListed(player),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _transferListedPlayers.contains(player.name)
                      ? const Color(0xFFef4444).withOpacity(0.2)
                      : Colors.transparent,
                  border: Border.all(
                    color: _transferListedPlayers.contains(player.name)
                        ? const Color(0xFFef4444)
                        : Colors.grey[700]!,
                    width: 1,
                  ),
                ),
                child: Icon(
                  _transferListedPlayers.contains(player.name)
                      ? Icons.sell
                      : Icons.sell_outlined,
                  color: _transferListedPlayers.contains(player.name)
                      ? const Color(0xFFef4444)
                      : Colors.grey[600],
                  size: 14,
                ),
              ),
            ),
          if (!player.isSuggested) const SizedBox(width: 8),
          // Drag Handle
          Icon(
            Icons.drag_indicator,
            color: Colors.grey[600],
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        // Handle add player
      },
      backgroundColor: const Color(0xFF0d59f2),
      child: const Icon(
        Icons.add,
        size: 32,
        color: Colors.white,
      ),
    );
  }

  String _getPositionName(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.goalkeeper:
        return 'Goalkeepers';
      case PlayerPosition.defender:
        return 'Defenders';
      case PlayerPosition.midfielder:
        return 'Midfielders';
      case PlayerPosition.forward:
        return 'Forwards';
    }
  }

  Color _getPositionColor(PlayerPosition position) {
    switch (position) {
      case PlayerPosition.goalkeeper:
        return const Color(0xFFeab308); // Yellow
      case PlayerPosition.defender:
        return const Color(0xFF3b82f6); // Blue
      case PlayerPosition.midfielder:
        return const Color(0xFF22c55e); // Green
      case PlayerPosition.forward:
        return const Color(0xFFef4444); // Red
    }
  }
}
