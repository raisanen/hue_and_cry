import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/cases/vanishing_violinist.dart';
import '../providers/theme_provider.dart';
import '../widgets/common/gazette_button.dart';
import '../widgets/common/gazette_card.dart';
import '../widgets/common/gazette_divider.dart';
import '../widgets/common/gazette_header.dart';

/// The home screen showing available cases to play.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Theme toggle row
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  icon: Icon(
                    isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    size: 20,
                  ),
                  tooltip: isDarkMode ? 'Switch to light theme' : 'Switch to dark theme',
                  onPressed: () {
                    ref.read(themeModeProvider.notifier).state = 
                        isDarkMode ? ThemeMode.light : ThemeMode.dark;
                  },
                ),
              ),
              // Masthead
              const GazetteMasthead(),
              const SizedBox(height: 32),
              const GazetteDivider(),
              const SizedBox(height: 24),

              // Available Cases section
              const GazetteHeader(
                text: 'Available Investigations',
                major: false,
                showDividers: false,
              ),
              const SizedBox(height: 16),

              // Case card - The Vanishing Violinist
              _CaseCard(
                title: vanishingViolinistCase.title,
                subtitle: vanishingViolinistCase.subtitle,
                difficulty: vanishingViolinistCase.difficulty,
                estimatedMinutes: vanishingViolinistCase.estimatedMinutes,
                onTap: () {
                  context.push('/case/${vanishingViolinistCase.id}/setup');
                },
              ),

              const SizedBox(height: 32),
              const GazetteDivider.ends(),
              const SizedBox(height: 16),

              // Footer text
              Text(
                'More cases coming soon...',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A card displaying case information.
class _CaseCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final int difficulty;
  final int estimatedMinutes;
  final VoidCallback onTap;

  const _CaseCard({
    required this.title,
    required this.subtitle,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GazetteCard(
      showOrnaments: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontSize: 20,
                  letterSpacing: 1.5,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtitle
          Text(
            subtitle,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 14,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),

          const GazetteDivider.simple(height: 16),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StatItem(
                label: 'Difficulty',
                value: '★' * difficulty + '☆' * (5 - difficulty),
              ),
              _StatItem(
                label: 'Duration',
                value: '~$estimatedMinutes min',
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Start button
          Center(
            child: GazetteButton(
              text: 'Begin Investigation',
              onPressed: onTap,
              icon: Icons.search,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                letterSpacing: 1.0,
                fontSize: 10,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
