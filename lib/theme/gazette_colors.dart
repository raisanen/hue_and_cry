import 'package:flutter/material.dart';

/// Police Gazette-inspired color palette.
/// 
/// The visual design mimics 1800s Police Gazette newspapers—sensationalist
/// crime reporting with dramatic woodcut illustrations, bold typography,
/// and a distinct sepia/cream color palette.
class GazetteColors {
  GazetteColors._();

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME COLORS (Classic aged paper look)
  // ═══════════════════════════════════════════════════════════════════════════

  // Paper and backgrounds
  static const Color parchment = Color(0xFFF5F0E1);      // Aged paper cream
  static const Color paperWhite = Color(0xFFFAF8F5);     // Cleaner cream
  static const Color newsprint = Color(0xFFE8E4D9);      // Slightly gray paper

  // Inks
  static const Color inkBlack = Color(0xFF1A1A1A);       // Rich black text
  static const Color inkBrown = Color(0xFF3D2B1F);       // Aged ink, sepia
  static const Color inkFaded = Color(0xFF5C4B3A);       // Secondary text

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME COLORS (Midnight edition / gas-lit atmosphere)
  // ═══════════════════════════════════════════════════════════════════════════

  // Dark backgrounds (like reading by candlelight)
  static const Color darkBackground = Color(0xFF1A1612);     // Deep warm black
  static const Color darkSurface = Color(0xFF2A2420);        // Slightly lighter
  static const Color darkCard = Color(0xFF332D28);           // Card background

  // Light text on dark (aged paper color as text)
  static const Color darkText = Color(0xFFE8E0D0);           // Warm cream text
  static const Color darkTextSecondary = Color(0xFFB8A898);  // Muted cream
  static const Color darkTextFaded = Color(0xFF8A7A6A);      // Faded text

  // ═══════════════════════════════════════════════════════════════════════════
  // SHARED ACCENT COLORS (used in both themes)
  // ═══════════════════════════════════════════════════════════════════════════

  // Accent colors (used sparingly, as spot color)
  static const Color bloodRed = Color(0xFF8B0000);       // Headlines, alerts
  static const Color bloodRedLight = Color(0xFFB33030);  // Lighter for dark theme
  static const Color copperplate = Color(0xFF6B4423);    // Decorative elements
  static const Color wanted = Color(0xFFB8860B);         // Gold/reward emphasis
  static const Color wantedLight = Color(0xFFD4A84B);    // Brighter gold for dark

  // Functional
  static const Color success = Color(0xFF2D5A27);        // Dark green
  static const Color successLight = Color(0xFF4A8B40);   // Lighter for dark theme
  static const Color error = Color(0xFF8B0000);          // Same as bloodRed
  static const Color errorLight = Color(0xFFB33030);     // Lighter for dark theme
  static const Color disabled = Color(0xFF9E9E9E);
  static const Color disabledDark = Color(0xFF5A5A5A);   // For dark theme
}
