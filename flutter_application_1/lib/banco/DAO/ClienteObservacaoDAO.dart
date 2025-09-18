import 'package:barber_shop/Banco/entidades/ClienteObservacao.dart';
import 'package:barber_shop/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class ClienteObservacaoDAO {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(ClienteObservacao clienteObservacao) async {
    final db = await _dbService.database;
    return await db.insert(
      'clientes_observacao',
      clienteObservacao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<ClienteObservacao?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clientes_observacao',
      where: 'id_observacao = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return ClienteObservacao.fromMap(maps.first);
    }
    return null;
  }

  Future<List<ClienteObservacao>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'clientes_observacao',
    );
    return List.generate(
      maps.length,
      (i) => ClienteObservacao.fromMap(maps[i]),
    );
  }

  Future<int> update(ClienteObservacao clienteObservacao) async {
    final db = await _dbService.database;
    return await db.update(
      'clientes_observacao',
      clienteObservacao.toMap(),
      where: 'id = ?',
      whereArgs: [clienteObservacao.id_observacao],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(
      'clientes_observacao',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
