import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// The current phase of the game.
enum GamePhase {
  /// Setting up the case (fetching POIs, binding locations)
  setup,

  /// Actively investigating
  active,

  /// Case has been solved
  solved,
}

/// Tracks the player's progress through a case.
/// 
/// This state is persisted locally so players can resume interrupted games.
@freezed
class GameState with _$GameState {
  const factory GameState({
    /// ID of the case being played
    required String caseId,

    /// Current game phase
    @Default(GamePhase.setup) GamePhase phase,

    /// IDs of locations the player has visited
    @Default({}) Set<String> visitedLocations,

    /// IDs of clues the player has discovered
    @Default({}) Set<String> discoveredClues,

    /// IDs of locations revealed by clues (initially hidden)
    @Default({}) Set<String> unlockedLocations,

    /// Order in which locations were visited (for scoring)
    @Default([]) List<String> visitOrder,

    /// When the game was started
    required DateTime startedAt,

    /// When the case was solved (null if still in progress)
    DateTime? completedAt,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}
