import '../models/conquista.dart';
import 'servico_banco_dados.dart';

class ServicoConquistas {
  final ServicoBancoDados _bancoDados = ServicoBancoDados();

  static final List<Conquista> conquistasBase = [
    Conquista(id: 1, titulo: 'Primeiros Passos', descricao: 'Complete o nível 1', icone: '🎯', pontosRecompensa: 50, tipo: 'nivel', valorRequisito: 1),
    Conquista(id: 2, titulo: 'Colecionador', descricao: 'Acumule 100 moedas', icone: '💰', pontosRecompensa: 100, tipo: 'moedas', valorRequisito: 100),
    Conquista(id: 3, titulo: 'Veterano', descricao: 'Alcance o nível 5', icone: '⭐', pontosRecompensa: 200, tipo: 'nivel', valorRequisito: 5),
    Conquista(id: 4, titulo: 'Mestre dos Pontos', descricao: 'Faça 1000 pontos', icone: '🏆', pontosRecompensa: 300, tipo: 'pontuacao', valorRequisito: 1000),
    Conquista(id: 5, titulo: 'Comprador', descricao: 'Compre seu primeiro item', icone: '🛒', pontosRecompensa: 150, tipo: 'loja', valorRequisito: 1),
    Conquista(id: 6, titulo: 'Mestre do Tempo', descricao: 'Responda 10 perguntas com menos de 5 segundos', icone: '⚡', pontosRecompensa: 100, tipo: 'tempo', valorRequisito: 10),
    Conquista(id: 7, titulo: 'Perfeccionista', descricao: 'Complete um nível com 100% de acertos', icone: '💯', pontosRecompensa: 150, tipo: 'perfeicao', valorRequisito: 1),
    Conquista(id: 8, titulo: 'Colecionador Supremo', descricao: 'Compre todos os itens da loja', icone: '🛍️', pontosRecompensa: 200, tipo: 'loja', valorRequisito: 10),
    Conquista(id: 9, titulo: 'Lenda Viva', descricao: 'Alcance o nível 10', icone: '👑', pontosRecompensa: 500, tipo: 'nivel', valorRequisito: 10),
    Conquista(id: 10, titulo: 'Estrategista', descricao: 'Use 5 dicas especiais', icone: '💡', pontosRecompensa: 80, tipo: 'dicas', valorRequisito: 5),
    Conquista(id: 11, titulo: 'Maratonista', descricao: 'Jogue por 7 dias consecutivos', icone: '🔥', pontosRecompensa: 120, tipo: 'streak', valorRequisito: 7),
    Conquista(id: 12, titulo: 'Mente Rápida', descricao: 'Responda 50 perguntas corretamente', icone: '🚀', pontosRecompensa: 180, tipo: 'acertos', valorRequisito: 50),
  ];

  Future<void> verificarConquistas(int usuarioId, int nivel, int pontuacao, int moedas, int acertosConsecutivos, int tempoResposta) async {
    final conquistas = await obterConquistasUsuario(usuarioId);
    final inventario = await _bancoDados.obterInventario(usuarioId);
    final estatisticas = await _bancoDados.obterEstatisticasUsuario(usuarioId);

    for (var conquista in conquistas) {
      if (!conquista.desbloqueada) {
        bool desbloquear = false;

        switch (conquista.id) {
          case 1: desbloquear = nivel >= 2; break;
          case 2: desbloquear = moedas >= 100; break;
          case 3: desbloquear = nivel >= 5; break;
          case 4: desbloquear = pontuacao >= 1000; break;
          case 5: desbloquear = inventario.isNotEmpty; break;
          case 6: desbloquear = estatisticas['respostas_rapidas'] >= 10; break;
          case 7: desbloquear = estatisticas['niveis_perfeitos'] >= 1; break;
          case 8: desbloquear = inventario.length >= 10; break;
          case 9: desbloquear = nivel >= 10; break;
          case 10: desbloquear = estatisticas['dicas_usadas'] >= 5; break;
          case 11: desbloquear = estatisticas['dias_consecutivos'] >= 7; break;
          case 12: desbloquear = estatisticas['total_acertos'] >= 50; break;
        }

        if (desbloquear) {
          await _bancoDados.desbloquearConquista(usuarioId, conquista.id);
          print('🎉 Conquista desbloqueada: ${conquista.titulo}');
        }
      }
    }
  }

  Future<List<Conquista>> obterConquistasUsuario(int usuarioId) async {
    final resultados = await _bancoDados.obterConquistasUsuario(usuarioId);

    return conquistasBase.map((base) {
      final conquistaUsuario = resultados.firstWhere(
        (c) => c['conquista_id'] == base.id,
        orElse: () => {},
      );

      return Conquista(
        id: base.id,
        titulo: base.titulo,
        descricao: base.descricao,
        icone: base.icone,
        pontosRecompensa: base.pontosRecompensa,
        desbloqueada: conquistaUsuario.isNotEmpty ? conquistaUsuario['desbloqueada'] == 1 : false,
        dataDesbloqueio: conquistaUsuario.isNotEmpty && conquistaUsuario['data_desbloqueio'] != null
            ? DateTime.fromMillisecondsSinceEpoch(conquistaUsuario['data_desbloqueio'])
            : null,
        tipo: base.tipo,
        valorRequisito: base.valorRequisito,
      );
    }).toList();
  }

  Future<int> obterProgressoConquista(Conquista conquista, int usuarioId) async {
    final estatisticas = await _bancoDados.obterEstatisticasUsuario(usuarioId);

    switch (conquista.id) {
      case 1: return estatisticas['nivel_atual'] ?? 0;
      case 2: return estatisticas['moedas'] ?? 0;
      case 3: return estatisticas['nivel_atual'] ?? 0;
      case 4: return estatisticas['pontuacao_total'] ?? 0;
      case 5: return (await _bancoDados.obterInventario(usuarioId)).length;
      case 6: return estatisticas['respostas_rapidas'] ?? 0;
      case 7: return estatisticas['niveis_perfeitos'] ?? 0;
      case 8: return (await _bancoDados.obterInventario(usuarioId)).length;
      case 9: return estatisticas['nivel_atual'] ?? 0;
      case 10: return estatisticas['dicas_usadas'] ?? 0;
      case 11: return estatisticas['dias_consecutivos'] ?? 0;
      case 12: return estatisticas['total_acertos'] ?? 0;
      default: return 0;
    }
  }
}