## Contexto rápido

Repo: app Flutter simples para upload e processamento (mock) de contratos.
Principais áreas: UI em `lib/Telas/*`, rotas em `lib/Routes/rotas.dart`, configuração da aplicação em `lib/Config/app.dart`, serviços de domínio em `lib/Services/*` e persistência via SQLite em `lib/banco/DAO/*` com `Services/databaseService.dart`.

## Objetivo do agente

Seja pragmático: faça mudanças pequenas, testáveis e consistentes com o padrão existente (DAO + Service + Widgets). Priorize alterações que compilam localmente e mantenham o banco local em `DatabaseService`.

## Estrutura e padrões relevantes

- Arquitetura: camada UI (Widgets em `lib/Telas`), lógica de aplicação/serviço em `lib/Services`, persistência em `lib/banco` (DAOs + entidades). `main.dart` inicializa `DatabaseService` e executa `App`.
- Rotas: declaradas em `lib/Routes/rotas.dart` e usadas em `lib/Config/app.dart` (MaterialApp.routes).
- Banco: `DatabaseService` é singleton e cria tabelas (users, contracts, partners, processing_logs...). Os DAOs usam `DatabaseService.instance.database` e retornam entidades via `fromMap()`/`toMap()`.
- Processamento de contrato: `ContractService.uploadAndProcessContract` usa um mock `_mockAnalyzeApi` que lê `assets/contratos.json` e persiste contratos/partners e logs de processamento.

## Convenções de código

- Nomes: DAOs terminam com `Dao`/`DAO` (ex.: `ContractDao`, `UserDao`). Entidades possuem `toMap()`/`fromMap()`.
- Erros: serviços lançam `Exception` com mensagens em português (ex.: 'Credenciais inválidas'). Mantenha esse padrão de mensagens.
- Banco em Web: `DatabaseService` usa `sqflite_ffi_web` com banco em memória quando `kIsWeb`.

## Fluxos comuns que o agente pode tocar

- Adicionar um campo na entidade: atualizar `lib/banco/entidades/*`, migrar `DatabaseService._onCreate` (e, se necessário, documentar migração). Para mudanças simples, preferir adicionar colunas com `ALTER TABLE` em `_onCreate` ou instruir desenvolvedor humano sobre como migrar o DB existente.
- Atualizar upload/processamento: `lib/Services/ContractService.dart` centraliza validação de arquivo, chamada de API (mock) e persistência. Exemplos: validar extensão via `validateFile`, retornar a resposta da API para a UI.
- Autenticação: `AuthService` usa `UserDao.findByEmailAndPassword`. Para autenticação persistente, existem comentários indicando SharedPreferences/SecureStorage, mas não há implementação.

## Comandos úteis / Build & Test

- Rodar app em debug (Windows) com Flutter:
  - flutter pub get
  - flutter run -d windows
- Rodar em mobile (Android/iOS): execute via IDE ou:
  - flutter run -d <deviceId>
- Tests unitários (há apenas `test/widget_test.dart`):
  - flutter test

Nota: `main.dart` inicializa o banco antes de `runApp`, então para testes que importam `main.dart` pode ser necessário adaptar ou usar `WidgetsFlutterBinding.ensureInitialized()`.

## Integrações externas e assets

- `assets/contratos.json` é usado como mock para analisar contratos. Mantenha formato JSON estável ao alterar `ContractService`.
- Dependências importantes em `pubspec.yaml`: `sqflite`, `sqflite_common_ffi(_web)`, `file_picker`, `http`, `uuid`. Evite trocar versões sem rodar `flutter pub get` e validar comportamento do DB.

## Exemplos práticos (copy-paste friendly)

- Exemplo: buscar contratos processados

  final dao = ContractDao();
  final processed = await dao.findByStatus('processed');

- Exemplo: uso de rotas

  Navigator.pushNamed(context, Rotas.Upload);

## O que não fazer

- Não altere o esquema do DB sem ajustar `DatabaseService` ou documentar migração.
- Não remover o `await DatabaseService.instance.database;` em `main.dart` (isso garante tabelas criadas antes da UI).

## Onde olhar primeiro (arquivos chave)

- `lib/main.dart` — bootstrap do app
- `lib/Config/app.dart` — MaterialApp, tema e rotas
- `lib/Services/ContractService.dart` — lógica de upload/processamento
- `lib/Services/databaseService.dart` — inicialização e esquema do DB
- `lib/banco/DAO/*` e `lib/banco/entidades/*` — padrão de persistência
- `assets/contratos.json` — mock de API

Se algo ficou ambíguo, me diga qual área você quer que eu expanda (ex.: política de migração do DB, exemplos de testes unitários, ou fluxos da UI para upload). 
