class Conquista {
  final int id;
  final String titulo;
  final String descricao;
  final String icone;
  final int pontosRecompensa;
  final bool desbloqueada;
  final DateTime? dataDesbloqueio;
  final String tipo; // 'nivel', 'pontuacao', 'tempo', 'combo', 'loja'
  final int valorRequisito;

  Conquista({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.icone,
    required this.pontosRecompensa,
    this.desbloqueada = false,
    this.dataDesbloqueio,
    required this.tipo,
    required this.valorRequisito,
  });

  Map<String, dynamic> toMap(int usuarioId) {
    return {
      'usuario_id': usuarioId,
      'conquista_id': id,
      'desbloqueada': desbloqueada ? 1 : 0,
      'data_desbloqueio': dataDesbloqueio?.millisecondsSinceEpoch,
    };
  }
}