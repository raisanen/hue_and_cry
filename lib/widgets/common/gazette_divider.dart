import 'package:flutter/material.dart';

import '../../theme/gazette_colors.dart';

/// A decorative horizontal divider with the Police Gazette aesthetic.
///
/// Features ornamental flourishes at the ends and center.
class GazetteDivider extends StatelessWidget {
  /// Height of the divider area.
  final double height;

  /// Whether to show center ornament.
  final bool showCenterOrnament;

  /// Whether to show end ornaments.
  final bool showEndOrnaments;

  /// Optional custom color.
  final Color? color;

  /// Thickness of the line.
  final double thickness;

  const GazetteDivider({
    super.key,
    this.height = 32,
    this.showCenterOrnament = true,
    this.showEndOrnaments = true,
    this.color,
    this.thickness = 1,
  });

  /// Creates a simple divider without ornaments.
  const GazetteDivider.simple({
    super.key,
    this.height = 24,
    this.color,
    this.thickness = 1,
  })  : showCenterOrnament = false,
        showEndOrnaments = false;

  /// Creates a divider with only end ornaments.
  const GazetteDivider.ends({
    super.key,
    this.height = 28,
    this.color,
    this.thickness = 1,
  })  : showCenterOrnament = false,
        showEndOrnaments = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineColor = color ??
        (isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown);

    if (!showCenterOrnament && !showEndOrnaments) {
      return SizedBox(
        height: height,
        child: Center(
          child: Container(
            height: thickness,
            color: lineColor,
          ),
        ),
      );
    }

    return SizedBox(
      height: height,
      child: Row(
        children: [
          if (showEndOrnaments) ...[
            Text(
              '❧',
              style: TextStyle(color: lineColor, fontSize: 14),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: Container(
              height: thickness,
              color: lineColor,
            ),
          ),
          if (showCenterOrnament) ...[
            const SizedBox(width: 8),
            Text(
              '✦',
              style: TextStyle(color: lineColor, fontSize: 10),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                height: thickness,
                color: lineColor,
              ),
            ),
          ],
          if (showEndOrnaments) ...[
            const SizedBox(width: 8),
            Text(
              '❧',
              style: TextStyle(color: lineColor, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}

/// A decorative double-line divider.
class GazetteDoubleDivider extends StatelessWidget {
  /// Height of the divider area.
  final double height;

  /// Optional custom color.
  final Color? color;

  const GazetteDoubleDivider({
    super.key,
    this.height = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lineColor = color ??
        (isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown);

    return SizedBox(
      height: height,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 1, color: lineColor),
            const SizedBox(height: 3),
            Container(height: 1, color: lineColor),
          ],
        ),
      ),
    );
  }
}
