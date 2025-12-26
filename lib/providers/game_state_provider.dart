import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';

import '../models/bound_case.dart';
import '../models/game_state.dart';
import '../services/game_service.dart';

/// Key used to store game state in Hive.
const String _gameStateBoxName = 'game_state';
const String _activeGameStateKey = 'active_game';
const String _activeBoundCaseKey = 'active_bound_case';

/// Provider for the GameService.
final gameServiceProvider = Provider<GameService>((ref) {
  return GameService();
});

/// Provider for the Hive box that stores game state.
final gameStateBoxProvider = Provider<Box<String>>((ref) {
  return Hive.box<String>(_gameStateBoxName);
});

/// Provider for the active bound case (persisted).
final activeBoundCaseProvider =
    StateNotifierProvider<ActiveBoundCaseNotifier, BoundCase?>((ref) {
  final box = ref.watch(gameStateBoxProvider);
  return ActiveBoundCaseNotifier(box);
});

/// Notifier that manages the active bound case with Hive persistence.
class ActiveBoundCaseNotifier extends StateNotifier<BoundCase?> {
  final Box<String> _box;

  ActiveBoundCaseNotifier(this._box) : super(null) {
    _loadPersistedState();
  }

  void _loadPersistedState() {
    final jsonString = _box.get(_activeBoundCaseKey);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        state = BoundCase.fromJson(json);
      } catch (e) {
        // If parsing fails, clear the corrupted data
        _box.delete(_activeBoundCaseKey);
        state = null;
      }
    }
  }

  void _persistState() {
    if (state != null) {
      final jsonString = jsonEncode(state!.toJson());
      _box.put(_activeBoundCaseKey, jsonString);
    } else {
      _box.delete(_activeBoundCaseKey);
    }
  }

  /// Sets the active bound case.
  void setBoundCase(BoundCase boundCase) {
    state = boundCase;
    _persistState();
  }

  /// Clears the active bound case.
  void clear() {
    state = null;
    _persistState();
  }
}

/// Notifier that manages the active game state with Hive persistence.
class ActiveGameStateNotifier extends StateNotifier<GameState?> {
  final Box<String> _box;
  final GameService _gameService;

  ActiveGameStateNotifier(this._box, this._gameService) : super(null) {
    // Load persisted state on initialization
    _loadPersistedState();
  }

  void _loadPersistedState() {
    final jsonString = _box.get(_activeGameStateKey);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        state = GameState.fromJson(json);
      } catch (e) {
        // If parsing fails, clear the corrupted data
        _box.delete(_activeGameStateKey);
        state = null;
      }
    }
  }

  void _persistState() {
    if (state != null) {
      final jsonString = jsonEncode(state!.toJson());
      _box.put(_activeGameStateKey, jsonString);
    } else {
      _box.delete(_activeGameStateKey);
    }
  }

  /// Starts a new game with the given bound case.
  void startCase(BoundCase boundCase) {
    state = _gameService.startCase(boundCase);
    _persistState();
  }

  /// Visits a location if the player is in range.
  ///
  /// Returns `true` if the visit was successful.
  bool visitLocation(
    String locationId,
    LatLng playerPos,
    BoundCase boundCase,
  ) {
    if (state == null) return false;

    final newState = _gameService.visitLocation(
      state!,
      locationId,
      playerPos,
      boundCase,
    );

    if (newState != null && newState != state) {
      state = newState;
      _persistState();
      return true;
    }
    return false;
  }

  /// Discovers a clue at the current location.
  ///
  /// Returns `true` if the clue was newly discovered.
  bool discoverClue(String clueId, BoundCase boundCase) {
    if (state == null) return false;

    final previousClues = state!.discoveredClues;
    state = _gameService.discoverClue(state!, clueId, boundCase);
    _persistState();

    return state!.discoveredClues.length > previousClues.length;
  }

  /// Updates the state directly (for advanced use cases).
  void updateState(GameState newState) {
    state = newState;
    _persistState();
  }

  /// Clears the active game.
  void clearGame() {
    state = null;
    _persistState();
  }

  /// Marks the current game as completed.
  void completeGame() {
    if (state == null) return;
    state = _gameService.completeGame(state!);
    _persistState();
  }
}

/// Provider for the active game state notifier.
///
/// This persists the game state to Hive whenever it changes.
final activeGameStateProvider =
    StateNotifierProvider<ActiveGameStateNotifier, GameState?>((ref) {
  final box = ref.watch(gameStateBoxProvider);
  final gameService = ref.watch(gameServiceProvider);
  return ActiveGameStateNotifier(box, gameService);
});

/// Initializes the game state Hive box.
///
/// Call this during app initialization, after [Hive.initFlutter()].
Future<void> initializeGameStateStorage() async {
  if (!Hive.isBoxOpen(_gameStateBoxName)) {
    await Hive.openBox<String>(_gameStateBoxName);
  }
}

/// Provider that exposes whether a game is currently active.
final hasActiveGameProvider = Provider<bool>((ref) {
  final state = ref.watch(activeGameStateProvider);
  return state != null && state.phase == GamePhase.active;
});

/// Provider for the current game phase.
final gamePhaseProvider = Provider<GamePhase?>((ref) {
  return ref.watch(activeGameStateProvider)?.phase;
});

/// Provider for visited locations in the current game.
final visitedLocationsProvider = Provider<Set<String>>((ref) {
  return ref.watch(activeGameStateProvider)?.visitedLocations ?? {};
});

/// Provider for discovered clues in the current game.
final discoveredCluesProvider = Provider<Set<String>>((ref) {
  return ref.watch(activeGameStateProvider)?.discoveredClues ?? {};
});

/// Provider for unlocked locations in the current game.
final unlockedLocationsProvider = Provider<Set<String>>((ref) {
  return ref.watch(activeGameStateProvider)?.unlockedLocations ?? {};
});
