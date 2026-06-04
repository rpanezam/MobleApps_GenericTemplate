import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable UI theme defining the App Factory design system.
///
/// Implements premium dark and light modes, typography using Outfit and Inter,
/// and smooth custom gradients.
class AppTheme {
  AppTheme._();

  // Color Tokens - HSL tailored harmonious palette
  static const Color darkBackground = Color(0xFF0D0E12); // Sleek dark slate
  static const Color darkSurface = Color(0xFF161820);    // Card background
  static const Color primaryPurple = Color(0xFF8B5CF6);  // Royal Violet
  static const Color primaryCyan = Color(0xFF06B6D4);    // Cool Cyan
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFF9CA3AF);

  // Gradient definitions
  static const LinearGradient premiumGradient = LinearGradient(
    colors: [primaryPurple, primaryCyan],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Sleek dark mode theme configuration.
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: primaryPurple,
        secondary: primaryCyan,
        surface: darkSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      // Define typography using Google Fonts (Outfit for headers, Inter for body)
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: textPrimaryDark,
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: textPrimaryDark,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: textSecondaryDark,
        ),
      ),
      cardTheme: const CardTheme(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  /// Premium light mode theme configuration.
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF3F4F6),
      colorScheme: const ColorScheme.light(
        primary: primaryPurple,
        secondary: primaryCyan,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.outfit(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF111827),
        ),
        titleLarge: GoogleFonts.outfit(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF111827),
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF19232D),
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: const Color(0xFF4B5563),
        ),
      ),
      cardTheme: const CardTheme(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }
}
