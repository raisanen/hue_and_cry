import 'package:freezed_annotation/freezed_annotation.dart';

import 'character.dart';
import 'clue.dart';
import 'location_requirement.dart';
import 'solution.dart';

part 'case_template.freezed.dart';
part 'case_template.g.dart';

/// A pre-authored mystery case template.
/// 
/// Templates define the abstract structure of a case (locations, characters,
/// clues, solution) without binding to specific real-world POIs. The binding
/// happens at runtime when the player starts a new game.
@freezed
class CaseTemplate with _$CaseTemplate {
  const factory CaseTemplate({
    /// Unique identifier for this case
    required String id,

    /// Main title, e.g., "The Vanishing Violinist"
    required String title,

    /// Subtitle/tagline for the case
    required String subtitle,

    /// Opening briefing text presented to the player
    required String briefing,

    /// Location requirements mapped by their IDs
    @Default({}) Map<String, LocationRequirement> locations,

    /// NPCs in this case
    @Default([]) List<Character> characters,

    /// All clues available in this case
    @Default([]) List<Clue> clues,

    /// The correct solution
    required Solution solution,

    /// Target number of location visits for a perfect score
    @Default(5) int parVisits,

    /// Estimated play time in minutes
    @Default(60) int estimatedMinutes,

    /// Difficulty rating (1-5)
    @Default(3) int difficulty,
  }) = _CaseTemplate;

  factory CaseTemplate.fromJson(Map<String, dynamic> json) =>
      _$CaseTemplateFromJson(json);
}
