import 'package:flutter/foundation.dart';
import '../../../core/utils/api_service.dart';

class FarmController with ChangeNotifier {
  Map<String, dynamic>? _dashboardData;
  List<dynamic> _farms = [];
  List<dynamic> _alerts = [];
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get dashboardData => _dashboardData;
  List<dynamic> get farms => _farms;
  List<dynamic> get alerts => _alerts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadDashboard() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getFarmDashboard();
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

  Future<void> loadFarms() async {
    try {
      final response = await ApiService.getFarms();
      if (response['success']) {
        _farms = response['data']['farms'];
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> loadAlerts() async {
    try {
      final response = await ApiService.getAlerts();
      if (response['success']) {
        _alerts = response['data']['alerts']
            .where((a) => a['module'] == 'farm')
            .toList();
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
