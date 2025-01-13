// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'theme/theme_manager.dart';
import 'screens/login_screen.dart';
import 'package:reserva/screens/signup_screen.dart';
import 'package:reserva/screens/space_screen.dart';
import 'services/auth_service.dart';
import 'screens/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDZPHf5ebqXzTIb297ag_TKYCHhNR5ybmA",
          authDomain: "reservas-396d3.firebaseapp.com",
          databaseURL: "https://reservas-396d3-default-rtdb.firebaseio.com",
          projectId: "reservas-396d3",
          storageBucket: "reservas-396d3.firebasestorage.app",
          messagingSenderId: "193365538369",
          appId: "1:193365538369:web:b19a2b897053f6aab6b8c0",
          measurementId: "G-43E936MHFV"
      ),
    );
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeManager(),
        child: const MyApp(),
      ),
    );
  } catch (e) {
    print('Erro ao inicializar Firebase: $e');
    runApp(
      ChangeNotifierProvider(
        create: (_) => ThemeManager(),
        child: const MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp(
          title: 'Sistema de Reservas',
          debugShowCheckedModeBanner: false,
          theme: ThemeManager.lightTheme,
          darkTheme: ThemeManager.darkTheme,
          themeMode: themeManager.themeMode,
          themeAnimationDuration: ThemeManager.themeDuration,
          themeAnimationCurve: ThemeManager.themeCurve,
          home: const SplashScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/signup': (context) => const SignupScreen(),
            '/spaces': (context) => const SpacesScreen(),
            '/admin': (context) => const AdminScreen(),
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      bool isLoggedIn = await _authService.isLoggedIn();

      if (!mounted) return;

      if (isLoggedIn) {
        await _authService.loadSavedUser();
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/spaces');
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      print('Erro na inicialização: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao inicializar: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.meeting_room_outlined,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}