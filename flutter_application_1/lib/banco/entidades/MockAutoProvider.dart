import 'dart:async';
import 'package:flutter_application_1/banco/entidades/AuthProvider.dart';

class MockAuthProvider implements AuthProvider {
  static const _email = 'admin@admin.com';
  static const _password = 'admin123';

  AuthSession? _session;

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (email.toLowerCase() == _email && password == _password) {
      _session = AuthSession(accessToken: 'fake-token', email: _email);
      return _session!;
    }
    throw Exception('Credenciais inválidas');
  }

  @override
  Future<void> logout() async {
    _session = null;
  }

  @override
  Future<AuthSession?> refreshSession(String refreshToken) async {
    if (_session == null) return null;
    _session = AuthSession(
      accessToken: 'fake-token-refreshed',
      email: _session!.email,
    );
    return _session;
  }

  @override
  Future<AuthSession?> loadPersistedSession() async {
    // No mock, pode retornar direto a sessão em memória
    return _session;
  }
}
