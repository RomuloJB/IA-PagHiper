import 'package:flutter_application_1/banco/entidades/AuthProvider.dart';
import 'package:flutter_application_1/banco/entidades/MockAutoProvider.dart';

// import 'http_auth_provider.dart'; // quando for usar real

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  late AuthProvider _provider;
  AuthSession? _session;

  bool get isLoggedIn => _session != null;
  String? get email => _session?.email;
  String? get accessToken => _session?.accessToken;

  void init({AuthProvider? provider}) {
    _provider =
        provider ?? MockAuthProvider(); // Trocar aqui para HttpAuthProvider
  }

  Future<void> load() async {
    _session = await _provider.loadPersistedSession();
  }

  Future<void> login(
    String email,
    String password, {
    bool remember = true,
  }) async {
    _session = await _provider.login(email: email, password: password);
    // se rememberMe = false, eu posso decidir não persistir (mover persistência p/ provider condicionalmente)
  }

  Future<void> logout() async {
    await _provider.logout();
    _session = null;
  }
}
