import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<HomeController>().loadDashboardData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040810),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2872A1), Color(0xFF00AAFF)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.satellite_alt, size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text('KUBE Command Center', style: TextStyle(color: Colors.white, fontSize: 16)),
          ],
        ),
      ),
      body: Consumer<HomeController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFF00AAFF)));
          }

          final stats = controller.dashboardData?['stats'];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatsGrid(stats),
                const SizedBox(height: 16),
                _buildAlertsSection(),
                const SizedBox(height: 16),
                _buildFarmSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic>? stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2,
      children: [
        _StatCard(title: 'Animals', value: '${stats?['animals'] ?? 0}', color: const Color(0xFF0066FF)),
        _StatCard(title: 'Farms', value: '${stats?['farms'] ?? 0}', color: const Color(0xFF00CC66)),
        _StatCard(title: 'Active Alerts', value: '${stats?['activeAlerts'] ?? 0}', color: const Color(0xFFFF3366)),
        _StatCard(title: 'Parks', value: '${stats?['parks'] ?? 0}', color: const Color(0xFFFFAA00)),
      ],
    );
  }

  Widget _buildAlertsSection() {
    final alerts = [
      {'title': 'Fever Detected in Multiple Animals', 'message': 'Thermal imaging detected elevated temperatures', 'severity': 'CRITICAL'},
      {'title': 'Missing Animals Detected', 'message': '3 cattle not detected in last survey', 'severity': 'WARNING'},
      {'title': 'Pasture Degradation Warning', 'message': 'NDVI dropping below threshold', 'severity': 'WARNING'},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2872A1).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning, color: Color(0xFFFF3366), size: 16),
              SizedBox(width: 8),
              Text('LIVE ALERTS', style: TextStyle(color: Color(0xFFFF3366), fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ...alerts.map((alert) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: alert['severity'] == 'CRITICAL' 
                ? const Color(0xFFFF3366).withOpacity(0.1)
                : const Color(0xFFFFAA00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: alert['severity'] == 'CRITICAL' 
                  ? const Color(0xFFFF3366).withOpacity(0.3)
                  : const Color(0xFFFFAA00).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(alert['title']!, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(alert['message']!, style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildFarmSection() {
    final herds = [
      {'name': 'Main Dairy Herd', 'type': 'Cattle', 'count': 245, 'healthy': 230, 'sick': 12, 'missing': 3},
      {'name': 'Beef Cattle Herd', 'type': 'Cattle', 'count': 180, 'healthy': 175, 'sick': 5, 'missing': 0},
      {'name': 'Community Goat Herd', 'type': 'Goats', 'count': 156, 'healthy': 148, 'sick': 7, 'missing': 1},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2872A1).withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.agriculture, color: Color(0xFF00CC66), size: 16),
              SizedBox(width: 8),
              Text('HERD STATUS', style: TextStyle(color: Color(0xFF00CC66), fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ...herds.map((herd) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1B2E).withOpacity(0.5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF2872A1).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(herd['name'] as String, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('${herd['count']} ${herd['type']}', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _StatusDot(color: const Color(0xFF00CC66), count: herd['healthy'] as int, label: 'Healthy'),
                    const SizedBox(width: 12),
                    _StatusDot(color: const Color(0xFFFF3366), count: herd['sick'] as int, label: 'Sick'),
                    const SizedBox(width: 12),
                    _StatusDot(color: const Color(0xFFFFAA00), count: herd['missing'] as int, label: 'Missing'),
                  ],
                ),
              ],
            ),
          )),
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
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1628).withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: color.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final Color color;
  final int count;
  final String label;

  const _StatusDot({required this.color, required this.count, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text('$count $label', style: TextStyle(color: color, fontSize: 9)),
      ],
    );
  }
}