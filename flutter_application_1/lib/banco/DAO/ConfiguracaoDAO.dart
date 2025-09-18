import 'package:barber_shop/Banco/entidades/Configuracao.dart';
import 'package:barber_shop/Services/databaseService.dart';

class ConfiguracaoDAO {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<Configuracao?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.query('configuracao');
    if (maps.isNotEmpty) {
      return Configuracao.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Configuracao configuracao) async {
    final db = await _dbService.database;
    return await db.update(
      'configuracao',
      configuracao.toMap(),
      where: 'id_configuracao = ?',
      whereArgs: [configuracao.id_configuracao],
    );
  }
}
