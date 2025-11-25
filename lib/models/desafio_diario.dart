class DesafioDiario {
  final int id;
  final String titulo;
  final String descricao;
  final String icone;
  final int recompensaMoedas;
  final int recompensaPontos;
  int progressoAtual; // MUDADO: removido final
  final int progressoNecessario;
  final String tipo;
  bool concluido; // MUDADO: removido final
  final DateTime dataExpiracao;

  DesafioDiario({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.recompensaMoedas,
    required this.recompensaPontos,
    required this.progressoAtual,
    required this.progressoNecessario,
    required this.tipo,
    required this.concluido,
    required this.dataExpiracao,
  });

  double get progresso => progressoAtual / progressoNecessario;
  bool get expirado => DateTime.now().isAfter(dataExpiracao);
  bool get podeCompletar => progressoAtual >= progressoNecessario && !concluido && !expirado;
}