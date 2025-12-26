import 'package:latlong2/latlong.dart';

import '../models/bound_case.dart';
import '../models/case_template.dart';
import '../models/location_requirement.dart';
import '../models/poi.dart';
import '../models/story_role.dart';
import '../utils/geo_utils.dart';

/// Result of attempting to bind a case template to available POIs.
class BindingResult {
  /// The bound case (may be incomplete if some locations failed)
  final BoundCase boundCase;

  /// Error messages for failed bindings
  final List<String> errors;

  /// Whether all required locations were successfully bound
  bool get isSuccess => boundCase.isPlayable;

  const BindingResult({
    required this.boundCase,
    this.errors = const [],
  });
}

/// Service for binding case templates to real-world POIs.
///
/// The binding process matches abstract location requirements from a case
/// template to actual POIs in the player's neighborhood, creating a playable
/// bound case.
class BindingService {
  /// Binds a case template to available POIs near the player's location.
  ///
  /// Returns a [BindingResult] containing the bound case and any errors.
  /// The bound case may be incomplete if some locations couldn't be bound.
  ///
  /// Algorithm:
  /// 1. Group POIs by their story roles
  /// 2. Sort each group by distance from player (closest first)
  /// 3. Process required locations first, then optional
  /// 4. For each location, try primary role, then fallback
  /// 5. Track used POIs to prevent reuse
  BindingResult bindCase(
    CaseTemplate template,
    List<POI> availablePOIs,
    LatLng playerLocation,
  ) {
    // Track which POIs have been used
    final usedOsmIds = <int>{};

    // Pre-compute distances and group POIs by role
    final poisByRole = _groupAndSortByRole(availablePOIs, playerLocation);

    // Separate required and optional locations
    final requiredLocations = <String, LocationRequirement>{};
    final optionalLocations = <String, LocationRequirement>{};

    for (final entry in template.locations.entries) {
      if (entry.value.required) {
        requiredLocations[entry.key] = entry.value;
      } else {
        optionalLocations[entry.key] = entry.value;
      }
    }

    // Bind locations
    final boundLocations = <String, BoundLocation>{};
    final unboundOptional = <String>[];
    final errors = <String>[];

    // Process required locations first
    for (final entry in requiredLocations.entries) {
      final locationId = entry.key;
      final requirement = entry.value;

      final result = _bindLocation(
        locationId,
        requirement,
        poisByRole,
        usedOsmIds,
        playerLocation,
      );

      if (result != null) {
        boundLocations[locationId] = result;
        usedOsmIds.add(result.poi.osmId);
      } else {
        errors.add(
          'Required location "$locationId" could not be bound: '
          'no available POI with role ${requirement.role.name}'
          '${requirement.fallbackRole != null ? ' or ${requirement.fallbackRole!.name}' : ''}',
        );
      }
    }

    // Process optional locations
    for (final entry in optionalLocations.entries) {
      final locationId = entry.key;
      final requirement = entry.value;

      final result = _bindLocation(
        locationId,
        requirement,
        poisByRole,
        usedOsmIds,
        playerLocation,
      );

      if (result != null) {
        boundLocations[locationId] = result;
        usedOsmIds.add(result.poi.osmId);
      } else {
        unboundOptional.add(locationId);
      }
    }

    final boundCase = BoundCase(
      template: template,
      playerStart: playerLocation,
      boundLocations: boundLocations,
      unboundOptional: unboundOptional,
    );

    return BindingResult(
      boundCase: boundCase,
      errors: errors,
    );
  }

  /// Quick check if a case can potentially be bound with available POIs.
  ///
  /// This doesn't account for POI reuse, just checks if there are enough
  /// POIs of each required role type.
  bool canBindCase(
    CaseTemplate template,
    Map<StoryRole, int> availableRoleCounts,
  ) {
    // Count required locations by role
    final requiredCounts = <StoryRole, int>{};

    for (final requirement in template.locations.values) {
      if (requirement.required) {
        final role = requirement.role;
        requiredCounts[role] = (requiredCounts[role] ?? 0) + 1;
      }
    }

    // Check if we have enough POIs for each role
    for (final entry in requiredCounts.entries) {
      final role = entry.key;
      final needed = entry.value;
      final available = availableRoleCounts[role] ?? 0;

      if (available < needed) {
        // Check if fallback roles could help
        // (simplified check - doesn't account for complex fallback chains)
        return false;
      }
    }

    return true;
  }

  /// Groups POIs by story role and sorts each group by distance.
  ///
  /// Returns a map where each role maps to a list of (POI, distance) pairs,
  /// sorted by distance ascending.
  Map<StoryRole, List<_POIWithDistance>> _groupAndSortByRole(
    List<POI> pois,
    LatLng playerLocation,
  ) {
    final result = <StoryRole, List<_POIWithDistance>>{};

    // Initialize all roles with empty lists
    for (final role in StoryRole.values) {
      result[role] = [];
    }

    // Add each POI to all its role groups
    for (final poi in pois) {
      final poiLocation = LatLng(poi.lat, poi.lon);
      final distance = haversineDistance(playerLocation, poiLocation);
      final poiWithDistance = _POIWithDistance(poi, distance);

      for (final role in poi.storyRoles) {
        result[role]!.add(poiWithDistance);
      }
    }

    // Sort each group by distance
    for (final list in result.values) {
      list.sort((a, b) => a.distance.compareTo(b.distance));
    }

    return result;
  }

  /// Attempts to bind a single location requirement to an available POI.
  ///
  /// Returns null if no suitable POI is found.
  BoundLocation? _bindLocation(
    String locationId,
    LocationRequirement requirement,
    Map<StoryRole, List<_POIWithDistance>> poisByRole,
    Set<int> usedOsmIds,
    LatLng playerLocation,
  ) {
    // Try primary role first
    final primaryResult = _findUnusedPOI(
      requirement.role,
      poisByRole,
      usedOsmIds,
      requirement.preferredTags,
    );

    if (primaryResult != null) {
      return BoundLocation(
        templateId: locationId,
        poi: primaryResult.poi,
        displayName: _generateDisplayName(requirement, primaryResult.poi),
        distanceFromStart: primaryResult.distance,
      );
    }

    // Try fallback role if available
    if (requirement.fallbackRole != null) {
      final fallbackResult = _findUnusedPOI(
        requirement.fallbackRole!,
        poisByRole,
        usedOsmIds,
        requirement.preferredTags,
      );

      if (fallbackResult != null) {
        return BoundLocation(
          templateId: locationId,
          poi: fallbackResult.poi,
          displayName: _generateDisplayName(requirement, fallbackResult.poi),
          distanceFromStart: fallbackResult.distance,
        );
      }
    }

    return null;
  }

  /// Finds the first unused POI matching the given role.
  ///
  /// If preferredTags are specified, tries to match those first.
  /// Returns null if no suitable POI is found.
  _POIWithDistance? _findUnusedPOI(
    StoryRole role,
    Map<StoryRole, List<_POIWithDistance>> poisByRole,
    Set<int> usedOsmIds,
    List<String> preferredTags,
  ) {
    final candidates = poisByRole[role] ?? [];

    // If we have preferred tags, try to find a match first
    if (preferredTags.isNotEmpty) {
      for (final candidate in candidates) {
        if (usedOsmIds.contains(candidate.poi.osmId)) continue;
        if (_matchesPreferredTags(candidate.poi, preferredTags)) {
          return candidate;
        }
      }
    }

    // Fall back to first unused POI with this role
    for (final candidate in candidates) {
      if (!usedOsmIds.contains(candidate.poi.osmId)) {
        return candidate;
      }
    }

    return null;
  }

  /// Checks if a POI matches any of the preferred tags.
  ///
  /// Tags are in format "key=value", e.g., "amenity=cafe".
  bool _matchesPreferredTags(POI poi, List<String> preferredTags) {
    for (final tag in preferredTags) {
      final parts = tag.split('=');
      if (parts.length == 2) {
        final key = parts[0];
        final value = parts[1];
        if (poi.osmTags[key] == value) {
          return true;
        }
      }
    }
    return false;
  }

  /// Generates a display name for a bound location.
  ///
  /// Uses the POI's name if available, otherwise falls back to
  /// a generic name based on the location requirement.
  String _generateDisplayName(LocationRequirement requirement, POI poi) {
    // If POI has a name, use it
    if (poi.name != null && poi.name!.isNotEmpty) {
      return poi.name!;
    }

    // If requirement has a description template, use it
    if (requirement.descriptionTemplate.isNotEmpty) {
      return requirement.descriptionTemplate;
    }

    // Fall back to POI's generated display name
    return poi.displayName;
  }
}

/// Internal class for tracking POI with its distance from player.
class _POIWithDistance {
  final POI poi;
  final double distance;

  const _POIWithDistance(this.poi, this.distance);
}
