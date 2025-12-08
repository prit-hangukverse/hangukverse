import 'dart:async';
import 'package:flutter/material.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Delay then navigate to Welcome screen. Use pushReplacement to remove splash.
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Simple centered logo + loader — customize as you like
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Replace with your asset logo path
              Image.asset('assets/logo.png', height: 120, fit: BoxFit.contain),
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
