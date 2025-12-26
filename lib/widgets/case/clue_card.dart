import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/clue.dart';
import '../../theme/gazette_colors.dart';
import '../common/gazette_button.dart';

/// A gazette-styled card displaying a clue that can be discovered.
class ClueCard extends StatelessWidget {
  /// The clue to display.
  final Clue clue;

  /// Whether this clue has already been discovered.
  final bool isDiscovered;

  /// Callback when the player wants to examine the clue.
  final VoidCallback? onExamine;

  /// Callback when the player adds the clue to their casebook.
  final VoidCallback? onAddToCasebook;

  const ClueCard({
    super.key,
    required this.clue,
    this.isDiscovered = false,
    this.onExamine,
    this.onAddToCasebook,
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
          // Header with type indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: borderColor, width: 1),
              ),
            ),
            child: Row(
              children: [
                // Clue type icon
                _ClueTypeIcon(type: clue.type, isDark: isDark),
                const SizedBox(width: 10),

                // Title
                Expanded(
                  child: Text(
                    clue.title.toUpperCase(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: textColor,
                    ),
                  ),
                ),

                // Discovered indicator
                if (isDiscovered)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: GazetteColors.success.withOpacity(0.2),
                      border: Border.all(
                        color: GazetteColors.success,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      'NOTED',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                        color: GazetteColors.success,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Body
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Preview text
                Text(
                  _getPreviewText(),
                  style: GoogleFonts.oldStandardTt(
                    fontSize: 13,
                    height: 1.4,
                    color: subtitleColor,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                if (!isDiscovered) ...[
                  const SizedBox(height: 12),

                  // Action button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GazetteButton.outlined(
                        text: 'Examine',
                        icon: Icons.search,
                        onPressed: onExamine,
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

  String _getPreviewText() {
    // Show first part of discovery text as preview
    final text = clue.discoveryText;
    if (text.length > 80) {
      return '${text.substring(0, 77)}...';
    }
    return text;
  }
}

class _ClueTypeIcon extends StatelessWidget {
  final ClueType type;
  final bool isDark;

  const _ClueTypeIcon({
    required this.type,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor =
        isDark ? GazetteColors.wanted : GazetteColors.copperplate;

    IconData iconData;
    switch (type) {
      case ClueType.physical:
        iconData = Icons.vpn_key;
        break;
      case ClueType.testimony:
        iconData = Icons.record_voice_over;
        break;
      case ClueType.observation:
        iconData = Icons.visibility;
        break;
      case ClueType.record:
        iconData = Icons.description;
        break;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        border: Border.all(color: iconColor, width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Icon(
        iconData,
        size: 16,
        color: iconColor,
      ),
    );
  }
}

/// Returns a human-readable label for a clue type.
String clueTypeLabel(ClueType type) {
  switch (type) {
    case ClueType.physical:
      return 'Physical Evidence';
    case ClueType.testimony:
      return 'Testimony';
    case ClueType.observation:
      return 'Observation';
    case ClueType.record:
      return 'Document';
  }
}
