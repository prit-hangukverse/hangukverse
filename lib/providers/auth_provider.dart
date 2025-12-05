// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supa;
import 'supabase_provider.dart';

class AuthState {
  final bool isLoading;
  final String? userEmail;
  final String? errorMessage;

  const AuthState({this.isLoading = false, this.userEmail, this.errorMessage});

  AuthState copyWith({
    bool? isLoading,
    String? userEmail,
    String? errorMessage,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      userEmail: userEmail ?? this.userEmail,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref ref;
  AuthNotifier(this.ref) : super(const AuthState()) {
    _loadCurrentUser();
  }

  // returns supa.SupabaseClient from provider
  supa.SupabaseClient get _supabase => ref.read(supabaseClientProvider);

  /// Public getter so other widgets can get the current supabase user:
  supa.User? get currentUser => _supabase.auth.currentUser;

  void _loadCurrentUser() {
    final user = _supabase.auth.currentUser;
    if (user != null) {
      state = state.copyWith(userEmail: user.email);
    }
  }

  /// Email/password login
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = res.user;
      state = state.copyWith(
        isLoading: false,
        userEmail: user?.email ?? email,
        errorMessage: null,
      );
    } on supa.AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Email/password registration
  Future<void> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final res = await _supabase.auth.signUp(email: email, password: password);
      final user = res.user;
      state = state.copyWith(
        isLoading: false,
        userEmail: user?.email ?? email,
        errorMessage: null,
      );
    } on supa.AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Send password reset email
  Future<void> sendResetLink(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      state = state.copyWith(isLoading: false, errorMessage: null);
    } on supa.AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  /// Sign in with Google (OAuth). Use OAuthProvider (not Provider).
  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _supabase.auth.signInWithOAuth(
        supa.OAuthProvider.google,
        // Optionally set redirectTo and authScreenLaunchMode:
        // redirectTo: 'yourapp://callback',
        // authScreenLaunchMode: supa.LaunchMode.externalApplication,
      );
      // OAuth flow starts externally; finish state after redirect/return.
      state = state.copyWith(isLoading: false);
    } on supa.AuthException catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (_) {}
    state = const AuthState();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
