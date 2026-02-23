import '../../core/constants/app_constants.dart';

class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final UserRole role;
  final List<ServiceType> services;

  User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.services,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      role: _parseRole(json['role']),
      services: _parseServices(json['services']),
    );
  }

  static UserRole _parseRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'farmer':
      case 'rancher':
        return UserRole.farmer;
      case 'ranger':
      case 'conservationist':
        return UserRole.ranger;
      case 'land_manager':
      case 'environmentalist':
        return UserRole.landManager;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.farmer;
    }
  }

  static List<ServiceType> _parseServices(dynamic services) {
    if (services is List) {
      return services.map((s) {
        // Handle both string and object formats
        String serviceName = '';
        if (s is String) {
          serviceName = s;
        } else if (s is Map) {
          serviceName = s['name']?.toString() ?? s['serviceName']?.toString() ?? '';
        } else {
          serviceName = s.toString();
        }
        
        // Remove KUBE_ prefix and convert to lowercase
        serviceName = serviceName.replaceAll('KUBE_', '').toLowerCase();
        
        switch (serviceName) {
          case 'farm':
            return ServiceType.farm;
          case 'park':
            return ServiceType.park;
          case 'land':
            return ServiceType.land;
          default:
            return ServiceType.farm;
        }
      }).toList();
    }
    return [ServiceType.farm];
  }

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName[0]}${lastName[0]}';
}
