import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/usuario.dart';
import '../models/progresso_jogo.dart';
import '../models/pergunta.dart';
import '../models/modo_jogo.dart';
import '../services/servico_jogo.dart';
import '../services/servico_quiz.dart';
import '../services/gerenciador_audio.dart';
import '../widgets/botao_personalizado.dart';
import '../widgets/cartao_progresso.dart';

class TelaQuiz extends StatefulWidget {
  final Usuario usuario;
  final int nivelInicial;
  final ConfiguracaoModoJogo? configuracaoModo;

  const TelaQuiz({
    Key? key, 
    required this.usuario, 
    this.nivelInicial = 1,
    this.configuracaoModo,
  }) : super(key: key);

  @override
  _TelaQuizState createState() => _TelaQuizState();
}

class _TelaQuizState extends State<TelaQuiz> {
  final ServicoJogo _servicoJogo = ServicoJogo();
  final GerenciadorAudio _audio = GerenciadorAudio();
  ProgressoJogo? _progresso;
  int _nivelAtual = 1;
  int _pontuacaoAtual = 0;
  int _moedasAtuais = 0;
  bool _salvando = false;

  // Sistema de vidas e tempo
  int _vidasAtuais = 1;
  int _comboAtual = 0;
  int _tempoRestante = 30;
  int _tempoTotalRestante = 120;
  bool _isModoContraRelogio = false;
  late Timer _timerPergunta;
  late Timer _timerTotal;

  List<Pergunta> _perguntasAtuais = [];
  int _perguntaIndex = 0;
  int? _respostaSelecionada;
  bool _mostrarResultado = false;

  @override
  void initState() {
    super.initState();
    _carregarProgresso();
  }

  @override
  void dispose() {
    _timerPergunta.cancel();
    if (_isModoContraRelogio) _timerTotal.cancel();
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
    _inicializarModoJogo();
    _iniciarQuiz();
  }

  void _inicializarModoJogo() {
    if (widget.configuracaoModo != null) {
      final modo = widget.configuracaoModo!.modo;
      _vidasAtuais = modo.vidas;
      _isModoContraRelogio = modo == ModoJogo.CONTRA_RELOGIO;
      
      // Iniciar timer total para contra-relógio
      if (_isModoContraRelogio) {
        _timerTotal = Timer.periodic(Duration(seconds: 1), (timer) {
          if (_tempoTotalRestante > 0) {
            setState(() => _tempoTotalRestante--);
          } else {
            timer.cancel();
            _tempoEsgotado();
          }
        });
      }
    }
  }

  void _iniciarQuiz() {
    final categoria = widget.configuracaoModo?.categoria;
    
    setState(() {
      _perguntasAtuais = ServicoQuiz.obterPerguntasPorNivel(_nivelAtual, categoria: categoria);
      _perguntaIndex = 0;
      _respostaSelecionada = null;
      _mostrarResultado = false;
      _tempoRestante = _obterTempoPorPergunta();
      _comboAtual = 0;
    });
    _iniciarTimerPergunta();
  }

  int _obterTempoPorPergunta() {
    if (widget.configuracaoModo != null) {
      return widget.configuracaoModo!.modo.tempoPorPergunta;
    }
    return 30;
  }

  void _iniciarTimerPergunta() {
    _timerPergunta = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_tempoRestante > 0) {
        setState(() => _tempoRestante--);
      } else {
        timer.cancel();
        if (!_mostrarResultado) {
          _verificarResposta();
        }
      }
    });
  }

  void _verificarResposta() {
    _timerPergunta.cancel();
    setState(() => _mostrarResultado = true);

    final pergunta = _perguntasAtuais[_perguntaIndex];
    final bool acertou = _respostaSelecionada == pergunta.respostaCorreta;
    final int tempoUsado = _obterTempoPorPergunta() - _tempoRestante;
    final int pontosGanhos = ServicoQuiz.calcularPontuacao(acertou, pergunta.dificuldade, tempoUsado);

    // Sistema de vidas
    if (!acertou) {
      _vidasAtuais--;
      _comboAtual = 0;
      _audio.playEfeitoErro();
    } else {
      _comboAtual++;
      _audio.playEfeitoAcerto();
    }

    setState(() {
      _pontuacaoAtual += pontosGanhos;
      _moedasAtuais += acertou ? 10 : 5;
    });

    Future.delayed(Duration(seconds: 2), () {
      if (_vidasAtuais <= 0) {
        _gameOver();
      } else {
        _proximaPergunta();
      }
    });
  }

  void _proximaPergunta() {
    if (_perguntaIndex < _perguntasAtuais.length - 1) {
      setState(() {
        _perguntaIndex++;
        _respostaSelecionada = null;
        _mostrarResultado = false;
        _tempoRestante = _obterTempoPorPergunta();
      });
      _iniciarTimerPergunta();
    } else {
      _completarNivel();
    }
  }

  void _completarNivel() {
    final nivelAntigo = _nivelAtual;
    _audio.playEfeitoNivelUp();

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

  void _gameOver() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fim de Jogo!', style: GoogleFonts.poppins()),
        content: Text('Suas vidas acabaram!\nPontuação final: $_pontuacaoAtual', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Voltar ao Menu', style: GoogleFonts.poppins(color: Color(0xFF6A5AE0))),
          ),
        ],
      ),
    );
  }

  void _tempoEsgotado() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Tempo Esgotado!', style: GoogleFonts.poppins()),
        content: Text('O tempo acabou!\nPontuação final: $_pontuacaoAtual', style: GoogleFonts.poppins()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Voltar ao Menu', style: GoogleFonts.poppins(color: Color(0xFF6A5AE0))),
          ),
        ],
      ),
    );
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
    if (_isModoContraRelogio) {
      final minutos = _tempoTotalRestante ~/ 60;
      final segundos = _tempoTotalRestante % 60;
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _tempoTotalRestante <= 30 ? Colors.red : Color(0xFFFF9800),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.timer, color: Colors.white, size: 16),
            SizedBox(width: 4),
            Text(
              '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    } else {
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
  }

  Widget _buildVidas() {
    if (widget.configuracaoModo?.modo.vidas == 999) return SizedBox();
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.favorite, color: Colors.red, size: 20),
        SizedBox(width: 4),
        Text(
          '$_vidasAtuais',
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ],
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
            Row(
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
                SizedBox(width: 8),
                _buildVidas(),
              ],
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
        _audio.playEfeitoClick();
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