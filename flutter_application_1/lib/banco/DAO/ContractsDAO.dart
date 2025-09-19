import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/banco/entidades/Contract.dart';
import 'package:sqflite/sqflite.dart';

class ContractDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'contracts';

  Future<int> create(Contract contract) async {
    final db = await _dbService.database;
    return await db.insert(
      tableName,
      contract.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Contract?> read(String id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Contract.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Contract>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Contract.fromMap(maps[i]));
  }

  Future<int> update(Contract contract) async {
    final db = await _dbService.database;
    return await db.update(
      tableName,
      contract.toMap(),
      where: 'id = ?',
      whereArgs: [contract.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await _dbService.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Métodos específicos para Contratos
  Future<List<Contract>> findByStatus(String status) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'status = ?',
      whereArgs: [status],
    );
    return List.generate(maps.length, (i) => Contract.fromMap(maps[i]));
  }

  Future<List<Contract>> findByUser(String userId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) => Contract.fromMap(maps[i]));
  }
}
