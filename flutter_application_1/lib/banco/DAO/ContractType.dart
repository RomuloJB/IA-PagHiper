import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/banco/entidades/ContractType.dart';

class ContractTypeDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'contract_types';

  Future<int> create(ContractType contractType) async {
    final db = await _dbService.database;
    return await db.insert(tableName, contractType.toMap());
  }

  Future<ContractType?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ContractType.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ContractType>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => ContractType.fromMap(maps[i]));
  }

  Future<int> update(ContractType contractType) async {
    final db = await _dbService.database;
    return await db.update(
      tableName,
      contractType.toMap(),
      where: 'id = ?',
      whereArgs: [contractType.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }
}
