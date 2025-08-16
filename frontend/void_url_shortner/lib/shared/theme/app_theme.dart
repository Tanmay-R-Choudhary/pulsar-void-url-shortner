import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color voidBlack = Color(0xFF0A0A0B);
  static const Color deepSpace = Color(0xFF1A1A2E);
  static const Color pulsarBlue = Color(0xFF16213E);
  static const Color cosmicPurple = Color(0xFF533483);
  static const Color stellarCyan = Color(0xFF0F3460);
  static const Color neutronWhite = Color(0xFFE94560);
  static const Color plasmaGreen = Color(0xFF00D9FF);
  static const Color magneticField = Color(0xFF9D4EDD);

  static const Color starlight = Color(0xFFFFFFFF);
  static const Color dimStar = Color(0xFFB8B8B8);
  static const Color errorRed = Color(0xFFFF6B6B);
  static const Color successGreen = Color(0xFF4ECDC4);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: voidBlack,

      colorScheme: const ColorScheme.dark(
        primary: plasmaGreen,
        secondary: magneticField,
        surface: deepSpace,
        error: errorRed,
        onPrimary: voidBlack,
        onSecondary: starlight,
        onSurface: starlight,
        onError: starlight,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: deepSpace,
        foregroundColor: starlight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.questrial(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: starlight,
        ),
      ),

      cardTheme: CardTheme(
        color: deepSpace,
        elevation: 8,
        shadowColor: plasmaGreen.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: plasmaGreen.withValues(alpha: 0.2), width: 1),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: plasmaGreen,
          foregroundColor: voidBlack,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          textStyle: GoogleFonts.questrial(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.questrial(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: deepSpace,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: plasmaGreen.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: plasmaGreen.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: plasmaGreen, width: 2),
        ),
        labelStyle: GoogleFonts.inter(color: dimStar, fontSize: 14),
        hintStyle: GoogleFonts.inter(
          color: dimStar.withValues(alpha: 0.6),
          fontSize: 14,
        ),
      ),

      textTheme: TextTheme(
        displayLarge: GoogleFonts.questrial(
          color: starlight,
          fontSize: 32,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: GoogleFonts.questrial(
          color: starlight,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: GoogleFonts.questrial(
          color: starlight,
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: GoogleFonts.questrial(
          color: starlight,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: GoogleFonts.questrial(
          color: starlight,
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: GoogleFonts.inter(color: starlight, fontSize: 16),
        bodyMedium: GoogleFonts.inter(color: dimStar, fontSize: 14),
        bodySmall: GoogleFonts.inter(color: dimStar, fontSize: 12),
        labelLarge: GoogleFonts.questrial(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
