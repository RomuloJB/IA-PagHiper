import 'package:barber_shop/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';
import 'package:barber_shop/Banco/entidades/VendaItem.dart';

class VendaItemDAO {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Map<String, dynamic> vendaItem) async {
    final db = await _dbService.database;
    return await db.insert(
      'venda_items',
      vendaItem,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'venda_items',
      where: 'id_venda_item = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<VendaItem>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('venda_items');
    return maps.map((map) => VendaItem.fromMap(map)).toList();
  }
  Future<List<Map<String, dynamic>>> readByVendaId(int vendaId) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''SELECT 
          id_venda_item AS id,
          id_venda,
          p.id_produto,
          p.nome AS nome,
          p.valor_unitario AS valorUnitario,
          vi.valor_total as valorTotal,
          vi.quantidade as qtde
      FROM venda_items vi
      JOIN produtos p ON vi.id_produto = p.id_produto
      WHERE id_venda = ?''',
      [vendaId],
    );
    print('Itens da venda: ${maps} encontrados');
    return maps.map((map) => Map<String, dynamic>.from(map)).toList();
  }

  Future<int> update(Map<String, dynamic> vendaItem) async {
    final db = await _dbService.database;
    return await db.update(
      'venda_items',
      vendaItem,
      where: 'id = ?',
      whereArgs: [vendaItem['id']],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete('venda_items', where: 'id = ?', whereArgs: [id]);
  }
}
