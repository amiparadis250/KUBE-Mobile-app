import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../farm_controller.dart';

class FarmDashboard extends StatefulWidget {
  const FarmDashboard({super.key});

  @override
  State<FarmDashboard> createState() => _FarmDashboardState();
}

class _FarmDashboardState extends State<FarmDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<FarmController>().loadDashboard();
      context.read<FarmController>().loadAlerts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FarmController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00CC66)));
        }

        final stats = controller.dashboardData?['stats'];
        final alerts = controller.alerts;
        final herds = controller.dashboardData?['herds'] ?? [];

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(stats),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildAlertsSection(alerts),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildHerdsSection(herds),
            ],
          ),
        );
      },
    );
      },
    );
  }

  Widget _buildStatsGrid(Map<String, dynamic>? stats) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
        final aspectRatio = constraints.maxWidth > 600 ? 1.2 : 1.5;
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: constraints.maxWidth * 0.03,
          mainAxisSpacing: constraints.maxWidth * 0.03,
          childAspectRatio: aspectRatio,
          children: [
            _StatCard(title: 'Total Animals', value: '${stats?['totalAnimals'] ?? 0}', color: const Color(0xFF00CC66)),
            _StatCard(title: 'Health Rate', value: '${stats?['healthRate'] ?? 0}%', color: const Color(0xFF0066FF)),
            _StatCard(title: 'Sick Animals', value: '${stats?['sickAnimals'] ?? 0}', color: const Color(0xFFFF3366)),
            _StatCard(title: 'Missing', value: '${stats?['missingAnimals'] ?? 0}', color: const Color(0xFFFFAA00)),
          ],
        );
      },
    );
  }

  Widget _buildAlertsSection(List<dynamic> alerts) {

    return _SectionCard(
      title: 'LIVE ALERTS',
      icon: Icons.warning,
      color: const Color(0xFFFF3366),
      child: alerts.isEmpty
          ? const Text('No alerts', style: TextStyle(color: Colors.white70, fontSize: 12))
          : Column(
              children: alerts.take(5).map((alert) => _AlertItem(
                title: alert['title'] ?? 'Alert',
                message: alert['message'] ?? '',
                isCritical: alert['severity'] == 'CRITICAL',
              )).toList(),
            ),
    );
  }

  Widget _buildHerdsSection(List<dynamic> herds) {

    return _SectionCard(
      title: 'HERD STATUS',
      icon: Icons.agriculture,
      color: const Color(0xFF00CC66),
      child: herds.isEmpty
          ? const Text('No herds', style: TextStyle(color: Colors.white70, fontSize: 12))
          : Column(
              children: herds.take(5).map((herd) => _HerdItem(
                name: herd['name'] ?? 'Unknown',
                type: herd['animalType'] ?? 'Cattle',
                count: herd['totalCount'] ?? 0,
                healthy: herd['healthyCount'] ?? 0,
                sick: herd['sickCount'] ?? 0,
                missing: herd['missingCount'] ?? 0,
              )).toList(),
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
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final Widget child;

  const _SectionCard({required this.title, required this.icon, required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
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
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(title, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _AlertItem extends StatelessWidget {
  final String title;
  final String message;
  final bool isCritical;

  const _AlertItem({required this.title, required this.message, required this.isCritical});

  @override
  Widget build(BuildContext context) {
    final color = isCritical ? const Color(0xFFFF3366) : const Color(0xFFFFAA00);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(message, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}

class _HerdItem extends StatelessWidget {
  final String name;
  final String type;
  final int count;
  final int healthy;
  final int sick;
  final int missing;

  const _HerdItem({
    required this.name,
    required this.type,
    required this.count,
    required this.healthy,
    required this.sick,
    required this.missing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              Text('$count $type', style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _StatusDot(color: const Color(0xFF00CC66), count: healthy, label: 'Healthy'),
              const SizedBox(width: 12),
              _StatusDot(color: const Color(0xFFFF3366), count: sick, label: 'Sick'),
              const SizedBox(width: 12),
              _StatusDot(color: const Color(0xFFFFAA00), count: missing, label: 'Missing'),
            ],
          ),
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
