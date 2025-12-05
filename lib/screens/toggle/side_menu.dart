// lib/screens/toggle/side_menu.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/supabase_provider.dart';
import '../../providers/auth_provider.dart';

// menu screens routes (ensure the files exist)
import 'menu/home_menu_screen.dart';
import 'menu/about_us_menu_screen.dart';
import 'menu/community_menu_screen.dart';
import 'menu/membership_menu_screen.dart';
import 'menu/my_collection_menu_screen.dart';
import 'menu/event_entries_menu_screen.dart';
import 'menu/magazine_menu_screen.dart';
import 'menu/hangukverse_concert_menu_screen.dart';
import 'menu/survey_menu_screen.dart';
import 'menu/setting_menu_screen.dart'; // new

class SideMenu extends ConsumerWidget {
  final VoidCallback onClose;
  const SideMenu({super.key, required this.onClose});

  // list of menu items + their route names
  static const List<Map<String, String>> _items = [
    {'label': 'Home', 'route': HomeMenuScreen.routeName},
    {'label': 'About Us', 'route': AboutUsMenuScreen.routeName},
    {'label': 'Community', 'route': CommunityMenuScreen.routeName},
    {'label': 'Membership', 'route': MembershipMenuScreen.routeName},
    {'label': 'My Collection', 'route': MyCollectionMenuScreen.routeName},
    {'label': 'Event Entries', 'route': EventEntriesMenuScreen.routeName},
    {'label': 'Magazine', 'route': MagazineMenuScreen.routeName},
    {'label': 'Hangukverse Concert', 'route': HangukverseConcertMenuScreen.routeName},
    {'label': 'Survey', 'route': SurveyMenuScreen.routeName},
    {'label': 'Settings', 'route': SettingMenuScreen.routeName}, // <- added
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch auth state to rebuild header when user logs in/out
    ref.watch(authNotifierProvider);

    final supabase = ref.read(supabaseClientProvider);
    final user = supabase.auth.currentUser;

    final displayName = _getUserName(user);
    final avatarUrl = _getAvatar(user);

    return Drawer(
      backgroundColor: Colors.black.withOpacity(0.85),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.deepPurple),
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                // back arrow to close
                Positioned(
                  top: 8,
                  left: 8,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: onClose,
                  ),
                ),
                // profile area
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: (avatarUrl != null) ? NetworkImage(avatarUrl) : null,
                        child: (avatarUrl == null)
                            ? const Icon(Icons.person, size: 45, color: Colors.grey)
                            : null,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // menu items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: _items.map((item) {
                return _menuItem(
                  context: context,
                  label: item['label']!,
                  routeName: item['route']!,
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _menuItem({
    required BuildContext context,
    required String label,
    required String routeName,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () {
          Navigator.of(context).pop(); // close drawer
          Future.delayed(const Duration(milliseconds: 200), () {
            Navigator.of(context).pushNamed(routeName);
          });
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ------------ Helpers ------------
  String _getUserName(dynamic user) {
    if (user == null) return "User";
    final meta = user.userMetadata;
    return (meta?['full_name'] as String?) ??
        (meta?['name'] as String?) ??
        (meta?['display_name'] as String?) ??
        (user.email?.split('@').first as String?) ??
        "User";
  }

  String? _getAvatar(dynamic user) {
    if (user == null) return null;
    final meta = user.userMetadata;
    return (meta?['avatar_url'] as String?) ?? (meta?['picture'] as String?) ?? (meta?['avatar'] as String?);
  }
}
