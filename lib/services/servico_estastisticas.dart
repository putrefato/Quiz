import '../models/estatisticas.dart';
import 'servico_banco_dados.dart';

class ServicoEstatisticas {
  final ServicoBancoDados _bancoDados = ServicoBancoDados();

  Future<EstatisticasUsuario> obterEstatisticas(int usuarioId) async {
    // Em app real, isso viria do banco de dados
    // Vamos simular dados para demonstração

    final acertosPorCategoria = {
      'História': 45,
      'Hardware': 38,
      'Linguagens': 52,
      'Sistemas Operacionais': 41,
      'Internet': 36,
      'Conceitos': 48,
      'Web': 33,
      'Redes': 29,
      'Banco de Dados': 25,
      'IA': 18,
    };

    final errosPorCategoria = {
      'História': 12,
      'Hardware': 15,
      'Linguagens': 8,
      'Sistemas Operacionais': 16,
      'Internet': 21,
      'Conceitos': 9,
      'Web': 14,
      'Redes': 18,
      'Banco de Dados': 22,
      'IA': 25,
    };

    return EstatisticasUsuario(
      usuarioId: usuarioId,
      totalJogos: 47,
      totalAcertos: 365,
      totalErros: 160,
      pontuacaoTotal: 8750,
      nivelMaximo: 8,
      moedasGanhas: 1250,
      tempoTotalJogado: 12450, // 3.5 horas
      taxaAcerto: 69.5,
      acertosPorCategoria: acertosPorCategoria,
      errosPorCategoria: errosPorCategoria,
      streakAtual: 5,
      melhorStreak: 12,
      respostasRapidas: 23,
      niveisPerfeitos: 3,
      dataPrimeiroJogo: DateTime(2024, 1, 15),
      dataUltimoJogo: DateTime.now(),
    );
  }

  Future<Map<String, dynamic>> obterEstatisticasResumidas(int usuarioId) async {
    final estatisticas = await obterEstatisticas(usuarioId);

    return {
      'total_acertos': estatisticas.totalAcertos,
      'total_erros': estatisticas.totalErros,
      'pontuacao_total': estatisticas.pontuacaoTotal,
      'nivel_atual': estatisticas.nivelMaximo,
      'moedas': 500, // Simulado
      'respostas_rapidas': estatisticas.respostasRapidas,
      'niveis_perfeitos': estatisticas.niveisPerfeitos,
      'dias_consecutivos': estatisticas.streakAtual,
      'dicas_usadas': 8, // Simulado
    };
  }

  Future<List<Map<String, dynamic>>> obterHistoricoJogos(int usuarioId) async {
    // Simular histórico de jogos
    return [
      {
        'data': DateTime.now().subtract(Duration(days: 1)),
        'pontuacao': 450,
        'nivel': 5,
        'acertos': 22,
        'erros': 3,
        'tempo_total': 1250,
      },
      {
        'data': DateTime.now().subtract(Duration(days: 2)),
        'pontuacao': 380,
        'nivel': 4,
        'acertos': 18,
        'erros': 7,
        'tempo_total': 1420,
      },
      {
        'data': DateTime.now().subtract(Duration(days: 3)),
        'pontuacao': 520,
        'nivel': 6,
        'acertos': 25,
        'erros': 0,
        'tempo_total': 1100,
      },
    ];
  }
}