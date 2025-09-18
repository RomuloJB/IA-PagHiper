import 'package:barber_shop/Banco/entidades/Venda.dart';
import 'package:barber_shop/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class VendaDAO {
  final DatabaseService _dbService = DatabaseService.instance;
  Future<int> create(Map<String, dynamic> venda) async {
    final db = await _dbService.database;
    return await db.insert(
      'venda',
      venda,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'venda',
      where: 'id_venda = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Venda>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('venda');
    return maps.map((map) => Venda.fromMap(map)).toList();
  }

  Future<List<Map<String, dynamic>>> readByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String extraWhere = '',
  }) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT 
        a.id_venda,
        a.cliente_id,
        a.valor_total,
        a.data_venda,
        c.nome AS cliente_nome
      FROM venda a
      JOIN clientes c ON a.cliente_id = c.id
       WHERE a.data_venda >= ? AND a.data_venda <= ?
      ${extraWhere.isNotEmpty ? extraWhere : ''}
    ''',
      [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
    );
    print('Consulta realizada: ${maps} registros encontrados');

    return maps.map((map) => Map<String, dynamic>.from(map)).toList();
  }

  Future<int> update(Map<String, dynamic> venda) async {
    final db = await _dbService.database;
    return await db.update(
      'venda',
      venda,
      where: 'id_venda = ?',
      whereArgs: [venda['id_venda']],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete('venda', where: 'id_venda = ?', whereArgs: [id]);
  }
}
