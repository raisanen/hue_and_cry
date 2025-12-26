import 'package:flutter/material.dart';

import 'gazette_colors.dart';
import 'gazette_typography.dart';

/// ThemeData configuration for the Police Gazette aesthetic.
class GazetteTheme {
  GazetteTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: const ColorScheme.light(
        primary: GazetteColors.inkBlack,
        onPrimary: GazetteColors.paperWhite,
        secondary: GazetteColors.bloodRed,
        onSecondary: GazetteColors.paperWhite,
        surface: GazetteColors.parchment,
        onSurface: GazetteColors.inkBlack,
        error: GazetteColors.error,
        onError: GazetteColors.paperWhite,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: GazetteColors.parchment,
      
      // AppBar theme
      appBarTheme: AppBarTheme(
        backgroundColor: GazetteColors.inkBlack,
        foregroundColor: GazetteColors.paperWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GazetteTypography.headline.copyWith(
          color: GazetteColors.paperWhite,
          fontSize: 20,
        ),
      ),
      
      // Card theme
      cardTheme: const CardThemeData(
        color: GazetteColors.paperWhite,
        elevation: 2,
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: GazetteColors.inkBlack,
          foregroundColor: GazetteColors.paperWhite,
          textStyle: GazetteTypography.button,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      
      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: GazetteColors.inkBlack,
          side: const BorderSide(color: GazetteColors.inkBlack, width: 1),
          textStyle: GazetteTypography.button.copyWith(
            color: GazetteColors.inkBlack,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      
      // Text theme
      textTheme: TextTheme(
        displayLarge: GazetteTypography.masthead,
        headlineLarge: GazetteTypography.headline,
        headlineMedium: GazetteTypography.subheadline,
        bodyLarge: GazetteTypography.body,
        bodyMedium: GazetteTypography.body,
        labelLarge: GazetteTypography.button,
        bodySmall: GazetteTypography.caption,
      ),
      
      // Divider theme
      dividerTheme: const DividerThemeData(
        color: GazetteColors.inkBlack,
        thickness: 1,
        space: 24,
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: GazetteColors.inkBlack,
        size: 24,
      ),
    );
  }
}
