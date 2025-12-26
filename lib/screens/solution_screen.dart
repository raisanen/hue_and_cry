import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/bound_case.dart';
import '../models/character.dart';
import '../providers/game_state_provider.dart';
import '../services/game_service.dart';
import '../theme/gazette_colors.dart';
import '../widgets/common/gazette_button.dart';
import '../widgets/common/gazette_card.dart';
import '../widgets/common/gazette_divider.dart';

/// Screen for submitting a solution and seeing the score.
/// Styled as a dramatic gazette "EXTRA! EXTRA!" special edition.
class SolutionScreen extends ConsumerStatefulWidget {
  final String caseId;

  const SolutionScreen({
    super.key,
    required this.caseId,
  });

  @override
  ConsumerState<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends ConsumerState<SolutionScreen>
    with SingleTickerProviderStateMixin {
  String? _selectedSuspect;
  final TextEditingController _motiveController = TextEditingController();
  bool _hasSubmitted = false;
  SolutionResult? _result;
  
  // Animation for reveal
  late AnimationController _revealController;
  late Animation<double> _revealAnimation;
  bool _showFullResults = false;

  @override
  void initState() {
    super.initState();
    _revealController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _revealAnimation = CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _motiveController.dispose();
    _revealController.stop();
    _revealController.dispose();
    super.dispose();
  }

  void _submitAccusation(BoundCase boundCase) {
    if (_selectedSuspect == null) return;

    final gameState = ref.read(activeGameStateProvider);
    if (gameState == null) return;

    final gameService = ref.read(gameServiceProvider);
    final result = gameService.submitSolution(
      gameState,
      _selectedSuspect!,
      boundCase,
    );

    // Complete the game
    ref.read(activeGameStateProvider.notifier).completeGame();

    setState(() {
      _hasSubmitted = true;
      _result = result;
    });

    // Start reveal animation
    _revealController.forward().then((_) {
      if (mounted) {
        setState(() {
          _showFullResults = true;
        });
      }
    });
  }

  void _showConfirmationDialog(BoundCase boundCase) {
    final character = boundCase.template.characters
        .firstWhere((c) => c.id == _selectedSuspect);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? GazetteColors.darkCard : GazetteColors.parchment;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: accentColor, width: 2),
        ),
        title: Column(
          children: [
            Text(
              '⚖ FORMAL DECLARATION ⚖',
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: accentColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            GazetteDivider.simple(
              color: accentColor,
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You hereby accuse',
              style: GoogleFonts.oldStandardTt(
                fontSize: 16,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              character.name.toUpperCase(),
              style: GoogleFonts.playfairDisplay(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'of this most heinous crime.',
              style: GoogleFonts.oldStandardTt(
                fontSize: 16,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                border: Border.all(color: accentColor),
              ),
              child: Text(
                'This decision is FINAL.\nYour investigation will conclude.',
                style: GoogleFonts.oldStandardTt(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'RECONSIDER',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
                color: isDark
                    ? GazetteColors.darkTextSecondary
                    : GazetteColors.inkBrown,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitAccusation(boundCase);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'PROCEED',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boundCase = ref.watch(activeBoundCaseProvider);

    if (boundCase == null) {
      return _buildErrorState(context);
    }

    return Scaffold(
      backgroundColor:
          isDark ? GazetteColors.darkBackground : GazetteColors.newsprint,
      body: SafeArea(
        child: _hasSubmitted
            ? _buildResultsPhase(isDark, boundCase)
            : _buildAccusationPhase(isDark, boundCase),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // ACCUSATION PHASE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildAccusationPhase(bool isDark, BoundCase boundCase) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;
    final characters = boundCase.template.characters;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Back button
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: textColor),
              onPressed: () => context.pop(),
              padding: EdgeInsets.zero,
            ),
          ),

          // Header
          _buildAccusationHeader(isDark, textColor, accentColor),

          const SizedBox(height: 24),

          // Formal prompt
          GazetteCard(
            showOrnaments: true,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  'FORMAL ENQUIRY',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Having gathered the evidence and conducted your investigation, whom do you accuse of this most heinous crime?',
                  style: GoogleFonts.oldStandardTt(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Section header
          _buildSectionHeader('PERSONS OF INTEREST', isDark),

          const SizedBox(height: 16),

          // Character cards (WANTED style)
          ...characters.map((character) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _WantedCard(
                  character: character,
                  locationName: boundCase
                          .boundLocations[character.locationId]?.displayName ??
                      'Unknown',
                  isSelected: _selectedSuspect == character.id,
                  onTap: () {
                    setState(() {
                      _selectedSuspect = character.id;
                    });
                  },
                ),
              )),

          const SizedBox(height: 24),

          // Motive field
          _buildMotiveField(isDark, textColor, subtitleColor),

          const SizedBox(height: 32),

          // Submit button
          Center(
            child: GazetteButton.primary(
              text: 'Submit Accusation',
              icon: Icons.gavel,
              onPressed: _selectedSuspect != null
                  ? () => _showConfirmationDialog(boundCase)
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          // Cancel option
          Center(
            child: TextButton(
              onPressed: () => context.pop(),
              child: Text(
                'Return to Investigation',
                style: GoogleFonts.oldStandardTt(
                  fontSize: 14,
                  color: subtitleColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAccusationHeader(
      bool isDark, Color textColor, Color accentColor) {
    return Column(
      children: [
        // Decorative top
        Row(
          children: [
            Expanded(child: Container(height: 2, color: accentColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '⚖',
                style: TextStyle(fontSize: 20, color: accentColor),
              ),
            ),
            Expanded(child: Container(height: 2, color: accentColor)),
          ],
        ),
        const SizedBox(height: 16),

        // Title
        Text(
          'THE ACCUSATION',
          style: GoogleFonts.playfairDisplay(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
            color: textColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'A MOST GRAVE MATTER',
          style: GoogleFonts.oldStandardTt(
            fontSize: 14,
            letterSpacing: 2,
            color: accentColor,
          ),
        ),

        // Decorative bottom
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: Container(height: 1, color: textColor)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '◆',
                style: TextStyle(fontSize: 8, color: textColor),
              ),
            ),
            Expanded(child: Container(height: 1, color: textColor)),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, bool isDark) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;

    return Row(
      children: [
        const Expanded(child: GazetteDivider.simple()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '❧ $title ❧',
            style: GoogleFonts.playfairDisplay(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: textColor,
            ),
          ),
        ),
        const Expanded(child: GazetteDivider.simple()),
      ],
    );
  }

  Widget _buildMotiveField(
      bool isDark, Color textColor, Color subtitleColor) {
    final borderColor =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'STATE YOUR CASE (OPTIONAL)',
          style: GoogleFonts.playfairDisplay(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: subtitleColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'What was their motive?',
          style: GoogleFonts.oldStandardTt(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: subtitleColor,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? GazetteColors.darkSurface : GazetteColors.paperWhite,
            border: Border.all(color: borderColor),
          ),
          child: TextField(
            controller: _motiveController,
            maxLines: 3,
            style: GoogleFonts.specialElite(
              fontSize: 14,
              color: textColor,
            ),
            decoration: InputDecoration(
              hintText: 'Their motive was...',
              hintStyle: GoogleFonts.specialElite(
                fontSize: 14,
                color: isDark
                    ? GazetteColors.darkTextFaded
                    : GazetteColors.inkFaded,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
            ),
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // RESULTS PHASE
  // ═══════════════════════════════════════════════════════════════════════════

  Widget _buildResultsPhase(bool isDark, BoundCase boundCase) {
    if (_result == null) return const SizedBox();

    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final accentColor = _result!.isCorrect
        ? GazetteColors.success
        : (isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // EXTRA! EXTRA! Banner
          _buildExtraBanner(isDark, textColor, accentColor),

          const SizedBox(height: 24),

          // Animated reveal
          AnimatedBuilder(
            animation: _revealAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: 0.8 + (0.2 * _revealAnimation.value),
                child: Opacity(
                  opacity: _revealAnimation.value,
                  child: _buildResultCard(isDark, boundCase),
                ),
              );
            },
          ),

          // Full results (shown after animation)
          if (_showFullResults) ...[
            const SizedBox(height: 24),
            _buildScoreBreakdown(isDark, boundCase),

            const SizedBox(height: 24),
            _buildTruthRevealed(isDark, boundCase),

            if (!_result!.isCorrect) ...[
              const SizedBox(height: 24),
              _buildKeyEvidence(isDark, boundCase),
            ],

            const SizedBox(height: 32),
            _buildBottomButtons(isDark),

            const SizedBox(height: 32),
          ],
        ],
      ),
    );
  }

  Widget _buildExtraBanner(bool isDark, Color textColor, Color accentColor) {
    return Column(
      children: [
        // Top decorative border
        Container(
          height: 4,
          color: accentColor,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: isDark ? GazetteColors.darkCard : GazetteColors.parchment,
          child: Column(
            children: [
              Text(
                '✦ EXTRA! EXTRA! ✦',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'SPECIAL EDITION',
                style: GoogleFonts.oldStandardTt(
                  fontSize: 11,
                  letterSpacing: 2,
                  color: isDark
                      ? GazetteColors.darkTextSecondary
                      : GazetteColors.inkBrown,
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 2,
          color: accentColor,
        ),
      ],
    );
  }

  Widget _buildResultCard(bool isDark, BoundCase boundCase) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;

    if (_result!.isCorrect) {
      return GazetteCard(
        showOrnaments: true,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: GazetteColors.success.withOpacity(0.15),
                border: Border.all(color: GazetteColors.success, width: 3),
              ),
              child: const Icon(
                Icons.check,
                size: 48,
                color: GazetteColors.success,
              ),
            ),
            const SizedBox(height: 16),

            // CASE SOLVED banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              decoration: BoxDecoration(
                color: GazetteColors.success,
                border: Border.all(color: GazetteColors.success, width: 2),
              ),
              child: Text(
                'CASE SOLVED!',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'JUSTICE PREVAILS',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'in the matter of',
              style: GoogleFonts.oldStandardTt(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: subtitleColor,
              ),
            ),
            Text(
              boundCase.template.title.toUpperCase(),
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    } else {
      return GazetteCard(
        showOrnaments: true,
        padding: const EdgeInsets.all(24),
        borderColor:
            isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed,
        child: Column(
          children: [
            // Failure icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (isDark
                        ? GazetteColors.bloodRedLight
                        : GazetteColors.bloodRed)
                    .withOpacity(0.15),
                border: Border.all(
                  color: isDark
                      ? GazetteColors.bloodRedLight
                      : GazetteColors.bloodRed,
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.close,
                size: 48,
                color: isDark
                    ? GazetteColors.bloodRedLight
                    : GazetteColors.bloodRed,
              ),
            ),
            const SizedBox(height: 16),

            // GUILTY ESCAPES headline
            Text(
              'THE GUILTY PARTY',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                color: isDark
                    ? GazetteColors.bloodRedLight
                    : GazetteColors.bloodRed,
              ),
            ),
            Text(
              'ESCAPES!',
              style: GoogleFonts.playfairDisplay(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
                color: isDark
                    ? GazetteColors.bloodRedLight
                    : GazetteColors.bloodRed,
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Alas, your accusation was in error.',
              style: GoogleFonts.oldStandardTt(
                fontSize: 16,
                fontStyle: FontStyle.italic,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'The true perpetrator remains at large...',
              style: GoogleFonts.oldStandardTt(
                fontSize: 14,
                color: subtitleColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }
  }

  Widget _buildScoreBreakdown(bool isDark, BoundCase boundCase) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.copperplate;

    // Determine efficiency rating
    String efficiencyRating;
    if (_result!.playerVisits <= _result!.optimalVisits) {
      efficiencyRating = 'EXCELLENT';
    } else if (_result!.playerVisits <= _result!.optimalVisits + 2) {
      efficiencyRating = 'GOOD';
    } else if (_result!.playerVisits <= _result!.optimalVisits + 4) {
      efficiencyRating = 'ADEQUATE';
    } else {
      efficiencyRating = 'POOR';
    }

    return GazetteCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '─── OFFICIAL REPORT ───',
              style: GoogleFonts.playfairDisplay(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: subtitleColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          _ScoreRow(
            label: 'Locations Visited',
            value: '${_result!.playerVisits}',
            detail:
                'Scotland Yard solved it in ${_result!.optimalVisits}',
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
          const SizedBox(height: 8),
          _ScoreRow(
            label: 'Efficiency Rating',
            value: efficiencyRating,
            textColor: textColor,
            subtitleColor: subtitleColor,
            valueColor: _getEfficiencyColor(efficiencyRating, isDark),
          ),
          const SizedBox(height: 8),
          _ScoreRow(
            label: 'Essential Evidence',
            value:
                '${_result!.essentialCluesFound} of ${_result!.totalEssentialClues}',
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),

          const SizedBox(height: 16),
          const GazetteDivider.simple(),
          const SizedBox(height: 16),

          // Final score
          Row(
            children: [
              Text(
                'FINAL SCORE',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                  color: textColor,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  border: Border.all(color: accentColor, width: 2),
                ),
                child: Text(
                  '${_result!.score}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getEfficiencyColor(String rating, bool isDark) {
    switch (rating) {
      case 'EXCELLENT':
        return GazetteColors.success;
      case 'GOOD':
        return isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
      case 'ADEQUATE':
        return GazetteColors.wanted;
      case 'POOR':
        return isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;
      default:
        return isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    }
  }

  Widget _buildTruthRevealed(bool isDark, BoundCase boundCase) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.copperplate;

    // Get the perpetrator
    final perpetrator = boundCase.template.characters.firstWhere(
      (c) => c.id == _result!.correctPerpetrator,
    );
    final solution = boundCase.template.solution;

    return GazetteCard(
      showOrnaments: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              '❧ THE TRUTH REVEALED ❧',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: textColor,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // The perpetrator
          Text(
            'THE PERPETRATOR',
            style: GoogleFonts.playfairDisplay(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            perpetrator.name,
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: accentColor,
            ),
          ),
          Text(
            perpetrator.role,
            style: GoogleFonts.oldStandardTt(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: subtitleColor,
            ),
          ),

          const SizedBox(height: 16),
          const GazetteDivider.simple(),
          const SizedBox(height: 16),

          // Motive
          Text(
            'THE MOTIVE',
            style: GoogleFonts.playfairDisplay(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            solution.motive,
            style: GoogleFonts.oldStandardTt(
              fontSize: 16,
              height: 1.5,
              color: textColor,
            ),
          ),

          const SizedBox(height: 16),

          // Method
          Text(
            'THE METHOD',
            style: GoogleFonts.playfairDisplay(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            solution.method,
            style: GoogleFonts.oldStandardTt(
              fontSize: 16,
              height: 1.5,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyEvidence(bool isDark, BoundCase boundCase) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final solution = boundCase.template.solution;

    // Get key evidence clues
    final keyClues = boundCase.template.clues
        .where((c) => solution.keyEvidence.contains(c.id))
        .toList();

    return GazetteCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KEY EVIDENCE OVERLOOKED',
            style: GoogleFonts.playfairDisplay(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: isDark
                  ? GazetteColors.bloodRedLight
                  : GazetteColors.bloodRed,
            ),
          ),
          const SizedBox(height: 12),

          ...keyClues.map((clue) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.arrow_right,
                      size: 18,
                      color: subtitleColor,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            clue.title,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                          Text(
                            clue.notebookSummary,
                            style: GoogleFonts.oldStandardTt(
                              fontSize: 13,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),

          const SizedBox(height: 12),
          Center(
            child: Text(
              'Perhaps a fresh investigation is warranted?',
              style: GoogleFonts.oldStandardTt(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: subtitleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(bool isDark) {
    return Column(
      children: [
        GazetteButton.primary(
          text: 'Return to Front Page',
          icon: Icons.home,
          onPressed: () => context.go('/'),
        ),
        const SizedBox(height: 12),
        GazetteButton.outlined(
          text: 'Review Casebook',
          icon: Icons.menu_book,
          onPressed: () => context.push('/case/${widget.caseId}/notebook'),
        ),
      ],
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: const Center(
        child: Text('No active case found.'),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// WANTED CARD
// ═══════════════════════════════════════════════════════════════════════════

class _WantedCard extends StatelessWidget {
  final Character character;
  final String locationName;
  final bool isSelected;
  final VoidCallback onTap;

  const _WantedCard({
    required this.character,
    required this.locationName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? GazetteColors.darkCard : GazetteColors.parchment;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;
    final borderColor = isSelected
        ? accentColor
        : (isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(
            color: borderColor,
            width: isSelected ? 3 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: accentColor.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            // WANTED header (only when selected)
            if (isSelected)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: accentColor,
                child: Text(
                  '★ ACCUSED ★',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 2,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Portrait frame
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? accentColor : borderColor,
                        width: 2,
                      ),
                      color: isDark
                          ? GazetteColors.darkSurface
                          : GazetteColors.newsprint,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 32,
                      color: isSelected ? accentColor : subtitleColor,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Details
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
                            color: isSelected ? accentColor : textColor,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          character.role,
                          style: GoogleFonts.oldStandardTt(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: subtitleColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                              color: subtitleColor,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                locationName,
                                style: GoogleFonts.oldStandardTt(
                                  fontSize: 11,
                                  color: subtitleColor,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Selection indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? accentColor : borderColor,
                        width: 2,
                      ),
                      color: isSelected ? accentColor : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SCORE ROW
// ═══════════════════════════════════════════════════════════════════════════

class _ScoreRow extends StatelessWidget {
  final String label;
  final String value;
  final String? detail;
  final Color textColor;
  final Color subtitleColor;
  final Color? valueColor;

  const _ScoreRow({
    required this.label,
    required this.value,
    this.detail,
    required this.textColor,
    required this.subtitleColor,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.oldStandardTt(
                  fontSize: 14,
                  color: textColor,
                ),
              ),
              if (detail != null)
                Text(
                  detail!,
                  style: GoogleFonts.oldStandardTt(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: subtitleColor,
                  ),
                ),
            ],
          ),
        ),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: valueColor ?? textColor,
          ),
        ),
      ],
    );
  }
}
