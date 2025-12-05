import 'package:flutter/material.dart';

class SurveyMenuScreen extends StatelessWidget {
  static const routeName = '/menu-survey';

  const SurveyMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Survey")),
      body: const Center(child: Text("Survey Screen")),
    );
  }
}
