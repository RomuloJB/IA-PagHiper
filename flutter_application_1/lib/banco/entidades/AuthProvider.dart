abstract class AuthProvider {
  Future<AuthSession> login({required String email, required String password});

  Future<void> logout();

  Future<AuthSession?> refreshSession(String refreshToken);

  Future<AuthSession?> loadPersistedSession();
}

class AuthSession {
  final String accessToken;
  final String? refreshToken;
  final String email;
  final DateTime? expiresAt; // opcional

  AuthSession({
    required this.accessToken,
    required this.email,
    this.refreshToken,
    this.expiresAt,
  });
}
