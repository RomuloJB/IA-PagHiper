import 'package:flutter_application_1/Banco/DAO/UserDAO.dart';
import 'package:flutter_application_1/Banco/entidades/User.dart';

class AuthService {
  AuthService({UserDao? userDao}) : _userDao = userDao ?? UserDao();

  final UserDao _userDao;

  /// Autentica por e-mail e senha.
  /// Retorna o User em caso de sucesso; lança Exception em caso de falha.
  Future<User> signIn(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final user = await _userDao.findByEmailAndPassword(
      normalizedEmail,
      password,
    );
    if (user == null) {
      throw Exception('Credenciais inválidas');
    }
    // Aqui você pode persistir sessão (SharedPreferences/SecureStorage) se quiser.
    return user;
  }

  /// Verifica se existe usuário por e-mail (útil para validações de cadastro).
  Future<User?> getByEmail(String email) {
    return _userDao.findByEmail(email.trim().toLowerCase());
  }
}
