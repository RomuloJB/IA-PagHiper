import 'package:flutter_application_1/Services/databaseService.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseResetHelper {
  static Future<void> resetDatabase() async {
    final dbService = DatabaseService.instance;
    final db = await dbService.database;

    print('🔄 Resetando banco de dados...');

    // Desabilitar FK temporariamente para permitir DROP
    await db.execute('PRAGMA foreign_keys = OFF');

    // Dropar todas as tabelas
    final tables = [
      'processing_protocols',
      'processing_logs',
      'capital_details',
      'contract_changes',
      'partners',
      'contracts',
      'society_types',
      'corporate_regimes',
      'contract_types',
      'users',
    ];

    for (var table in tables) {
      try {
        await db.execute('DROP TABLE IF EXISTS $table');
        print('✅ Tabela $table removida');
      } catch (e) {
        print('⚠️ Erro ao dropar $table: $e');
      }
    }

    // Re-habilitar FK
    await db.execute('PRAGMA foreign_keys = ON');

    print('✨ Banco resetado! Reinicie o app para recriar as tabelas.');
  }

  /// Limpar apenas dados de teste (mantém estrutura)
  static Future<void> clearTestData() async {
    final dbService = DatabaseService.instance;
    final db = await dbService.database;

    print('🧹 Limpando dados de teste...');

    // Ordem reversa para respeitar FK
    await db.delete('processing_protocols');
    await db.delete('processing_logs');
    await db.delete('capital_details');
    await db.delete('contract_changes');
    await db.delete('partners');
    await db.delete(
      'contracts',
      where: 'id != ?',
      whereArgs: ['admin'],
    ); // Mantém admin

    print('✅ Dados de teste limpos!');
  }

  /// Verificar integridade do banco
  static Future<void> checkIntegrity() async {
    final dbService = DatabaseService.instance;
    final db = await dbService.database;

    print('🔍 Verificando integridade do banco...');

    final result = await db.rawQuery('PRAGMA integrity_check');
    print('Resultado: $result');

    final fkCheck = await db.rawQuery('PRAGMA foreign_key_check');
    if (fkCheck.isEmpty) {
      print('✅ Nenhum erro de Foreign Key');
    } else {
      print('⚠️ Erros de Foreign Key encontrados:');
      for (var error in fkCheck) {
        print('  $error');
      }
    }
  }

  /// Listar todas as tabelas
  static Future<void> listTables() async {
    final dbService = DatabaseService.instance;
    final db = await dbService.database;

    print('📋 Tabelas no banco:');

    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' ORDER BY name",
    );

    for (var table in tables) {
      final tableName = table['name'];
      final count = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'),
      );
      print('  - $tableName ($count registros)');
    }
  }
}
