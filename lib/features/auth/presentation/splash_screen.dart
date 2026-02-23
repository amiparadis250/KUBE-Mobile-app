import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_controller.dart';
import '../../../core/utils/api_service.dart';
import 'login_screen.dart';
import '../../home/presentation/main_app_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _status = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Step 1: Check local auth status
      setState(() => _status = 'Checking authentication...');
      await Future.delayed(const Duration(milliseconds: 500));
      
      final authController = Provider.of<AuthController>(context, listen: false);
      await authController.checkAuthStatus();

      if (authController.isAuthenticated) {
        // Step 2: Verify token with backend
        setState(() => _status = 'Verifying credentials...');
        await Future.delayed(const Duration(milliseconds: 500));
        
        try {
          final profileResponse = await ApiService.getProfile();
          
          if (profileResponse['success']) {
            // Step 3: Update user data from backend
            setState(() => _status = 'Loading profile...');
            await Future.delayed(const Duration(milliseconds: 500));
            
            final userData = profileResponse['data']['user'];
            authController.updateUserFromBackend(userData);
            
            // Step 4: Navigate to main app
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const MainAppScreen()),
              );
            }
          } else {
            // Token invalid, logout and show login
            await authController.logout();
            _navigateToLogin();
          }
        } catch (e) {
          // Backend error, logout and show login
          await authController.logout();
          _navigateToLogin();
        }
      } else {
        // Not authenticated, show login
        await Future.delayed(const Duration(seconds: 1));
        _navigateToLogin();
      }
    } catch (e) {
      // Error during initialization
      await Future.delayed(const Duration(seconds: 1));
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
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
            const SizedBox(height: 16),
            Text(_status, style: const TextStyle(fontSize: 12, color: Colors.white54)),
          ],
        ),
      ),
    );
  }
}