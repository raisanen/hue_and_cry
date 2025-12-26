import 'package:freezed_annotation/freezed_annotation.dart';

import 'story_role.dart';

part 'location_requirement.freezed.dart';
part 'location_requirement.g.dart';

/// Defines what kind of real-world location is needed for a story location.
/// 
/// Case templates specify abstract requirements (e.g., "need a café")
/// which are then bound to real POIs during case setup.
@freezed
class LocationRequirement with _$LocationRequirement {
  const factory LocationRequirement({
    /// Unique identifier for this location within the case
    required String id,

    /// Primary story role this location should fulfill
    required StoryRole role,

    /// Preferred OSM tags, e.g., ["amenity=cafe", "amenity=restaurant"]
    @Default([]) List<String> preferredTags,

    /// Whether this location is required for the case to be playable
    @Default(true) bool required,

    /// Alternative role to try if primary role has no matches
    StoryRole? fallbackRole,

    /// Template for describing this location, e.g., "a quiet café where..."
    @Default('') String descriptionTemplate,
  }) = _LocationRequirement;

  factory LocationRequirement.fromJson(Map<String, dynamic> json) =>
      _$LocationRequirementFromJson(json);
}
