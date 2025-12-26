import 'package:latlong2/latlong.dart';

import '../models/bound_case.dart';
import '../models/character.dart';
import '../models/clue.dart';
import '../models/game_state.dart';
import '../utils/geo_utils.dart';

/// Result of submitting a solution to a case.
class SolutionResult {
  /// Whether the player correctly identified the perpetrator.
  final bool isCorrect;

  /// The actual perpetrator's character ID.
  final String correctPerpetrator;

  /// Number of locations the player visited.
  final int playerVisits;

  /// Optimal number of visits (par for the case).
  final int optimalVisits;

  /// Final score (0-100+).
  final int score;

  /// Number of essential clues the player found.
  final int essentialCluesFound;

  /// Total number of essential clues in the case.
  final int totalEssentialClues;

  const SolutionResult({
    required this.isCorrect,
    required this.correctPerpetrator,
    required this.playerVisits,
    required this.optimalVisits,
    required this.score,
    required this.essentialCluesFound,
    required this.totalEssentialClues,
  });

  @override
  String toString() {
    return 'SolutionResult('
        'isCorrect: $isCorrect, '
        'correctPerpetrator: $correctPerpetrator, '
        'playerVisits: $playerVisits, '
        'optimalVisits: $optimalVisits, '
        'score: $score, '
        'essentialCluesFound: $essentialCluesFound, '
        'totalEssentialClues: $totalEssentialClues)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SolutionResult &&
        other.isCorrect == isCorrect &&
        other.correctPerpetrator == correctPerpetrator &&
        other.playerVisits == playerVisits &&
        other.optimalVisits == optimalVisits &&
        other.score == score &&
        other.essentialCluesFound == essentialCluesFound &&
        other.totalEssentialClues == totalEssentialClues;
  }

  @override
  int get hashCode {
    return Object.hash(
      isCorrect,
      correctPerpetrator,
      playerVisits,
      optimalVisits,
      score,
      essentialCluesFound,
      totalEssentialClues,
    );
  }
}

/// Manages game state transitions and logic for playing a case.
///
/// This service handles:
/// - Starting a new case
/// - Visiting locations and validating proximity
/// - Discovering clues and checking prerequisites
/// - Getting available clues and character dialogue
/// - Submitting and scoring solutions
class GameService {
  /// Creates initial game state for a bound case.
  ///
  /// Sets up the game with:
  /// - Phase set to [GamePhase.active]
  /// - The starting location unlocked
  /// - Empty visited/discovered sets
  GameState startCase(BoundCase boundCase) {
    // Find the first location in the optimal path as the starting location
    // If no optimal path, find any required location
    final startingLocationId = _findStartingLocation(boundCase);

    return GameState(
      caseId: boundCase.template.id,
      phase: GamePhase.active,
      visitedLocations: const {},
      discoveredClues: const {},
      unlockedLocations: {if (startingLocationId != null) startingLocationId},
      visitOrder: const [],
      startedAt: DateTime.now(),
    );
  }

  /// Finds the starting location for a case.
  ///
  /// Uses the first location in the optimal path, or falls back to
  /// the first required location.
  String? _findStartingLocation(BoundCase boundCase) {
    final optimalPath = boundCase.template.solution.optimalPath;

    // Use first location in optimal path if available
    if (optimalPath.isNotEmpty) {
      return optimalPath.first;
    }

    // Fall back to first required location that's bound
    for (final entry in boundCase.template.locations.entries) {
      if (entry.value.required && boundCase.boundLocations.containsKey(entry.key)) {
        return entry.key;
      }
    }

    // No required locations, use first bound location
    if (boundCase.boundLocations.isNotEmpty) {
      return boundCase.boundLocations.keys.first;
    }

    return null;
  }

  /// Attempts to visit a location.
  ///
  /// Validates that:
  /// - The location is unlocked (in [GameState.unlockedLocations])
  /// - The player is within [visitRadiusMeters] of the location
  ///
  /// Returns the updated [GameState] with the location marked as visited,
  /// or `null` if the visit is invalid.
  GameState? visitLocation(
    GameState state,
    String locationId,
    LatLng playerPos,
    BoundCase boundCase,
  ) {
    // Must be in active phase
    if (state.phase != GamePhase.active) {
      return null;
    }

    // Location must be unlocked
    if (!state.unlockedLocations.contains(locationId)) {
      return null;
    }

    // Location must be bound
    final boundLocation = boundCase.boundLocations[locationId];
    if (boundLocation == null) {
      return null;
    }

    // Player must be within range
    final locationPos = LatLng(boundLocation.poi.lat, boundLocation.poi.lon);
    if (!hasVisited(playerPos, locationPos)) {
      return null;
    }

    // Already visited - no change needed
    if (state.visitedLocations.contains(locationId)) {
      return state;
    }

    // Mark as visited and add to visit order
    return state.copyWith(
      visitedLocations: {...state.visitedLocations, locationId},
      visitOrder: [...state.visitOrder, locationId],
    );
  }

  /// Discovers a clue.
  ///
  /// Prerequisites must be met (all prerequisite clues discovered).
  /// The clue's revealed locations will be added to [GameState.unlockedLocations].
  ///
  /// Returns the updated [GameState] with:
  /// - The clue added to [GameState.discoveredClues]
  /// - Any revealed locations added to [GameState.unlockedLocations]
  GameState discoverClue(
    GameState state,
    String clueId,
    BoundCase boundCase,
  ) {
    // Find the clue in the case
    final clue = boundCase.template.clues.where((c) => c.id == clueId).firstOrNull;
    if (clue == null) {
      return state;
    }

    // Check prerequisites
    if (!canDiscoverClue(state, clue)) {
      return state;
    }

    // Already discovered
    if (state.discoveredClues.contains(clueId)) {
      return state;
    }

    // Add clue and any revealed locations
    final newUnlocked = <String>{...state.unlockedLocations};
    for (final revealedId in clue.reveals) {
      // Only unlock if the location exists (either bound or in template)
      if (boundCase.boundLocations.containsKey(revealedId) ||
          boundCase.template.locations.containsKey(revealedId)) {
        newUnlocked.add(revealedId);
      }
    }

    return state.copyWith(
      discoveredClues: {...state.discoveredClues, clueId},
      unlockedLocations: newUnlocked,
    );
  }

  /// Checks if a clue can be discovered.
  ///
  /// Returns `true` if all prerequisite clues have been discovered.
  bool canDiscoverClue(GameState state, Clue clue) {
    return clue.prerequisites.every(
      (prereqId) => state.discoveredClues.contains(prereqId),
    );
  }

  /// Gets clues available for discovery at a location.
  ///
  /// Returns clues that:
  /// - Are at the specified location
  /// - Have all prerequisites met
  /// - Have not already been discovered
  List<Clue> getAvailableClues(
    GameState state,
    String locationId,
    BoundCase boundCase,
  ) {
    return boundCase.template.clues
        .where((clue) =>
            clue.locationId == locationId &&
            canDiscoverClue(state, clue) &&
            !state.discoveredClues.contains(clue.id))
        .toList();
  }

  /// Gets the appropriate dialogue for a character.
  ///
  /// Returns:
  /// - Conditional dialogue for any discovered clues that unlock it
  ///   (concatenated in order)
  /// - Initial dialogue if no conditional dialogue is unlocked
  String getCharacterDialogue(GameState state, Character character) {
    // Check for conditional dialogue based on discovered clues
    final conditionalLines = <String>[];

    for (final entry in character.conditionalDialogue.entries) {
      if (state.discoveredClues.contains(entry.key)) {
        conditionalLines.add(entry.value);
      }
    }

    // If we have conditional dialogue, combine with initial
    if (conditionalLines.isNotEmpty) {
      return '${character.initialDialogue}\n\n${conditionalLines.join('\n\n')}';
    }

    // Otherwise just return initial dialogue
    return character.initialDialogue;
  }

  /// Submits a solution and calculates the score.
  ///
  /// Scoring formula:
  /// - Base score: 100 points if correct perpetrator
  /// - Efficiency bonus: +10 per visit under par
  /// - Efficiency penalty: -5 per visit over par
  /// - Evidence bonus: +5 per essential clue found
  /// - Minimum score: 0
  SolutionResult submitSolution(
    GameState state,
    String accusedId,
    BoundCase boundCase,
  ) {

    final template = boundCase.template;
    final solution = template.solution;

    // Debug logging
    // ignore: avoid_print
    print('[submitSolution] accusedId: '
      '[33m$accusedId[0m, solution.perpetratorId: '
      '[36m${solution.perpetratorId}[0m');

    // Check if correct
    final isCorrect = accusedId == solution.perpetratorId;

    // Count visits
    final playerVisits = state.visitedLocations.length;
    final optimalVisits = template.parVisits;

    // Count essential clues
    final essentialClues = template.clues.where((c) => c.isEssential).toList();
    final totalEssential = essentialClues.length;
    final foundEssential = essentialClues
        .where((c) => state.discoveredClues.contains(c.id))
        .length;

    // Calculate score
    int score = 0;

    // Base score for correct answer
    if (isCorrect) {
      score += 100;
    }

    // Efficiency bonus/penalty
    final visitDiff = optimalVisits - playerVisits;
    if (visitDiff > 0) {
      // Under par: bonus
      score += visitDiff * 10;
    } else if (visitDiff < 0) {
      // Over par: penalty
      score += visitDiff * 5; // visitDiff is negative, so this subtracts
    }

    // Evidence bonus
    score += foundEssential * 5;

    // Minimum score is 0
    if (score < 0) {
      score = 0;
    }

    return SolutionResult(
      isCorrect: isCorrect,
      correctPerpetrator: solution.perpetratorId,
      playerVisits: playerVisits,
      optimalVisits: optimalVisits,
      score: score,
      essentialCluesFound: foundEssential,
      totalEssentialClues: totalEssential,
    );
  }

  /// Gets all clues the player has discovered at a specific location.
  List<Clue> getDiscoveredCluesAtLocation(
    GameState state,
    String locationId,
    BoundCase boundCase,
  ) {
    return boundCase.template.clues
        .where((clue) =>
            clue.locationId == locationId &&
            state.discoveredClues.contains(clue.id))
        .toList();
  }

  /// Gets all characters at a specific location.
  List<Character> getCharactersAtLocation(String locationId, BoundCase boundCase) {
    return boundCase.template.characters
        .where((char) => char.locationId == locationId)
        .toList();
  }

  /// Checks if the game is ready to be solved.
  ///
  /// A game can always be solved (player can guess anytime),
  /// but this indicates if all essential clues have been found.
  bool hasFoundAllEssentialClues(GameState state, BoundCase boundCase) {
    final essentialClues = boundCase.template.clues.where((c) => c.isEssential);
    return essentialClues.every((c) => state.discoveredClues.contains(c.id));
  }

  /// Marks the game as solved and sets completion time.
  GameState completeGame(GameState state) {
    return state.copyWith(
      phase: GamePhase.solved,
      completedAt: DateTime.now(),
    );
  }
}
