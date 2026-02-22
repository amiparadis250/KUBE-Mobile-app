import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_controller.dart';
import '../../auth/auth_controller.dart';
import '../../auth/presentation/login_screen.dart';

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
            const Text('KUBE Command Center'),
          ],
        ),
        actions: [
          PopupMenuButton(
            child: CircleAvatar(
              backgroundColor: const Color(0xFF2872A1),
              child: Text(
                user != null ? '${user['firstName'][0]}${user['lastName'][0]}' : 'U',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                enabled: false,
                child: Text('${user?['firstName']} ${user?['lastName']}'),
              ),
              PopupMenuItem(
                enabled: false,
                child: Text('Role: ${user?['role']}'),
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
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          _OverviewTab(),
          _FarmTab(),
          _ParkTab(),
          _MapTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF0A1628),
        selectedItemColor: const Color(0xFF00AAFF),
        unselectedItemColor: Colors.white54,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Overview'),
          BottomNavigationBarItem(icon: Icon(Icons.agriculture), label: 'Farm'),
          BottomNavigationBarItem(icon: Icon(Icons.park), label: 'Park'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('System Status', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _StatCard(title: 'Active Drones', value: '8', color: const Color(0xFF00CC66)),
                  _StatCard(title: 'Farms Monitored', value: '12', color: const Color(0xFF2872A1)),
                  _StatCard(title: 'Wildlife Parks', value: '3', color: const Color(0xFF00AAFF)),
                  _StatCard(title: 'Active Alerts', value: '2', color: const Color(0xFFFF3366)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FarmTab extends StatelessWidget {
  const _FarmTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.agriculture, size: 64, color: Color(0xFF00CC66)),
          SizedBox(height: 16),
          Text('KUBE-Farm', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('Livestock Intelligence', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _ParkTab extends StatelessWidget {
  const _ParkTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.park, size: 64, color: Color(0xFF00AAFF)),
          SizedBox(height: 16),
          Text('KUBE-Park', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('Wildlife Protection', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _MapTab extends StatelessWidget {
  const _MapTab();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map, size: 64, color: Color(0xFFFFAA00)),
          SizedBox(height: 16),
          Text('Aerial Command', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          Text('Live Map View', style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}