class AppConstants {
  static const String appName = 'KUBE';
  static const String appTagline = 'Aerial Intelligence Platform';
}

enum UserRole {
  farmer,
  ranger,
  landManager,
  admin
}

enum ServiceType {
  farm,
  park,
  land
}

extension ServiceTypeExtension on ServiceType {
  String get name {
    switch (this) {
      case ServiceType.farm:
        return 'farm';
      case ServiceType.park:
        return 'park';
      case ServiceType.land:
        return 'land';
    }
  }
}
