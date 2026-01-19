import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
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
            child: _buildNavigationMenu(context),
          ),

          // Footer
          _buildSideMenuFooter(),
        ],
      ),
    );
  }

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

  Widget _buildNavigationMenu(BuildContext context) {
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
          label: 'Squad Management',
          isActive: false,
          onTap: () {
            Navigator.pushNamed(context, '/squad');
          },
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
}
