import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/banco/entidades/ProcessingLog.dart';

class ProcessingLogDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'processing_logs';

  Future<int> create(ProcessingLog log) async {
    final db = await _dbService.database;
    return await db.insert(tableName, log.toMap());
  }

  // Método específico para buscar logs de um contrato
  Future<List<ProcessingLog>> findByContract(String contractId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'contract_id = ?',
      whereArgs: [contractId],
      orderBy: 'created_at DESC', // Ordena para ver os mais recentes primeiro
    );
    return List.generate(maps.length, (i) => ProcessingLog.fromMap(maps[i]));
  }

  Future<int> deleteByContract(String contractId) async {
    final db = await _dbService.database;
    return await db.delete(
      tableName,
      where: 'contract_id = ?',
      whereArgs: [contractId],
    );
  }
}
