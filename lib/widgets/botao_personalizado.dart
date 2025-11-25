import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BotaoPersonalizado extends StatelessWidget {
  final String texto;
  final VoidCallback? aoPressionar;
  final bool carregando;
  final Color? corFundo;
  final Color? corTexto;
  final double? largura;

  const BotaoPersonalizado({
    Key? key,
    required this.texto,
    this.aoPressionar,
    this.carregando = false,
    this.corFundo,
    this.corTexto,
    this.largura,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: largura,
      child: ElevatedButton(
        onPressed: carregando ? null : aoPressionar,
        style: ElevatedButton.styleFrom(
          backgroundColor: corFundo ?? const Color(0xFF6A5AE0),
          foregroundColor: corTexto ?? Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: carregando
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
              )
            : Text(texto, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }
}