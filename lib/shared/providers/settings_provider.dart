import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage { english, french, swahili }
enum UnitSystem { metric, imperial }

class SettingsProvider with ChangeNotifier {
  AppLanguage _language = AppLanguage.english;
  bool _notificationsEnabled = true;
  bool _offlineMode = false;
  UnitSystem _unitSystem = UnitSystem.metric;

  AppLanguage get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get offlineMode => _offlineMode;
  UnitSystem get unitSystem => _unitSystem;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _language = AppLanguage.values[prefs.getInt('language') ?? 0];
    _notificationsEnabled = prefs.getBool('notifications') ?? true;
    _offlineMode = prefs.getBool('offline_mode') ?? false;
    _unitSystem = UnitSystem.values[prefs.getInt('unit_system') ?? 0];
    notifyListeners();
  }

  Future<void> setLanguage(AppLanguage language) async {
    _language = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('language', language.index);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications', enabled);
    notifyListeners();
  }

  Future<void> toggleOfflineMode(bool enabled) async {
    _offlineMode = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('offline_mode', enabled);
    notifyListeners();
  }

  Future<void> setUnitSystem(UnitSystem system) async {
    _unitSystem = system;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('unit_system', system.index);
    notifyListeners();
  }
}
