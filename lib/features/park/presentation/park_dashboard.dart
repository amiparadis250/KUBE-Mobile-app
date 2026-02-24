import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../park_controller.dart';

class ParkDashboard extends StatefulWidget {
  const ParkDashboard({super.key});

  @override
  State<ParkDashboard> createState() => _ParkDashboardState();
}

class _ParkDashboardState extends State<ParkDashboard> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ParkController>().loadDashboard();
      context.read<ParkController>().loadIncidents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ParkController>(
      builder: (context, controller, child) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator(color: Color(0xFF00AAFF)));
        }

        final stats = controller.dashboardData?['stats'];
        final incidents = controller.incidents;
        final wildlife = controller.dashboardData?['wildlifePopulations'] ?? [];

        return SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatsGrid(stats),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildActivePatrols(),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildWildlifeStatus(wildlife),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              _buildIncidents(incidents),
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
            _StatCard(title: 'Active Patrols', value: '${stats?['activePatrols'] ?? 0}', color: const Color(0xFF00AAFF)),
            _StatCard(title: 'Wildlife Species', value: '${stats?['wildlifeSpecies'] ?? 0}', color: const Color(0xFF00CC66)),
            _StatCard(title: 'Incidents', value: '${stats?['incidentsCount'] ?? 0}', color: const Color(0xFFFF3366)),
            _StatCard(title: 'Parks', value: '${stats?['parks'] ?? 0}', color: const Color(0xFFFFAA00)),
          ],
        );
      },
    );
  }

  Widget _buildActivePatrols() {
    final patrols = [
      {'name': 'North Sector Patrol', 'ranger': 'Team Alpha', 'status': 'Active', 'duration': '2h 15m'},
      {'name': 'River Border Watch', 'ranger': 'Team Bravo', 'status': 'Active', 'duration': '1h 45m'},
      {'name': 'Night Thermal Scan', 'ranger': 'Team Charlie', 'status': 'Scheduled', 'duration': 'Starts 20:00'},
    ];

    return _SectionCard(
      title: 'ACTIVE PATROLS',
      icon: Icons.security,
      color: const Color(0xFF00AAFF),
      child: Column(
        children: patrols.map((patrol) => _PatrolItem(
          name: patrol['name']!,
          ranger: patrol['ranger']!,
          status: patrol['status']!,
          duration: patrol['duration']!,
        )).toList(),
      ),
    );
  }

  Widget _buildWildlifeStatus(List<dynamic> wildlife) {
    return _SectionCard(
      title: 'WILDLIFE STATUS',
      icon: Icons.pets,
      color: const Color(0xFF00CC66),
      child: wildlife.isEmpty
          ? const Text('No wildlife data', style: TextStyle(color: Colors.white70, fontSize: 12))
          : Column(
              children: wildlife.take(5).map((s) => _WildlifeItem(
                name: s['commonName'] ?? s['species'] ?? 'Unknown',
                count: s['estimatedCount'] ?? 0,
                status: s['trend'] ?? 'stable',
                endangered: s['conservationStatus']?.toString().contains('endangered') ?? false,
              )).toList(),
            ),
    );
  }

  Widget _buildIncidents(List<dynamic> incidents) {

    return _SectionCard(
      title: 'RECENT INCIDENTS',
      icon: Icons.report_problem,
      color: const Color(0xFFFF3366),
      child: incidents.isEmpty
          ? const Text('No incidents', style: TextStyle(color: Colors.white70, fontSize: 12))
          : Column(
              children: incidents.take(5).map((incident) => _IncidentItem(
                type: incident['title'] ?? 'Incident',
                location: incident['location'] ?? 'Unknown',
                severity: incident['severity'] ?? 'MEDIUM',
                time: _formatTime(incident['createdAt']),
              )).toList(),
            ),
    );
  }

  String _formatTime(dynamic timestamp) {
    if (timestamp == null) return 'Recently';
    try {
      final date = DateTime.parse(timestamp.toString());
      final diff = DateTime.now().difference(date);
      if (diff.inHours < 1) return '${diff.inMinutes}m ago';
      if (diff.inDays < 1) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (e) {
      return 'Recently';
    }
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

class _PatrolItem extends StatelessWidget {
  final String name;
  final String ranger;
  final String status;
  final String duration;

  const _PatrolItem({required this.name, required this.ranger, required this.status, required this.duration});

  @override
  Widget build(BuildContext context) {
    final isActive = status == 'Active';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2872A1).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFF00CC66) : const Color(0xFFFFAA00),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                Text(ranger, style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
          Text(duration, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}

class _WildlifeItem extends StatelessWidget {
  final String name;
  final int count;
  final String status;
  final bool endangered;

  const _WildlifeItem({required this.name, required this.count, required this.status, required this.endangered});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (status) {
      case 'Increasing':
        statusColor = const Color(0xFF00CC66);
        break;
      case 'Critical':
        statusColor = const Color(0xFFFF3366);
        break;
      default:
        statusColor = const Color(0xFF00AAFF);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B2E).withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2872A1).withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    if (endangered) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF3366).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('ENDANGERED', style: TextStyle(color: Color(0xFFFF3366), fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('$count individuals', style: const TextStyle(color: Colors.white70, fontSize: 10)),
                    const SizedBox(width: 8),
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    Text(status, style: TextStyle(color: statusColor, fontSize: 10)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _IncidentItem extends StatelessWidget {
  final String type;
  final String location;
  final String severity;
  final String time;

  const _IncidentItem({required this.type, required this.location, required this.severity, required this.time});

  @override
  Widget build(BuildContext context) {
    final color = severity == 'CRITICAL' ? const Color(0xFFFF3366) : const Color(0xFFFFAA00);
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
                Text(type, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(location, style: const TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ),
          Text(time, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}
