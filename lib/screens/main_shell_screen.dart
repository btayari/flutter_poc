import 'package:flutter/material.dart';
import 'tactical_lineup_screen.dart';
import 'squad_management_screen.dart';

class MainShellScreen extends StatefulWidget {
  final int initialIndex;

  const MainShellScreen({super.key, this.initialIndex = 0});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onMenuItemSelected(int index) {
    if (index >= 0) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget _getSelectedScreen() {
    switch (_selectedIndex) {
      case 0:
        return const TacticalLineupContent();
      case 1:
        return const SquadManagementContent();
      default:
        return const TacticalLineupContent();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWebLayout = screenWidth > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF101622),
      drawer: isWebLayout ? null : _buildDrawer(),
      body: SafeArea(
        child: isWebLayout ? _buildWebLayout() : _buildMobileLayout(),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0d1117),
      child: _SideMenuWithCallback(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          _onMenuItemSelected(index);
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildWebLayout() {
    return Row(
      children: [
        _SideMenuWithCallback(
          selectedIndex: _selectedIndex,
          onItemSelected: _onMenuItemSelected,
        ),
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: KeyedSubtree(
              key: ValueKey(_selectedIndex),
              child: _getSelectedScreen(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildMobileAppBar(),
        Expanded(child: _getSelectedScreen()),
      ],
    );
  }

  Widget _buildMobileAppBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101622),
        border: Border(bottom: BorderSide(color: Colors.grey[800]!, width: 1)),
      ),
      child: Row(
        children: [
          Builder(
            builder: (context) => GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.menu, color: Colors.white, size: 24),
              ),
            ),
          ),
          Expanded(
            child: Text(
              _selectedIndex == 0 ? 'Match Prediction' : 'Squad Management',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.settings, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideMenuWithCallback extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const _SideMenuWithCallback({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: const Color(0xFF0d1117),
        border: Border(right: BorderSide(color: Colors.grey[800]!)),
      ),
      child: Column(
        children: [
          _buildUserProfile(),
          const SizedBox(height: 24),
          Expanded(child: _buildNavigationMenu()),
          _buildSideMenuFooter(),
        ],
      ),
    );
  }

  Widget _buildUserProfile() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[800]!))),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF0d59f2), width: 3),
              boxShadow: [BoxShadow(color: const Color(0xFF0d59f2).withOpacity(0.3), blurRadius: 12, spreadRadius: 2)],
            ),
            child: ClipOval(
              child: Container(
                color: Colors.grey[800],
                child: Icon(Icons.person, size: 40, color: Colors.grey[400]),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text('John Manager', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text('john.manager@mancity.com', style: TextStyle(fontSize: 13, color: Colors.grey[400])),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFF1e2736), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[800]!)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF6CABDD)),
                  child: const Icon(Icons.shield, size: 16, color: Colors.white),
                ),
                const SizedBox(width: 8),
                Text('Manchester City', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.grey[300])),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationMenu() {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        _buildMenuItem(icon: Icons.home_rounded, label: 'Home', index: -1, isActive: false),
        _buildMenuItem(icon: Icons.assessment_rounded, label: 'Prediction', index: 0, isActive: selectedIndex == 0),
        _buildMenuItem(icon: Icons.swap_horiz_rounded, label: 'Transfers', index: -1, isActive: false),
        _buildMenuItem(icon: Icons.search_rounded, label: 'Scouting', index: -1, isActive: false),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('TEAM MANAGEMENT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2)),
        ),
        _buildMenuItem(icon: Icons.people_rounded, label: 'Squad Management', index: 1, isActive: selectedIndex == 1),
        _buildMenuItem(icon: Icons.bar_chart_rounded, label: 'Statistics', index: -1, isActive: false),
        _buildMenuItem(icon: Icons.event_note_rounded, label: 'Fixtures', index: -1, isActive: false),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text('SETTINGS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey[500], letterSpacing: 1.2)),
        ),
        _buildMenuItem(icon: Icons.settings_rounded, label: 'Settings', index: -1, isActive: false),
        _buildMenuItem(icon: Icons.help_rounded, label: 'Help & Support', index: -1, isActive: false),
      ],
    );
  }

  Widget _buildMenuItem({required IconData icon, required String label, required int index, required bool isActive}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0d59f2).withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isActive ? Border.all(color: const Color(0xFF0d59f2).withOpacity(0.3)) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onItemSelected(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 22, color: isActive ? const Color(0xFF0d59f2) : Colors.grey[400]),
                const SizedBox(width: 14),
                Expanded(child: Text(label, style: TextStyle(fontSize: 14, fontWeight: isActive ? FontWeight.w600 : FontWeight.w500, color: isActive ? Colors.white : Colors.grey[400]))),
                if (isActive) Container(width: 6, height: 6, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF0d59f2))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideMenuFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[800]!))),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: const Color(0xFF1e2736), borderRadius: BorderRadius.circular(8)),
            child: Icon(Icons.nightlight_round, size: 18, color: Colors.grey[400]),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text('Dark Mode', style: TextStyle(fontSize: 13, color: Colors.grey[400]))),
          Switch(value: true, onChanged: (value) {}, activeColor: const Color(0xFF0d59f2), materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
        ],
      ),
    );
  }
}
