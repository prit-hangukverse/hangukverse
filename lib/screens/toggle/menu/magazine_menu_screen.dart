import 'package:flutter/material.dart';

class MagazineMenuScreen extends StatelessWidget {
  static const routeName = '/menu-magazine';

  const MagazineMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Magazine")),
      body: const Center(child: Text("Magazine Screen")),
    );
  }
}
