import 'package:flutter/foundation.dart';
import '../../core/utils/api_service.dart';

class HomeController with ChangeNotifier {
  Map<String, dynamic>? _dashboardData;
  bool _isLoading = false;

  Map<String, dynamic>? get dashboardData => _dashboardData;
  bool get isLoading => _isLoading;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.getDashboardOverview();
      if (response['success']) {
        _dashboardData = response['data'];
      }
    } catch (e) {
      // Handle error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}