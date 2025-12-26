import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../data/cases/vanishing_violinist.dart';
import '../models/case_template.dart';
import '../providers/theme_provider.dart';
import '../theme/gazette_colors.dart';
import '../widgets/case/case_card.dart';
import '../widgets/case/case_detail_sheet.dart';
import '../widgets/common/gazette_divider.dart';

/// The home screen showing available cases to play.
///
/// Designed to look like opening a 19th century Police Gazette,
/// with a dramatic masthead, decorative elements, and case listings
/// styled as newspaper headlines.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Settings row (theme toggle)
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(
                      isDarkMode ? Icons.light_mode : Icons.dark_mode,
                      size: 20,
                    ),
                    tooltip: isDarkMode
                        ? 'Switch to light theme'
                        : 'Switch to dark theme',
                    onPressed: () {
                      ref.read(themeModeProvider.notifier).state =
                          isDarkMode ? ThemeMode.light : ThemeMode.dark;
                    },
                  ),
                ),
              ),

              // Main content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Masthead
                    _buildMasthead(context, textColor, subtitleColor),
                    const SizedBox(height: 32),

                    // Decorative divider
                    const GazetteDivider(),
                    const SizedBox(height: 24),

                    // "Latest Investigations" section header
                    _buildSectionHeader(context, textColor, subtitleColor),
                    const SizedBox(height: 20),

                    // Case cards
                    _buildCaseList(context),
                    const SizedBox(height: 32),

                    // Footer
                    _buildFooter(context, textColor, subtitleColor),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMasthead(
    BuildContext context,
    Color textColor,
    Color subtitleColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;

    return Column(
      children: [
        // Top decorative border
        _buildMastheadBorder(subtitleColor),
        const SizedBox(height: 16),

        // Main title with ornaments
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '❧',
              style: TextStyle(fontSize: 24, color: accentColor),
            ),
            const SizedBox(width: 12),
            Text(
              'HUE & CRY',
              style: GoogleFonts.playfairDisplay(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: 4.0,
                color: textColor,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '❧',
              style: TextStyle(fontSize: 24, color: accentColor),
            ),
          ],
        ),
        const SizedBox(height: 4),

        // Decorative line under title
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 60,
              height: 1,
              color: subtitleColor,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '✦',
                style: TextStyle(fontSize: 8, color: subtitleColor),
              ),
            ),
            Container(
              width: 60,
              height: 1,
              color: subtitleColor,
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          'BEING A CHRONICLE OF',
          style: GoogleFonts.oldStandardTt(
            fontSize: 10,
            letterSpacing: 3.0,
            color: subtitleColor,
          ),
        ),
        Text(
          'MYSTERY & CRIME',
          style: GoogleFonts.playfairDisplay(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 4.0,
            color: accentColor,
          ),
        ),
        const SizedBox(height: 16),

        // Bottom decorative border
        _buildMastheadBorder(subtitleColor),
      ],
    );
  }

  Widget _buildMastheadBorder(Color color) {
    return Row(
      children: [
        Text('╔', style: TextStyle(color: color, fontSize: 14)),
        Expanded(
          child: Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: color, width: 1),
                bottom: BorderSide(color: color, width: 1),
              ),
            ),
          ),
        ),
        Text('╗', style: TextStyle(color: color, fontSize: 14)),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    Color textColor,
    Color subtitleColor,
  ) {
    return Column(
      children: [
        // Section title
        Text(
          'LATEST INVESTIGATIONS',
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 2.0,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Cases Requiring the Attention of Discerning Investigators',
          style: GoogleFonts.oldStandardTt(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: subtitleColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCaseList(BuildContext context) {
    // For MVP, we only have one case, but this is designed to
    // easily support multiple cases in the future
    final cases = <CaseTemplate>[
      vanishingViolinistCase,
    ];

    return Column(
      children: cases.map((caseTemplate) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CaseCard(
            caseTemplate: caseTemplate,
            teaser: _getCaseTeaser(caseTemplate.id),
            onTap: () => _showCaseDetails(context, caseTemplate),
          ),
        );
      }).toList(),
    );
  }

  void _showCaseDetails(BuildContext context, CaseTemplate caseTemplate) {
    CaseDetailSheet.show(
      context,
      caseTemplate: caseTemplate,
      onCommence: () {
        context.push('/case/${caseTemplate.id}/setup');
      },
    );
  }

  String _getCaseTeaser(String caseId) {
    // Teaser text for each case in newspaper prose style
    const teasers = {
      'vanishing_violinist':
          'Three days past, the acclaimed violinist Maria Lindgren departed '
              'a private engagement and has not been seen since. Her prized '
              'Stradivarius was discovered abandoned in her carriage—an '
              'instrument she was known never to let leave her sight. The '
              'circumstances demand investigation.',
    };

    return teasers[caseId] ??
        'A mystery of considerable intrigue awaits the discerning investigator.';
  }

  Widget _buildFooter(
    BuildContext context,
    Color textColor,
    Color subtitleColor,
  ) {
    return Column(
      children: [
        const GazetteDivider.ends(),
        const SizedBox(height: 16),

        // "More cases" notice
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: subtitleColor.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Text(
                'ADDITIONAL CASES',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Further investigations are currently under preparation '
                'by our editorial staff and shall be published in due course.',
                style: GoogleFonts.oldStandardTt(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: subtitleColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Copyright / Attribution
        Text(
          '— Est. MMXV —',
          style: GoogleFonts.oldStandardTt(
            fontSize: 10,
            letterSpacing: 2.0,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}
