import '../models/poi.dart';
import '../models/story_role.dart';

/// Classification rules mapping OSM tag keys and values to StoryRoles.
///
/// Structure: { tagKey: { tagValue: [StoryRole, ...] } }
/// Use '*' as tagValue for wildcard matching (any value for that key).
const Map<String, Map<String, List<StoryRole>>> classificationRules = {
  // ═══════════════════════════════════════════════════════════════════════════
  // LEISURE - Parks, gardens, playgrounds (crime scenes, hidden spots)
  // ═══════════════════════════════════════════════════════════════════════════
  'leisure': {
    'park': [StoryRole.crimeScene, StoryRole.hidden],
    'garden': [StoryRole.crimeScene, StoryRole.hidden],
    'playground': [StoryRole.crimeScene],
    'nature_reserve': [StoryRole.crimeScene, StoryRole.hidden],
    'pitch': [StoryRole.crimeScene],
    'dog_park': [StoryRole.crimeScene],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // AMENITY - Various public facilities
  // ═══════════════════════════════════════════════════════════════════════════
  'amenity': {
    // Crime scenes
    'parking': [StoryRole.crimeScene],
    'parking_space': [StoryRole.crimeScene],

    // Information sources (places where people gather and gossip)
    'cafe': [StoryRole.information, StoryRole.witness],
    'bar': [StoryRole.information, StoryRole.witness],
    'pub': [StoryRole.information, StoryRole.witness],
    'restaurant': [StoryRole.information, StoryRole.witness],
    'fast_food': [StoryRole.information, StoryRole.witness],
    'library': [StoryRole.information],
    'community_centre': [StoryRole.information, StoryRole.witness],
    'social_facility': [StoryRole.information],

    // Suspect workplaces
    'bank': [StoryRole.suspectWork],
    'pharmacy': [StoryRole.suspectWork],
    'post_office': [StoryRole.suspectWork],
    'veterinary': [StoryRole.suspectWork],
    'dentist': [StoryRole.suspectWork],
    'doctors': [StoryRole.suspectWork, StoryRole.witness],
    'clinic': [StoryRole.suspectWork, StoryRole.witness],

    // Authority figures
    'police': [StoryRole.authority],
    'hospital': [StoryRole.authority, StoryRole.witness],
    'townhall': [StoryRole.authority],
    'courthouse': [StoryRole.authority],
    'fire_station': [StoryRole.authority],
    'embassy': [StoryRole.authority],

    // Hidden/secretive locations
    'place_of_worship': [StoryRole.hidden, StoryRole.atmosphere],
    'monastery': [StoryRole.hidden, StoryRole.atmosphere],
    'grave_yard': [StoryRole.hidden, StoryRole.atmosphere],
    'mortuary': [StoryRole.hidden, StoryRole.authority],

    // Atmosphere
    'theatre': [StoryRole.atmosphere, StoryRole.witness],
    'cinema': [StoryRole.atmosphere],
    'nightclub': [StoryRole.atmosphere, StoryRole.information],
    'casino': [StoryRole.atmosphere, StoryRole.information],
    'arts_centre': [StoryRole.atmosphere],
    'fountain': [StoryRole.atmosphere],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // SHOP - Retail establishments (suspect workplaces, information sources)
  // ═══════════════════════════════════════════════════════════════════════════
  'shop': {
    // Specific information sources
    'hairdresser': [StoryRole.information, StoryRole.suspectWork],
    'beauty': [StoryRole.information, StoryRole.suspectWork],
    'convenience': [StoryRole.information, StoryRole.witness],
    'newsagent': [StoryRole.information],
    'kiosk': [StoryRole.information],

    // Specialty shops that might have specific story relevance
    'pawnbroker': [StoryRole.information, StoryRole.suspectWork],
    'antiques': [StoryRole.information, StoryRole.suspectWork],
    'jewelry': [StoryRole.suspectWork],
    'chemist': [StoryRole.suspectWork],

    // Wildcard: any other shop is a potential suspect workplace
    '*': [StoryRole.suspectWork],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // OFFICE - Business premises (suspect workplaces)
  // ═══════════════════════════════════════════════════════════════════════════
  'office': {
    'lawyer': [StoryRole.suspectWork, StoryRole.authority],
    'notary': [StoryRole.suspectWork, StoryRole.authority],
    'accountant': [StoryRole.suspectWork],
    'insurance': [StoryRole.suspectWork],
    'estate_agent': [StoryRole.suspectWork],
    'financial': [StoryRole.suspectWork],

    // Wildcard: any office is a potential suspect workplace
    '*': [StoryRole.suspectWork],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // TOURISM - Hotels, museums, attractions
  // ═══════════════════════════════════════════════════════════════════════════
  'tourism': {
    'museum': [StoryRole.atmosphere, StoryRole.information],
    'gallery': [StoryRole.atmosphere, StoryRole.information],
    'hotel': [StoryRole.atmosphere, StoryRole.witness],
    'hostel': [StoryRole.atmosphere, StoryRole.witness],
    'guest_house': [StoryRole.atmosphere, StoryRole.witness],
    'motel': [StoryRole.atmosphere, StoryRole.witness],
    'attraction': [StoryRole.atmosphere],
    'viewpoint': [StoryRole.atmosphere, StoryRole.crimeScene],
    'artwork': [StoryRole.atmosphere],
    'information': [StoryRole.information],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // HISTORIC - Old buildings, monuments (atmosphere, hidden)
  // ═══════════════════════════════════════════════════════════════════════════
  'historic': {
    'castle': [StoryRole.atmosphere, StoryRole.hidden],
    'ruins': [StoryRole.atmosphere, StoryRole.hidden, StoryRole.crimeScene],
    'monument': [StoryRole.atmosphere],
    'memorial': [StoryRole.atmosphere],
    'archaeological_site': [StoryRole.atmosphere, StoryRole.hidden],
    'manor': [StoryRole.atmosphere, StoryRole.witness],
    'building': [StoryRole.atmosphere],

    // Wildcard: any historic feature adds atmosphere
    '*': [StoryRole.atmosphere],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // LANDUSE - Land areas
  // ═══════════════════════════════════════════════════════════════════════════
  'landuse': {
    'cemetery': [StoryRole.hidden, StoryRole.atmosphere],
    'allotments': [StoryRole.hidden, StoryRole.crimeScene],
    'industrial': [StoryRole.crimeScene, StoryRole.suspectWork],
    'commercial': [StoryRole.suspectWork],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // BUILDING - Building types (when no other tags)
  // ═══════════════════════════════════════════════════════════════════════════
  'building': {
    'church': [StoryRole.hidden, StoryRole.atmosphere],
    'chapel': [StoryRole.hidden, StoryRole.atmosphere],
    'cathedral': [StoryRole.hidden, StoryRole.atmosphere],
    'mosque': [StoryRole.hidden, StoryRole.atmosphere],
    'synagogue': [StoryRole.hidden, StoryRole.atmosphere],
    'temple': [StoryRole.hidden, StoryRole.atmosphere],
    'warehouse': [StoryRole.crimeScene, StoryRole.hidden],
    'industrial': [StoryRole.crimeScene, StoryRole.suspectWork],
    'residential': [StoryRole.witness],
    'apartments': [StoryRole.witness],
    'house': [StoryRole.witness],
    'hotel': [StoryRole.witness, StoryRole.atmosphere],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // NATURAL - Natural features (crime scenes, hidden)
  // ═══════════════════════════════════════════════════════════════════════════
  'natural': {
    'water': [StoryRole.crimeScene, StoryRole.atmosphere],
    'wood': [StoryRole.crimeScene, StoryRole.hidden],
    'wetland': [StoryRole.crimeScene, StoryRole.hidden],
    'beach': [StoryRole.crimeScene, StoryRole.atmosphere],
    'cliff': [StoryRole.crimeScene],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // WATERWAY - Rivers, canals (crime scenes)
  // ═══════════════════════════════════════════════════════════════════════════
  'waterway': {
    'river': [StoryRole.crimeScene, StoryRole.atmosphere],
    'canal': [StoryRole.crimeScene, StoryRole.atmosphere],
    'dock': [StoryRole.crimeScene, StoryRole.suspectWork],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // RAILWAY - Stations (witness locations)
  // ═══════════════════════════════════════════════════════════════════════════
  'railway': {
    'station': [StoryRole.witness, StoryRole.atmosphere],
    'halt': [StoryRole.witness],
  },

  // ═══════════════════════════════════════════════════════════════════════════
  // PUBLIC TRANSPORT
  // ═══════════════════════════════════════════════════════════════════════════
  'public_transport': {
    'station': [StoryRole.witness, StoryRole.atmosphere],
    'stop_position': [StoryRole.witness],
  },
};

/// Service for classifying POIs into story roles based on OSM tags.
///
/// Uses the classification rules defined in CLAUDE.md to map OSM tags
/// to narrative functions in the game.
class ClassificationService {
  /// Classifies a single POI based on its OSM tags.
  ///
  /// Returns a list of [StoryRole]s that match the POI's tags.
  /// If no rules match, returns [StoryRole.atmosphere] as a fallback.
  List<StoryRole> classifyPOI(POI poi) {
    final roles = <StoryRole>{};

    for (final entry in poi.osmTags.entries) {
      final tagKey = entry.key;
      final tagValue = entry.value;

      // Check if we have rules for this tag key
      final valueRules = classificationRules[tagKey];
      if (valueRules == null) continue;

      // First, check for exact value match
      final exactRoles = valueRules[tagValue];
      if (exactRoles != null) {
        roles.addAll(exactRoles);
      }

      // Then, check for wildcard match (if no exact match found for this key)
      // Wildcard applies to any value for that key
      if (exactRoles == null) {
        final wildcardRoles = valueRules['*'];
        if (wildcardRoles != null) {
          roles.addAll(wildcardRoles);
        }
      }
    }

    // Fallback to atmosphere if no roles matched
    if (roles.isEmpty) {
      return [StoryRole.atmosphere];
    }

    return roles.toList();
  }

  /// Classifies all POIs and returns new instances with storyRoles populated.
  ///
  /// The original POI instances are not modified.
  List<POI> classifyAll(List<POI> pois) {
    return pois.map((poi) {
      final roles = classifyPOI(poi);
      return poi.copyWith(storyRoles: roles);
    }).toList();
  }

  /// Groups POIs by their story roles.
  ///
  /// A POI can appear in multiple groups if it has multiple roles.
  /// Returns a map from StoryRole to list of POIs with that role.
  Map<StoryRole, List<POI>> groupByRole(List<POI> pois) {
    final grouped = <StoryRole, List<POI>>{};

    // Initialize all role lists
    for (final role in StoryRole.values) {
      grouped[role] = [];
    }

    // Add POIs to their role groups
    for (final poi in pois) {
      for (final role in poi.storyRoles) {
        grouped[role]!.add(poi);
      }
    }

    return grouped;
  }

  /// Gets all POIs that have a specific role.
  List<POI> getPOIsWithRole(List<POI> pois, StoryRole role) {
    return pois.where((poi) => poi.storyRoles.contains(role)).toList();
  }

  /// Gets all POIs that have any of the specified roles.
  List<POI> getPOIsWithAnyRole(List<POI> pois, List<StoryRole> roles) {
    return pois
        .where((poi) => poi.storyRoles.any((r) => roles.contains(r)))
        .toList();
  }

  /// Checks if there is at least one POI for each required role.
  ///
  /// Returns a map of missing roles (empty if all roles are covered).
  Map<StoryRole, bool> checkRoleCoverage(
    List<POI> pois,
    List<StoryRole> requiredRoles,
  ) {
    final coverage = <StoryRole, bool>{};
    final grouped = groupByRole(pois);

    for (final role in requiredRoles) {
      coverage[role] = grouped[role]?.isNotEmpty ?? false;
    }

    return coverage;
  }
}
