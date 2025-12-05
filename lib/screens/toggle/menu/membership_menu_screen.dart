import 'package:flutter/material.dart';

class MembershipMenuScreen extends StatelessWidget {
  static const routeName = '/menu-membership';

  const MembershipMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Membership")),
      body: const Center(child: Text("Membership Screen")),
    );
  }
}
