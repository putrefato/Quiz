import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/gerenciador_acessibilidade.dart';

class TelaAcessibilidade extends StatefulWidget {
  const TelaAcessibilidade({Key? key}) : super(key: key);

  @override
  _TelaAcessibilidadeState createState() => _TelaAcessibilidadeState();
}

class _TelaAcessibilidadeState extends State<TelaAcessibilidade> {
  final GerenciadorAcessibilidade _acessibilidade = GerenciadorAcessibilidade();
  late double _tamanhoFonte;
  late bool _altoContraste;
  late bool _leitorTela;
  late bool _animacoesReduzidas;
  late bool _feedbackHaptico;

  @override
  void initState() {
    super.initState();
    _tamanhoFonte = _acessibilidade.tamanhoFonte;
    _altoContraste = _acessibilidade.altoContraste;
    _leitorTela = _acessibilidade.leitorTela;
    _animacoesReduzidas = _acessibilidade.animacoesReduzidas;
    _feedbackHaptico = _acessibilidade.feedbackHaptico;
  }

  void _aplicarConfiguracoes() {
    _acessibilidade.setTamanhoFonte(_tamanhoFonte);
    _acessibilidade.setAltoContraste(_altoContraste);
    _acessibilidade.setLeitorTela(_leitorTela);
    _acessibilidade.setAnimacoesReduzidas(_animacoesReduzidas);
    _acessibilidade.setFeedbackHaptico(_feedbackHaptico);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Configurações de acessibilidade aplicadas!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  Widget _buildCardConfiguracao({
    required String titulo,
    required String descricao,
    required IconData icone,
    required Widget controle,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
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
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1D1D1D),
                  ),
                ),
                Text(
                  descricao,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          controle,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acessibilidade', style: GoogleFonts.poppins()),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF6A5AE0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.accessibility_new, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Configurações de Acessibilidade',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Torne o app mais acessível para suas necessidades',
                            style: GoogleFonts.poppins(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 24),

              // Configurações
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Tamanho da Fonte
                      _buildCardConfiguracao(
                        titulo: 'Tamanho da Fonte',
                        descricao: 'Ajuste o tamanho do texto',
                        icone: Icons.text_fields,
                        controle: Column(
                          children: [
                            Text(
                              '${(_tamanhoFonte * 100).toInt()}%',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Slider(
                              value: _tamanhoFonte,
                              onChanged: (valor) {
                                setState(() => _tamanhoFonte = valor);
                              },
                              min: 0.8,
                              max: 2.0,
                              divisions: 12,
                            ),
                          ],
                        ),
                      ),

                      // Alto Contraste
                      _buildCardConfiguracao(
                        titulo: 'Alto Contraste',
                        descricao: 'Melhor visibilidade para baixa visão',
                        icone: Icons.contrast,
                        controle: Switch(
                          value: _altoContraste,
                          onChanged: (valor) {
                            setState(() => _altoContraste = valor);
                          },
                          activeColor: Color(0xFF6A5AE0),
                        ),
                      ),

                      // Leitor de Tela
                      _buildCardConfiguracao(
                        titulo: 'Leitor de Tela',
                        descricao: 'Otimizado para leitores de tela',
                        icone: Icons.hearing,
                        controle: Switch(
                          value: _leitorTela,
                          onChanged: (valor) {
                            setState(() => _leitorTela = valor);
                          },
                          activeColor: Color(0xFF6A5AE0),
                        ),
                      ),

                      // Animações Reduzidas
                      _buildCardConfiguracao(
                        titulo: 'Animações Reduzidas',
                        descricao: 'Reduz movimentos e transições',
                        icone: Icons.animation,
                        controle: Switch(
                          value: _animacoesReduzidas,
                          onChanged: (valor) {
                            setState(() => _animacoesReduzidas = valor);
                          },
                          activeColor: Color(0xFF6A5AE0),
                        ),
                      ),

                      // Feedback Háptico
                      _buildCardConfiguracao(
                        titulo: 'Feedback Háptico',
                        descricao: 'Vibração ao tocar nos botões',
                        icone: Icons.vibration,
                        controle: Switch(
                          value: _feedbackHaptico,
                          onChanged: (valor) {
                            setState(() => _feedbackHaptico = valor);
                          },
                          activeColor: Color(0xFF6A5AE0),
                        ),
                      ),

                      SizedBox(height: 24),

                      // Preview
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
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
                              'Prévia do Texto',
                              style: GoogleFonts.poppins(
                                fontSize: 16 * _tamanhoFonte,
                                fontWeight: FontWeight.w600,
                                color: _altoContraste ? Colors.black : Color(0xFF1D1D1D),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Este é um exemplo de como o texto aparecerá com as configurações atuais.',
                              style: GoogleFonts.poppins(
                                fontSize: 14 * _tamanhoFonte,
                                color: _altoContraste ? Colors.black : Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),

              // Botão Aplicar
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _aplicarConfiguracoes,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6A5AE0),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Aplicar Configurações',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}