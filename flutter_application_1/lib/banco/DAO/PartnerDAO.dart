import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:flutter_application_1/banco/entidades/Partner.dart';

class PartnerDao {
  final DatabaseService _dbService = DatabaseService.instance;
  static const String tableName = 'partners';

  Future<int> create(Partner partner) async {
    final db = await _dbService.database;
    return await db.insert(tableName, partner.toMap());
  }

  Future<Partner?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Partner.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Partner>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (i) => Partner.fromMap(maps[i]));
  }

  Future<int> update(Partner partner) async {
    final db = await _dbService.database;
    return await db.update(
      tableName,
      partner.toMap(),
      where: 'id = ?',
      whereArgs: [partner.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  // Método específico para buscar sócios de um contrato
  Future<List<Partner>> findByContract(String contractId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'contract_id = ?',
      whereArgs: [contractId],
    );
    return List.generate(maps.length, (i) => Partner.fromMap(maps[i]));
  }
}
