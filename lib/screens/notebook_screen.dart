import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/common/gazette_card.dart';
import '../widgets/common/gazette_divider.dart';
import '../widgets/common/gazette_header.dart';

/// Screen showing collected clues and notes.
class NotebookScreen extends ConsumerWidget {
  final String caseId;

  const NotebookScreen({
    super.key,
    required this.caseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get actual clues from game state provider

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detective Notebook'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              const GazetteMasthead(showSubtitle: false),
              const SizedBox(height: 8),
              Text(
                'EVIDENCE & OBSERVATIONS',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      letterSpacing: 2.0,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const GazetteDivider(),

              // Stats summary
              const SizedBox(height: 16),
              GazetteCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(
                      value: '3',
                      label: 'Locations\nVisited',
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Theme.of(context).dividerColor,
                    ),
                    _StatColumn(
                      value: '5',
                      label: 'Clues\nFound',
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: Theme.of(context).dividerColor,
                    ),
                    _StatColumn(
                      value: '2',
                      label: 'Witnesses\nInterviewed',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const GazetteHeader.minor(
                text: 'Collected Evidence',
              ),
              const SizedBox(height: 12),

              // Placeholder clue entries
              _ClueEntry(
                title: 'Torn Concert Ticket',
                type: 'Physical Evidence',
                summary: 'A ticket stub for last Tuesday\'s performance, found near the park bench.',
                location: 'Victoria Park',
              ),
              const SizedBox(height: 12),

              _ClueEntry(
                title: 'Witness Statement',
                type: 'Testimony',
                summary: 'The barista recalls Maria seeming distressed during her last visit.',
                location: 'The Corner Café',
              ),
              const SizedBox(height: 12),

              _ClueEntry(
                title: 'Insurance Policy',
                type: 'Document',
                summary: 'A substantial life insurance policy was taken out recently.',
                location: 'Insurance Office',
              ),

              const SizedBox(height: 24),
              const GazetteDivider.ends(),
              const SizedBox(height: 16),

              Text(
                'Continue investigating to uncover more clues...',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;

  const _StatColumn({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 28,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ClueEntry extends StatelessWidget {
  final String title;
  final String type;
  final String summary;
  final String location;

  const _ClueEntry({
    required this.title,
    required this.type,
    required this.summary,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    return GazetteCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconForType(type),
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontSize: 16,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            type.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  letterSpacing: 1.0,
                  fontSize: 10,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            summary,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.location_on,
                size: 14,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(String type) {
    switch (type.toLowerCase()) {
      case 'physical evidence':
        return Icons.search;
      case 'testimony':
        return Icons.record_voice_over;
      case 'document':
        return Icons.description;
      case 'observation':
        return Icons.visibility;
      default:
        return Icons.info;
    }
  }
}
