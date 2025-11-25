import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/usuario.dart';
import 'tela_quiz.dart';

class TelaSelecaoNivel extends StatefulWidget {
  final Usuario usuario;

  const TelaSelecaoNivel({Key? key, required this.usuario}) : super(key: key);

  @override
  _TelaSelecaoNivelState createState() => _TelaSelecaoNivelState();
}

class _TelaSelecaoNivelState extends State<TelaSelecaoNivel> {
  int _nivelDesbloqueado = 1;

  @override
  void initState() {
    super.initState();
    _carregarProgresso();
  }

  void _carregarProgresso() async {
    // Simulação - na prática você buscaria do banco
    setState(() {
      _nivelDesbloqueado = 3;
    });
  }

  void _iniciarNivel(int nivel) {
    if (nivel <= _nivelDesbloqueado) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TelaQuiz(usuario: widget.usuario, nivelInicial: nivel),
        ),
      );
    }
  }

  Widget _buildCardNivel(int nivel, String titulo, String descricao, bool desbloqueado) {
    return GestureDetector(
      onTap: desbloqueado ? () => _iniciarNivel(nivel) : null,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: desbloqueado ? Colors.white : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          boxShadow: desbloqueado
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ]
              : null,
          border: Border.all(
            color: desbloqueado ? Color(0xFF6A5AE0) : Colors.grey,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: desbloqueado ? Color(0xFF6A5AE0) : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$nivel',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: desbloqueado ? Color(0xFF1D1D1D) : Colors.grey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    descricao,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: desbloqueado ? Color(0xFF666666) : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              desbloqueado ? Icons.lock_open : Icons.lock,
              color: desbloqueado ? Colors.green : Colors.grey,
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
        title: Text('Seleção de Nível', style: GoogleFonts.poppins()),
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
                'Escolha um Nível',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1D1D1D),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Níveis desbloqueados: $_nivelDesbloqueado/10',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF666666),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _buildCardNivel(1, 'Iniciante', 'Perguntas básicas sobre computação', _nivelDesbloqueado >= 1),
                    _buildCardNivel(2, 'Fundamentos', 'Conceitos essenciais de TI', _nivelDesbloqueado >= 2),
                    _buildCardNivel(3, 'Intermediário', 'História e linguagens de programação', _nivelDesbloqueado >= 3),
                    _buildCardNivel(4, 'Avançado I', 'Sistemas operacionais e hardware', _nivelDesbloqueado >= 4),
                    _buildCardNivel(5, 'Avançado II', 'Redes e internet', _nivelDesbloqueado >= 5),
                    _buildCardNivel(6, 'Especialista I', 'Questões técnicas complexas', _nivelDesbloqueado >= 6),
                    _buildCardNivel(7, 'Especialista II', 'Arquitetura de computadores', _nivelDesbloqueado >= 7),
                    _buildCardNivel(8, 'Mestre I', 'Perguntas desafiadoras', _nivelDesbloqueado >= 8),
                    _buildCardNivel(9, 'Mestre II', 'Tópicos avançados de computação', _nivelDesbloqueado >= 9),
                    _buildCardNivel(10, 'Lenda da Computação', 'O nível mais difícil!', _nivelDesbloqueado >= 10),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF6A5AE0).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Color(0xFF6A5AE0)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Complete um nível para desbloquear o próximo!',
                        style: GoogleFonts.poppins(
                          color: Color(0xFF6A5AE0),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}