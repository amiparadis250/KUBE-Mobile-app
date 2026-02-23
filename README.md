# KUBE Mobile App

Flutter mobile application for the KUBE Aerial Intelligence Platform with role-based dashboards.

## Architecture

The app supports three distinct user types with dedicated dashboards:

### 🐄 KUBE-Farm (Farmers/Ranchers)
- Herd management and tracking
- Animal health monitoring
- Pasture health analysis
- Missing animal alerts

### 🦁 KUBE-Park (Rangers/Conservationists)
- Wildlife population tracking
- Active patrol management
- Incident reporting (poaching, fires)
- Thermal patrol integration

### 🌱 KUBE-Land (Land Managers/Environmentalists)
- Land zone monitoring
- Vegetation health analysis (NDVI)
- Degradation tracking
- Climate intelligence

## Project Structure

```
lib/
├── core/
│   ├── constants/        # App constants, enums
│   ├── theme/           # App theme
│   └── utils/           # API service, helpers
├── data/
│   └── models/          # User model
├── features/
│   ├── auth/            # Authentication
│   ├── farm/            # Farm dashboard
│   ├── park/            # Park dashboard
│   ├── land/            # Land dashboard
│   └── home/            # Main navigation
└── main.dart
```

## Features

- **Role-Based Authentication**: Users assigned to Farm, Park, or Land services
- **Service Switching**: Multi-service users can switch between dashboards
- **Offline Support**: Works with cached data when offline
- **Real-time Monitoring**: Live alerts and status updates

## Getting Started

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Run the App**
   ```bash
   flutter run
   ```

3. **Demo Credentials**
   - Email: `admin@kube.africa`
   - Password: `password123`

## API Configuration

Update the API base URL in `lib/core/utils/api_service.dart`:
```dart
static const String baseUrl = 'https://your-api-url.com/api';
```

## User Roles

The backend should return user data with:
```json
{
  "id": "user_id",
  "email": "user@example.com",
  "firstName": "John",
  "lastName": "Doe",
  "role": "farmer|ranger|land_manager|admin",
  "services": ["farm", "park", "land"]
}
```

## Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```
