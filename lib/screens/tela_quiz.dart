import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/usuario.dart';
import '../models/progresso_jogo.dart';
import '../models/pergunta.dart';
import '../services/servico_jogo.dart';
import '../services/servico_quiz.dart';
import '../widgets/botao_personalizado.dart';
import '../widgets/cartao_progresso.dart';
import '../models/modo_jogo.dart'; 

class TelaQuiz extends StatefulWidget {
  final Usuario usuario;
  final int nivelInicial;
  // final ConfiguracaoModoJogo? configuracaoModo; 

  const TelaQuiz({Key? key, required this.usuario, this.nivelInicial = 1,
  //this.configuracaoModo,
  }) : super(key: key);

  @override
  _TelaQuizState createState() => _TelaQuizState();
}

class _TelaQuizState extends State<TelaQuiz> {
  final ServicoJogo _servicoJogo = ServicoJogo();
  ProgressoJogo? _progresso;
  int _nivelAtual = 1;
  int _pontuacaoAtual = 0;
  int _moedasAtuais = 0;
  bool _salvando = false;

  List<Pergunta> _perguntasAtuais = [];
  int _perguntaIndex = 0;
  int? _respostaSelecionada;
  bool _mostrarResultado = false;
  int _tempoRestante = 30;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _carregarProgresso();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _carregarProgresso() async {
    final progresso = await _servicoJogo.obterProgresso(widget.usuario.id!);
    setState(() {
      _progresso = progresso;
      _nivelAtual = widget.nivelInicial;
      _pontuacaoAtual = progresso?.pontuacao ?? 0;
      _moedasAtuais = progresso?.moedas ?? 100;
    });
    _iniciarQuiz();
  }

  void _iniciarQuiz() {
    setState(() {
      _perguntasAtuais = ServicoQuiz.obterPerguntasPorNivel(_nivelAtual);
      _perguntaIndex = 0;
      _respostaSelecionada = null;
      _mostrarResultado = false;
      _tempoRestante = 30;
    });
    _iniciarTimer();
  }

  void _iniciarTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_tempoRestante > 0) {
        setState(() {
          _tempoRestante--;
        });
      } else {
        _timer.cancel();
        if (!_mostrarResultado) {
          _verificarResposta();
        }
      }
    });
  }

  Future<void> _salvarProgresso() async {
    setState(() => _salvando = true);

    final progresso = ProgressoJogo(
      id: _progresso?.id,
      usuarioId: widget.usuario.id!,
      nivel: _nivelAtual,
      pontuacao: _pontuacaoAtual,
      moedas: _moedasAtuais,
      ultimoSalvamento: DateTime.now(),
    );

    await _servicoJogo.salvarProgressoComConquistas(progresso);
    setState(() {
      _progresso = progresso;
      _salvando = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progresso salvo com sucesso!'), backgroundColor: Colors.green),
    );
  }

  void _verificarResposta() {
    _timer.cancel();
    setState(() {
      _mostrarResultado = true;
    });

    final bool acertou = _respostaSelecionada == _perguntasAtuais[_perguntaIndex].respostaCorreta;
    final int tempoUsado = 30 - _tempoRestante;
    final int pontosGanhos = ServicoQuiz.calcularPontuacao(
      acertou,
      _perguntasAtuais[_perguntaIndex].dificuldade,
      tempoUsado
    );

    setState(() {
      _pontuacaoAtual += pontosGanhos;
      _moedasAtuais += acertou ? 10 : 5;
    });

    Future.delayed(Duration(seconds: 2), () {
      _proximaPergunta();
    });
  }

  void _proximaPergunta() {
    if (_perguntaIndex < _perguntasAtuais.length - 1) {
      setState(() {
        _perguntaIndex++;
        _respostaSelecionada = null;
        _mostrarResultado = false;
        _tempoRestante = 30;
      });
      _iniciarTimer();
    } else {
      _completarNivel();
    }
  }

  void _completarNivel() {
    final nivelAntigo = _nivelAtual;

    setState(() {
      _nivelAtual++;
      _moedasAtuais += 50;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Parabéns! Nível $nivelAntigo completado! Nível $_nivelAtual desbloqueado! +50 moedas!'),
        backgroundColor: Colors.green,
      ),
    );

    _salvarProgresso();
    _mostrarDialogoContinuar();
  }

  void _mostrarDialogoContinuar() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nível Concluído!', style: GoogleFonts.poppins()),
        content: Text('Deseja continuar para o próximo nível ou voltar para a seleção?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _iniciarQuiz();
            },
            child: Text('Continuar', style: GoogleFonts.poppins(color: Color(0xFF6A5AE0))),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Seleção', style: GoogleFonts.poppins(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildTimer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _tempoRestante <= 10 ? Colors.red : Color(0xFF6A5AE0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            '$_tempoRestante seg',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPergunta() {
    if (_perguntasAtuais.isEmpty) return CircularProgressIndicator();

    final pergunta = _perguntasAtuais[_perguntaIndex];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF6A5AE0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Nível $_nivelAtual • ${pergunta.dificuldade}',
                style: GoogleFonts.poppins(
                  color: Color(0xFF6A5AE0),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            _buildTimer(),
          ],
        ),

        SizedBox(height: 20),

        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Text(
            pergunta.pergunta,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1D),
            ),
          ),
        ),

        SizedBox(height: 20),

        Expanded(
          child: ListView.builder(
            itemCount: pergunta.opcoes.length,
            itemBuilder: (context, index) {
              return _buildOpcaoResposta(index, pergunta.opcoes[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOpcaoResposta(int index, String texto) {
    final bool isSelecionada = _respostaSelecionada == index;
    final bool isCorreta = index == _perguntasAtuais[_perguntaIndex].respostaCorreta;
    final bool mostrarCorreta = _mostrarResultado && isCorreta;
    final bool mostrarErrada = _mostrarResultado && isSelecionada && !isCorreta;

    Color backgroundColor = Colors.white;
    Color borderColor = Colors.grey[300]!;

    if (mostrarCorreta) {
      backgroundColor = Colors.green.withOpacity(0.1);
      borderColor = Colors.green;
    } else if (mostrarErrada) {
      backgroundColor = Colors.red.withOpacity(0.1);
      borderColor = Colors.red;
    } else if (isSelecionada) {
      backgroundColor = Color(0xFF6A5AE0).withOpacity(0.1);
      borderColor = Color(0xFF6A5AE0);
    }

    return GestureDetector(
      onTap: _mostrarResultado ? null : () {
        setState(() {
          _respostaSelecionada = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor),
                color: mostrarCorreta ? Colors.green :
                       mostrarErrada ? Colors.red : Colors.transparent,
              ),
              child: mostrarCorreta || mostrarErrada
                  ? Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF1D1D1D),
                  fontWeight: isSelecionada ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz de Computação', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF6A5AE0),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _salvarProgresso,
            tooltip: 'Salvar Progresso'
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F7F7), Color(0xFFE8E8E8)]
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CartaoProgresso(
                nivel: _nivelAtual,
                pontuacao: _pontuacaoAtual,
                moedas: _moedasAtuais,
                proximoNivel: _nivelAtual * 100
              ),

              const SizedBox(height: 20),

              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
                  ),
                  child: _perguntasAtuais.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : _buildPergunta(),
                ),
              ),

              const SizedBox(height: 20),

              if (!_mostrarResultado && _respostaSelecionada != null)
                BotaoPersonalizado(
                  texto: 'Confirmar Resposta',
                  aoPressionar: _verificarResposta,
                  largura: double.infinity,
                ),

              if (_perguntasAtuais.isNotEmpty)
                Text(
                  'Pergunta ${_perguntaIndex + 1}/${_perguntasAtuais.length}',
                  style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF666666)),
                ),

              const SizedBox(height: 10),

              if (_salvando)
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}