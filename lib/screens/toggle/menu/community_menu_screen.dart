import 'package:flutter/material.dart';

class CommunityMenuScreen extends StatelessWidget {
  static const routeName = '/menu-community';

  const CommunityMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Community")),
      body: const Center(child: Text("Community Screen")),
    );
  }
}
