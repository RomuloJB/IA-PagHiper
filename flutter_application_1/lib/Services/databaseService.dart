import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._constructor();
  static DatabaseService get instance => _instance;

  DatabaseService._constructor();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    if (kIsWeb) {
      final dbFactory = databaseFactoryFfiWeb;
      print('Inicializando banco de dados na web (em memória)');
      return await dbFactory.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 2,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onConfigure: _onConfigure,
        ),
      );
    } else {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'apollo.db'); // Nome do DB atualizado
      print('Inicializando banco de dados local: $path');
      return await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 2,
          onCreate: _onCreate,
          onUpgrade: _onUpgrade,
          onConfigure: _onConfigure,
        ),
      );
    }
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('Atualizando banco de $oldVersion para $newVersion');

    if (oldVersion < 2) {
      // Adicionar tabela de protocolos na migração da v1 para v2
      print('Criando tabela processing_protocols...');
      await db.execute('''
        CREATE TABLE IF NOT EXISTS processing_protocols (
          protocol_code TEXT PRIMARY KEY,
          contract_id TEXT NOT NULL,
          status TEXT NOT NULL,
          current_step TEXT,
          progress INTEGER,
          file_name TEXT,
          created_at TEXT NOT NULL,
          completed_at TEXT,
          error_message TEXT,
          FOREIGN KEY(contract_id) REFERENCES contracts(id) ON DELETE CASCADE
        )
      ''');
    }
  }

  Future<void> _onConfigure(Database db) async {
    // Habilita o suporte a chaves estrangeiras, essencial para a integridade dos dados
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    print('Criando tabelas para a versão $version do banco de dados...');

    // Tabela de Usuários
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT,
        email TEXT,
        password TEXT,
        created_at TEXT
      )
    ''');

    // Tabelas de "tipos" (lookup tables)
    await db.execute('''
      CREATE TABLE contract_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE corporate_regimes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE society_types (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT UNIQUE NOT NULL
      )
    ''');

    // Tabela principal de Contratos
    await db.execute('''
      CREATE TABLE contracts (
        id TEXT PRIMARY KEY,
        user_id TEXT,
        filename TEXT NOT NULL,
        hash TEXT UNIQUE,
        uploaded_at TEXT NOT NULL,
        processed_at TEXT,
        status TEXT NOT NULL,
        company_name TEXT,
        cnpj TEXT,
        foundation_date TEXT,
        capital_social REAL,
        address TEXT,
        contract_type_id INTEGER,
        corporate_regime_id INTEGER,
        society_type_id INTEGER,
        confidence REAL,
        raw_json TEXT,
        notes TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL,
        FOREIGN KEY(contract_type_id) REFERENCES contract_types(id),
        FOREIGN KEY(corporate_regime_id) REFERENCES corporate_regimes(id),
        FOREIGN KEY(society_type_id) REFERENCES society_types(id)
      )
    ''');

    // Tabela de Sócios
    await db.execute('''
      CREATE TABLE partners (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contract_id TEXT NOT NULL,
        name TEXT NOT NULL,
        cpf_cnpj TEXT,
        qualification TEXT,
        role TEXT,
        quota_percent REAL,
        capital_subscribed REAL,
        address TEXT,
        FOREIGN KEY(contract_id) REFERENCES contracts(id) ON DELETE CASCADE
      )
    ''');

    // Tabela de Alterações Contratuais
    await db.execute('''
      CREATE TABLE contract_changes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contract_id TEXT NOT NULL,
        change_date TEXT NOT NULL,
        change_type TEXT,
        description TEXT NOT NULL,
        FOREIGN KEY(contract_id) REFERENCES contracts(id) ON DELETE CASCADE
      )
    ''');

    // Tabela de Detalhes do Capital
    await db.execute('''
      CREATE TABLE capital_details (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contract_id TEXT NOT NULL,
        type TEXT NOT NULL,
        description TEXT,
        value REAL NOT NULL,
        FOREIGN KEY(contract_id) REFERENCES contracts(id) ON DELETE CASCADE
      )
    ''');

    // Tabela de Logs de Processamento
    await db.execute('''
      CREATE TABLE processing_logs (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contract_id TEXT NOT NULL,
        step TEXT NOT NULL,
        message TEXT,
        created_at TEXT NOT NULL,
        FOREIGN KEY(contract_id) REFERENCES contracts(id) ON DELETE CASCADE
      )
    ''');

    // Tabela de Protocolos de Processamento
    await db.execute('''
      CREATE TABLE processing_protocols (
        protocol_code TEXT PRIMARY KEY,
        contract_id TEXT NOT NULL,
        status TEXT NOT NULL,
        current_step TEXT,
        progress INTEGER,
        file_name TEXT,
        created_at TEXT NOT NULL,
        completed_at TEXT,
        error_message TEXT,
        FOREIGN KEY(contract_id) REFERENCES contracts(id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      INSERT INTO users (name, email, password) VALUES (
      'admin',
      'admin@admin.com',
      'admin123')
    ''');

    print('Tabelas criadas com sucesso!');
  }
}
