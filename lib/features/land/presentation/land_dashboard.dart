import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../land_controller.dart';

class LandDashboard extends StatefulWidget {
  const LandDashboard({super.key});

  @override
  State<LandDashboard> createState() => _LandDashboardState();
}

class _LandDashboardState extends State<LandDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<LandController>().loadDashboard();
      context.read<LandController>().loadChanges();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LandController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00CC66)));
        }

        final stats = controller.dashboardData?['stats'];
        final changes = controller.changes;
        final zones = controller.dashboardData?['zones'] ?? [];

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(stats),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildDegradationAlerts(changes),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildLandZones(zones),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildVegetationHealth(),
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
            _StatCard(title: 'Total Zones', value: '${stats?['totalZones'] ?? 0}', color: const Color(0xFF00CC66)),
            _StatCard(title: 'Healthy Zones', value: '${stats?['healthyZones'] ?? 0}', color: const Color(0xFF00AAFF)),
            _StatCard(title: 'Degraded', value: '${stats?['degradedZones'] ?? 0}', color: const Color(0xFFFF3366)),
            _StatCard(title: 'Health Rate', value: '${stats?['healthRate'] ?? 0}%', color: const Color(0xFFFFAA00)),
          ],
        );
      },
    );
  }

  Widget _buildDegradationAlerts(List<dynamic> changes) {

    return _SectionCard(
      title: 'DEGRADATION ALERTS',
      icon: Icons.warning_amber,
      color: const Color(0xFFFF3366),
      child: changes.isEmpty
          ? const Text('No alerts', style: TextStyle(color: Colors.white70, fontSize: 12))
          : Column(
              children: changes.take(5).map((alert) => _AlertItem(
                title: alert['title'] ?? 'Land Change',
                location: alert['location'] ?? 'Unknown',
                severity: alert['severity'] ?? 'MEDIUM',
                area: '${alert['details'] ?? 'N/A'}',
              )).toList(),
            ),
    );
  }

  Widget _buildLandZones(List<dynamic> zones) {

    return _SectionCard(
      title: 'LAND ZONES',
      icon: Icons.landscape,
      color: const Color(0xFF00CC66),
      child: zones.isEmpty
          ? const Text('No zones', style: TextStyle(color: Colors.white70, fontSize: 12))
          : Column(
              children: zones.take(5).map((zone) => _ZoneItem(
                name: zone['name'] ?? 'Unknown Zone',
                area: (zone['area'] ?? 0).toInt(),
                health: (zone['soilHealth'] ?? 70).toInt(),
                ndvi: (zone['vegetationIndex'] ?? 0.5).toDouble(),
                status: _getZoneStatus(zone['degradationLevel']),
              )).toList(),
            ),
    );
  }

  String _getZoneStatus(dynamic degradation) {
    if (degradation == null) return 'Moderate';
    final level = degradation is int ? degradation : int.tryParse(degradation.toString()) ?? 50;
    if (level < 20) return 'Excellent';
    if (level < 40) return 'Healthy';
    if (level < 60) return 'Moderate';
    return 'Degraded';
  }

  Widget _buildVegetationHealth() {
    return _SectionCard(
      title: 'VEGETATION ANALYSIS',
      icon: Icons.eco,
      color: const Color(0xFF00AAFF),
      child: Column(
        children: [
          _VegetationMetric(label: 'NDVI Index', value: '0.68', trend: 'up', color: const Color(0xFF00CC66)),
          const SizedBox(height: 8),
          _VegetationMetric(label: 'Biomass', value: '12.4 t/ha', trend: 'stable', color: const Color(0xFF00AAFF)),
          const SizedBox(height: 8),
          _VegetationMetric(label: 'Tree Canopy', value: '42%', trend: 'down', color: const Color(0xFFFFAA00)),
          const SizedBox(height: 8),
          _VegetationMetric(label: 'Bare Ground', value: '8%', trend: 'up', color: const Color(0xFFFF3366)),
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
  final String location;
  final String severity;
  final String area;

  const _AlertItem({required this.title, required this.location, required this.severity, required this.area});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (severity) {
      case 'CRITICAL':
        color = const Color(0xFFFF3366);
        break;
      case 'HIGH':
        color = const Color(0xFFFF6633);
        break;
      default:
        color = const Color(0xFFFFAA00);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$location • $area', style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(severity, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _ZoneItem extends StatelessWidget {
  final String name;
  final int area;
  final int health;
  final double ndvi;
  final String status;

  const _ZoneItem({required this.name, required this.area, required this.health, required this.ndvi, required this.status});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Excellent':
        statusColor = const Color(0xFF00CC66);
        break;
      case 'Healthy':
        statusColor = const Color(0xFF00AAFF);
        break;
      case 'Moderate':
        statusColor = const Color(0xFFFFAA00);
        break;
      default:
        statusColor = const Color(0xFFFF3366);
    }

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
              Text('$area ha', style: const TextStyle(color: Colors.white70, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _Metric(label: 'Health', value: '$health%', color: statusColor),
              const SizedBox(width: 16),
              _Metric(label: 'NDVI', value: ndvi.toStringAsFixed(2), color: const Color(0xFF00AAFF)),
              const Spacer(),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Text(status, style: TextStyle(color: statusColor, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _Metric({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: const TextStyle(color: Colors.white70, fontSize: 9)),
        Text(value, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _VegetationMetric extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final Color color;

  const _VegetationMetric({required this.label, required this.value, required this.trend, required this.color});

  @override
  Widget build(BuildContext context) {
    IconData trendIcon;
    switch (trend) {
      case 'up':
        trendIcon = Icons.trending_up;
        break;
      case 'down':
        trendIcon = Icons.trending_down;
        break;
      default:
        trendIcon = Icons.trending_flat;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ),
          Text(value, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Icon(trendIcon, color: color, size: 16),
        ],
      ),
    );
  }
}
