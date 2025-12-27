import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meowmedia/navigation/main_navigation.dart';
import 'package:meowmedia/screen/auth/login_screen.dart';
import 'package:meowmedia/services/auth_service.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    final isLoggedIn = await AuthService.isLoggedIn();

    // delay splash 3 detik
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            isLoggedIn ? const MainNavigation() : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.jpeg",
          width: 160,
        ),
      ),
    );
  }
}
