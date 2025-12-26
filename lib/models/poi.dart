import 'package:freezed_annotation/freezed_annotation.dart';

import 'story_role.dart';

part 'poi.freezed.dart';
part 'poi.g.dart';

/// A Point of Interest fetched from OpenStreetMap via Overpass API.
/// 
/// POIs are real-world locations that get mapped to story locations
/// during case binding.
@freezed
class POI with _$POI {
  const POI._();

  const factory POI({
    /// OpenStreetMap node/way ID
    required int osmId,

    /// Optional name from OSM tags
    String? name,

    /// Latitude coordinate
    required double lat,

    /// Longitude coordinate
    required double lon,

    /// Raw OSM tags for this POI
    @Default({}) Map<String, String> osmTags,

    /// Story roles this POI can fulfill based on its tags
    @Default([]) List<StoryRole> storyRoles,
  }) = _POI;

  factory POI.fromJson(Map<String, dynamic> json) => _$POIFromJson(json);

  /// Returns the POI name, or generates a generic name from tags.
  /// 
  /// For example, a café without a name becomes "A Café",
  /// a park becomes "A Park", etc.
  String get displayName {
    if (name != null && name!.isNotEmpty) {
      return name!;
    }
    return _generateGenericName();
  }

  String _generateGenericName() {
    // Try common tag patterns to generate a readable name
    final amenity = osmTags['amenity'];
    if (amenity != null) {
      return 'A ${_formatTagValue(amenity)}';
    }

    final shop = osmTags['shop'];
    if (shop != null) {
      return 'A ${_formatTagValue(shop)} Shop';
    }

    final leisure = osmTags['leisure'];
    if (leisure != null) {
      return 'A ${_formatTagValue(leisure)}';
    }

    final tourism = osmTags['tourism'];
    if (tourism != null) {
      return 'A ${_formatTagValue(tourism)}';
    }

    final historic = osmTags['historic'];
    if (historic != null) {
      return 'A Historic ${_formatTagValue(historic)}';
    }

    final office = osmTags['office'];
    if (office != null) {
      return 'An Office';
    }

    final landuse = osmTags['landuse'];
    if (landuse != null) {
      return 'A ${_formatTagValue(landuse)}';
    }

    return 'An Unknown Location';
  }

  /// Converts snake_case tag values to Title Case.
  String _formatTagValue(String value) {
    return value
        .split('_')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1)}'
            : '')
        .join(' ');
  }
}
