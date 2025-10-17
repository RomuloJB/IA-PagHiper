import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/Banco/entidades/User.dart';

class UserDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'users';

  Future<int> create(User user) async {
    final db = await _dbService.database;
    return await db.insert(tableName, {
      'name': user.name,
      'email': user.email,
      'password': user.password,
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
    final maps = await db.query(tableName);
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
        'created_at': user.createdAt,
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
}
