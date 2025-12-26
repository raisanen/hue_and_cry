import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/gazette_colors.dart';
import 'gazette_divider.dart';

/// A styled section header with the Police Gazette aesthetic.
///
/// Features:
/// - Decorative rules above and below
/// - Optional ornaments
/// - ALL CAPS styling for major headers
class GazetteHeader extends StatelessWidget {
  /// The header text.
  final String text;

  /// Whether this is a major header (larger, all caps).
  final bool major;

  /// Whether to show decorative dividers.
  final bool showDividers;

  /// Whether to center the text.
  final bool centered;

  /// Optional subtitle below the main text.
  final String? subtitle;

  const GazetteHeader({
    super.key,
    required this.text,
    this.major = false,
    this.showDividers = true,
    this.centered = true,
    this.subtitle,
  });

  /// Creates a major header (case titles, etc.)
  const GazetteHeader.major({
    super.key,
    required this.text,
    this.showDividers = true,
    this.centered = true,
    this.subtitle,
  }) : major = true;

  /// Creates a minor header (section titles)
  const GazetteHeader.minor({
    super.key,
    required this.text,
    this.showDividers = false,
    this.centered = false,
    this.subtitle,
  }) : major = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;

    final headerStyle = major
        ? GoogleFonts.playfairDisplay(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: textColor,
          )
        : GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
            color: textColor,
          );

    final subtitleStyle = GoogleFonts.oldStandardTt(
      fontSize: 14,
      fontStyle: FontStyle.italic,
      color: subtitleColor,
    );

    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        if (showDividers) const GazetteDivider.simple(height: 16),
        Text(
          major ? text.toUpperCase() : text,
          style: headerStyle,
          textAlign: centered ? TextAlign.center : TextAlign.start,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 4),
          Text(
            subtitle!,
            style: subtitleStyle,
            textAlign: centered ? TextAlign.center : TextAlign.start,
          ),
        ],
        if (showDividers) const GazetteDivider.simple(height: 16),
      ],
    );
  }
}

/// A decorative masthead for the app title.
class GazetteMasthead extends StatelessWidget {
  /// Whether to show the full masthead with subtitle.
  final bool showSubtitle;

  const GazetteMasthead({
    super.key,
    this.showSubtitle = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;

    return Column(
      children: [
        Text(
          '❧ HUE & CRY ❧',
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 3.0,
            color: textColor,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 4),
          Text(
            'A CHRONICLE OF MYSTERY & CRIME',
            style: GoogleFonts.oldStandardTt(
              fontSize: 12,
              letterSpacing: 2.0,
              color: accentColor,
            ),
          ),
        ],
      ],
    );
  }
}
