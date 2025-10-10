import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/banco/entidades/User.dart';

class UserDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'users';

  Future<int> create(User user) async {
    final db = await _dbService.database;
    return await db.insert(tableName, user.toMap());
  }

  Future<User?> read(String id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    }
    return null;
  }

  Future<List<User>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => User.fromMap(maps[i]));
  }

  Future<int> update(User user) async {
    final db = await _dbService.database;
    return await db.update(
      tableName,
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await _dbService.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<User?> findByEmail(String email) async {
    final db = await _dbService.database;
    final rows = await db.query(
      tableName,
      where: 'LOWER(email) = ?',
      whereArgs: [email.toLowerCase()],
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
      whereArgs: [email.toLowerCase(), password],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return User.fromMap(rows.first);
  }
}
