// lib/core/theme/app_theme.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2E7D32);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF1B5E20);
  static const Color primaryGradientStart = Color(0xFF388E3C);
  static const Color primaryGradientEnd = Color(0xFF1B5E20);
  static const Color accent = Color(0xFFFFEB3B);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF5F5F5);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color calColor = Color(0xFFFFEB3B);
  static const Color proteinColor = Color(0xFF7C4DFF);
  static const Color fatColor = Color(0xFF2E7D32);
  static const Color negativeBar = Color(0xFFE53935);
  static const Color positiveBar = Color(0xFF43A047);
  static const Color starColor = Color(0xFFFFB300);
  static const Color suggestionBg = Color(0xFFE8F5E9);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryGradientStart, primaryGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF43A047), Color(0xFF2E7D32)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // App bar colors
  static const Color appBar = Color(0xFF2E7D32);
  static const Color appBarLight = Color(0xFF4CAF50);

  // Status / indicator
  static const Color onlineGreen = Color(0xFF43A047);

  // Chips and surfaces
  static const Color dateChipBg = Color(0xFFF1F8ED);

  // Chat bubble colors
  static const Color userBubble = Color(0xFFDCF8C6);
  static const Color botBubble = Color(0xFFFFFFFF);

  static const Color botLabel = Color(0xFF6C6C6C);
  static const Color userBubbleText = Color(0xFF1A1A1A);

  static const Color timeText = Color(0xFF9E9E9E);
  static const Color readTick = Color(0xFF43A047);

  static const Color inputBar = Color(0xFFF5F5F5);
  static const Color botBubbleText = Color(0xFF1A1A1A);

  // Search and action button colors
  static const Color searchBg = Color(0xFF367c3a);
  static const Color sendButton = primary;
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      secondary: AppColors.primaryLight,
      background: AppColors.background,
      surface: AppColors.surface,
    ),
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: TextStyle(
        color: AppColors.textPrimary,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: AppColors.textPrimary,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
      titleLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
      bodyLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),
      bodyMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    ),
  );
}
