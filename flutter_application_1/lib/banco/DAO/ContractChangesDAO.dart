import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/banco/entidades/ContractChange.dart';

class ContractChangeDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'contract_changes';

  Future<int> create(ContractChange contractChange) async {
    final db = await _dbService.database;
    return await db.insert(tableName, contractChange.toMap());
  }

  Future<ContractChange?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ContractChange.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Método específico para buscar alterações de um contrato
  Future<List<ContractChange>> findByContract(String contractId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'contract_id = ?',
      whereArgs: [contractId],
      orderBy: 'change_date DESC',
    );
    return List.generate(maps.length, (i) => ContractChange.fromMap(maps[i]));
  }
}
