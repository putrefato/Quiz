class ProgressoJogo {
  final int? id;
  final int usuarioId;
  final int nivel;
  final int pontuacao;
  final int moedas;
  final DateTime ultimoSalvamento;

  ProgressoJogo({this.id, required this.usuarioId, required this.nivel, required this.pontuacao, required this.moedas, required this.ultimoSalvamento});

  Map<String, dynamic> paraMapa() {
    return {
      'id': id,
      'usuario_id': usuarioId,
      'nivel': nivel,
      'pontuacao': pontuacao,
      'moedas': moedas,
      'ultimo_salvamento': ultimoSalvamento.millisecondsSinceEpoch,
    };
  }

  factory ProgressoJogo.deMapa(Map<String, dynamic> mapa) {
    return ProgressoJogo(
      id: mapa['id'],
      usuarioId: mapa['usuario_id'],
      nivel: mapa['nivel'],
      pontuacao: mapa['pontuacao'],
      moedas: mapa['moedas'],
      ultimoSalvamento: DateTime.fromMillisecondsSinceEpoch(mapa['ultimo_salvamento']),
    );
  }
}