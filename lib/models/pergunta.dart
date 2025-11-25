class Pergunta {
  final int id;
  final String pergunta;
  final List<String> opcoes;
  final int respostaCorreta;
  final String categoria;
  final String dificuldade;

  Pergunta({
    required this.id,
    required this.pergunta,
    required this.opcoes,
    required this.respostaCorreta,
    required this.categoria,
    required this.dificuldade,
  });
}