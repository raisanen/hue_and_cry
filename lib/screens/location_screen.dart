import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/common/gazette_button.dart';
import '../widgets/common/gazette_card.dart';
import '../widgets/common/gazette_divider.dart';
import '../widgets/common/gazette_header.dart';

/// Screen showing location details, clues, and NPC dialogue.
class LocationScreen extends ConsumerWidget {
  final String caseId;
  final String locationId;

  const LocationScreen({
    super.key,
    required this.caseId,
    required this.locationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Get actual location and clues from providers
    final locationName = _getLocationName(locationId);

    return Scaffold(
      appBar: AppBar(
        title: Text(locationName),
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
              // Location header
              GazetteCard(
                showOrnaments: true,
                child: Column(
                  children: [
                    GazetteHeader.major(
                      text: locationName,
                      subtitle: 'You have arrived at this location',
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _getLocationDescription(locationId),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const GazetteDivider.ends(),

              // Available clues section
              const SizedBox(height: 16),
              const GazetteHeader.minor(
                text: 'Available Clues',
              ),
              const SizedBox(height: 12),

              // Placeholder clue card
              GazetteCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.search, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'A Curious Discovery',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to examine this clue and add it to your notebook.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 12),
                    GazetteButton.outlined(
                      text: 'Examine',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Clue added to notebook!'),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const GazetteDivider.ends(),

              // Characters section
              const SizedBox(height: 16),
              const GazetteHeader.minor(
                text: 'Present at this Location',
              ),
              const SizedBox(height: 12),

              // Placeholder character card
              GazetteCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          child: const Icon(Icons.person, color: Colors.white),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'A Helpful Witness',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Local resident',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const GazetteDivider.simple(height: 12),
                    Text(
                      '"Good day to you! I may have seen something that could help with your investigation..."',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Back to map button
              Center(
                child: GazetteButton.outlined(
                  text: 'Return to Map',
                  icon: Icons.map,
                  onPressed: () => context.pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLocationName(String id) {
    // Map location IDs to display names
    const names = {
      'cafe_practice': 'The Corner Café',
      'orchestra_hall': 'Concert Hall',
      'husband_office': 'Insurance Office',
      'park_meeting': 'Victoria Park',
      'police_station': 'Police Station',
      'rival_apartment': 'Riverside Apartments',
      'antique_shop': 'Antique Emporium',
    };
    return names[id] ?? 'Unknown Location';
  }

  String _getLocationDescription(String id) {
    const descriptions = {
      'cafe_practice': 'A cozy establishment where local musicians often gather.',
      'orchestra_hall': 'The prestigious concert venue where Maria performed.',
      'husband_office': 'The offices of Lindgren & Associates Insurance.',
      'park_meeting': 'A quiet park with winding paths and secluded benches.',
      'police_station': 'The local constabulary, staffed day and night.',
      'rival_apartment': 'An upscale apartment building near the river.',
      'antique_shop': 'A dusty shop filled with curiosities from ages past.',
    };
    return descriptions[id] ?? 'A location of interest in this investigation.';
  }
}
