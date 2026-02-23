import 'package:flutter/foundation.dart';
import '../../../core/utils/api_service.dart';

class ParkController with ChangeNotifier {
  Map<String, dynamic>? _dashboardData;
  List<dynamic> _parks = [];
  List<dynamic> _incidents = [];
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get dashboardData => _dashboardData;
  List<dynamic> get parks => _parks;
  List<dynamic> get incidents => _incidents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getParkDashboard();
      if (response['success']) {
        _dashboardData = response['data'];
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadParks() async {
    try {
      final response = await ApiService.getParks();
      if (response['success']) {
        _parks = response['data']['parks'];
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadIncidents() async {
    try {
      final response = await ApiService.getAlerts();
      if (response['success']) {
        _incidents = response['data']['alerts']
            .where((a) => a['module'] == 'park')
            .toList();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
