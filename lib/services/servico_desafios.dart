import '../models/desafio_diario.dart';

class ServicoDesafios {
  static List<DesafioDiario> gerarDesafiosDiarios() {
    final agora = DateTime.now();
    final expiracao = DateTime(agora.year, agora.month, agora.day + 1); // Expira à meia-noite

    return [
      DesafioDiario(
        id: 1,
        titulo: 'Acertar 10 Questões',
        descricao: 'Acertar 10 questões em qualquer modo de jogo',
        icone: '🎯',
        recompensaMoedas: 25,
        recompensaPontos: 50,
        progressoAtual: 0,
        progressoNecessario: 10,
        tipo: 'acertos',
        concluido: false,
        dataExpiracao: expiracao,
      ),
      DesafioDiario(
        id: 2,
        titulo: 'Completar 1 Nível',
        descricao: 'Completar qualquer nível com sucesso',
        icone: '⭐',
        recompensaMoedas: 30,
        recompensaPontos: 75,
        progressoAtual: 0,
        progressoNecessario: 1,
        tipo: 'nivel',
        concluido: false,
        dataExpiracao: expiracao,
      ),
      DesafioDiario(
        id: 3,
        titulo: 'Ganhar 200 Pontos',
        descricao: 'Acumular 200 pontos em uma sessão',
        icone: '🏆',
        recompensaMoedas: 40,
        recompensaPontos: 100,
        progressoAtual: 0,
        progressoNecessario: 200,
        tipo: 'pontuacao',
        concluido: false,
        dataExpiracao: expiracao,
      ),
      DesafioDiario(
        id: 4,
        titulo: 'Respostas Rápidas',
        descricao: 'Responder 5 questões em menos de 10 segundos',
        icone: '⚡',
        recompensaMoedas: 35,
        recompensaPontos: 80,
        progressoAtual: 0,
        progressoNecessario: 5,
        tipo: 'tempo',
        concluido: false,
        dataExpiracao: expiracao,
      ),
      DesafioDiario(
        id: 5,
        titulo: 'Combo Perfeito',
        descricao: 'Acertar 5 questões consecutivas',
        icone: '🔥',
        recompensaMoedas: 50,
        recompensaPontos: 120,
        progressoAtual: 0,
        progressoNecessario: 5,
        tipo: 'combo',
        concluido: false,
        dataExpiracao: expiracao,
      ),
    ];
  }

  static void atualizarProgressoDesafios({
    required List<DesafioDiario> desafios,
    int acertos = 0,
    int niveisCompletos = 0,
    int pontosGanhos = 0,
    int respostasRapidas = 0,
    int comboAtual = 0,
  }) {
    for (var desafio in desafios) {
      if (!desafio.concluido && !desafio.expirado) {
        switch (desafio.tipo) {
          case 'acertos':
            desafio.progressoAtual += acertos;
            break;
          case 'nivel':
            desafio.progressoAtual += niveisCompletos;
            break;
          case 'pontuacao':
            desafio.progressoAtual += pontosGanhos;
            break;
          case 'tempo':
            desafio.progressoAtual += respostasRapidas;
            break;
          case 'combo':
            if (comboAtual > desafio.progressoAtual) {
              desafio.progressoAtual = comboAtual;
            }
            break;
        }
      }
    }
  }
}