import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/estatisticas.dart';
import '../models/usuario.dart';
import '../services/servico_estatisticas.dart';

class TelaEstatisticas extends StatefulWidget {
  final Usuario usuario;

  const TelaEstatisticas({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaEstatisticasState createState() => _TelaEstatisticasState();
}

class _TelaEstatisticasState extends State<TelaEstatisticas> {
  final ServicoEstatisticas _servicoEstatisticas = ServicoEstatisticas();
  EstatisticasUsuario? _estatisticas;
  List<Map<String, dynamic>> _historico = [];

  @override
  void initState() {
    super.initState();
    _carregarEstatisticas();
  }

  Future<void> _carregarEstatisticas() async {
    final estatisticas = await _servicoEstatisticas.obterEstatisticas(widget.usuario.id!);
    final historico = await _servicoEstatisticas.obterHistoricoJogos(widget.usuario.id!);

    setState(() {
      _estatisticas = estatisticas;
      _historico = historico;
    });
  }

  Widget _buildCardEstatistica(String titulo, String valor, String subtitulo, IconData icone) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFF6A5AE0).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icone, color: Color(0xFF6A5AE0), size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  valor,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
                Text(
                  titulo,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Color(0xFF666666),
                  ),
                ),
                if (subtitulo.isNotEmpty)
                  Text(
                    subtitulo,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(0xFF6A5AE0),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGraficoCategorias() {
    if (_estatisticas == null) return Container();

    final taxas = _estatisticas!.taxaAcertoPorCategoria;
    final categorias = taxas.keys.toList();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Desempenho por Categoria',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1D),
            ),
          ),
          SizedBox(height: 16),
          ...categorias.map((categoria) {
            final taxa = taxas[categoria]!;
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          categoria,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: LinearProgressIndicator(
                          value: taxa / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            _getCorTaxaAcerto(taxa),
                          ),
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        '${taxa.toStringAsFixed(1)}%',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _getCorTaxaAcerto(taxa),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Color _getCorTaxaAcerto(double taxa) {
    if (taxa >= 80) return Colors.green;
    if (taxa >= 60) return Colors.orange;
    return Colors.red;
  }

  Widget _buildHistoricoJogos() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Histórico Recente',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1D1D1D),
            ),
          ),
          SizedBox(height: 12),
          ..._historico.map((jogo) {
            return Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_events, color: Color(0xFF6A5AE0), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${jogo['pontuacao']} pontos',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'Nível ${jogo['nivel']} • ${jogo['acertos']}/${jogo['acertos'] + jogo['erros']} acertos',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _formatarData(jogo['data']),
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  String _formatarData(DateTime data) {
    final agora = DateTime.now();
    final diferenca = agora.difference(data);

    if (diferenca.inDays == 0) return 'Hoje';
    if (diferenca.inDays == 1) return 'Ontem';
    if (diferenca.inDays < 7) return '${diferenca.inDays} dias atrás';

    return '${data.day}/${data.month}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    if (_estatisticas == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Estatísticas', style: GoogleFonts.poppins()),
          backgroundColor: Color(0xFF6A5AE0),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Estatísticas', style: GoogleFonts.poppins()),
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
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Cards de Estatísticas Principais
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildCardEstatistica(
                    'Pontuação Total',
                    '${_estatisticas!.pontuacaoTotal}',
                    '',
                    Icons.emoji_events,
                  ),
                  _buildCardEstatistica(
                    'Taxa de Acerto',
                    '${_estatisticas!.taxaAcerto.toStringAsFixed(1)}%',
                    '',
                    Icons.trending_up,
                  ),
                  _buildCardEstatistica(
                    'Total de Jogos',
                    '${_estatisticas!.totalJogos}',
                    '',
                    Icons.play_arrow,
                  ),
                  _buildCardEstatistica(
                    'Nível Máximo',
                    '${_estatisticas!.nivelMaximo}',
                    '',
                    Icons.star,
                  ),
                  _buildCardEstatistica(
                    'Melhor Streak',
                    '${_estatisticas!.melhorStreak}',
                    'acertos consecutivos',
                    Icons.local_fire_department,
                  ),
                  _buildCardEstatistica(
                    'Tempo Total',
                    '${_estatisticas!.tempoTotalJogadoDuration.inHours}h',
                    'de jogo',
                    Icons.timer,
                  ),
                ],
              ),

              SizedBox(height: 20),

              // Gráfico de Categorias
              _buildGraficoCategorias(),

              SizedBox(height: 20),

              // Histórico de Jogos
              _buildHistoricoJogos(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}