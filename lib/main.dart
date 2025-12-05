// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hangukverse/routes/app_routes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/auth/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://pkwxarzxsnkumpxouuff.supabase.co',
  );
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBrd3hhcnp4c25rdW1weG91dWZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3NDM3NTksImV4cCI6MjA4MDMxOTc1OX0.X0zEHgT1GXYD23hhEMPKau4uI75H1FH1k9BOoASBjs8',
  );

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HangukVerse',
      debugShowCheckedModeBanner: false,
      initialRoute: LoginScreen.routeName,
      routes: AppRoutes.routes, // <-- clean & organized in one place
      theme: ThemeData(useMaterial3: true),
    );
  }
}
