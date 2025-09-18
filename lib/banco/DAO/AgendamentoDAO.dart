import 'package:barber_shop/Banco/entidades/Agendamento.dart';
import 'package:barber_shop/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class AgendamentoDao {
  final DatabaseService _dbService = DatabaseService.instance;

  Future<int> create(Agendamento agendamento) async {
    final db = await _dbService.database;
    return await db.insert(
      'agendamentos',
      agendamento.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Agendamento?> read(int id) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT 
        a.id,
        a.cliente_id,
        a.dia_agendamento,
        a.hora_agendada,
        a.servico_id,
        a.status,
        c.nome AS cliente_nome,
        c.sobrenome AS cliente_sobrenome,
        c.celular AS cliente_celular,
        s.nome AS servico_nome,
        s.preco AS servico_preco
      FROM agendamentos a
      JOIN clientes c ON a.cliente_id = c.id
      JOIN servicos s ON a.servico_id = s.id_servico
      WHERE a.id = ?
    ''',
      [id],
    );
    if (maps.isNotEmpty) {
      return Agendamento.fromMap(maps.first);
    }
    return null;
  }

  Future<List<Agendamento>> readAll() async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        a.id,
        a.cliente_id,
        a.dia_agendamento,
        a.hora_agendada,
        a.servico_id,
        a.status,
        c.nome AS cliente_nome,
        c.sobrenome AS cliente_sobrenome,
        c.celular AS cliente_celular,
        s.nome AS servico_nome,
        s.preco AS servico_preco
      FROM agendamentos a
      JOIN clientes c ON a.cliente_id = c.id
      JOIN servicos s ON a.servico_id = s.id_servico
    ''');
    return maps.map((map) => Agendamento.fromMap(map)).toList();
  }

  Future<List<Agendamento>> readByDateRange(
    DateTime startDate,
    DateTime endDate, {
    String extraWhere = '',
  }) async {
    final db = await _dbService.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery(
      '''
      SELECT 
        a.id,
        a.cliente_id,
        a.dia_agendamento,
        a.hora_agendada,
        a.servico_id,
        a.status,
        c.nome AS cliente_nome,
        c.sobrenome AS cliente_sobrenome,
        c.celular AS cliente_celular,
        s.nome AS servico_nome,
        s.preco AS servico_preco
      FROM agendamentos a
      JOIN clientes c ON a.cliente_id = c.id
      JOIN servicos s ON a.servico_id = s.id_servico
      WHERE a.dia_agendamento >= ? AND a.dia_agendamento <= ?
      ${extraWhere.isNotEmpty ? extraWhere : ''}
    ''',
      [startDate.millisecondsSinceEpoch, endDate.millisecondsSinceEpoch],
    );
    return maps.map((map) => Agendamento.fromMap(map)).toList();
  }

  Future<int> update(Agendamento agendamento) async {
    final db = await _dbService.database;
    return await db.update(
      'agendamentos',
      agendamento.toMap(),
      where: 'id = ?',
      whereArgs: [agendamento.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await _dbService.database;
    return await db.delete('agendamentos', where: 'id = ?', whereArgs: [id]);
  }
}
