import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'features/home/home_controller.dart';
import 'features/auth/auth_controller.dart';
import 'features/farm/farm_controller.dart';
import 'features/park/park_controller.dart';
import 'features/land/land_controller.dart';
import 'features/auth/presentation/splash_screen.dart';
import 'shared/providers/notification_provider.dart';
import 'shared/providers/settings_provider.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const KubeApp());
}

class KubeApp extends StatelessWidget {
  const KubeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => HomeController()),
        ChangeNotifierProvider(create: (_) => FarmController()),
        ChangeNotifierProvider(create: (_) => ParkController()),
        ChangeNotifierProvider(create: (_) => LandController()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..loadSettings()),
      ],
      child: MaterialApp(
        title: 'KUBE - Aerial Intelligence',
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}