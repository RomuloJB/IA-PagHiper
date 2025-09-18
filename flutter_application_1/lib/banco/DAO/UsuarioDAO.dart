import 'package:barber_shop/Banco/entidades/Usuario.dart';
import 'package:barber_shop/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class UsuarioDao {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Usuario usuario) async {
    final db = await _dbService.database;
    return await db.insert('usuarios', {
      'id': usuario.id,
      'nome': usuario.nome,
      'senha': usuario.senha,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Usuario?> read(String id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Usuario>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('usuarios');
    return List.generate(maps.length, (i) => Usuario.fromMap(maps[i]));
  }

  Future<int> update(Usuario usuario) async {
    final db = await _dbService.database;
    return await db.update(
      'usuarios',
      {'nome': usuario.nome, 'senha': usuario.senha},
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> delete(String id) async {
    final db = await _dbService.database;
    return await db.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }
}
