import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_controller.dart';
import 'login_screen.dart';
import '../../home/presentation/dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  _checkAuth() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      final authController = Provider.of<AuthController>(context, listen: false);
      await authController.checkAuthStatus();
      
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => authController.isAuthenticated 
            ? const DashboardScreen() 
            : const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040810),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF2872A1), Color(0xFF00AAFF)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.satellite_alt, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            const Text('KUBE', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Aerial Intelligence Platform', style: TextStyle(fontSize: 16, color: Colors.white70)),
            const SizedBox(height: 40),
            const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00AAFF))),
          ],
        ),
      ),
    );
  }
}