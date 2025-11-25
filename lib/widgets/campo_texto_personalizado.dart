import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CampoTextoPersonalizado extends StatelessWidget {
  final TextEditingController controller;
  final String rotulo;
  final bool obscuro;
  final IconData? icone;
  final TextInputType tipoTeclado;
  final String? Function(String?)? validador;

  const CampoTextoPersonalizado({
    Key? key,
    required this.controller,
    required this.rotulo,
    this.obscuro = false,
    this.icone,
    this.tipoTeclado = TextInputType.text,
    this.validador,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscuro,
      keyboardType: tipoTeclado,
      validator: validador,
      style: GoogleFonts.poppins(fontSize: 16, color: const Color(0xFF1D1D1D)),
      decoration: InputDecoration(
        labelText: rotulo,
        labelStyle: GoogleFonts.poppins(color: const Color(0xFF666666)),
        prefixIcon: icone != null ? Icon(icone, color: const Color(0xFF6A5AE0)) : null,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}