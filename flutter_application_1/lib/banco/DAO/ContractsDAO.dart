import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/Banco/entidades/Contract.dart';
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

  // Novo método para filtrar por nome da empresa
  Future<List<Contract>> findByCompanyName(String name) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'company_name LIKE ?',
      whereArgs: ['%$name%'],
    );
    return List.generate(maps.length, (i) => Contract.fromMap(maps[i]));
  }

  // Novo método para filtrar por número de sócios
  Future<List<Contract>> findByPartnerCount(String partnerCount) async {
    final db = await _dbService.database;
    String whereClause;
    List<dynamic> whereArgs;

    if (partnerCount == '3+') {
      whereClause = '''
        id IN (
          SELECT contract_id 
          FROM partners 
          GROUP BY contract_id 
          HAVING COUNT(*) >= 3
        )
      ''';
      whereArgs = [];
    } else {
      whereClause = '''
        id IN (
          SELECT contract_id 
          FROM partners 
          GROUP BY contract_id 
          HAVING COUNT(*) = ?
        )
      ''';
      whereArgs = [int.parse(partnerCount)];
    }

    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: whereClause,
      whereArgs: whereArgs,
    );
    return List.generate(maps.length, (i) => Contract.fromMap(maps[i]));
  }
}
