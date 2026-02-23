class ApiConfig {
  // Change this based on your environment
  static const String environment = 'development'; // 'development', 'production'
  
  // API Base URLs
  static const String devBaseUrl = 'http://10.0.2.2:5000/api'; // Android emulator
  static const String prodBaseUrl = 'https://your-production-api.com/api';
  
  // Get current base URL
  static String get baseUrl {
    return environment == 'production' ? prodBaseUrl : devBaseUrl;
  }
  
  // Platform-specific URLs
  static String getBaseUrlForPlatform() {
    // For iOS simulator, use localhost
    // For Android emulator, use 10.0.2.2
    // For physical devices, use your computer's IP address
    return devBaseUrl;
  }
  
  // API Endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String profile = '/auth/profile';
  static const String dashboardOverview = '/dashboard/overview';
  static const String dashboardFarm = '/dashboard/farm';
  static const String dashboardPark = '/dashboard/park';
  static const String dashboardLand = '/dashboard/land';
  static const String farms = '/farms';
  static const String parks = '/parks';
  static const String landZones = '/land/zones';
  static const String alerts = '/alerts';
  
  // Timeout durations
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
