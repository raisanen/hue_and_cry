import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/bound_case.dart';
import '../models/character.dart';
import '../models/clue.dart';
import '../providers/game_state_provider.dart';
import '../theme/gazette_colors.dart';
import '../widgets/common/gazette_button.dart';
import '../widgets/common/gazette_card.dart';
import '../widgets/common/gazette_divider.dart';

/// Screen showing collected clues, locations, and characters as a casebook.
class NotebookScreen extends ConsumerStatefulWidget {
  final String caseId;

  const NotebookScreen({
    super.key,
    required this.caseId,
  });

  @override
  ConsumerState<NotebookScreen> createState() => _NotebookScreenState();
}

class _NotebookScreenState extends ConsumerState<NotebookScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final boundCase = ref.watch(activeBoundCaseProvider);
    final gameState = ref.watch(activeGameStateProvider);

    if (boundCase == null || gameState == null) {
      return _buildErrorState(context);
    }

    // Gather data
    final discoveredClues = boundCase.template.clues
        .where((c) => gameState.discoveredClues.contains(c.id))
        .toList();

    final unlockedLocations = boundCase.boundLocations.entries
        .where((e) =>
            gameState.unlockedLocations.contains(e.key) ||
            boundCase.template.locations[e.key]?.required == true ||
            !_hasPrerequisites(e.key, boundCase))
        .toList();

    final encounteredCharacters = boundCase.template.characters
        .where((c) => gameState.visitedLocations.contains(c.locationId))
        .toList();

    return Scaffold(
      backgroundColor:
          isDark ? GazetteColors.darkBackground : GazetteColors.newsprint,
      body: Column(
        children: [
          // Custom header
          _buildHeader(context, isDark),

          // Stats bar
          _buildStatsBar(
            isDark,
            discoveredClues.length,
            boundCase.template.clues.length,
            gameState.visitedLocations.length,
            boundCase.boundLocations.length,
            encounteredCharacters.length,
          ),

          // Tab bar
          _buildTabBar(isDark),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Evidence tab
                _EvidenceTab(
                  clues: discoveredClues,
                  boundCase: boundCase,
                ),

                // Locations tab
                _LocationsTab(
                  boundCase: boundCase,
                  visitedLocations: gameState.visitedLocations,
                  unlockedLocations: gameState.unlockedLocations,
                  cluesByLocation: _groupCluesByLocation(discoveredClues),
                ),

                // Persons tab
                _PersonsTab(
                  characters: encounteredCharacters,
                  boundCase: boundCase,
                  discoveredClueIds: gameState.discoveredClues,
                ),
              ],
            ),
          ),

          // Bottom buttons
          _buildBottomButtons(context, isDark),
        ],
      ),
    );
  }

  bool _hasPrerequisites(String locationId, BoundCase boundCase) {
    // Check if any clue reveals this location
    return boundCase.template.clues.any((c) => c.reveals.contains(locationId));
  }

  Map<String, List<Clue>> _groupCluesByLocation(List<Clue> clues) {
    final map = <String, List<Clue>>{};
    for (final clue in clues) {
      map.putIfAbsent(clue.locationId, () => []).add(clue);
    }
    return map;
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;

    return SafeArea(
      bottom: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: isDark ? GazetteColors.darkCard : GazetteColors.parchment,
          border: Border(
            bottom: BorderSide(
              color:
                  isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            // Back button row
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: textColor),
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 8),

            // Decorative top rule
            Row(
              children: [
                Expanded(
                  child: Container(height: 2, color: textColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '❧',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
                Expanded(
                  child: Container(height: 2, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(
              'YOUR CASEBOOK',
              style: GoogleFonts.playfairDisplay(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 3,
                color: textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'EVIDENCE & OBSERVATIONS',
              style: GoogleFonts.oldStandardTt(
                fontSize: 11,
                letterSpacing: 2,
                color: isDark
                    ? GazetteColors.darkTextSecondary
                    : GazetteColors.inkBrown,
              ),
            ),

            // Decorative bottom rule
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(height: 1, color: textColor),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    '◆',
                    style: TextStyle(fontSize: 8, color: textColor),
                  ),
                ),
                Expanded(
                  child: Container(height: 1, color: textColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsBar(
    bool isDark,
    int cluesFound,
    int totalClues,
    int locationsVisited,
    int totalLocations,
    int personsEncountered,
  ) {
    final bgColor = isDark ? GazetteColors.darkSurface : GazetteColors.paperWhite;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final dividerColor =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkFaded;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: bgColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            value: '$cluesFound/$totalClues',
            label: 'CLUES',
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
          Container(width: 1, height: 30, color: dividerColor),
          _StatItem(
            value: '$locationsVisited/$totalLocations',
            label: 'LOCATIONS',
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
          Container(width: 1, height: 30, color: dividerColor),
          _StatItem(
            value: '$personsEncountered',
            label: 'PERSONS',
            textColor: textColor,
            subtitleColor: subtitleColor,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    final selectedColor =
        isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final unselectedColor =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkFaded;
    final indicatorColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? GazetteColors.darkCard : GazetteColors.parchment,
        border: Border(
          bottom: BorderSide(
            color:
                isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown,
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: selectedColor,
        unselectedLabelColor: unselectedColor,
        indicatorColor: indicatorColor,
        indicatorWeight: 3,
        labelStyle: GoogleFonts.playfairDisplay(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
        unselectedLabelStyle: GoogleFonts.playfairDisplay(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.5,
        ),
        tabs: const [
          Tab(text: '❧ EVIDENCE'),
          Tab(text: '❧ LOCATIONS'),
          Tab(text: '❧ PERSONS'),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? GazetteColors.darkCard : GazetteColors.parchment,
        border: Border(
          top: BorderSide(
            color:
                isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: GazetteButton.outlined(
                text: 'Return to Map',
                icon: Icons.map,
                onPressed: () => context.pop(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GazetteButton.primary(
                text: 'Make Accusation',
                icon: Icons.gavel,
                  onPressed: () {
                    context.push('/case/${widget.caseId}/solve');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Casebook'),
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
// STAT ITEM
// ═══════════════════════════════════════════════════════════════════════════

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color textColor;
  final Color subtitleColor;

  const _StatItem({
    required this.value,
    required this.label,
    required this.textColor,
    required this.subtitleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.oldStandardTt(
            fontSize: 9,
            letterSpacing: 1,
            color: subtitleColor,
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// EVIDENCE TAB
// ═══════════════════════════════════════════════════════════════════════════

class _EvidenceTab extends StatelessWidget {
  final List<Clue> clues;
  final BoundCase boundCase;

  const _EvidenceTab({
    required this.clues,
    required this.boundCase,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (clues.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: clues.length,
      itemBuilder: (context, index) {
        final clue = clues[index];
        // Slight random rotation for "pasted clipping" effect
        final rotation = (index % 3 - 1) * 0.02;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Transform.rotate(
            angle: rotation,
            child: _ClippingCard(
              clue: clue,
              locationName:
                  boundCase.boundLocations[clue.locationId]?.displayName ??
                      'Unknown',
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    final textColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.content_paste_off,
              size: 48,
              color: textColor,
            ),
            const SizedBox(height: 16),
            Text(
              'NO EVIDENCE COLLECTED',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Visit locations to gather clues\nfor your investigation.',
              style: GoogleFonts.oldStandardTt(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// CLIPPING CARD (styled as newspaper clipping pasted in casebook)
// ═══════════════════════════════════════════════════════════════════════════

class _ClippingCard extends StatefulWidget {
  final Clue clue;
  final String locationName;

  const _ClippingCard({
    required this.clue,
    required this.locationName,
  });

  @override
  State<_ClippingCard> createState() => _ClippingCardState();
}

class _ClippingCardState extends State<_ClippingCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? GazetteColors.darkCard : GazetteColors.paperWhite;
    final borderColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: borderColor, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header with type icon and title
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: borderColor, width: 1),
                ),
              ),
              child: Row(
                children: [
                  // Type icon
                  _ClueTypeIcon(type: widget.clue.type, isDark: isDark),
                  const SizedBox(width: 10),

                  // Title as mini-headline
                  Expanded(
                    child: Text(
                      widget.clue.title.toUpperCase(),
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: textColor,
                      ),
                    ),
                  ),

                  // Expand indicator
                  Icon(
                    _expanded ? Icons.expand_less : Icons.expand_more,
                    size: 20,
                    color: subtitleColor,
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type label and location
                  Row(
                    children: [
                      Text(
                        _clueTypeLabel(widget.clue.type).toUpperCase(),
                        style: GoogleFonts.oldStandardTt(
                          fontSize: 9,
                          letterSpacing: 1,
                          fontWeight: FontWeight.w600,
                          color: accentColor,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: subtitleColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.locationName,
                        style: GoogleFonts.oldStandardTt(
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Summary or full text
                  Text(
                    _expanded
                        ? widget.clue.discoveryText
                        : widget.clue.notebookSummary,
                    style: GoogleFonts.oldStandardTt(
                      fontSize: 12,
                      height: 1.5,
                      color: textColor,
                    ),
                  ),

                  // Handwritten annotation (only when expanded)
                  if (_expanded) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: accentColor,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        _getAnnotation(widget.clue),
                        style: GoogleFonts.specialElite(
                          fontSize: 11,
                          color: isDark
                              ? GazetteColors.darkTextSecondary
                              : GazetteColors.copperplate,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAnnotation(Clue clue) {
    if (clue.isRedHerring) {
      return 'Note: This may be a false lead...';
    } else if (clue.isEssential) {
      return 'Important! This seems crucial to the case.';
    } else if (clue.reveals.isNotEmpty) {
      return 'This has revealed a new line of enquiry.';
    }
    return 'Noted for the record.';
  }

  String _clueTypeLabel(ClueType type) {
    switch (type) {
      case ClueType.physical:
        return 'Physical Evidence';
      case ClueType.testimony:
        return 'Testimony';
      case ClueType.observation:
        return 'Observation';
      case ClueType.record:
        return 'Document';
    }
  }
}

class _ClueTypeIcon extends StatelessWidget {
  final ClueType type;
  final bool isDark;

  const _ClueTypeIcon({
    required this.type,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final color =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.copperplate;

    IconData iconData;
    switch (type) {
      case ClueType.physical:
        iconData = Icons.key;
        break;
      case ClueType.testimony:
        iconData = Icons.record_voice_over;
        break;
      case ClueType.observation:
        iconData = Icons.visibility;
        break;
      case ClueType.record:
        iconData = Icons.description;
        break;
    }

    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
      ),
      child: Icon(iconData, size: 14, color: color),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// LOCATIONS TAB
// ═══════════════════════════════════════════════════════════════════════════

class _LocationsTab extends StatelessWidget {
  final BoundCase boundCase;
  final Set<String> visitedLocations;
  final Set<String> unlockedLocations;
  final Map<String, List<Clue>> cluesByLocation;

  const _LocationsTab({
    required this.boundCase,
    required this.visitedLocations,
    required this.unlockedLocations,
    required this.cluesByLocation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;

    // Get all locations, sorted by visited first
    final locations = boundCase.boundLocations.entries.toList();
    locations.sort((a, b) {
      final aVisited = visitedLocations.contains(a.key);
      final bVisited = visitedLocations.contains(b.key);
      if (aVisited && !bVisited) return -1;
      if (!aVisited && bVisited) return 1;
      return a.value.displayName.compareTo(b.value.displayName);
    });

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Directory header
        Center(
          child: Text(
            '─── DIRECTORY OF LOCATIONS ───',
            style: GoogleFonts.playfairDisplay(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
              color: textColor,
            ),
          ),
        ),
        const SizedBox(height: 16),

        ...locations.map((entry) {
          final locationId = entry.key;
          final boundLocation = entry.value;
          final isVisited = visitedLocations.contains(locationId);
          final isUnlocked = unlockedLocations.contains(locationId) ||
              boundCase.template.locations[locationId]?.required == true;
          final cluesHere = cluesByLocation[locationId] ?? [];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _LocationEntry(
              name: boundLocation.displayName,
              isVisited: isVisited,
              isUnlocked: isUnlocked,
              clueCount: cluesHere.length,
            ),
          );
        }),
      ],
    );
  }
}

class _LocationEntry extends StatelessWidget {
  final String name;
  final bool isVisited;
  final bool isUnlocked;
  final int clueCount;

  const _LocationEntry({
    required this.name,
    required this.isVisited,
    required this.isUnlocked,
    required this.clueCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? GazetteColors.darkCard : GazetteColors.parchment;
    final borderColor =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final fadedColor =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkFaded;
    final successColor = GazetteColors.success;

    // Faded style for not-yet-visited locations
    final effectiveTextColor = isVisited ? textColor : fadedColor;
    final effectiveCardColor =
        isVisited ? cardColor : cardColor.withOpacity(0.6);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: effectiveCardColor,
        border: Border.all(
          color: isVisited ? borderColor : fadedColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Status icon
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isVisited
                  ? successColor.withOpacity(0.15)
                  : Colors.transparent,
              border: Border.all(
                color: isVisited ? successColor : fadedColor,
                width: 1.5,
              ),
            ),
            child: Icon(
              isVisited ? Icons.check : Icons.radio_button_unchecked,
              size: 14,
              color: isVisited ? successColor : fadedColor,
            ),
          ),
          const SizedBox(width: 12),

          // Location name and status
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.toUpperCase(),
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: effectiveTextColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isVisited
                      ? 'Investigated'
                      : (isUnlocked
                          ? 'Requires investigation'
                          : 'Location unknown'),
                  style: GoogleFonts.oldStandardTt(
                    fontSize: 10,
                    fontStyle: FontStyle.italic,
                    color: isVisited
                        ? (isDark
                            ? GazetteColors.darkTextSecondary
                            : GazetteColors.inkBrown)
                        : fadedColor,
                  ),
                ),
              ],
            ),
          ),

          // Clue count badge
          if (clueCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? GazetteColors.bloodRedLight.withOpacity(0.2)
                    : GazetteColors.bloodRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                '$clueCount clue${clueCount > 1 ? 's' : ''}',
                style: GoogleFonts.oldStandardTt(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? GazetteColors.bloodRedLight
                      : GazetteColors.bloodRed,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// PERSONS TAB
// ═══════════════════════════════════════════════════════════════════════════

class _PersonsTab extends StatelessWidget {
  final List<Character> characters;
  final BoundCase boundCase;
  final Set<String> discoveredClueIds;

  const _PersonsTab({
    required this.characters,
    required this.boundCase,
    required this.discoveredClueIds,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (characters.isEmpty) {
      return _buildEmptyState(isDark);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];

        // Get key quotes (testimony clues from this character)
        final testimonies = boundCase.template.clues
            .where((c) =>
                c.characterId == character.id &&
                discoveredClueIds.contains(c.id))
            .toList();

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _PersonCard(
            character: character,
            locationName:
                boundCase.boundLocations[character.locationId]?.displayName ??
                    'Unknown',
            testimonies: testimonies,
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(bool isDark) {
    final textColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_off,
              size: 48,
              color: textColor,
            ),
            const SizedBox(height: 16),
            Text(
              'NO PERSONS ENCOUNTERED',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Visit locations to meet persons\nof interest in this case.',
              style: GoogleFonts.oldStandardTt(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: textColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  final Character character;
  final String locationName;
  final List<Clue> testimonies;

  const _PersonCard({
    required this.character,
    required this.locationName,
    required this.testimonies,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? GazetteColors.darkCard : GazetteColors.parchment;
    final borderColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.copperplate;

    return GazetteCard(
      backgroundColor: cardColor,
      padding: EdgeInsets.zero,
      showOrnaments: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header with portrait and name
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Portrait placeholder
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor, width: 2),
                    color: isDark
                        ? GazetteColors.darkSurface
                        : GazetteColors.newsprint,
                  ),
                  child: Icon(
                    Icons.person,
                    size: 32,
                    color: subtitleColor,
                  ),
                ),
                const SizedBox(width: 12),

                // Name and role
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name.toUpperCase(),
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        character.role,
                        style: GoogleFonts.oldStandardTt(
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                          color: subtitleColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 10,
                            color: subtitleColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            locationName,
                            style: GoogleFonts.oldStandardTt(
                              fontSize: 10,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              character.description,
              style: GoogleFonts.oldStandardTt(
                fontSize: 11,
                height: 1.4,
                color: textColor,
              ),
            ),
          ),

          // Key quotes from testimony
          if (testimonies.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? GazetteColors.darkSurface
                    : GazetteColors.newsprint,
                border: Border(
                  left: BorderSide(color: accentColor, width: 3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KEY TESTIMONY:',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                      color: accentColor,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...testimonies.map((testimony) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '"${testimony.notebookSummary}"',
                          style: GoogleFonts.oldStandardTt(
                            fontSize: 11,
                            fontStyle: FontStyle.italic,
                            height: 1.4,
                            color: textColor,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
