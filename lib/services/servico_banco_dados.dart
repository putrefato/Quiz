import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/usuario.dart';
import '../models/progresso_jogo.dart';

class ServicoBancoDados {
  static final ServicoBancoDados _instancia = ServicoBancoDados._interno();
  factory ServicoBancoDados() => _instancia;

  ServicoBancoDados._interno() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  static Database? _bancoDados;

  Future<Database> get bancoDados async {
    if (_bancoDados != null) return _bancoDados!;
    _bancoDados = await _iniciarBancoDados();
    return _bancoDados!;
  }

  Future<Map<String, dynamic>> obterEstatisticasUsuario(int usuarioId) async {
  return {
    'nivel_atual': 6,
    'moedas': 500,
    'pontuacao_total': 3200,
    'respostas_rapidas': 8,
    'niveis_perfeitos': 2,
    'dias_consecutivos': 5,
    'dicas_usadas': 3,
    'total_acertos': 85,
  };
}

/*************  ✨ Windsurf Command ⭐  *************/
  /// Abre o caminho para o banco de dados e inicia o banco com
  /// as op es de vers o e onCreate.
  ///
  /// Retorna o banco de dados pronto para uso.
  ///
  /// Throws a [DatabaseException] se houver um erro ao abrir o banco.
  ///
  /// Retorna um [Future] que completa com o banco de dados quando estiver pronto.
/*******  080ec902-ccbd-4e80-b3b4-0d465da032a0  *******/
  Future<Database> _iniciarBancoDados() async {
    String caminho = join(await getDatabasesPath(), 'banco_jogo.db');
    return await databaseFactory.openDatabase(
      caminho,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: _aoCriar,
      ),
    );
  }

  Future<String> getDatabasesPath() async {
    return '.';
  }

  Future<void> _aoCriar(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE usuarios(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome_usuario TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        hash_senha TEXT NOT NULL,
        data_criacao INTEGER NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE progresso_jogo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        nivel INTEGER DEFAULT 1,
        pontuacao INTEGER DEFAULT 0,
        moedas INTEGER DEFAULT 0,
        ultimo_salvamento INTEGER NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE conquistas_usuario(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        conquista_id INTEGER NOT NULL,
        desbloqueada INTEGER DEFAULT 0,
        data_desbloqueio INTEGER,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE inventario_usuario(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL,
        item_id INTEGER NOT NULL,
        quantidade INTEGER DEFAULT 1,
        data_compra INTEGER NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuarios (id) ON DELETE CASCADE
      )
    ''');
  }

  // MÉTODO NOVO ADICIONADO
  Future<Map<String, dynamic>> obterEstatisticasUsuario(int usuarioId) async {
    return {
      'nivel_atual': 6,
      'moedas': 500,
      'pontuacao_total': 3200,
      'respostas_rapidas': 8,
      'niveis_perfeitos': 2,
      'dias_consecutivos': 5,
      'dicas_usadas': 3,
      'total_acertos': 85,
    };
  }

  Future<int> inserirUsuario(Usuario usuario) async {
    final db = await bancoDados;
    return await db.insert('usuarios', usuario.paraMapa());
  }

  Future<Usuario?> obterUsuarioPorNome(String nomeUsuario) async {
    final db = await bancoDados;
    final List<Map<String, dynamic>> mapas = await db.query(
      'usuarios',
      where: 'nome_usuario = ?',
      whereArgs: [nomeUsuario]
    );
    if (mapas.isNotEmpty) return Usuario.deMapa(mapas.first);
    return null;
  }

  Future<Usuario?> obterUsuarioPorEmail(String email) async {
    final db = await bancoDados;
    final List<Map<String, dynamic>> mapas = await db.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email]
    );
    if (mapas.isNotEmpty) return Usuario.deMapa(mapas.first);
    return null;
  }

  Future<Usuario?> obterUsuarioPorId(int id) async {
    final db = await bancoDados;
    final List<Map<String, dynamic>> mapas = await db.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id]
    );
    if (mapas.isNotEmpty) return Usuario.deMapa(mapas.first);
    return null;
  }

  Future<int> salvarProgresso(ProgressoJogo progresso) async {
    final db = await bancoDados;
    return await db.insert(
      'progresso_jogo',
      progresso.paraMapa(),
      conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<ProgressoJogo?> obterProgresso(int usuarioId) async {
    final db = await bancoDados;
    final List<Map<String, dynamic>> mapas = await db.query(
      'progresso_jogo',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId]
    );
    if (mapas.isNotEmpty) return ProgressoJogo.deMapa(mapas.first);
    return null;
  }

  Future<int> atualizarProgresso(ProgressoJogo progresso) async {
    final db = await bancoDados;
    return await db.update(
      'progresso_jogo',
      progresso.paraMapa(),
      where: 'usuario_id = ?',
      whereArgs: [progresso.usuarioId]
    );
  }

  Future<List<Map<String, dynamic>>> obterConquistasUsuario(int usuarioId) async {
    final db = await bancoDados;
    return await db.query(
      'conquistas_usuario',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId]
    );
  }

  Future<void> desbloquearConquista(int usuarioId, int conquistaId) async {
    final db = await bancoDados;
    await db.insert('conquistas_usuario', {
      'usuario_id': usuarioId,
      'conquista_id': conquistaId,
      'desbloqueada': 1,
      'data_desbloqueio': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<Map<String, dynamic>>> obterInventario(int usuarioId) async {
    final db = await bancoDados;
    return await db.query(
      'inventario_usuario',
      where: 'usuario_id = ?',
      whereArgs: [usuarioId]
    );
  }

  Future<int> adicionarItemInventario(int usuarioId, int itemId) async {
    final db = await bancoDados;
    return await db.insert('inventario_usuario', {
      'usuario_id': usuarioId,
      'item_id': itemId,
      'quantidade': 1,
      'data_compra': DateTime.now().millisecondsSinceEpoch,
    });
  }
}