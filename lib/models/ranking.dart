class PosicaoRanking {
  final int posicao;
  final String nomeUsuario;
  final int pontuacao;
  final int nivel;
  final String? avatar;

  PosicaoRanking({
    required this.posicao,
    required this.nomeUsuario,
    required this.pontuacao,
    required this.nivel,
    this.avatar,
  });
}