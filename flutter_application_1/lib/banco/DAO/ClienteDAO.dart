import 'package:barber_shop/Banco/entidades/Cliente.dart';
import 'package:barber_shop/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class ClienteDao {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Cliente cliente) async {
    final db = await _dbService.database;
    return await db.insert(
      'clientes',
      cliente.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Cliente?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clientes',
      where: 'id = ?',
      whereArgs: [id],
    );
    print('Clientes no banco: $maps');
    if (maps.isNotEmpty) {
      return Cliente.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Cliente>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('clientes');
    print('Clientes no banco: $maps');
    return List.generate(maps.length, (i) => Cliente.fromMap(maps[i]));
  }

  Future<int> update(Cliente cliente) async {
    final db = await _dbService.database;
    return await db.update(
      'clientes',
      cliente.toMap(),
      where: 'id = ?',
      whereArgs: [cliente.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete('clientes', where: 'id = ?', whereArgs: [id]);
  }
}
