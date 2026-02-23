import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../core/constants/map_config.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040810),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1628),
        title: const Text('Live Map', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.layers, color: Color(0xFF00AAFF)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.my_location, color: Color(0xFF00AAFF)),
            onPressed: () => _goToLocation(),
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(MapConfig.defaultLatitude, MapConfig.defaultLongitude),
              initialZoom: MapConfig.defaultZoom,
              minZoom: 5,
              maxZoom: 18,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v12/tiles/{z}/{x}/{y}?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': MapConfig.mapboxAccessToken,
                },
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(MapConfig.defaultLatitude, MapConfig.defaultLongitude),
                    width: 40,
                    height: 40,
                    child: Icon(Icons.location_pin, color: Color(0xFFFF3366), size: 40),
                  ),
                ],
              ),
            ],
          ),
          _buildSearchBar(),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1628).withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2872A1).withOpacity(0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Color(0xFF00AAFF), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Text('Search locations...', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Positioned(
      bottom: 16,
      left: 16,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0A1628).withOpacity(0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF2872A1).withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Legend', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF00AAFF))),
            const SizedBox(height: 8),
            _LegendItem(color: const Color(0xFF00CC66), label: 'Farms'),
            _LegendItem(color: const Color(0xFF00AAFF), label: 'Parks'),
            _LegendItem(color: const Color(0xFFFFAA00), label: 'Land Zones'),
            _LegendItem(color: const Color(0xFFFF3366), label: 'Alerts'),
          ],
        ),
      ),
    );
  }

  void _goToLocation() {
    _mapController.move(
      LatLng(MapConfig.defaultLatitude, MapConfig.defaultLongitude),
      MapConfig.defaultZoom,
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white70)),
        ],
      ),
    );
  }
}
