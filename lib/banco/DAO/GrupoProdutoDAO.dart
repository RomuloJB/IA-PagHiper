import 'package:barber_shop/Banco/entidades/GrupoProduto.dart';
import 'package:barber_shop/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class GrupoProdutoDao {
  final DatabaseService _dbService = DatabaseService.instance;
  Future<int> create(GrupoProduto grupoProduto) async {
    final db = await _dbService.database;
    return await db.insert(
      'grupo_produto',
      grupoProduto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<GrupoProduto?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'grupo_produto',
      where: 'id_grupo_produto = ?',
      whereArgs: [id],
    );
    print('Grupos de produto no banco: $maps');
    if (maps.isNotEmpty) {
      return GrupoProduto.fromMap(maps.first);
    }
    return null;
  }

  Future<List<GrupoProduto>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('grupo_produto');
    print('Grupos de produto no banco: $maps');
    return List.generate(maps.length, (i) => GrupoProduto.fromMap(maps[i]));
  }

  Future<int> update(GrupoProduto grupoProduto) async {
    final db = await _dbService.database;
    return await db.update(
      'grupo_produto',
      grupoProduto.toMap(),
      where: 'id_grupo_produto = ?',
      whereArgs: [grupoProduto.id_grupo_produto],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(
      'grupo_produto',
      where: 'id_grupo_produto = ?',
      whereArgs: [id],
    );
  }
}
