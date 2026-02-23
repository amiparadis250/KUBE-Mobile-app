import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_controller.dart';
import '../../auth/auth_controller.dart';
import '../../auth/presentation/login_screen.dart';
import '../../../core/constants/app_constants.dart';
import '../../farm/presentation/farm_dashboard.dart';
import '../../park/presentation/park_dashboard.dart';
import '../../land/presentation/land_dashboard.dart';
import '../../../shared/widgets/notification_bell.dart';
import '../../../shared/widgets/settings_screen.dart';
import '../../../shared/widgets/offline_indicator.dart';
import '../../../shared/widgets/map_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<HomeController>(context, listen: false).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final user = authController.user;
    final currentService = authController.currentService;

    String title;
    switch (currentService) {
      case ServiceType.farm:
        title = 'KUBE-Farm';
        break;
      case ServiceType.park:
        title = 'KUBE-Park';
        break;
      case ServiceType.land:
        title = 'KUBE-Land';
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2872A1), Color(0xFF00AAFF)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.satellite_alt, size: 20, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Text(title),
          ],
        ),
        actions: [
          const NotificationBell(),
          if (user != null && user.services.length > 1)
            PopupMenuButton<ServiceType>(
              icon: const Icon(Icons.apps),
              onSelected: (service) => authController.switchService(service),
              itemBuilder: (context) => ServiceType.values
                  .where((s) => user.services.contains(s))
                  .map((service) => PopupMenuEntry<ServiceType>(
                        value: service,
                        child: PopupMenuItem<ServiceType>(
                          value: service,
                          child: Row(
                            children: [
                              Icon(
                                service == ServiceType.farm
                                    ? Icons.agriculture
                                    : service == ServiceType.park
                                        ? Icons.park
                                        : Icons.landscape,
                                size: 16,
                                color: currentService == service ? const Color(0xFF00AAFF) : Colors.white70,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'KUBE-${service.name[0].toUpperCase()}${service.name.substring(1)}',
                                style: TextStyle(
                                  color: currentService == service ? const Color(0xFF00AAFF) : Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                  .toList(),
            ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          PopupMenuButton(
            child: CircleAvatar(
              backgroundColor: const Color(0xFF2872A1),
              child: Text(
                user?.initials ?? 'U',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                enabled: false,
                child: Text(user?.fullName ?? 'User'),
              ),
              PopupMenuItem(
                enabled: false,
                child: Text('Role: ${user?.role.name ?? "Unknown"}'),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                onTap: () async {
                  await authController.logout();
                  if (mounted) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  }
                },
                child: const Row(
                  children: [
                    Icon(Icons.logout, size: 16),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          const OfflineIndicator(),
          Expanded(child: _selectedIndex == 3 ? const MapScreen() : _buildDashboard(currentService)),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(currentService),
    );
  }

  Widget _buildDashboard(ServiceType service) {
    switch (service) {
      case ServiceType.farm:
        return const FarmDashboard();
      case ServiceType.park:
        return const ParkDashboard();
      case ServiceType.land:
        return const LandDashboard();
    }
  }

  BottomNavigationBar? _buildBottomNav(ServiceType service) {
    List<BottomNavigationBarItem> items;
    switch (service) {
      case ServiceType.farm:
        items = const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Herds'),
          BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Health'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        ];
        break;
      case ServiceType.park:
        items = const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Patrols'),
          BottomNavigationBarItem(icon: Icon(Icons.pets), label: 'Wildlife'),
          BottomNavigationBarItem(icon: Icon(Icons.report), label: 'Incidents'),
        ];
        break;
      case ServiceType.land:
        items = const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.landscape), label: 'Zones'),
          BottomNavigationBarItem(icon: Icon(Icons.eco), label: 'Vegetation'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        ];
        break;
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFF0A1628),
      selectedItemColor: const Color(0xFF00AAFF),
      unselectedItemColor: Colors.white54,
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: items,
    );
  }
}