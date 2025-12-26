import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gazette_colors.dart';

/// Police Gazette-inspired typography.
/// 
/// Uses period-appropriate typefaces:
/// - Old Standard TT: Elegant serif for body text (19th century printing style)
/// - Playfair Display: High contrast serif for dramatic headlines
/// - Special Elite: Typewriter style for evidence and clue documents
/// 
/// Font sizes are scaled so the minimum size is 16px for accessibility.
class GazetteTypography {
  GazetteTypography._();

  // ═══════════════════════════════════════════════════════════════════════════
  // LIGHT THEME STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Masthead style - for the main app title
  static TextStyle get masthead => GoogleFonts.playfairDisplay(
    fontSize: 43,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.0,
    color: GazetteColors.inkBlack,
  );

  /// Headline style - for major section headers
  static TextStyle get headline => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: GazetteColors.inkBlack,
  );

  /// Subheadline style - for secondary headers
  static TextStyle get subheadline => GoogleFonts.oldStandardTt(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: GazetteColors.inkBrown,
  );

  /// Body text style - for main content
  static TextStyle get body => GoogleFonts.oldStandardTt(
    fontSize: 19,
    height: 1.5,
    color: GazetteColors.inkBlack,
  );

  /// Caption style - for smaller annotations
  static TextStyle get caption => GoogleFonts.oldStandardTt(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: GazetteColors.inkFaded,
  );

  /// Evidence style - for clue documents and evidence text
  static TextStyle get evidence => GoogleFonts.specialElite(
    fontSize: 19,
    height: 1.6,
    color: GazetteColors.inkBrown,
  );

  /// Button text style
  static TextStyle get button => GoogleFonts.playfairDisplay(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: GazetteColors.paperWhite,
  );

  // ═══════════════════════════════════════════════════════════════════════════
  // DARK THEME STYLES
  // ═══════════════════════════════════════════════════════════════════════════

  /// Masthead style for dark theme
  static TextStyle get mastheadDark => GoogleFonts.playfairDisplay(
    fontSize: 43,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.0,
    color: GazetteColors.darkText,
  );

  /// Headline style for dark theme
  static TextStyle get headlineDark => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: GazetteColors.darkText,
  );

  /// Subheadline style for dark theme
  static TextStyle get subheadlineDark => GoogleFonts.oldStandardTt(
    fontSize: 21,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: GazetteColors.darkTextSecondary,
  );

  /// Body text style for dark theme
  static TextStyle get bodyDark => GoogleFonts.oldStandardTt(
    fontSize: 19,
    height: 1.5,
    color: GazetteColors.darkText,
  );

  /// Caption style for dark theme
  static TextStyle get captionDark => GoogleFonts.oldStandardTt(
    fontSize: 16,
    fontStyle: FontStyle.italic,
    color: GazetteColors.darkTextFaded,
  );

  /// Evidence style for dark theme
  static TextStyle get evidenceDark => GoogleFonts.specialElite(
    fontSize: 19,
    height: 1.6,
    color: GazetteColors.darkTextSecondary,
  );

  /// Button text style for dark theme
  static TextStyle get buttonDark => GoogleFonts.playfairDisplay(
    fontSize: 19,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: GazetteColors.darkBackground,
  );
}
