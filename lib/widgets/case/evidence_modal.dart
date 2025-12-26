import 'package:flutter/material.dart';
import '../../theme/gazette_typography.dart';

import '../../models/clue.dart';
import '../../theme/gazette_colors.dart';
import '../common/gazette_button.dart';
import '../common/gazette_divider.dart';
import 'clue_card.dart';

/// A modal dialog displaying the full details of a clue.
class EvidenceModal extends StatelessWidget {
  /// The clue to display.
  final Clue clue;

  /// Callback when the player adds the clue to their casebook.
  final VoidCallback? onAddToCasebook;

  /// Whether this clue reveals new locations.
  final List<String> revealedLocationNames;

  const EvidenceModal({
    super.key,
    required this.clue,
    this.onAddToCasebook,
    this.revealedLocationNames = const [],
  });

  /// Shows the evidence modal as a dialog.
  static Future<bool?> show(
    BuildContext context, {
    required Clue clue,
    VoidCallback? onAddToCasebook,
    List<String> revealedLocationNames = const [],
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => EvidenceModal(
        clue: clue,
        onAddToCasebook: onAddToCasebook,
        revealedLocationNames: revealedLocationNames,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
      isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final bgColor = isDark ? GazetteColors.darkCard : GazetteColors.parchment;
    final borderColor =
      isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown;
    final accentColor =
      isDark ? GazetteColors.wanted : GazetteColors.copperplate;
    final headlineStyle = isDark ? GazetteTypography.headlineDark : GazetteTypography.headline;
    final captionStyle = isDark ? GazetteTypography.captionDark : GazetteTypography.caption;
    final evidenceStyle = isDark ? GazetteTypography.evidenceDark : GazetteTypography.evidence;
    final bodyStyle = isDark ? GazetteTypography.bodyDark : GazetteTypography.body;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              _buildHeader(isDark, textColor, accentColor, borderColor),

              // Body
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Type label
                    Row(
                      children: [
                        _buildTypeIcon(isDark),
                        const SizedBox(width: 8),
                        Text(
                          clueTypeLabel(clue.type).toUpperCase(),
                          style: captionStyle.copyWith(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5, color: subtitleColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Discovery text
                    Text(
                      clue.discoveryText,
                      style: bodyStyle.copyWith(fontSize: 14, height: 1.6, color: textColor),
                    ),

                    // Revealed locations banner
                    if (revealedLocationNames.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _buildRevealBanner(isDark),
                    ],

                    // Red herring hint
                    if (clue.isRedHerring) ...[
                      const SizedBox(height: 16),
                      _buildRedHerringHint(isDark, subtitleColor),
                    ],
                  ],
                ),
              ),

              // Footer
              GazetteDivider.simple(height: 1, color: borderColor),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(
                        'Close',
                        style: captionStyle.copyWith(fontSize: 14, color: subtitleColor),
                      ),
                    ),
                    GazetteButton(
                      text: 'Add to Casebook',
                      icon: Icons.bookmark_add,
                      onPressed: () {
                        onAddToCasebook?.call();
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    bool isDark,
    Color textColor,
    Color accentColor,
    Color borderColor,
  ) {
    final captionStyle = isDark ? GazetteTypography.captionDark : GazetteTypography.caption;
    final headlineStyle = isDark ? GazetteTypography.headlineDark : GazetteTypography.headline;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor, width: 1),
        ),
      ),
      child: Column(
        children: [
          // Decorative header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '❧',
                style: captionStyle.copyWith(color: accentColor, fontSize: 14),
              ),
              const SizedBox(width: 8),
              Text(
                'EVIDENCE SECURED',
                style: captionStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 2, color: accentColor),
              ),
              const SizedBox(width: 8),
              Text(
                '❧',
                style: captionStyle.copyWith(color: accentColor, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Title
          Text(
            clue.title.toUpperCase(),
            style: headlineStyle.copyWith(fontSize: 18, fontWeight: FontWeight.w700, letterSpacing: 1, color: textColor),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTypeIcon(bool isDark) {
    final iconColor =
        isDark ? GazetteColors.wanted : GazetteColors.copperplate;

    IconData iconData;
    switch (clue.type) {
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

    return Icon(iconData, size: 16, color: iconColor);
  }

  Widget _buildRevealBanner(bool isDark) {
    final captionStyle = isDark ? GazetteTypography.captionDark : GazetteTypography.caption;
    final bodyStyle = isDark ? GazetteTypography.bodyDark : GazetteTypography.body;
    final bannerBg = isDark
        ? GazetteColors.wanted.withOpacity(0.2)
        : GazetteColors.wanted.withOpacity(0.15);
    final bannerBorder = GazetteColors.wanted;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bannerBg,
        border: Border.all(color: bannerBorder, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.explore,
                size: 16,
                color: bannerBorder,
              ),
              const SizedBox(width: 8),
              Text(
                'NEW LOCATION DISCOVERED!',
                style: captionStyle.copyWith(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1, color: bannerBorder),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...revealedLocationNames.map(
            (name) => Padding(
              padding: const EdgeInsets.only(left: 24, top: 2),
              child: Text(
                '• $name',
                style: bodyStyle.copyWith(fontSize: 13, color: textColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRedHerringHint(bool isDark, Color subtitleColor) {
    // We don't actually tell them it's a red herring - that would ruin it!
    // But we might show a subtle hint in the design
    final captionStyle = isDark ? GazetteTypography.captionDark : GazetteTypography.caption;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Text(
        'This information has been noted.',
        style: captionStyle.copyWith(fontSize: 11, fontStyle: FontStyle.italic, color: subtitleColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
