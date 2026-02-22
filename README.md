# KUBE Mobile App
![WhatsApp Image 2026-02-22 at 2 32 23 PM](https://github.com/user-attachments/assets/d85d56f7-7db1-4dbb-b912-ce8807bd4baf)

Flutter mobile application for the KUBE Aerial Intelligence Platform.

## Features

- **Authentication**: Login with email/password
- **Dashboard**: Real-time livestock, wildlife, and land monitoring
- **Multi-module Support**: KUBE-Farm, KUBE-Park, KUBE-Land
- **Offline Support**: Works with cached data when offline

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

## Build for Production

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```
