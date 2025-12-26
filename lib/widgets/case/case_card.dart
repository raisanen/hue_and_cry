import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/case_template.dart';
import '../../theme/gazette_colors.dart';
import '../common/gazette_card.dart';
import '../common/gazette_divider.dart';

/// A newspaper-style card for displaying case information.
///
/// Designed to look like a Victorian newspaper front page headline,
/// complete with decorative borders, dramatic typography, and
/// period-appropriate prose styling.
class CaseCard extends StatelessWidget {
  /// The case template to display.
  final CaseTemplate caseTemplate;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  /// Optional teaser text (if not provided, uses a default).
  final String? teaser;

  const CaseCard({
    super.key,
    required this.caseTemplate,
    this.onTap,
    this.teaser,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;

    return GestureDetector(
      onTap: onTap,
      child: GazetteCard(
        showOrnaments: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top ornamental line
            // _buildOrnamentalRule(isDark),
            // const SizedBox(height: 16),

            // "SPECIAL REPORT" or similar label
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: accentColor, width: 1),
                ),
                child: Text(
                  'SPECIAL INVESTIGATION',
                  style: GoogleFonts.oldStandardTt(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2.0,
                    color: accentColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Main headline (case title)
            Text(
              caseTemplate.title.toUpperCase(),
              style: GoogleFonts.playfairDisplay(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
                height: 1.1,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),

            // Subtitle in italic
            Text(
              caseTemplate.subtitle,
              style: GoogleFonts.oldStandardTt(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: subtitleColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Decorative divider
            const GazetteDivider.ends(height: 16),
            const SizedBox(height: 12),

            // Teaser paragraph in newspaper prose
            Text(
              teaser ?? _getDefaultTeaser(),
              style: GoogleFonts.oldStandardTt(
                fontSize: 13,
                height: 1.5,
                color: textColor,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),

            // Stats row with period styling
            _buildStatsRow(context, isDark),
            const SizedBox(height: 16),

            // Bottom ornamental line
            _buildOrnamentalRule(isDark),
            const SizedBox(height: 12),

            // "Read more" hint
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.touch_app,
                    size: 14,
                    color: subtitleColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Tap to examine case particulars',
                    style: GoogleFonts.oldStandardTt(
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrnamentalRule(bool isDark) {
    final color =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    return Row(
      children: [
        Text('❧', style: TextStyle(color: color, fontSize: 12)),
        Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: color,
          ),
        ),
        Text('✦', style: TextStyle(color: color, fontSize: 10)),
        Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: color,
          ),
        ),
        Text('❧', style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isDark) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final labelColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkFaded;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStat(
          context,
          label: 'DIFFICULTY',
          value: _buildDifficultyIndicator(isDark),
          textColor: textColor,
          labelColor: labelColor,
        ),
        Container(
          width: 1,
          height: 40,
          color: labelColor.withOpacity(0.5),
        ),
        _buildStat(
          context,
          label: 'DURATION',
          value: Text(
            '~${caseTemplate.estimatedMinutes} min.',
            style: GoogleFonts.oldStandardTt(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          textColor: textColor,
          labelColor: labelColor,
        ),
        Container(
          width: 1,
          height: 40,
          color: labelColor.withOpacity(0.5),
        ),
        _buildStat(
          context,
          label: 'LOCATIONS',
          value: Text(
            '${caseTemplate.parVisits} stops',
            style: GoogleFonts.oldStandardTt(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
          textColor: textColor,
          labelColor: labelColor,
        ),
      ],
    );
  }

  Widget _buildStat(
    BuildContext context, {
    required String label,
    required Widget value,
    required Color textColor,
    required Color labelColor,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.oldStandardTt(
            fontSize: 9,
            letterSpacing: 1.0,
            color: labelColor,
          ),
        ),
        const SizedBox(height: 4),
        value,
      ],
    );
  }

  Widget _buildDifficultyIndicator(bool isDark) {
    final activeColor =
        isDark ? GazetteColors.wanted : GazetteColors.copperplate;
    final inactiveColor =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkFaded;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Text(
          index < caseTemplate.difficulty ? '✦' : '✧',
          style: TextStyle(
            fontSize: 14,
            color:
                index < caseTemplate.difficulty ? activeColor : inactiveColor,
          ),
        );
      }),
    );
  }

  String _getDefaultTeaser() {
    return 'A mystery of considerable intrigue awaits the discerning '
        'investigator. The particulars of this case demand careful '
        'examination and a keen eye for detail.';
  }
}

/// A compact version of the case card for list views.
class CaseCardCompact extends StatelessWidget {
  /// The case template to display.
  final CaseTemplate caseTemplate;

  /// Called when the card is tapped.
  final VoidCallback? onTap;

  const CaseCardCompact({
    super.key,
    required this.caseTemplate,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;

    return GestureDetector(
      onTap: onTap,
      child: GazetteCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Difficulty indicator
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: subtitleColor, width: 1),
              ),
              child: Center(
                child: Text(
                  '${caseTemplate.difficulty}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Title and subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    caseTemplate.title.toUpperCase(),
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    caseTemplate.subtitle,
                    style: GoogleFonts.oldStandardTt(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: subtitleColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(
              Icons.chevron_right,
              color: subtitleColor,
            ),
          ],
        ),
      ),
    );
  }
}
