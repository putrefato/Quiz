import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CartaoProgresso extends StatelessWidget {
  final int nivel;
  final int pontuacao;
  final int moedas;
  final int proximoNivel;

  const CartaoProgresso({
    Key? key,
    required this.nivel,
    required this.pontuacao,
    required this.moedas,
    required this.proximoNivel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double progresso = pontuacao / proximoNivel;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF6A5AE0),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            _buildInfoItem(Icons.star, 'Nível $nivel'),
            _buildInfoItem(Icons.emoji_events, '$pontuacao Pontos'),
            _buildInfoItem(Icons.monetization_on, '$moedas Moedas'),
          ]),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: progresso,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFD6E87)),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Progresso para o próximo nível', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12)),
            Text('${(progresso * 100).toStringAsFixed(0)}%', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(children: [
      Icon(icon, color: Colors.white, size: 16),
      const SizedBox(width: 4),
      Text(text, style: GoogleFonts.poppins(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
    ]);
  }
}