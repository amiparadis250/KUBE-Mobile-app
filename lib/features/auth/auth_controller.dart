import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/utils/api_service.dart';
import '../../data/models/user.dart';
import '../../core/constants/app_constants.dart';

class AuthController with ChangeNotifier {
  bool _isAuthenticated = false;
  User? _user;
  ServiceType _currentService = ServiceType.farm;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  User? get user => _user;
  ServiceType get currentService => _currentService;
  bool get isLoading => _isLoading;

  void switchService(ServiceType service) {
    if (_user?.services.contains(service) ?? false) {
      _currentService = service;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userData = prefs.getString('user_data');
    if (token != null && userData != null) {
      _isAuthenticated = true;
      _user = User.fromJson({
        'id': prefs.getString('user_id'),
        'email': prefs.getString('user_email'),
        'firstName': prefs.getString('user_firstName'),
        'lastName': prefs.getString('user_lastName'),
        'role': prefs.getString('user_role'),
        'services': prefs.getStringList('user_services') ?? ['farm'],
      });
      _currentService = _user!.services.first;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      debugPrint('🔐 AuthController: Starting login for $email');
      final response = await ApiService.login(email, password);
      debugPrint('✅ AuthController: Login response received - Success: ${response['success']}');
      debugPrint('📦 AuthController: User data: ${response['data']['user']}');
      
      if (response['success']) {
        _isAuthenticated = true;
        _user = User.fromJson(response['data']['user']);
        debugPrint('👤 AuthController: Parsed user services: ${_user!.services.map((s) => s.name).toList()}');
        _currentService = _user!.services.first;
        
        await _saveUserData();
        
        _isLoading = false;
        notifyListeners();
        debugPrint('✅ AuthController: Login successful for ${_user!.email}');
        return true;
      }
    } catch (e) {
      debugPrint('❌ AuthController: Login failed - Error: $e');
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', 'true');
    await prefs.setString('user_id', _user!.id);
    await prefs.setString('user_email', _user!.email);
    await prefs.setString('user_firstName', _user!.firstName);
    await prefs.setString('user_lastName', _user!.lastName);
    await prefs.setString('user_role', _user!.role.name);
    await prefs.setStringList('user_services', _user!.services.map((s) => s.name).toList());
  }

  void updateUserFromBackend(Map<String, dynamic> userData) {
    _user = User.fromJson(userData);
    _currentService = _user!.services.first;
    _saveUserData();
    notifyListeners();
  }

  Future<void> logout() async {
    _isAuthenticated = false;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }
}