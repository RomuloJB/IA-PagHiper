import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/Banco/entidades/User.dart';
import 'package:sqflite/sqflite.dart';

class UserDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'users';

  Future<int> create(User user) async {
    final db = await _dbService.database;
    return await db.insert(tableName, {
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'role': user.role,
      'company_id': user.companyId,
      'created_at': user.createdAt,
    });
  }

  Future<User?> read(int id) async {
    final db = await _dbService.database;
    final rows = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  Future<List<User>> readAll() async {
    final db = await _dbService.database;
    final maps = await db.query(tableName, orderBy: 'name ASC');
    return maps.map(User.fromMap).toList();
  }

  Future<int> update(User user) async {
    if (user.id == null) {
      throw ArgumentError('user.id não pode ser nulo no update');
    }
    final db = await _dbService.database;
    return await db.update(
      tableName,
      {
        'name': user.name,
        'email': user.email,
        'password': user.password,
        'role': user.role,
        'company_id': user.companyId,
      },
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<User?> findByEmail(String email) async {
    final db = await _dbService.database;
    final rows = await db.query(
      tableName,
      where: 'LOWER(email) = ?',
      whereArgs: [email.trim().toLowerCase()],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  Future<User?> findByEmailAndPassword(String email, String password) async {
    final db = await _dbService.database;
    final rows = await db.query(
      tableName,
      where: 'LOWER(email) = ? AND password = ?',
      whereArgs: [email.trim().toLowerCase(), password],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }

  Future<List<User>> findAdmins() async {
    final db = await _dbService.database;
    final maps = await db.query(
      tableName,
      where: 'role = ?',
      whereArgs: ['admin'],
      orderBy: 'name ASC',
    );
    return maps.map(User.fromMap).toList();
  }

  Future<List<User>> findEmployeesByCompany(int companyId) async {
    final db = await _dbService.database;
    final maps = await db.query(
      tableName,
      where: 'company_id = ? AND role = ?',
      whereArgs: [companyId, 'user'],
      orderBy: 'name ASC',
    );
    return maps.map(User.fromMap).toList();
  }

  Future<List<User>> findAllByCompany(int companyId) async {
    final db = await _dbService.database;
    final maps = await db.query(
      tableName,
      where: 'company_id = ?',
      whereArgs: [companyId],
      orderBy: 'role DESC, name ASC', // admin primeiro, depois users
    );
    return maps.map(User.fromMap).toList();
  }

  Future<bool> emailExists(String email) async {
    final user = await findByEmail(email);
    return user != null;
  }

  /// Contar funcionários de uma empresa
  Future<int> countEmployeesByCompany(int companyId) async {
    final db = await _dbService.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as total FROM users WHERE company_id = ? AND role = "user"',
      [companyId],
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Buscar admin de uma empresa (caso queira identificar o dono)
  Future<User?> findAdminByCompany(int companyId) async {
    final db = await _dbService.database;
    final rows = await db.query(
      tableName,
      where: 'company_id = ? AND role = ?',
      whereArgs: [companyId, 'admin'],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }
}
