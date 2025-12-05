import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../toggle/menu_toggle_button.dart';
import '../toggle/side_menu.dart';

class HomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/home';
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final userEmail = auth.userEmail ?? "User";

    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(onClose: () {
        Navigator.pop(context);
      }),

      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        leading: MenuToggleButton(
          onTap: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: const Text(
          "HangukVerse",
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Welcome, $userEmail",
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text("This is your Home Screen."),
          ],
        ),
      ),
    );
  }
}
