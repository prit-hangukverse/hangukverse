import 'package:flutter/material.dart';

class HangukverseConcertMenuScreen extends StatelessWidget {
  static const routeName = '/menu-concert';

  const HangukverseConcertMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hangukverse Concert")),
      body: const Center(child: Text("Concert Screen")),
    );
  }
}
