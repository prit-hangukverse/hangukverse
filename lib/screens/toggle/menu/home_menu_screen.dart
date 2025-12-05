import 'package:flutter/material.dart';

class HomeMenuScreen extends StatelessWidget {
  static const routeName = '/menu-home';

  const HomeMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home")),
      body: const Center(child: Text("Home Screen")),
    );
  }
}
