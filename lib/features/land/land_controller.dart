import 'package:flutter/foundation.dart';
import '../../../core/utils/api_service.dart';

class LandController with ChangeNotifier {
  Map<String, dynamic>? _dashboardData;
  List<dynamic> _zones = [];
  List<dynamic> _changes = [];
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get dashboardData => _dashboardData;
  List<dynamic> get zones => _zones;
  List<dynamic> get changes => _changes;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getLandDashboard();
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

  Future<void> loadZones() async {
    try {
      final response = await ApiService.getLandZones();
      if (response['success']) {
        _zones = response['data']['zones'];
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadChanges() async {
    try {
      final response = await ApiService.getAlerts();
      if (response['success']) {
        _changes = response['data']['alerts']
            .where((a) => a['module'] == 'land')
            .toList();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
