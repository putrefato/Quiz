import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ranking.dart';
import '../models/usuario.dart';
import '../services/servico_ranking.dart';

class TelaRanking extends StatefulWidget {
  final Usuario usuario;

  const TelaRanking({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaRankingState createState() => _TelaRankingState();
}

class _TelaRankingState extends State<TelaRanking> {
  final ServicoRanking _servicoRanking = ServicoRanking();
  List<PosicaoRanking> _rankingGlobal = [];
  List<PosicaoRanking> _rankingSemanal = [];
  PosicaoRanking? _minhaPosicao;
  int _abaSelecionada = 0;

  @override
  void initState() {
    super.initState();
    _carregarRanking();
  }

  Future<void> _carregarRanking() async {
    final global = await _servicoRanking.obterRankingGlobal();
    final semanal = await _servicoRanking.obterRankingSemanal();
    final minhaPosicao = await _servicoRanking.obterMinhaPosicao(widget.usuario.id!);

    setState(() {
      _rankingGlobal = global;
      _rankingSemanal = semanal;
      _minhaPosicao = minhaPosicao;
    });
  }

  Widget _buildCardPosicao(PosicaoRanking posicao, {bool isMinhaPosicao = false}) {
    Color corFundo = Colors.white;
    if (posicao.posicao == 1) {
      corFundo = Colors.amber.withOpacity(0.1);
    } else if (posicao.posicao == 2) {
      corFundo = Colors.grey.withOpacity(0.1);
    } else if (posicao.posicao == 3) {
      corFundo = Colors.orange.withOpacity(0.1);
    }

    if (isMinhaPosicao) {
      corFundo = Color(0xFF6A5AE0).withOpacity(0.1);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: corFundo,
        borderRadius: BorderRadius.circular(12),
        border: isMinhaPosicao ? Border.all(color: Color(0xFF6A5AE0), width: 2) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getCorPosicao(posicao.posicao),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${posicao.posicao}',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          Text(
            posicao.avatar ?? '😊',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  posicao.nomeUsuario,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
                Text(
                  'Nível ${posicao.nivel} • ${posicao.pontuacao} pts',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          if (posicao.posicao <= 3)
            Icon(
              _getIconePosicao(posicao.posicao),
              color: _getCorPosicao(posicao.posicao),
              size: 24,
            ),
        ],
      ),
    );
  }

  Color _getCorPosicao(int posicao) {
    switch (posicao) {
      case 1: return Colors.amber;
      case 2: return Colors.grey;
      case 3: return Colors.orange;
      default: return Color(0xFF6A5AE0);
    }
  }

  IconData _getIconePosicao(int posicao) {
    switch (posicao) {
      case 1: return Icons.emoji_events;
      case 2: return Icons.workspace_premium;
      case 3: return Icons.military_tech;
      default: return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ranking', style: GoogleFonts.poppins()),
        backgroundColor: Color(0xFF6A5AE0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7F7F7), Color(0xFFE8E8E8)],
          ),
        ),
        child: Column(
          children: [
            // Abas
            Container(
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() => _abaSelecionada = 0),
                      style: TextButton.styleFrom(
                        backgroundColor: _abaSelecionada == 0 ? Color(0xFF6A5AE0) : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Global',
                        style: GoogleFonts.poppins(
                          color: _abaSelecionada == 0 ? Colors.white : Color(0xFF6A5AE0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () => setState(() => _abaSelecionada = 1),
                      style: TextButton.styleFrom(
                        backgroundColor: _abaSelecionada == 1 ? Color(0xFF6A5AE0) : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Semanal',
                        style: GoogleFonts.poppins(
                          color: _abaSelecionada == 1 ? Colors.white : Color(0xFF6A5AE0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Minha Posição
            if (_minhaPosicao != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: _buildCardPosicao(_minhaPosicao!, isMinhaPosicao: true),
              ),

            SizedBox(height: 16),

            // Lista de Ranking
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
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
                child: _abaSelecionada == 0
                    ? ListView.builder(
                        itemCount: _rankingGlobal.length,
                        itemBuilder: (context, index) {
                          return _buildCardPosicao(_rankingGlobal[index]);
                        },
                      )
                    : ListView.builder(
                        itemCount: _rankingSemanal.length,
                        itemBuilder: (context, index) {
                          return _buildCardPosicao(_rankingSemanal[index]);
                        },
                      ),
              ),
            ),

            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}