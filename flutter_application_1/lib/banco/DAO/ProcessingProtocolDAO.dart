import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/Banco/entidades/ProcessingProtocol.dart';
import 'package:sqflite/sqflite.dart';

class ProcessingProtocolDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'processing_protocols';

  Future<int> create(ProcessingProtocol protocol) async {
    final db = await _dbService.database;
    return await db.insert(
      tableName,
      protocol.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ProcessingProtocol?> read(String code) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'protocol_code = ?',
      whereArgs: [code],
    );
    if (maps.isNotEmpty) {
      return ProcessingProtocol.fromMap(maps.first);
    }
    return null;
  }

  Future<ProcessingProtocol?> readByContractId(String contractId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'contract_id = ?',
      whereArgs: [contractId],
    );
    if (maps.isNotEmpty) {
      return ProcessingProtocol.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ProcessingProtocol>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      orderBy: 'created_at DESC',
    );
    return List.generate(
      maps.length,
      (i) => ProcessingProtocol.fromMap(maps[i]),
    );
  }

  Future<int> update(ProcessingProtocol protocol) async {
    final db = await _dbService.database;
    return await db.update(
      tableName,
      protocol.toMap(),
      where: 'protocol_code = ?',
      whereArgs: [protocol.protocolCode],
    );
  }

  Future<int> delete(String code) async {
    final db = await _dbService.database;
    return await db.delete(
      tableName,
      where: 'protocol_code = ?',
      whereArgs: [code],
    );
  }

  Future<List<ProcessingProtocol>> searchByStatus(String status) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'status = ?',
      whereArgs: [status],
      orderBy: 'created_at DESC',
    );
    return List.generate(
      maps.length,
      (i) => ProcessingProtocol.fromMap(maps[i]),
    );
  }
}
