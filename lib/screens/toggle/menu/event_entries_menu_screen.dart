import 'package:flutter/material.dart';

class EventEntriesMenuScreen extends StatelessWidget {
  static const routeName = '/menu-event-entries';

  const EventEntriesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Event Entries")),
      body: const Center(child: Text("Event Entries Screen")),
    );
  }
}
