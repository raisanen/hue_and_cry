import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../models/case_template.dart';
import '../../theme/gazette_colors.dart';
import '../common/gazette_button.dart';
import '../common/gazette_divider.dart';

/// A bottom sheet styled as a Victorian case file.
///
/// Displays the full case briefing in newspaper column style
/// with period-appropriate decorations and typography.
class CaseDetailSheet extends StatelessWidget {
  /// The case to display.
  final CaseTemplate caseTemplate;

  /// Called when "Commence Investigation" is pressed.
  final VoidCallback onCommence;

  const CaseDetailSheet({
    super.key,
    required this.caseTemplate,
    required this.onCommence,
  });

  /// Shows this sheet as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required CaseTemplate caseTemplate,
    required VoidCallback onCommence,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CaseDetailSheet(
        caseTemplate: caseTemplate,
        onCommence: onCommence,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor =
        isDark ? GazetteColors.darkBackground : GazetteColors.parchment;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;
    final borderColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: bgColor,
            border: Border(
              top: BorderSide(color: borderColor, width: 2),
              left: BorderSide(color: borderColor, width: 1),
              right: BorderSide(color: borderColor, width: 1),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: subtitleColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header with decorative elements
                      _buildHeader(
                        context,
                        textColor: textColor,
                        subtitleColor: subtitleColor,
                        accentColor: accentColor,
                      ),
                      const SizedBox(height: 24),

                      // Case title
                      Text(
                        caseTemplate.title.toUpperCase(),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.0,
                          height: 1.1,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Subtitle
                      Text(
                        caseTemplate.subtitle,
                        style: GoogleFonts.oldStandardTt(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: subtitleColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      const GazetteDivider(),
                      const SizedBox(height: 20),

                      // Briefing text in newspaper style
                      _buildBriefingText(context, textColor),
                      const SizedBox(height: 24),

                      const GazetteDivider.ends(),
                      const SizedBox(height: 20),

                      // Case particulars section
                      _buildParticulars(
                        context,
                        textColor: textColor,
                        subtitleColor: subtitleColor,
                      ),
                      const SizedBox(height: 32),

                      // Action buttons
                      _buildActionButtons(context),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required Color textColor,
    required Color subtitleColor,
    required Color accentColor,
  }) {
    return Column(
      children: [
        // Top ornamental line
        Row(
          children: [
            Text('╔', style: TextStyle(color: subtitleColor, fontSize: 16)),
            Expanded(
              child: Container(
                height: 2,
                color: subtitleColor,
              ),
            ),
            Text('╗', style: TextStyle(color: subtitleColor, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),

        // "Case File" label
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: accentColor.withOpacity(0.1),
            border: Border.all(color: accentColor, width: 1),
          ),
          child: Text(
            '❧ THE PARTICULARS OF THE CASE ❧',
            style: GoogleFonts.playfairDisplay(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
              color: accentColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBriefingText(BuildContext context, Color textColor) {
    // Parse and format the briefing text
    // Remove the decorative borders from the stored briefing
    String briefing = caseTemplate.briefing.trim();

    // Split into paragraphs for styling
    final paragraphs = briefing
        .split('\n\n')
        .where((p) => p.trim().isNotEmpty && !p.contains('═'))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: paragraphs.asMap().entries.map((entry) {
        final index = entry.key;
        final paragraph = entry.value.trim();

        // Skip decorative lines
        if (paragraph.startsWith('─') || paragraph.startsWith('═')) {
          return const SizedBox.shrink();
        }

        // Check if it's a centered header line
        final isCentered = paragraph.contains('❧') ||
            paragraph == paragraph.toUpperCase() ||
            paragraph.startsWith('INVESTIGATORS');

        return Padding(
          padding: EdgeInsets.only(bottom: index < paragraphs.length - 1 ? 16 : 0),
          child: Text(
            paragraph,
            style: GoogleFonts.oldStandardTt(
              fontSize: 14,
              height: 1.6,
              color: textColor,
              fontWeight:
                  isCentered ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: isCentered ? TextAlign.center : TextAlign.justify,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildParticulars(
    BuildContext context, {
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Text(
          'CASE PARTICULARS',
          style: GoogleFonts.playfairDisplay(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: textColor,
          ),
        ),
        const SizedBox(height: 12),

        // Details in period style
        _buildParticularItem(
          label: 'Difficulty Rating',
          value: _getDifficultyDescription(),
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 8),
        _buildParticularItem(
          label: 'Estimated Duration',
          value:
              'Approximately ${caseTemplate.estimatedMinutes} minutes of enquiry',
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 8),
        _buildParticularItem(
          label: 'Locations of Interest',
          value:
              '${caseTemplate.locations.length} establishments to investigate',
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
        const SizedBox(height: 8),
        _buildParticularItem(
          label: 'Optimal Path',
          value:
              'An astute detective may solve this in ${caseTemplate.parVisits} visits',
          textColor: textColor,
          subtitleColor: subtitleColor,
        ),
      ],
    );
  }

  Widget _buildParticularItem({
    required String label,
    required String value,
    required Color textColor,
    required Color subtitleColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: TextStyle(color: subtitleColor, fontSize: 16),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$label: ',
                  style: GoogleFonts.oldStandardTt(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: GoogleFonts.oldStandardTt(
                    fontSize: 13,
                    color: subtitleColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Main action button
        SizedBox(
          width: double.infinity,
          child: GazetteButton(
            text: 'Commence Investigation',
            icon: Icons.search,
            onPressed: () {
              Navigator.of(context).pop();
              onCommence();
            },
          ),
        ),
        const SizedBox(height: 12),

        // Dismiss button
        SizedBox(
          width: double.infinity,
          child: GazetteButton.outlined(
            text: 'Dismiss',
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ],
    );
  }

  String _getDifficultyDescription() {
    switch (caseTemplate.difficulty) {
      case 1:
        return 'Elementary (suitable for novice investigators)';
      case 2:
        return 'Moderate (some experience recommended)';
      case 3:
        return 'Challenging (requires keen observation)';
      case 4:
        return 'Demanding (only for seasoned detectives)';
      case 5:
        return 'Fiendish (a true test of deductive prowess)';
      default:
        return 'Unknown difficulty';
    }
  }
}
