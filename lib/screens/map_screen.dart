import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../theme/gazette_colors.dart';
import '../widgets/common/gazette_header.dart';

/// The main gameplay map screen.
class MapScreen extends ConsumerWidget {
  final String caseId;

  const MapScreen({
    super.key,
    required this.caseId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investigation'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => context.go('/'),
          tooltip: 'Return Home',
        ),
        actions: [
          // Notebook button
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () => context.push('/case/$caseId/notebook'),
            tooltip: 'Notebook',
          ),
          // Solve button
          IconButton(
            icon: const Icon(Icons.gavel),
            onPressed: () => context.push('/case/$caseId/solve'),
            tooltip: 'Make Accusation',
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map placeholder
          Container(
            color: Theme.of(context).brightness == Brightness.dark
                ? GazetteColors.darkSurface
                : GazetteColors.newsprint,
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 64),
                  SizedBox(height: 16),
                  GazetteHeader(
                    text: 'Map View',
                    showDividers: false,
                  ),
                  SizedBox(height: 8),
                  Text('flutter_map will be integrated here'),
                ],
              ),
            ),
          ),

          // Demo location buttons at bottom
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Demo Locations',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _LocationChip(
                          label: 'Café',
                          onTap: () => context.push(
                            '/case/$caseId/location/cafe_practice',
                          ),
                        ),
                        _LocationChip(
                          label: 'Park',
                          onTap: () => context.push(
                            '/case/$caseId/location/park_meeting',
                          ),
                        ),
                        _LocationChip(
                          label: 'Police',
                          onTap: () => context.push(
                            '/case/$caseId/location/police_station',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _LocationChip({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}
