import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:latlong2/latlong.dart';

import 'case_template.dart';
import 'poi.dart';

part 'bound_case.freezed.dart';
part 'bound_case.g.dart';

/// A location requirement that has been bound to a real-world POI.
@freezed
class BoundLocation with _$BoundLocation {
  const factory BoundLocation({
    /// The template location ID this is bound to
    required String templateId,

    /// The real-world POI
    required POI poi,

    /// Display name (may incorporate POI name or template description)
    required String displayName,

    /// Distance from the player's starting position in meters
    required double distanceFromStart,
  }) = _BoundLocation;

  factory BoundLocation.fromJson(Map<String, dynamic> json) =>
      _$BoundLocationFromJson(json);
}

/// A case template that has been bound to real-world POIs.
/// 
/// Created when the player starts a new game, binding abstract location
/// requirements to actual places in their neighborhood.
@freezed
class BoundCase with _$BoundCase {
  const BoundCase._();

  const factory BoundCase({
    /// The original case template
    required CaseTemplate template,

    /// Where the player started the game
    @LatLngConverter() required LatLng playerStart,

    /// Successfully bound locations mapped by template location ID
    @Default({}) Map<String, BoundLocation> boundLocations,

    /// Template location IDs that couldn't be bound (optional locations only)
    @Default([]) List<String> unboundOptional,
  }) = _BoundCase;

  factory BoundCase.fromJson(Map<String, dynamic> json) =>
      _$BoundCaseFromJson(json);

  /// Whether this case has all required locations bound and is playable.
  bool get isPlayable {
    return template.locations.entries
        .where((entry) => entry.value.required)
        .every((entry) => boundLocations.containsKey(entry.key));
  }
}

/// JSON converter for LatLng from latlong2 package.
class LatLngConverter implements JsonConverter<LatLng, Map<String, dynamic>> {
  const LatLngConverter();

  @override
  LatLng fromJson(Map<String, dynamic> json) {
    return LatLng(
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(LatLng object) {
    return {
      'latitude': object.latitude,
      'longitude': object.longitude,
    };
  }
}
