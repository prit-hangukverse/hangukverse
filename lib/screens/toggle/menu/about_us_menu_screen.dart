import 'package:flutter/material.dart';

class AboutUsMenuScreen extends StatelessWidget {
  static const routeName = '/menu-about-us';

  const AboutUsMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: const Center(child: Text("About Us Screen")),
    );
  }
}
