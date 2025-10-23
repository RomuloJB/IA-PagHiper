import 'package:flutter_application_1/Banco/DAO/UserDAO.dart';
import 'package:flutter_application_1/Banco/DAO/CompanyDAO.dart';
import 'package:flutter_application_1/Banco/entidades/User.dart';
import 'package:flutter_application_1/Banco/entidades/Company.dart';

class AuthService {
  final UserDao _userDao;
  final CompanyDao _companyDao;

  AuthService({
    UserDao? userDao,
    CompanyDao? companyDao,
  })  : _userDao = userDao ?? UserDao(),
        _companyDao = companyDao ?? CompanyDao();

  /// Autenticar usuário e retornar dados completos (user + empresa)
  Future<AuthResult> signIn(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    final user = await _userDao.findByEmailAndPassword(
      normalizedEmail,
      password,
    );

    if (user == null) {
      throw Exception('Credenciais inválidas');
    }

    // Buscar empresa, se o usuário estiver vinculado a uma
    Company? company;
    if (user.companyId != null) {
      company = await _companyDao.read(user.companyId!);
    }

    return AuthResult(user: user, company: company);
  }

  /// Verificar se email já existe (útil para validações de cadastro)
  Future<bool> emailExists(String email) async {
    return await _userDao.emailExists(email);
  }

  /// Obter usuário por email (mantém compatibilidade com código antigo)
  Future<User?> getByEmail(String email) {
    return _userDao.findByEmail(email.trim().toLowerCase());
  }
}

/// Classe que encapsula o resultado da autenticação
class AuthResult {
  final User user;
  final Company? company;

  AuthResult({
    required this.user,
    this.company,
  });

  // Helpers para facilitar verificações
  bool get isAdmin => user.isAdmin;
  bool get isUser => user.isUser;
  bool get hasCompany => company != null;
  int? get companyId => user.companyId;
  String get userName => user.name ?? 'Usuário';
  String get companyName => company?.name ?? 'Sem empresa';
}
