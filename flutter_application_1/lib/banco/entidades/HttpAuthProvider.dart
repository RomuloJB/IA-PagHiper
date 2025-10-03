import 'dart:convert';
import 'package:flutter_application_1/banco/entidades/AuthProvider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HttpAuthProvider implements AuthProvider {
  final String baseUrl;
  HttpAuthProvider({required this.baseUrl});

  static const _kAccessTokenKey = 'auth_access';
  static const _kRefreshTokenKey = 'auth_refresh';
  static const _kEmailKey = 'auth_email';
  static const _kExpiresAtKey = 'auth_expires';

  @override
  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('$baseUrl/auth/login');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (resp.statusCode != 200) {
      throw Exception(_mapError(resp));
    }

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final access = data['access_token'] as String;
    final refresh = data['refresh_token'] as String?;
    final userEmail = (data['user']?['email'] ?? email) as String;
    final expiresIn = data['expires_in'] as int?;
    final expiresAt = expiresIn != null
        ? DateTime.now().add(Duration(seconds: expiresIn))
        : null;

    final session = AuthSession(
      accessToken: access,
      refreshToken: refresh,
      email: userEmail,
      expiresAt: expiresAt,
    );

    await _persist(session);
    return session;
  }

  @override
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kAccessTokenKey);
    await prefs.remove(_kRefreshTokenKey);
    await prefs.remove(_kEmailKey);
    await prefs.remove(_kExpiresAtKey);
  }

  @override
  Future<AuthSession?> refreshSession(String refreshToken) async {
    final uri = Uri.parse('$baseUrl/auth/refresh');
    final resp = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh_token': refreshToken}),
    );

    if (resp.statusCode != 200) return null;

    final data = jsonDecode(resp.body) as Map<String, dynamic>;
    final access = data['access_token'] as String;
    final newRefresh = data['refresh_token'] as String? ?? refreshToken;
    final expiresIn = data['expires_in'] as int?;
    final email =
        data['user']?['email'] as String? ??
        (await _loadEmailFromPrefs()) ??
        'desconhecido';

    final expiresAt = expiresIn != null
        ? DateTime.now().add(Duration(seconds: expiresIn))
        : null;

    final session = AuthSession(
      accessToken: access,
      refreshToken: newRefresh,
      email: email,
      expiresAt: expiresAt,
    );
    await _persist(session);
    return session;
  }

  @override
  Future<AuthSession?> loadPersistedSession() async {
    final prefs = await SharedPreferences.getInstance();
    final access = prefs.getString(_kAccessTokenKey);
    final email = prefs.getString(_kEmailKey);
    if (access == null || email == null) return null;
    final refresh = prefs.getString(_kRefreshTokenKey);
    final expiresMillis = prefs.getInt(_kExpiresAtKey);
    DateTime? expiresAt = expiresMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(expiresMillis)
        : null;

    if (expiresAt != null && DateTime.now().isAfter(expiresAt)) {
      // Tentar refresh automático
      if (refresh != null) {
        return await refreshSession(refresh);
      }
      await logout();
      return null;
    }

    return AuthSession(
      accessToken: access,
      refreshToken: refresh,
      email: email,
      expiresAt: expiresAt,
    );
  }

  Future<void> _persist(AuthSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kAccessTokenKey, session.accessToken);
    if (session.refreshToken != null) {
      await prefs.setString(_kRefreshTokenKey, session.refreshToken!);
    }
    await prefs.setString(_kEmailKey, session.email);
    if (session.expiresAt != null) {
      await prefs.setInt(
        _kExpiresAtKey,
        session.expiresAt!.millisecondsSinceEpoch,
      );
    }
  }

  Future<String?> _loadEmailFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_kEmailKey);
  }

  String _mapError(http.Response resp) {
    try {
      final data = jsonDecode(resp.body);
      if (data is Map && data['message'] is String) {
        return data['message'];
      }
    } catch (_) {}
    if (resp.statusCode == 401) return 'Não autorizado';
    if (resp.statusCode == 404) return 'Rota não encontrada';
    return 'Erro (${resp.statusCode})';
  }
}
