import 'package:barber_shop/Banco/entidades/Servico.dart';
import 'package:barber_shop/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class ServicoDao {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Servico servico) async {
    final db = await _dbService.database;
    return await db.insert(
      'servicos',
      servico.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Servico?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'servicos',
      where: 'id_servico = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Servico.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Servico>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('servicos');
    return List.generate(maps.length, (i) => Servico.fromMap(maps[i]));
  }

  Future<int> update(Servico servico) async {
    final db = await _dbService.database;
    return await db.update(
      'servicos',
      servico.toMap(),
      where: 'id_servico = ?',
      whereArgs: [servico.id_servico],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete(
      'servicos',
      where: 'id_servico = ?',
      whereArgs: [id],
    );
  }
}
