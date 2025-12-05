import 'package:flutter/material.dart';

class MyCollectionMenuScreen extends StatelessWidget {
  static const routeName = '/menu-my-collection';

  const MyCollectionMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Collection")),
      body: const Center(child: Text("My Collection Screen")),
    );
  }
}
