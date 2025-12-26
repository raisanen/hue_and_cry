import 'package:flutter_test/flutter_test.dart';

import 'package:hue_and_cry/models/poi.dart';
import 'package:hue_and_cry/models/story_role.dart';
import 'package:hue_and_cry/services/classification_service.dart';

void main() {
  late ClassificationService service;

  setUp(() {
    service = ClassificationService();
  });

  /// Helper to create a POI with specific tags
  POI createPOI({
    int osmId = 1,
    String? name,
    double lat = 51.5,
    double lon = -0.1,
    Map<String, String> tags = const {},
  }) {
    return POI(
      osmId: osmId,
      name: name,
      lat: lat,
      lon: lon,
      osmTags: tags,
      storyRoles: const [],
    );
  }

  group('ClassificationService', () {
    group('classifyPOI', () {
      // ═══════════════════════════════════════════════════════════════════════
      // TEST: Each StoryRole has at least one matching rule
      // ═══════════════════════════════════════════════════════════════════════

      test('classifies parks as crimeScene', () {
        final poi = createPOI(tags: {'leisure': 'park'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.crimeScene));
      });

      test('classifies cafes as information source', () {
        final poi = createPOI(tags: {'amenity': 'cafe'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.information));
      });

      test('classifies hotels as witness locations', () {
        final poi = createPOI(tags: {'tourism': 'hotel'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.witness));
      });

      test('classifies banks as suspectWork', () {
        final poi = createPOI(tags: {'amenity': 'bank'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.suspectWork));
      });

      test('classifies police stations as authority', () {
        final poi = createPOI(tags: {'amenity': 'police'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.authority));
      });

      test('classifies cemeteries as hidden', () {
        final poi = createPOI(tags: {'landuse': 'cemetery'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.hidden));
      });

      test('classifies museums as atmosphere', () {
        final poi = createPOI(tags: {'tourism': 'museum'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.atmosphere));
      });

      // ═══════════════════════════════════════════════════════════════════════
      // TEST: Wildcard matching works
      // ═══════════════════════════════════════════════════════════════════════

      test('wildcard office=* matches any office type', () {
        final poi1 = createPOI(tags: {'office': 'government'});
        final poi2 = createPOI(tags: {'office': 'consulting'});
        final poi3 = createPOI(tags: {'office': 'ngo'});

        expect(service.classifyPOI(poi1), contains(StoryRole.suspectWork));
        expect(service.classifyPOI(poi2), contains(StoryRole.suspectWork));
        expect(service.classifyPOI(poi3), contains(StoryRole.suspectWork));
      });

      test('wildcard shop=* matches any shop type', () {
        final poi1 = createPOI(tags: {'shop': 'clothes'});
        final poi2 = createPOI(tags: {'shop': 'electronics'});
        final poi3 = createPOI(tags: {'shop': 'florist'});

        expect(service.classifyPOI(poi1), contains(StoryRole.suspectWork));
        expect(service.classifyPOI(poi2), contains(StoryRole.suspectWork));
        expect(service.classifyPOI(poi3), contains(StoryRole.suspectWork));
      });

      test('wildcard historic=* matches any historic type', () {
        final poi1 = createPOI(tags: {'historic': 'boundary_stone'});
        final poi2 = createPOI(tags: {'historic': 'wayside_cross'});

        expect(service.classifyPOI(poi1), contains(StoryRole.atmosphere));
        expect(service.classifyPOI(poi2), contains(StoryRole.atmosphere));
      });

      test('specific rules take precedence over wildcard', () {
        // Hairdresser has specific rules: information + suspectWork
        final hairdresser = createPOI(tags: {'shop': 'hairdresser'});
        final roles = service.classifyPOI(hairdresser);

        // Should have information from specific rule, not just suspectWork from wildcard
        expect(roles, contains(StoryRole.information));
        expect(roles, contains(StoryRole.suspectWork));
      });

      // ═══════════════════════════════════════════════════════════════════════
      // TEST: Multiple roles can be assigned to one POI
      // ═══════════════════════════════════════════════════════════════════════

      test('POI can have multiple roles from single tag', () {
        // Parks have both crimeScene and hidden
        final poi = createPOI(tags: {'leisure': 'park'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.crimeScene));
        expect(roles, contains(StoryRole.hidden));
        expect(roles.length, equals(2));
      });

      test('POI can accumulate roles from multiple tags', () {
        // A café in a historic building
        final poi = createPOI(tags: {
          'amenity': 'cafe',
          'historic': 'building',
        });
        final roles = service.classifyPOI(poi);

        // Should have roles from both amenity=cafe and historic=building
        expect(roles, contains(StoryRole.information)); // from cafe
        expect(roles, contains(StoryRole.witness)); // from cafe
        expect(roles, contains(StoryRole.atmosphere)); // from historic
      });

      test('duplicate roles are not repeated', () {
        // Hospital is authority+witness, tourism=hotel is atmosphere+witness
        // witness should only appear once
        final poi = createPOI(tags: {
          'amenity': 'hospital',
          'tourism': 'hotel',
        });
        final roles = service.classifyPOI(poi);

        final witnessCount =
            roles.where((r) => r == StoryRole.witness).length;
        expect(witnessCount, equals(1));
      });

      // ═══════════════════════════════════════════════════════════════════════
      // TEST: Fallback to atmosphere
      // ═══════════════════════════════════════════════════════════════════════

      test('fallback to atmosphere when no rules match', () {
        // Unknown tag that has no classification rules
        final poi = createPOI(tags: {'highway': 'residential'});
        final roles = service.classifyPOI(poi);

        expect(roles, equals([StoryRole.atmosphere]));
      });

      test('fallback to atmosphere when POI has no tags', () {
        final poi = createPOI(tags: {});
        final roles = service.classifyPOI(poi);

        expect(roles, equals([StoryRole.atmosphere]));
      });

      test('does not fallback when at least one rule matches', () {
        final poi = createPOI(tags: {'amenity': 'police'});
        final roles = service.classifyPOI(poi);

        expect(roles, isNot(contains(StoryRole.atmosphere)));
        expect(roles, contains(StoryRole.authority));
      });

      // ═══════════════════════════════════════════════════════════════════════
      // TEST: Specific classification rules
      // ═══════════════════════════════════════════════════════════════════════

      test('classifies bars as information + witness', () {
        final poi = createPOI(tags: {'amenity': 'bar'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.information));
        expect(roles, contains(StoryRole.witness));
      });

      test('classifies places of worship as hidden + atmosphere', () {
        final poi = createPOI(tags: {'amenity': 'place_of_worship'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.hidden));
        expect(roles, contains(StoryRole.atmosphere));
      });

      test('classifies libraries as information', () {
        final poi = createPOI(tags: {'amenity': 'library'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.information));
      });

      test('classifies parking as crimeScene', () {
        final poi = createPOI(tags: {'amenity': 'parking'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.crimeScene));
      });

      test('classifies ruins as atmosphere + hidden + crimeScene', () {
        final poi = createPOI(tags: {'historic': 'ruins'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.atmosphere));
        expect(roles, contains(StoryRole.hidden));
        expect(roles, contains(StoryRole.crimeScene));
      });

      test('classifies railway stations as witness + atmosphere', () {
        final poi = createPOI(tags: {'railway': 'station'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.witness));
        expect(roles, contains(StoryRole.atmosphere));
      });

      test('classifies lawyer offices with authority role', () {
        final poi = createPOI(tags: {'office': 'lawyer'});
        final roles = service.classifyPOI(poi);

        expect(roles, contains(StoryRole.suspectWork));
        expect(roles, contains(StoryRole.authority));
      });
    });

    group('classifyAll', () {
      test('classifies all POIs and returns new instances', () {
        final pois = [
          createPOI(osmId: 1, tags: {'amenity': 'cafe'}),
          createPOI(osmId: 2, tags: {'leisure': 'park'}),
          createPOI(osmId: 3, tags: {'amenity': 'police'}),
        ];

        final classified = service.classifyAll(pois);

        expect(classified, hasLength(3));

        // Check first POI (cafe)
        expect(classified[0].osmId, equals(1));
        expect(classified[0].storyRoles, contains(StoryRole.information));

        // Check second POI (park)
        expect(classified[1].osmId, equals(2));
        expect(classified[1].storyRoles, contains(StoryRole.crimeScene));

        // Check third POI (police)
        expect(classified[2].osmId, equals(3));
        expect(classified[2].storyRoles, contains(StoryRole.authority));
      });

      test('original POIs are not modified', () {
        final original = createPOI(tags: {'amenity': 'cafe'});
        service.classifyAll([original]);

        // Original should still have empty storyRoles
        expect(original.storyRoles, isEmpty);
      });

      test('handles empty list', () {
        final classified = service.classifyAll([]);
        expect(classified, isEmpty);
      });
    });

    group('groupByRole', () {
      test('groups POIs by their story roles', () {
        final pois = [
          createPOI(osmId: 1, tags: {'amenity': 'cafe'}),
          createPOI(osmId: 2, tags: {'amenity': 'bar'}),
          createPOI(osmId: 3, tags: {'leisure': 'park'}),
        ];

        final classified = service.classifyAll(pois);
        final grouped = service.groupByRole(classified);

        // Cafe and bar should be in information
        expect(grouped[StoryRole.information], hasLength(2));

        // Park should be in crimeScene
        expect(grouped[StoryRole.crimeScene], hasLength(1));
        expect(grouped[StoryRole.crimeScene]![0].osmId, equals(3));
      });

      test('POI appears in multiple groups if it has multiple roles', () {
        final poi = createPOI(tags: {'leisure': 'park'}); // crimeScene + hidden
        final classified = service.classifyAll([poi]);
        final grouped = service.groupByRole(classified);

        expect(grouped[StoryRole.crimeScene], hasLength(1));
        expect(grouped[StoryRole.hidden], hasLength(1));
        expect(
          identical(
              grouped[StoryRole.crimeScene]![0], grouped[StoryRole.hidden]![0]),
          isTrue,
        );
      });

      test('all role keys exist even if empty', () {
        final grouped = service.groupByRole([]);

        for (final role in StoryRole.values) {
          expect(grouped.containsKey(role), isTrue);
          expect(grouped[role], isEmpty);
        }
      });
    });

    group('getPOIsWithRole', () {
      test('returns POIs with specified role', () {
        final pois = [
          createPOI(osmId: 1, tags: {'amenity': 'cafe'}),
          createPOI(osmId: 2, tags: {'leisure': 'park'}),
          createPOI(osmId: 3, tags: {'amenity': 'police'}),
        ];

        final classified = service.classifyAll(pois);
        final informationPOIs =
            service.getPOIsWithRole(classified, StoryRole.information);

        expect(informationPOIs, hasLength(1));
        expect(informationPOIs[0].osmId, equals(1));
      });

      test('returns empty list if no POIs have role', () {
        final pois = [
          createPOI(osmId: 1, tags: {'amenity': 'cafe'}),
        ];

        final classified = service.classifyAll(pois);
        final authorityPOIs =
            service.getPOIsWithRole(classified, StoryRole.authority);

        expect(authorityPOIs, isEmpty);
      });
    });

    group('getPOIsWithAnyRole', () {
      test('returns POIs with any of specified roles', () {
        final pois = [
          createPOI(osmId: 1, tags: {'amenity': 'cafe'}), // information
          createPOI(osmId: 2, tags: {'leisure': 'park'}), // crimeScene
          createPOI(osmId: 3, tags: {'amenity': 'police'}), // authority
        ];

        final classified = service.classifyAll(pois);
        final results = service.getPOIsWithAnyRole(
          classified,
          [StoryRole.information, StoryRole.authority],
        );

        expect(results, hasLength(2));
        expect(results.map((p) => p.osmId), containsAll([1, 3]));
      });
    });

    group('checkRoleCoverage', () {
      test('returns coverage map for required roles', () {
        final pois = [
          createPOI(osmId: 1, tags: {'amenity': 'cafe'}),
          createPOI(osmId: 2, tags: {'leisure': 'park'}),
        ];

        final classified = service.classifyAll(pois);
        final coverage = service.checkRoleCoverage(
          classified,
          [StoryRole.information, StoryRole.crimeScene, StoryRole.authority],
        );

        expect(coverage[StoryRole.information], isTrue);
        expect(coverage[StoryRole.crimeScene], isTrue);
        expect(coverage[StoryRole.authority], isFalse); // No police station
      });
    });

    group('all StoryRoles have matching rules', () {
      // This meta-test ensures that the classification rules cover all StoryRoles

      test('crimeScene has matching rules', () {
        // Parks, parking, etc.
        final poi = createPOI(tags: {'leisure': 'park'});
        expect(service.classifyPOI(poi), contains(StoryRole.crimeScene));
      });

      test('witness has matching rules', () {
        // Cafes, hotels, residential
        final poi = createPOI(tags: {'tourism': 'hotel'});
        expect(service.classifyPOI(poi), contains(StoryRole.witness));
      });

      test('suspectWork has matching rules', () {
        // Banks, offices, shops
        final poi = createPOI(tags: {'office': 'accountant'});
        expect(service.classifyPOI(poi), contains(StoryRole.suspectWork));
      });

      test('information has matching rules', () {
        // Cafes, bars, libraries
        final poi = createPOI(tags: {'amenity': 'library'});
        expect(service.classifyPOI(poi), contains(StoryRole.information));
      });

      test('authority has matching rules', () {
        // Police, hospitals, townhall
        final poi = createPOI(tags: {'amenity': 'townhall'});
        expect(service.classifyPOI(poi), contains(StoryRole.authority));
      });

      test('hidden has matching rules', () {
        // Churches, cemeteries
        final poi = createPOI(tags: {'landuse': 'cemetery'});
        expect(service.classifyPOI(poi), contains(StoryRole.hidden));
      });

      test('atmosphere has matching rules (explicit, not fallback)', () {
        // Museums, historic sites
        final poi = createPOI(tags: {'tourism': 'museum'});
        expect(service.classifyPOI(poi), contains(StoryRole.atmosphere));
      });
    });
  });
}
