import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'gazette_colors.dart';

/// Police Gazette-inspired typography.
/// 
/// Uses period-appropriate typefaces:
/// - Old Standard TT: Elegant serif for body text (19th century printing style)
/// - Playfair Display: High contrast serif for dramatic headlines
class GazetteTypography {
  GazetteTypography._();

  /// Masthead style - for the main app title
  static TextStyle get masthead => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    letterSpacing: 2.0,
    color: GazetteColors.inkBlack,
  );

  /// Headline style - for major section headers
  static TextStyle get headline => GoogleFonts.playfairDisplay(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: GazetteColors.inkBlack,
  );

  /// Subheadline style - for secondary headers
  static TextStyle get subheadline => GoogleFonts.oldStandardTt(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
    color: GazetteColors.inkBrown,
  );

  /// Body text style - for main content
  static TextStyle get body => GoogleFonts.oldStandardTt(
    fontSize: 14,
    height: 1.5,
    color: GazetteColors.inkBlack,
  );

  /// Caption style - for smaller annotations
  static TextStyle get caption => GoogleFonts.oldStandardTt(
    fontSize: 12,
    fontStyle: FontStyle.italic,
    color: GazetteColors.inkFaded,
  );

  /// Evidence style - for clue documents and evidence text
  static TextStyle get evidence => GoogleFonts.specialElite(
    fontSize: 14,
    height: 1.6,
    color: GazetteColors.inkBrown,
  );

  /// Button text style
  static TextStyle get button => GoogleFonts.playfairDisplay(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.0,
    color: GazetteColors.paperWhite,
  );
}
