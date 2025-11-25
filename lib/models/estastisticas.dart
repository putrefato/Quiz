class EstatisticasUsuario {
  final int usuarioId;
  final int totalJogos;
  final int totalAcertos;
  final int totalErros;
  final int pontuacaoTotal;
  final int nivelMaximo;
  final int moedasGanhas;
  final int tempoTotalJogado;
  final double taxaAcerto;
  final Map<String, int> acertosPorCategoria;
  final Map<String, int> errosPorCategoria;
  final int streakAtual;
  final int melhorStreak;
  final int respostasRapidas;
  final int niveisPerfeitos;
  final DateTime dataPrimeiroJogo;
  final DateTime dataUltimoJogo;

  EstatisticasUsuario({
    required this.usuarioId,
    required this.totalJogos,
    required this.totalAcertos,
    required this.totalErros,
    required this.pontuacaoTotal,
    required this.nivelMaximo,
    required this.moedasGanhas,
    required this.tempoTotalJogado,
    required this.taxaAcerto,
    required this.acertosPorCategoria,
    required this.errosPorCategoria,
    required this.streakAtual,
    required this.melhorStreak,
    required this.respostasRapidas,
    required this.niveisPerfeitos,
    required this.dataPrimeiroJogo,
    required this.dataUltimoJogo,
  });

  Duration get tempoTotalJogadoDuration => Duration(seconds: tempoTotalJogado);

  Map<String, double> get taxaAcertoPorCategoria {
    final taxas = <String, double>{};
    acertosPorCategoria.forEach((categoria, acertos) {
      final erros = errosPorCategoria[categoria] ?? 0;
      final total = acertos + erros;
      taxas[categoria] = total > 0 ? (acertos / total * 100) : 0.0;
    });
    return taxas;
  }
}