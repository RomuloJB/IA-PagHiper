import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/banco/entidades/CorporateRegime.dart';

class CorporateRegimeDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'corporate_regimes';

  Future<int> create(CorporateRegime corporateRegime) async {
    final db = await _dbService.database;
    return await db.insert(tableName, corporateRegime.toMap());
  }

  Future<CorporateRegime?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return CorporateRegime.fromMap(maps.first);
    }
    return null;
  }

  Future<List<CorporateRegime>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => CorporateRegime.fromMap(maps[i]));
  }

  Future<int> update(CorporateRegime corporateRegime) async {
    final db = await _dbService.database;
    return await db.update(
      tableName,
      corporateRegime.toMap(),
      where: 'id = ?',
      whereArgs: [corporateRegime.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
