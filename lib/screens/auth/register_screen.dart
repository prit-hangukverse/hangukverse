// lib/screens/auth/register_screen.dart
// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '', _email = '', _password = '', _confirm = '';

  Future<void> _onCreateAccountPressed() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await ref.read(authNotifierProvider.notifier).register(_name, _email, _password);
    final s = ref.read(authNotifierProvider);
    if (s.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.errorMessage!)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Account created: ${s.userEmail ?? _email}')));
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  void _onGooglePressed() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
    final s = ref.read(authNotifierProvider);
    if (s.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s.errorMessage!)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Google sign-in started')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authNotifierProvider);
    final isLoading = auth.isLoading;

    return Theme(
      data: ThemeData.light(useMaterial3: true),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      const SizedBox(height: 8),
                      const Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 28),

                      _label('Name'),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: _fieldDecoration('Enter your full name'),
                        validator: (v) => (v != null && v.isNotEmpty) ? null : 'Required',
                        onSaved: (v) => _name = v!.trim(),
                      ),
                      const SizedBox(height: 16),

                      _label('Email'),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: _fieldDecoration('Enter your e-mail'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => (v != null && v.contains('@')) ? null : 'Invalid e-mail',
                        onSaved: (v) => _email = v!.trim(),
                      ),
                      const SizedBox(height: 16),

                      _label('Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: _fieldDecoration('Create a password'),
                        obscureText: true,
                        onChanged: (v) => _password = v.trim(),
                        validator: (v) => (v != null && v.length >= 6) ? null : 'Min 6 chars',
                      ),
                      const SizedBox(height: 16),

                      _label('Confirm Password'),
                      const SizedBox(height: 6),
                      TextFormField(
                        decoration: _fieldDecoration('Re-enter password'),
                        obscureText: true,
                        validator: (v) => (v == _password) ? null : 'Passwords do not match',
                        onSaved: (v) => _confirm = v!.trim(),
                      ),
                      const SizedBox(height: 24),

                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _onCreateAccountPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A84FF),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: isLoading
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Center(
                        child: TextButton(
                          onPressed: () => Navigator.pushReplacementNamed(context, LoginScreen.routeName),
                          child: const Text('Already have an account? Log In'),
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Divider(thickness: 1, color: Colors.black12),
                      const SizedBox(height: 16),
                      const Text('Or continue with', textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading ? null : _onGooglePressed,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.g_mobiledata, size: 20),
                                  SizedBox(width: 8),
                                  Text('Google', style: TextStyle(fontWeight: FontWeight.w600)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: const TextStyle(fontSize: 14, color: Colors.black87));

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: const Color(0xFFF0F2F5),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black26)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: Colors.black)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );
}
