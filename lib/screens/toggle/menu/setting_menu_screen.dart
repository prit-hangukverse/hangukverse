// lib/screens/toggle/menu/setting_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/auth_provider.dart';
import '../../auth/login_screen.dart';

class SettingMenuScreen extends ConsumerWidget {
  static const routeName = '/menu-settings';
  const SettingMenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authNotifierProvider);
    final email = auth.userEmail ?? 'User';

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Signed in as: $email', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),

            Card(
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                subtitle: const Text('Sign out from this account'),
                onTap: () async {
                  await ref.read(authNotifierProvider.notifier).signOut();
                  if (!context.mounted) return;
                  Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
                },
              ),
            ),

            const SizedBox(height: 12),

            // additional setting options placeholder
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile (coming soon)'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile screen coming soon')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
