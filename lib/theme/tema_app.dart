import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TemaApp {
  static ThemeData get temaClaro {
    return ThemeData(
      primaryColor: const Color(0xFF6A5AE0),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6A5AE0),
        secondary: Color(0xFFFD6E87),
        surface: Colors.white,
        background: Color(0xFFF7F7F7),
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F7F7),

      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF6A5AE0),
        elevation: 0,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      textTheme: TextTheme(
        headlineLarge: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: const Color(0xFF1D1D1D)),
        headlineMedium: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: const Color(0xFF1D1D1D)),
        bodyLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: const Color(0xFF1D1D1D)),
        bodyMedium: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: const Color(0xFF666666)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6A5AE0),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),

      cardTheme: const CardThemeData(
        color: Colors.white,
        elevation: 2,
        margin: EdgeInsets.all(8),
      ),
    );
  }
}
