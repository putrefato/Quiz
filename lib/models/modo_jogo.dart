import 'package:flutter/material.dart';

enum ModoJogo {
  CLASSICO(
    nome: 'Clássico',
    descricao: 'Modo tradicional com tempo limitado',
    icone: '🎮',
    cor: 0xFF6A5AE0,
    tempoPorPergunta: 30,
    vidas: 1,
    permiteDicas: true,
  ),

  SOBREVIVENCIA(
    nome: 'Sobrevivência',
    descricao: 'Uma vida apenas, perdeu acabou!',
    icone: '❤️',
    cor: 0xFFFD6E87,
    tempoPorPergunta: 25,
    vidas: 1,
    permiteDicas: false,
  ),

  CONTRA_RELOGIO(
    nome: 'Contra o Relógio',
    descricao: 'Máximo de pontos em 2 minutos',
    icone: '⏱️',
    cor: 0xFFFF9800,
    tempoPorPergunta: 0, // Tempo total, não por pergunta
    vidas: 999,
    permiteDicas: true,
  ),

  MARATONA(
    nome: 'Maratona',
    descricao: '50 perguntas sem pausa',
    icone: '🏃',
    cor: 0xFF4CAF50,
    tempoPorPergunta: 20,
    vidas: 1,
    permiteDicas: true,
  ),

  CATEGORIA(
    nome: 'Categoria Única',
    descricao: 'Foque em uma categoria específica',
    icone: '🎯',
    cor: 0xFF2196F3,
    tempoPorPergunta: 30,
    vidas: 1,
    permiteDicas: true,
  );

  final String nome;
  final String descricao;
  final String icone;
  final int cor;
  final int tempoPorPergunta;
  final int vidas;
  final bool permiteDicas;

  const ModoJogo({
    required this.nome,
    required this.descricao,
    required this.icone,
    required this.cor,
    required this.tempoPorPergunta,
    required this.vidas,
    required this.permiteDicas,
  });

  Color get color => Color(cor);
}

class ConfiguracaoModoJogo {
  final ModoJogo modo;
  final String? categoria;
  final int nivelDificuldade;

  ConfiguracaoModoJogo({
    required this.modo,
    this.categoria,
    this.nivelDificuldade = 1,
  });
}