import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/cases/vanishing_violinist.dart';
import '../widgets/common/gazette_button.dart';
import '../widgets/common/gazette_card.dart';
import '../widgets/common/gazette_divider.dart';
import '../widgets/common/gazette_header.dart';

/// Screen for submitting a solution and seeing the score.
class SolutionScreen extends ConsumerStatefulWidget {
  final String caseId;

  const SolutionScreen({
    super.key,
    required this.caseId,
  });

  @override
  ConsumerState<SolutionScreen> createState() => _SolutionScreenState();
}

class _SolutionScreenState extends ConsumerState<SolutionScreen> {
  String? _selectedSuspect;
  bool _hasSubmitted = false;
  bool _isCorrect = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Accusation'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _hasSubmitted ? _buildResultView() : _buildAccusationView(),
        ),
      ),
    );
  }

  Widget _buildAccusationView() {
    final characters = vanishingViolinistCase.characters;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const GazetteHeader.major(
          text: 'The Accusation',
          subtitle: 'Who is responsible for this crime?',
        ),
        const SizedBox(height: 24),

        // Warning text
        GazetteCard(
          backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Once you make an accusation, your investigation will conclude. '
                  'Choose wisely!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const GazetteDivider.ends(),
        const SizedBox(height: 16),

        const GazetteHeader.minor(
          text: 'Select the Perpetrator',
        ),
        const SizedBox(height: 12),

        // Suspect list
        ...characters.map((character) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: _SuspectOption(
            name: character.name,
            role: character.role,
            isSelected: _selectedSuspect == character.id,
            onTap: () {
              setState(() {
                _selectedSuspect = character.id;
              });
            },
          ),
        )),

        const SizedBox(height: 24),
        const GazetteDivider.simple(),
        const SizedBox(height: 24),

        // Submit button
        Center(
          child: GazetteButton(
            text: 'Submit Accusation',
            icon: Icons.gavel,
            onPressed: _selectedSuspect != null
                ? () {
                    setState(() {
                      _hasSubmitted = true;
                      _isCorrect = _selectedSuspect ==
                          vanishingViolinistCase.solution.perpetratorId;
                    });
                  }
                : null,
          ),
        ),
      ],
    );
  }

  Widget _buildResultView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Result header
        GazetteCard(
          showOrnaments: true,
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                _isCorrect ? Icons.check_circle : Icons.cancel,
                size: 64,
                color: _isCorrect
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                _isCorrect ? 'CASE SOLVED!' : 'CASE UNSOLVED',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      letterSpacing: 2.0,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                _isCorrect
                    ? 'Your deduction was correct!'
                    : 'Your accusation was incorrect.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        const GazetteDivider(),
        const SizedBox(height: 16),

        // Score card
        const GazetteHeader.minor(
          text: 'Investigation Summary',
        ),
        const SizedBox(height: 12),

        GazetteCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _ScoreRow(
                label: 'Base Score',
                value: _isCorrect ? '+100' : '+0',
              ),
              const Divider(),
              _ScoreRow(
                label: 'Locations Visited',
                value: '3',
                detail: 'Par: 4',
              ),
              _ScoreRow(
                label: 'Efficiency Bonus',
                value: '+10',
              ),
              const Divider(),
              _ScoreRow(
                label: 'Essential Clues',
                value: '5/7',
              ),
              _ScoreRow(
                label: 'Evidence Bonus',
                value: '+25',
              ),
              const Divider(height: 24),
              _ScoreRow(
                label: 'TOTAL SCORE',
                value: _isCorrect ? '135' : '35',
                isBold: true,
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // The truth revealed
        const GazetteHeader.minor(
          text: 'The Truth Revealed',
        ),
        const SizedBox(height: 12),

        GazetteCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'The Perpetrator',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: 1.0,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                'Erik Lindgren',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Motive',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: 1.0,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                vanishingViolinistCase.solution.motive,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              Text(
                'Method',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: 1.0,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                vanishingViolinistCase.solution.method,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Return home button
        Center(
          child: GazetteButton(
            text: 'Return to Cases',
            icon: Icons.home,
            onPressed: () => context.go('/'),
          ),
        ),
      ],
    );
  }
}

class _SuspectOption extends StatelessWidget {
  final String name;
  final String role;
  final bool isSelected;
  final VoidCallback onTap;

  const _SuspectOption({
    required this.name,
    required this.role,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GazetteCard(
      padding: EdgeInsets.zero,
      borderColor: isSelected
          ? Theme.of(context).colorScheme.primary
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: isSelected ? true : null,
                onChanged: (_) => onTap(),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 20,
                child: Text(name[0]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 16,
                          ),
                    ),
                    Text(
                      role,
                      style: Theme.of(context).textTheme.bodySmall,
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
}

class _ScoreRow extends StatelessWidget {
  final String label;
  final String value;
  final String? detail;
  final bool isBold;

  const _ScoreRow({
    required this.label,
    required this.value,
    this.detail,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: isBold
                  ? Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 16,
                      )
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (detail != null) ...[
            Text(
              detail!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 16),
          ],
          Text(
            value,
            style: isBold
                ? Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                    )
                : Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
