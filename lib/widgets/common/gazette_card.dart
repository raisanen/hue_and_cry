import 'package:flutter/material.dart';

import '../../theme/gazette_colors.dart';

/// A card widget styled with the Police Gazette aesthetic.
///
/// Features:
/// - Warm background color (parchment/dark depending on theme)
/// - Thin border with sepia/cream color
/// - Optional decorative corner ornaments
/// - Subtle shadow for depth
class GazetteCard extends StatelessWidget {
  /// The content of the card.
  final Widget child;

  /// Padding inside the card.
  final EdgeInsetsGeometry padding;

  /// Whether to show decorative corner ornaments.
  final bool showOrnaments;

  /// Optional custom background color.
  final Color? backgroundColor;

  /// Optional custom border color.
  final Color? borderColor;

  /// Optional margin around the card.
  final EdgeInsetsGeometry? margin;

  const GazetteCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.showOrnaments = false,
    this.backgroundColor,
    this.borderColor,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? GazetteColors.darkCard : GazetteColors.parchment);
    final border = borderColor ??
        (isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: padding,
            child: child,
          ),
          if (showOrnaments) ...[
            // Top-left ornament
            Positioned(
              top: 4,
              left: 4,
              child: _buildOrnament(border, topLeft: true),
            ),
            // Top-right ornament
            Positioned(
              top: 4,
              right: 4,
              child: _buildOrnament(border, topRight: true),
            ),
            // Bottom-left ornament
            Positioned(
              bottom: 4,
              left: 4,
              child: _buildOrnament(border, bottomLeft: true),
            ),
            // Bottom-right ornament
            Positioned(
              bottom: 4,
              right: 4,
              child: _buildOrnament(border, bottomRight: true),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrnament(
    Color color, {
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    return CustomPaint(
      size: const Size(12, 12),
      painter: _CornerOrnamentPainter(
        color: color,
        topLeft: topLeft,
        topRight: topRight,
        bottomLeft: bottomLeft,
        bottomRight: bottomRight,
      ),
    );
  }
}

class _CornerOrnamentPainter extends CustomPainter {
  final Color color;
  final bool topLeft;
  final bool topRight;
  final bool bottomLeft;
  final bool bottomRight;

  _CornerOrnamentPainter({
    required this.color,
    this.topLeft = false,
    this.topRight = false,
    this.bottomLeft = false,
    this.bottomRight = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final path = Path();

    if (topLeft) {
      path.moveTo(0, size.height);
      path.lineTo(0, 0);
      path.lineTo(size.width, 0);
    } else if (topRight) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
    } else if (bottomLeft) {
      path.moveTo(0, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else if (bottomRight) {
      path.moveTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
