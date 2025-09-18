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
      // Configuração para web usando sqflite_ffi
      final dbFactory = databaseFactoryFfiWeb;
      print('Inicializando banco de dados na web');
      return await dbFactory.openDatabase(
        inMemoryDatabasePath, // Banco em memória para web
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
          onUpgrade: (db, oldVersion, newVersion) async {
            if (oldVersion < 2) {}
          },
        ),
      );
    } else {
      // Configuração para plataformas não-web usando sqflite
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, 'barber_shop.db');
      print('Inicializando banco de dados local: $path');
      return await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: _onCreate,
          onUpgrade: (db, oldVersion, newVersion) async {
            if (oldVersion < 2) {}
          },
        ),
      );
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS clientes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        sobrenome TEXT,
        celular TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS servicos (
        id_servico INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        preco REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS usuarios (
        id TEXT PRIMARY KEY,
        nome TEXT,
        senha TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS agendamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente_id INTEGER,
        dia_agendamento INTEGER,
        hora_agendada TEXT,
        servico_id INTEGER,
        status TEXT DEFAULT 'Pendente',
        FOREIGN KEY (cliente_id) REFERENCES clientes(id),
        FOREIGN KEY (servico_id) REFERENCES servicos(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS configuracao (
        id_configuracao INTEGER PRIMARY KEY AUTOINCREMENT,
        enviarMensagemWhats INTEGER NOT NULL DEFAULT 1,
        tempoEnviarMensagem INTEGER NOT NULL,
        salvarObservacao INTEGER NOT NULL DEFAULT 1
      )
    ''');

    await db.execute(
      '''
        INSERT INTO configuracao (enviarMensagemWhats, tempoEnviarMensagem, salvarObservacao)
        VALUES (?, ?, ?)
      ''',
      [1, 5, 1],
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS cliente_observacao (
        id_observacao INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente_id INTEGER,
        dtCadastro INTEGER,
        agendamento_id INTEGER,
        FOREIGN KEY (cliente_id) REFERENCES clientes(id),
        FOREIGN KEY (agendamento_id) REFERENCES agendamentos(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS grupo_produto (
        id_grupo_produto INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS produtos (
        id_produto INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        valor_unitario REAL,
        percentual_lucro REAL,
        valor_venda REAL,
        id_grupo_produto INTEGER,
        FOREIGN KEY (id_grupo_produto) REFERENCES grupo_produto(id_grupo_produto)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS venda (
        id_venda INTEGER PRIMARY KEY AUTOINCREMENT,
        cliente_id INTEGER,
        data_venda INTEGER,
        descricao TEXT,
        valor_total REAL,
        FOREIGN KEY (cliente_id) REFERENCES clientes(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS venda_items (
        id_venda_item INTEGER PRIMARY KEY AUTOINCREMENT,
        id_venda INTEGER,
        id_produto INTEGER,
        quantidade INTEGER,
        valor_total REAL,
        FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
        FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
      )
    ''');
  }
}
