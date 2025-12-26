import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/character.dart';
import '../../theme/gazette_colors.dart';
import '../common/gazette_button.dart';
import '../common/gazette_divider.dart';

/// A gazette-styled card displaying a character at a location.
class CharacterCard extends StatelessWidget {
  /// The character to display.
  final Character character;

  /// The dialogue to show (may include conditional dialogue).
  final String dialogue;

  /// Whether this character has a testimony clue available.
  final bool hasTestimony;

  /// Callback when the player notes the testimony.
  final VoidCallback? onNoteTestimony;

  const CharacterCard({
    super.key,
    required this.character,
    required this.dialogue,
    this.hasTestimony = false,
    this.onNoteTestimony,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final cardColor = isDark ? GazetteColors.darkCard : GazetteColors.parchment;
    final borderColor =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.wanted : GazetteColors.copperplate;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with portrait frame
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Portrait frame
                _PortraitFrame(
                  character: character,
                  isDark: isDark,
                ),
                const SizedBox(width: 12),

                // Name and role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name.toUpperCase(),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        character.role,
                        style: GoogleFonts.oldStandardTt(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        character.description,
                        style: GoogleFonts.oldStandardTt(
                          fontSize: 12,
                          height: 1.4,
                          color: subtitleColor,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          GazetteDivider.simple(
            height: 1,
            color: borderColor,
          ),

          // Dialogue section
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Dialogue header
                Row(
                  children: [
                    Icon(
                      Icons.format_quote,
                      size: 16,
                      color: accentColor,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'STATEMENT',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Dialogue text
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: (isDark
                            ? GazetteColors.darkBackground
                            : GazetteColors.newsprint)
                        .withOpacity(0.5),
                    border: Border(
                      left: BorderSide(
                        color: accentColor,
                        width: 3,
                      ),
                    ),
                  ),
                  child: Text(
                    '"$dialogue"',
                    style: GoogleFonts.oldStandardTt(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      height: 1.5,
                      color: textColor,
                    ),
                  ),
                ),

                // Testimony button
                if (hasTestimony) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GazetteButton(
                        text: 'Make Note of This',
                        icon: Icons.edit_note,
                        onPressed: onNoteTestimony,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PortraitFrame extends StatelessWidget {
  final Character character;
  final bool isDark;

  const _PortraitFrame({
    required this.character,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown;
    final bgColor = isDark ? GazetteColors.darkSurface : GazetteColors.newsprint;
    final iconColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkFaded;

    return Container(
      width: 60,
      height: 72,
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Stack(
        children: [
          // Portrait placeholder (silhouette)
          Center(
            child: Icon(
              Icons.person,
              size: 36,
              color: iconColor,
            ),
          ),

          // Decorative corner accents
          Positioned(
            top: 2,
            left: 2,
            child: _CornerAccent(color: borderColor),
          ),
          Positioned(
            top: 2,
            right: 2,
            child: _CornerAccent(color: borderColor, flipHorizontal: true),
          ),
          Positioned(
            bottom: 2,
            left: 2,
            child: _CornerAccent(color: borderColor, flipVertical: true),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: _CornerAccent(
              color: borderColor,
              flipHorizontal: true,
              flipVertical: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _CornerAccent extends StatelessWidget {
  final Color color;
  final bool flipHorizontal;
  final bool flipVertical;

  const _CornerAccent({
    required this.color,
    this.flipHorizontal = false,
    this.flipVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..scale(
          flipHorizontal ? -1.0 : 1.0,
          flipVertical ? -1.0 : 1.0,
        ),
      alignment: Alignment.center,
      child: SizedBox(
        width: 8,
        height: 8,
        child: CustomPaint(
          painter: _CornerPainter(color: color),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final Color color;

  _CornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw an L-shaped corner
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CornerPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
