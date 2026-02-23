import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth_controller.dart';
import 'home_screen.dart';
import '../../../shared/widgets/map_screen.dart';
import '../../farm/presentation/farm_dashboard.dart';
import '../../park/presentation/park_dashboard.dart';
import '../../land/presentation/land_dashboard.dart';
import 'profile_screen.dart';

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final services = authController.user?.services ?? [];

    final List<_NavItem> navItems = [
      _NavItem(icon: Icons.dashboard, label: 'Dashboard', screen: const HomeScreen()),
      if (services.any((s) => s.name == 'farm')) 
        _NavItem(icon: Icons.agriculture, label: 'Farm', screen: const FarmDashboard()),
      if (services.any((s) => s.name == 'park')) 
        _NavItem(icon: Icons.pets, label: 'Park', screen: const ParkDashboard()),
      if (services.any((s) => s.name == 'land')) 
        _NavItem(icon: Icons.landscape, label: 'Land', screen: const LandDashboard()),
      _NavItem(icon: Icons.map, label: 'Map', screen: const MapScreen()),
      _NavItem(icon: Icons.person, label: 'Profile', screen: const ProfileScreen()),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF040810),
      body: IndexedStack(
        index: _currentIndex,
        children: navItems.map((item) => item.screen).toList(),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A1628),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(navItems.length, (index) {
                final item = navItems[index];
                final isSelected = _currentIndex == index;
                return Expanded(
                  child: InkWell(
                    onTap: () => setState(() => _currentIndex = index),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected ? const Color(0xFF00AAFF) : Colors.white54,
                            size: 24,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected ? const Color(0xFF00AAFF) : Colors.white54,
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final Widget screen;

  _NavItem({required this.icon, required this.label, required this.screen});
}
