import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final bool isLoggedIn;
  final String? email;

  const AuthState({
    required this.isLoggedIn,
    this.email,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? email,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      email: email ?? this.email,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(isLoggedIn: false));

  static const _sessionKey = 'session_email';
  static const _validPassword = '123456';

  Future<void> restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString(_sessionKey);

    if (savedEmail != null && savedEmail.isNotEmpty) {
      state = AuthState(
        isLoggedIn: true,
        email: savedEmail,
      );
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim();
    final normalizedPassword = password.trim();

    if (normalizedEmail.isEmpty || normalizedPassword.isEmpty) {
      return false;
    }

    if (!normalizedEmail.contains('@')) {
      return false;
    }

    if (normalizedPassword != _validPassword) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, normalizedEmail);

    state = AuthState(
      isLoggedIn: true,
      email: normalizedEmail,
    );
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    state = const AuthState(isLoggedIn: false);
  }
}

final authProvider =
StateNotifierProvider<AuthNotifier, AuthState>((ref) => AuthNotifier());