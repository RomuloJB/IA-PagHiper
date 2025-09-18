import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/banco/entidades/SocietyType.dart';

class SocietyTypeDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'society_types';

  Future<int> create(SocietyType societyType) async {
    final db = await _dbService.database;
    return await db.insert(tableName, societyType.toMap());
  }

  Future<SocietyType?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return SocietyType.fromMap(maps.first);
    }
    return null;
  }

  Future<List<SocietyType>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => SocietyType.fromMap(maps[i]));
  }

  Future<int> update(SocietyType societyType) async {
    final db = await _dbService.database;
    return await db.update(
      tableName,
      societyType.toMap(),
      where: 'id = ?',
      whereArgs: [societyType.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
