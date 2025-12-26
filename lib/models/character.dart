import 'package:freezed_annotation/freezed_annotation.dart';

part 'character.freezed.dart';
part 'character.g.dart';

/// An NPC that the player can interact with at a location.
/// 
/// Characters provide dialogue and can reveal additional information
/// based on clues the player has already discovered.
@freezed
class Character with _$Character {
  const factory Character({
    /// Unique identifier for this character
    required String id,

    /// Character's display name
    required String name,

    /// Character's role/occupation, e.g., "bartender", "witness"
    required String role,

    /// ID of the LocationRequirement where this character is found
    required String locationId,

    /// Physical/personality description shown to the player
    required String description,

    /// Dialogue shown when first meeting the character
    required String initialDialogue,

    /// Additional dialogue unlocked by discovering specific clues.
    /// Maps clue ID → dialogue text.
    @Default({}) Map<String, String> conditionalDialogue,
  }) = _Character;

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);
}
