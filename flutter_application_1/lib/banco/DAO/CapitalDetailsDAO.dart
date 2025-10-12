import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/Banco/entidades/CapitalDetail.dart';

class CapitalDetailDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'capital_details';

  Future<int> create(CapitalDetail capitalDetail) async {
    final db = await _dbService.database;
    return await db.insert(tableName, capitalDetail.toMap());
  }

  Future<CapitalDetail?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return CapitalDetail.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Método específico para buscar os detalhes de capital de um contrato
  Future<List<CapitalDetail>> findByContract(String contractId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'contract_id = ?',
      whereArgs: [contractId],
    );
    return List.generate(maps.length, (i) => CapitalDetail.fromMap(maps[i]));
  }
}
