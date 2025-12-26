import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../models/bound_case.dart';
import '../models/character.dart';
import '../models/clue.dart';
import '../providers/game_state_provider.dart';
import '../providers/location_provider.dart';
import '../theme/gazette_colors.dart';
import '../utils/geo_utils.dart';
import '../utils/text_interpolation.dart';
import '../widgets/case/character_card.dart';
import '../widgets/case/clue_card.dart';
import '../widgets/case/evidence_modal.dart';
import '../widgets/common/gazette_button.dart';
import '../widgets/common/gazette_card.dart';
import '../widgets/common/gazette_divider.dart';

/// Screen showing location details, clues, and NPC dialogue.
class LocationScreen extends ConsumerStatefulWidget {
  final String caseId;
  final String locationId;

  const LocationScreen({
    super.key,
    required this.caseId,
    required this.locationId,
  });

  @override
  ConsumerState<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends ConsumerState<LocationScreen>
    with SingleTickerProviderStateMixin {
  bool _showDiscoveryFeedback = false;
  String _discoveryMessage = '';
  List<String> _revealedLocations = [];

  late AnimationController _feedbackController;
  late Animation<double> _feedbackOpacity;

  @override
  void initState() {
    super.initState();
    _feedbackController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _feedbackOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _feedbackController,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
        reverseCurve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _showFeedback(String message, List<String> revealed) {
    setState(() {
      _showDiscoveryFeedback = true;
      _discoveryMessage = message;
      _revealedLocations = revealed;
    });

    _feedbackController.forward().then((_) {
      _feedbackController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _showDiscoveryFeedback = false;
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boundCase = ref.watch(activeBoundCaseProvider);
    final gameState = ref.watch(activeGameStateProvider);
    final locationState = ref.watch(locationStateProvider);
    final gameService = ref.watch(gameServiceProvider);

    if (boundCase == null || gameState == null) {
      return _buildErrorState(context, 'No active case found.');
    }

    final boundLocation = boundCase.boundLocations[widget.locationId];
    final templateLocation =
        boundCase.template.locations[widget.locationId];

    if (boundLocation == null || templateLocation == null) {
      return _buildErrorState(context, 'Location not found.');
    }

    // Calculate distance
    final playerPos = locationState.currentPosition;
    final locationPos = LatLng(boundLocation.poi.lat, boundLocation.poi.lon);
    final distance =
        playerPos != null ? haversineDistance(playerPos, locationPos) : null;
    final isInRange = distance != null && distance <= visitRadiusMeters;

    // Get available clues and characters at this location
    final availableClues = gameService.getAvailableClues(
      gameState,
      widget.locationId,
      boundCase,
    );
    final discoveredClues = boundCase.template.clues
        .where((c) =>
            c.locationId == widget.locationId &&
            gameState.discoveredClues.contains(c.id))
        .toList();
    final characters = boundCase.template.characters
        .where((c) => c.locationId == widget.locationId)
        .toList();

    // Interpolate description
    final description = interpolateLocationText(
      templateLocation.descriptionTemplate,
      boundCase.boundLocations,
    );

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // App bar
              _buildAppBar(isDark, boundLocation.displayName),

              // Content
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // Location header
                    _buildLocationHeader(
                      isDark,
                      boundLocation,
                      description,
                      distance,
                      isInRange,
                    ),

                    const SizedBox(height: 24),

                    // Content based on range
                    if (isInRange) ...[
                      // Evidence section
                      _buildEvidenceSection(
                        isDark,
                        availableClues,
                        discoveredClues,
                        boundCase,
                      ),

                      // Characters section
                      if (characters.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _buildCharactersSection(
                          isDark,
                          characters,
                          boundCase,
                          gameState.discoveredClues,
                          availableClues,
                        ),
                      ],
                    ] else ...[
                      // Too far message
                      _buildTooFarMessage(isDark, distance),
                    ],

                    const SizedBox(height: 32),

                    // Return to map button
                    Center(
                      child: GazetteButton.outlined(
                        text: 'Return to Map',
                        icon: Icons.map,
                        onPressed: () => context.pop(),
                      ),
                    ),

                    const SizedBox(height: 32),
                  ]),
                ),
              ),
            ],
          ),

          // Discovery feedback overlay
          if (_showDiscoveryFeedback)
            _buildDiscoveryFeedback(isDark),
        ],
      ),
    );
  }

  Widget _buildAppBar(bool isDark, String locationName) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 0,
      backgroundColor:
          isDark ? GazetteColors.darkBackground : GazetteColors.parchment,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: isDark ? GazetteColors.darkText : GazetteColors.inkBlack,
        ),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'LOCATION REPORT',
        style: GoogleFonts.playfairDisplay(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
          color: isDark ? GazetteColors.darkText : GazetteColors.inkBlack,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildLocationHeader(
    bool isDark,
    BoundLocation boundLocation,
    String description,
    double? distance,
    bool isInRange,
  ) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;

    // Distance in yards
    final distanceYards = distance != null ? (distance * 1.09361).round() : 0;

    return GazetteCard(
      showOrnaments: true,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Arrival banner
          if (isInRange)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: GazetteColors.success.withOpacity(0.15),
                border: Border.all(color: GazetteColors.success),
              ),
              child: Text(
                '✓ YOU HAVE ARRIVED',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: GazetteColors.success,
                ),
                textAlign: TextAlign.center,
              ),
            ),

          // Location name
          Text(
            boundLocation.displayName.toUpperCase(),
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // POI type from OSM tags
          if (boundLocation.poi.osmTags.isNotEmpty)
            Text(
              _getPoiTypeLabel(boundLocation.poi.osmTags),
              style: GoogleFonts.oldStandardTt(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: subtitleColor,
              ),
            ),

          const SizedBox(height: 12),
          GazetteDivider.simple(
            color: isDark
                ? GazetteColors.darkTextFaded
                : GazetteColors.inkFaded,
          ),
          const SizedBox(height: 12),

          // Description
          Text(
            description,
            style: GoogleFonts.oldStandardTt(
              fontSize: 14,
              height: 1.5,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Distance indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.straighten,
                size: 16,
                color: isInRange ? GazetteColors.success : accentColor,
              ),
              const SizedBox(width: 6),
              Text(
                'DISTANCE: ${distance != null ? "$distanceYards yards" : "Unknown"}',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                  color: isInRange ? GazetteColors.success : accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvidenceSection(
    bool isDark,
    List<Clue> availableClues,
    List<Clue> discoveredClues,
    BoundCase boundCase,
  ) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;

    final allClues = [...availableClues, ...discoveredClues];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            const SizedBox(
              width: 20,
              child: GazetteDivider.simple(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '❧ EVIDENCE ❧',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: textColor,
                ),
              ),
            ),
            const Expanded(child: GazetteDivider.simple()),
          ],
        ),
        const SizedBox(height: 16),

        if (allClues.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No evidence to be found here at present.',
                style: GoogleFonts.oldStandardTt(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: subtitleColor,
                ),
              ),
            ),
          )
        else
          ...allClues.map((clue) {
            final isDiscovered = discoveredClues.contains(clue);
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: ClueCard(
                clue: clue,
                isDiscovered: isDiscovered,
                onExamine: isDiscovered
                    ? null
                    : () => _examineClue(clue, boundCase),
              ),
            );
          }),
      ],
    );
  }

  Widget _buildCharactersSection(
    bool isDark,
    List<Character> characters,
    BoundCase boundCase,
    Set<String> discoveredClueIds,
    List<Clue> availableClues,
  ) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final gameService = ref.read(gameServiceProvider);
    final gameState = ref.read(activeGameStateProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            const SizedBox(
              width: 20,
              child: GazetteDivider.simple(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                '❧ PERSONS OF INTEREST ❧',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: textColor,
                ),
              ),
            ),
            const Expanded(child: GazetteDivider.simple()),
          ],
        ),
        const SizedBox(height: 16),

        ...characters.map((character) {
          // Get appropriate dialogue
          final dialogue = gameState != null
              ? gameService.getCharacterDialogue(gameState, character)
              : character.initialDialogue;

          // Check if character has a testimony clue available
          final testimonyClue = availableClues
              .where((c) =>
                  c.characterId == character.id &&
                  c.type == ClueType.testimony)
              .firstOrNull;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: CharacterCard(
              character: character,
              dialogue: interpolateLocationText(
                dialogue,
                boundCase.boundLocations,
              ),
              hasTestimony: testimonyClue != null,
              onNoteTestimony: testimonyClue != null
                  ? () => _examineClue(testimonyClue, boundCase)
                  : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTooFarMessage(bool isDark, double? distance) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;

    final distanceYards = distance != null ? (distance * 1.09361).round() : 0;

    return GazetteCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(
            Icons.directions_walk,
            size: 48,
            color: accentColor,
          ),
          const SizedBox(height: 16),
          Text(
            'TOO DISTANT',
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: accentColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'You are $distanceYards yards distant from this location.',
            style: GoogleFonts.oldStandardTt(
              fontSize: 14,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'You must draw nearer to conduct your enquiries.',
            style: GoogleFonts.oldStandardTt(
              fontSize: 13,
              fontStyle: FontStyle.italic,
              color: subtitleColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          _buildCompassHint(isDark, subtitleColor),
        ],
      ),
    );
  }

  Widget _buildCompassHint(bool isDark, Color subtitleColor) {
    // Simple direction hint
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.navigation,
          size: 16,
          color: subtitleColor,
        ),
        const SizedBox(width: 6),
        Text(
          'Proceed toward this location',
          style: GoogleFonts.oldStandardTt(
            fontSize: 11,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscoveryFeedback(bool isDark) {
    final bgColor = isDark ? GazetteColors.darkCard : GazetteColors.parchment;
    final borderColor = GazetteColors.success;

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: _feedbackOpacity,
        builder: (context, child) {
          return IgnorePointer(
            ignoring: !_showDiscoveryFeedback,
            child: Container(
              color: Colors.black.withOpacity(0.5 * _feedbackOpacity.value),
              child: Center(
                child: Transform.scale(
                  scale: 0.9 + (0.1 * _feedbackOpacity.value),
                  child: Opacity(
                    opacity: _feedbackOpacity.value,
                    child: Container(
                      margin: const EdgeInsets.all(32),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(color: borderColor, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 48,
                            color: borderColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _discoveryMessage,
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: borderColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          if (_revealedLocations.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              'NEW LOCATION DISCOVERED!',
                              style: GoogleFonts.playfairDisplay(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1,
                                color: GazetteColors.wanted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Text(message),
      ),
    );
  }

  Future<void> _examineClue(Clue clue, BoundCase boundCase) async {
    // Get revealed location names
    final revealedNames = clue.reveals
        .map((id) => boundCase.boundLocations[id]?.displayName)
        .whereType<String>()
        .toList();

    // Show evidence modal
    final added = await EvidenceModal.show(
      context,
      clue: clue,
      revealedLocationNames: revealedNames,
      onAddToCasebook: () {
        // Discover the clue
        ref.read(activeGameStateProvider.notifier).discoverClue(
              clue.id,
              boundCase,
            );
      },
    );

    if (added == true && mounted) {
      // Show feedback
      _showFeedback(
        clue.type == ClueType.testimony ? 'TESTIMONY NOTED!' : 'EVIDENCE SECURED!',
        revealedNames,
      );
    }
  }

  String _getPoiTypeLabel(Map<String, String> osmTags) {
    // Extract a human-readable type from OSM tags
    final amenity = osmTags['amenity'];
    final shop = osmTags['shop'];
    final leisure = osmTags['leisure'];
    final tourism = osmTags['tourism'];

    if (amenity != null) {
      return _formatOsmValue(amenity);
    } else if (shop != null) {
      return '${_formatOsmValue(shop)} Shop';
    } else if (leisure != null) {
      return _formatOsmValue(leisure);
    } else if (tourism != null) {
      return _formatOsmValue(tourism);
    }

    return 'Point of Interest';
  }

  String _formatOsmValue(String value) {
    // Convert snake_case to Title Case
    return value
        .split('_')
        .map((word) =>
            word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1)}' : '')
        .join(' ');
  }
}
