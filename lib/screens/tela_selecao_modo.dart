import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/modo_jogo.dart';
import '../models/usuario.dart';
import 'tela_quiz.dart';

class TelaSelecaoModo extends StatefulWidget {
  final Usuario usuario;

  const TelaSelecaoModo({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaSelecaoModoState createState() => _TelaSelecaoModoState();
}

class _TelaSelecaoModoState extends State<TelaSelecaoModo> {
  ModoJogo? _modoSelecionado;
  String? _categoriaSelecionada;
  final List<String> _categorias = [
    'História', 'Hardware', 'Linguagens', 'Sistemas Operacionais',
    'Internet', 'Conceitos', 'Web', 'Redes', 'Banco de Dados', 'IA'
  ];

  void _iniciarJogo() {
    if (_modoSelecionado == null) return;

    //final configuracao = ConfiguracaoModoJogo(
    //  modo: _modoSelecionado!,
    //  categoria: _modoSelecionado == ModoJogo.CATEGORIA ? _categoriaSelecionada : null,
    //);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaQuiz(
          usuario: widget.usuario,
          //configuracaoModo: configuracao,
        ),
      ),
    );
  }

  Widget _buildCardModo(ModoJogo modo) {
    final isSelecionado = _modoSelecionado == modo;

    return GestureDetector(
      onTap: () => setState(() => _modoSelecionado = modo),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelecionado ? modo.color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelecionado ? modo.color : Colors.grey[300]!,
            width: isSelecionado ? 2 : 1,
          ),
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
                color: modo.color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  modo.icone,
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    modo.nome,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D1D1D),
                    ),
                  ),
                  Text(
                    modo.descricao,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.timer,
                        '${modo.tempoPorPergunta}s',
                      ),
                      SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.favorite,
                        '${modo.vidas} ${modo.vidas == 1 ? 'vida' : 'vidas'}',
                      ),
                      SizedBox(width: 8),
                      _buildInfoChip(
                        Icons.lightbulb,
                        modo.permiteDicas ? 'Com dicas' : 'Sem dicas',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              isSelecionado ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isSelecionado ? modo.color : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icone, String texto) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, size: 12, color: Colors.grey),
          SizedBox(width: 4),
          Text(
            texto,
            style: GoogleFonts.poppins(
              fontSize: 10,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelecaoCategoria() {
    if (_modoSelecionado != ModoJogo.CATEGORIA) return SizedBox();

    return Container(
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
            'Selecione uma Categoria',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _categorias.map((categoria) {
              final isSelecionada = _categoriaSelecionada == categoria;
              return ChoiceChip(
                label: Text(categoria),
                selected: isSelecionada,
                onSelected: (selected) {
                  setState(() {
                    _categoriaSelecionada = selected ? categoria : null;
                  });
                },
                selectedColor: ModoJogo.CATEGORIA.color,
                labelStyle: GoogleFonts.poppins(
                  color: isSelecionada ? Colors.white : Color(0xFF666666),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modos de Jogo', style: GoogleFonts.poppins()),
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
              Text(
                'Escolha um Modo de Jogo',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1D1D),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Diversas formas de testar seus conhecimentos!',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 20),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ...ModoJogo.values.map((modo) => _buildCardModo(modo)).toList(),
                      SizedBox(height: 16),
                      _buildSelecaoCategoria(),
                    ],
                  ),
                ),
              ),

              // Botão Iniciar
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _modoSelecionado != null &&
                            (_modoSelecionado != ModoJogo.CATEGORIA || _categoriaSelecionada != null)
                      ? _iniciarJogo
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _modoSelecionado?.color ?? Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Iniciar Jogo',
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