import 'package:freezed_annotation/freezed_annotation.dart';

part 'clue.freezed.dart';
part 'clue.g.dart';

/// The type/category of a clue.
enum ClueType {
  /// Physical evidence found at a location
  physical,

  /// Information obtained from interviewing a character
  testimony,

  /// Something the detective notices or deduces
  observation,

  /// Documents, records, or written information
  record,
}

/// A piece of evidence or information the player can discover.
/// 
/// Clues are discovered at locations and may require prerequisites
/// (other clues) to be found first. Some clues reveal new locations.
@freezed
class Clue with _$Clue {
  const factory Clue({
    /// Unique identifier for this clue
    required String id,

    /// The category of this clue
    required ClueType type,

    /// ID of the LocationRequirement where this clue is found
    required String locationId,

    /// Short title for notebook display
    required String title,

    /// Text shown when the clue is first discovered
    required String discoveryText,

    /// Condensed summary shown in the notebook
    required String notebookSummary,

    /// IDs of clues that must be discovered before this one appears
    @Default([]) List<String> prerequisites,

    /// Location IDs that become visible after discovering this clue
    @Default([]) List<String> reveals,

    /// If this clue comes from an NPC, their character ID
    String? characterId,

    /// Whether this clue is required to solve the case
    @Default(false) bool isEssential,

    /// Whether this clue is a deliberate misdirection
    @Default(false) bool isRedHerring,
  }) = _Clue;

  factory Clue.fromJson(Map<String, dynamic> json) => _$ClueFromJson(json);
}
