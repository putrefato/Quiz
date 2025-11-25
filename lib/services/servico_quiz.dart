import '../models/pergunta.dart';

class ServicoQuiz {
  static List<Pergunta> obterPerguntasPorNivel(int nivel, {String? categoria}) {
    if (categoria != null) {
      return _obterPerguntasPorCategoria(categoria);
    }
    
    switch (nivel) {
      case 1:
        return _obterPerguntasNivel1();
      case 2:
        return _obterPerguntasNivel2();
      case 3:
        return _obterPerguntasNivel3();
      default:
        return _obterPerguntasNivel1();
    }
  }

  static List<Pergunta> _obterPerguntasPorCategoria(String categoria) {
    switch (categoria) {
      case 'Linguagens':
        return [
          Pergunta(
            id: 101,
            pergunta: "Qual linguagem é conhecida como 'a linguagem da web'?",
            opcoes: ["Python", "Java", "JavaScript", "C++"],
            respostaCorreta: 2,
            categoria: "Linguagens",
            dificuldade: "Fácil"
          ),
          Pergunta(
            id: 102,
            pergunta: "Qual linguagem usa 'print()' para exibir texto?",
            opcoes: ["Java", "Python", "C#", "PHP"],
            respostaCorreta: 1,
            categoria: "Linguagens",
            dificuldade: "Fácil"
          ),
          Pergunta(
            id: 103,
            pergunta: "Qual linguagem é compilada para bytecode e roda na JVM?",
            opcoes: ["Python", "JavaScript", "Java", "Ruby"],
            respostaCorreta: 2,
            categoria: "Linguagens",
            dificuldade: "Médio"
          ),
        ];
      
      case 'Hardware':
        return [
          Pergunta(
            id: 201,
            pergunta: "O que significa CPU?",
            opcoes: ["Computer Processing Unit", "Central Processing Unit", "Central Program Utility", "Computer Program Unit"],
            respostaCorreta: 1,
            categoria: "Hardware",
            dificuldade: "Fácil"
          ),
          Pergunta(
            id: 202,
            pergunta: "Qual componente armazena dados temporariamente?",
            opcoes: ["HD", "SSD", "RAM", "Processador"],
            respostaCorreta: 2,
            categoria: "Hardware",
            dificuldade: "Fácil"
          ),
        ];
      
      case 'História':
        return [
          Pergunta(
            id: 301,
            pergunta: "Qual foi o primeiro computador programável?",
            opcoes: ["ENIAC", "Harvard Mark I", "Analytical Engine", "UNIVAC"],
            respostaCorreta: 2,
            categoria: "História",
            dificuldade: "Médio"
          ),
        ];
      
      default:
        return _obterPerguntasNivel1();
    }
  }

  static List<Pergunta> _obterPerguntasNivel1() {
    return [
      Pergunta(
        id: 1,
        pergunta: "O que significa 'HTML'?",
        opcoes: [
          "Hyper Text Markup Language",
          "High Tech Modern Language", 
          "Hyper Transfer Markup Language",
          "Home Tool Markup Language"
        ],
        respostaCorreta: 0,
        categoria: "Web",
        dificuldade: "Fácil"
      ),
      Pergunta(
        id: 2,
        pergunta: "Qual empresa desenvolveu o Windows?",
        opcoes: ["Apple", "Google", "Microsoft", "IBM"],
        respostaCorreta: 2,
        categoria: "Sistemas Operacionais",
        dificuldade: "Fácil"
      ),
    ];
  }

  static List<Pergunta> _obterPerguntasNivel2() {
    return [
      Pergunta(
        id: 3,
        pergunta: "O que é um algoritmo?",
        opcoes: [
          "Um tipo de hardware",
          "Uma sequência de passos para resolver um problema", 
          "Uma linguagem de programação",
          "Um sistema operacional"
        ],
        respostaCorreta: 1,
        categoria: "Conceitos",
        dificuldade: "Fácil"
      ),
    ];
  }

  static List<Pergunta> _obterPerguntasNivel3() {
    return [
      Pergunta(
        id: 4,
        pergunta: "Qual protocolo é usado para emails?",
        opcoes: ["HTTP", "FTP", "SMTP", "TCP"],
        respostaCorreta: 2,
        categoria: "Internet",
        dificuldade: "Médio"
      ),
    ];
  }

  static int calcularPontuacao(bool acertou, String dificuldade, int tempoUsado) {
    if (!acertou) return 0;

    int pontosBase;
    switch (dificuldade) {
      case "Difícil":
        pontosBase = 100;
        break;
      case "Médio":
        pontosBase = 75;
        break;
      default:
        pontosBase = 50;
    }

    // Bônus por resposta rápida
    int bonusTempo = 0;
    if (tempoUsado <= 10) bonusTempo = 25;
    else if (tempoUsado <= 20) bonusTempo = 15;

    return pontosBase + bonusTempo;
  }
}