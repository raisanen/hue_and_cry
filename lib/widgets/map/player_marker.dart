import 'package:flutter/material.dart';

import '../../theme/gazette_colors.dart';

/// A distinctive player position marker with gazette styling.
///
/// Features a magnifying glass design with a subtle pulse animation
/// to clearly show the player's current location on the map.
class PlayerMarker extends StatefulWidget {
  /// Size of the marker.
  final double size;

  const PlayerMarker({
    super.key,
    this.size = 48,
  });

  @override
  State<PlayerMarker> createState() => _PlayerMarkerState();
}

class _PlayerMarkerState extends State<PlayerMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final markerColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;
    final glowColor = markerColor.withOpacity(0.3);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Pulse glow effect
              Transform.scale(
                scale: 1.0 + (_pulseAnimation.value - 0.8) * 2,
                child: Container(
                  width: widget.size * 0.8,
                  height: widget.size * 0.8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: glowColor.withOpacity(
                      0.5 * (1.0 - _pulseAnimation.value),
                    ),
                  ),
                ),
              ),

              // Main marker body
              Container(
                width: widget.size * 0.5,
                height: widget.size * 0.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: markerColor,
                  border: Border.all(
                    color: isDark
                        ? GazetteColors.darkText
                        : GazetteColors.paperWhite,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.search,
                  color:
                      isDark ? GazetteColors.darkText : GazetteColors.paperWhite,
                  size: widget.size * 0.25,
                ),
              ),

              // Direction indicator (small triangle at bottom)
              Positioned(
                bottom: widget.size * 0.1,
                child: CustomPaint(
                  size: Size(widget.size * 0.2, widget.size * 0.15),
                  painter: _DirectionIndicatorPainter(
                    color: markerColor,
                    borderColor: isDark
                        ? GazetteColors.darkText
                        : GazetteColors.paperWhite,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DirectionIndicatorPainter extends CustomPainter {
  final Color color;
  final Color borderColor;

  _DirectionIndicatorPainter({
    required this.color,
    required this.borderColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    // Fill
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, fillPaint);

    // Border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _DirectionIndicatorPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.borderColor != borderColor;
  }
}
