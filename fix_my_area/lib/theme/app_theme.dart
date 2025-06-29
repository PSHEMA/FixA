import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Venezia FC Theme
  static const Color primaryColor = Color(0xFF1B5E20); // Venezia Dark Green
  static const Color accentColor = Color(0xFFFFFFFF); // White
  static const Color backgroundColor = Color(0xFFF1F8E9); // Very light green tint
  static const Color textColor = Color(0xFF1B1B1B); // Almost black for text
  static const Color secondaryGold = Color(0xFFFF8F00); // Venezia Gold/Orange
  static const Color darkGreen = Color(0xFF2E7D32); // Lighter green for variety

  // Method to get the application's theme data
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        primary: primaryColor,
        onPrimary: accentColor, // Text on primary color
        secondary: secondaryGold,
        surface: backgroundColor,
        onSurface: textColor,
      ),

      // Scaffold Background Color
      scaffoldBackgroundColor: backgroundColor,

      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: accentColor, // Color for title, icons
        elevation: 4.0,
        titleTextStyle: GoogleFonts.lato(
          color: accentColor,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.lato(fontSize: 57, fontWeight: FontWeight.bold, color: textColor),
        displayMedium: GoogleFonts.lato(fontSize: 45, fontWeight: FontWeight.bold, color: textColor),
        displaySmall: GoogleFonts.lato(fontSize: 36, fontWeight: FontWeight.bold, color: textColor),
        headlineLarge: GoogleFonts.lato(fontSize: 32, fontWeight: FontWeight.w600, color: textColor),
        headlineMedium: GoogleFonts.lato(fontSize: 28, fontWeight: FontWeight.w600, color: textColor),
        headlineSmall: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.w600, color: textColor),
        titleLarge: GoogleFonts.lato(fontSize: 22, fontWeight: FontWeight.w600, color: textColor),
        bodyLarge: GoogleFonts.lato(fontSize: 16, color: textColor),
        bodyMedium: GoogleFonts.lato(fontSize: 14, color: textColor),
      ),

      // ElevatedButton Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: accentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          textStyle: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // InputDecoration Theme for TextFields
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: GoogleFonts.lato(color: textColor),
        filled: true,
        fillColor: accentColor,
      ),

      // FloatingActionButton Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: secondaryGold,
        foregroundColor: textColor,
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: accentColor,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // Additional theme elements for Venezia FC styling
      dividerTheme: DividerThemeData(
        color: primaryColor.withOpacity(0.2),
      ),

      // IconButton Theme
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: primaryColor,
        ),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: backgroundColor,
        selectedColor: secondaryGold,
        labelStyle: GoogleFonts.lato(color: textColor),
        side: BorderSide(color: primaryColor.withOpacity(0.3)),
      ),
    );
  }
}