import 'package:flutter/material.dart';

/// Police Gazette-inspired color palette.
/// 
/// The visual design mimics 1800s Police Gazette newspapers—sensationalist
/// crime reporting with dramatic woodcut illustrations, bold typography,
/// and a distinct sepia/cream color palette.
class GazetteColors {
  GazetteColors._();

  // Paper and backgrounds
  static const Color parchment = Color(0xFFF5F0E1);      // Aged paper cream
  static const Color paperWhite = Color(0xFFFAF8F5);     // Cleaner cream
  static const Color newsprint = Color(0xFFE8E4D9);      // Slightly gray paper

  // Inks
  static const Color inkBlack = Color(0xFF1A1A1A);       // Rich black text
  static const Color inkBrown = Color(0xFF3D2B1F);       // Aged ink, sepia
  static const Color inkFaded = Color(0xFF5C4B3A);       // Secondary text

  // Accent colors (used sparingly, as spot color)
  static const Color bloodRed = Color(0xFF8B0000);       // Headlines, alerts
  static const Color copperplate = Color(0xFF6B4423);    // Decorative elements
  static const Color wanted = Color(0xFFB8860B);         // Gold/reward emphasis

  // Functional
  static const Color success = Color(0xFF2D5A27);        // Dark green
  static const Color error = Color(0xFF8B0000);          // Same as bloodRed
  static const Color disabled = Color(0xFF9E9E9E);
}
