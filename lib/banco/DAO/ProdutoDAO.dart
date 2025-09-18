import 'package:barber_shop/Banco/entidades/Produto.dart';
import 'package:barber_shop/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class ProdutoDao {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Produto produto) async {
    final db = await _dbService.database;
    return await db.insert('produtos', {
      'nome': produto.nome,
      'valor_unitario': produto.valor_unitario,
      'percentual_lucro': produto.percentual_lucro,
      'valor_venda': produto.valor_venda,
      'id_grupo_produto': produto.grupo_produto.id_grupo_produto,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Produto?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT p.id_produto, p.nome, p.valor_unitario, p.percentual_lucro, p.valor_venda, 
             g.id_grupo_produto, g.nome AS nome_grupo_produto
      FROM produtos p
      JOIN grupo_produto g ON p.id_grupo_produto = g.id_grupo_produto
      WHERE p.id_produto = ?
      ''',
      [id],
    );
    print('Produtos no banco: $maps');
    if (maps.isNotEmpty) {
      return Produto.fromMap({
        'id_produto': maps.first['id_produto'],
        'nome': maps.first['nome'],
        'valor_unitario': maps.first['valor_unitario'],
        'percentual_lucro': maps.first['percentual_lucro'],
        'valor_venda': maps.first['valor_venda'],
        'id_grupo_produto': maps.first['id_grupo_produto'],
        'nome_grupo_produto': maps.first['nome_grupo_produto'],
      });
    }
    return null;
  }

  Future<List<Produto>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT p.id_produto, p.nome, p.valor_unitario, p.percentual_lucro, p.valor_venda, 
             g.id_grupo_produto, g.nome AS nome_grupo_produto
      FROM produtos p
      JOIN grupo_produto g ON p.id_grupo_produto = g.id_grupo_produto
      ''');
    print('Produtos no banco: $maps');
    return List.generate(
      maps.length,
      (i) => Produto.fromMap({
        'id_produto': maps[i]['id_produto'],
        'nome': maps[i]['nome'],
        'valor_unitario': maps[i]['valor_unitario'],
        'percentual_lucro': maps[i]['percentual_lucro'],
        'valor_venda': maps[i]['valor_venda'],
        'id_grupo_produto': maps[i]['id_grupo_produto'],
        'nome_grupo_produto': maps[i]['nome_grupo_produto'],
      }),
    );
  }

  Future<int> update(Produto produto) async {
    final db = await _dbService.database;
    return await db.update(
      'produtos',
      {
        'nome': produto.nome,
        'valor_unitario': produto.valor_unitario,
        'percentual_lucro': produto.percentual_lucro,
        'valor_venda': produto.valor_venda,
        'id_grupo_produto': produto.grupo_produto.id_grupo_produto,
      },
      where: 'id_produto = ?',
      whereArgs: [produto.id_produto],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(
      'produtos',
      where: 'id_produto = ?',
      whereArgs: [id],
    );
  }
}
