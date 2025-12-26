import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/gazette_colors.dart';

/// A button styled with the Police Gazette aesthetic.
///
/// Supports two variants:
/// - Primary: Solid dark background with light text
/// - Outlined: Transparent with dark border and text
class GazetteButton extends StatelessWidget {
  /// The text to display on the button.
  final String text;

  /// Called when the button is pressed.
  final VoidCallback? onPressed;

  /// Whether to use the outlined variant.
  final bool outlined;

  /// Optional icon to show before the text.
  final IconData? icon;

  /// Whether the button is in a loading state.
  final bool isLoading;

  /// Optional custom width.
  final double? width;

  const GazetteButton({
    super.key,
    required this.text,
    this.onPressed,
    this.outlined = false,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  /// Creates a primary (solid) button.
  const GazetteButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : outlined = false;

  /// Creates an outlined button.
  const GazetteButton.outlined({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.width,
  }) : outlined = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryBg = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final primaryFg =
        isDark ? GazetteColors.darkBackground : GazetteColors.paperWhite;
    final outlinedBorder =
        isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final outlinedFg =
        isDark ? GazetteColors.darkText : GazetteColors.inkBlack;

    final textStyle = GoogleFonts.playfairDisplay(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.0,
    );

    Widget buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(
                outlined ? outlinedFg : primaryFg,
              ),
            ),
          ),
          const SizedBox(width: 8),
        ] else if (icon != null) ...[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
        ],
        Text(text.toUpperCase()),
      ],
    );

    if (outlined) {
      return SizedBox(
        width: width,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: outlinedFg,
            side: BorderSide(color: outlinedBorder, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2),
            ),
            textStyle: textStyle,
          ),
          child: buttonChild,
        ),
      );
    }

    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBg,
          foregroundColor: primaryFg,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2),
          ),
          textStyle: textStyle,
          elevation: 2,
        ),
        child: buttonChild,
      ),
    );
  }
}
