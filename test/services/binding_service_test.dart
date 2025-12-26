import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:hue_and_cry/models/case_template.dart';
import 'package:hue_and_cry/models/location_requirement.dart';
import 'package:hue_and_cry/models/poi.dart';
import 'package:hue_and_cry/models/solution.dart';
import 'package:hue_and_cry/models/story_role.dart';
import 'package:hue_and_cry/services/binding_service.dart';

void main() {
  late BindingService service;
  late LatLng playerLocation;

  setUp(() {
    service = BindingService();
    // Central London as reference point
    playerLocation = LatLng(51.5074, -0.1278);
  });

  /// Helper to create a POI with specific properties
  POI createPOI({
    required int osmId,
    String? name,
    required double lat,
    required double lon,
    Map<String, String> tags = const {},
    List<StoryRole> roles = const [],
  }) {
    return POI(
      osmId: osmId,
      name: name,
      lat: lat,
      lon: lon,
      osmTags: tags,
      storyRoles: roles,
    );
  }

  /// Helper to create a simple case template
  CaseTemplate createTemplate({
    String id = 'test-case',
    Map<String, LocationRequirement>? locations,
  }) {
    return CaseTemplate(
      id: id,
      title: 'Test Case',
      subtitle: 'A test mystery',
      teaser: 'A test mystery teaser.',
      briefing: 'Test briefing',
      locations: locations ?? {},
      characters: [],
      clues: [],
      solution: const Solution(
        perpetratorId: 'suspect',
        motive: 'Test motive',
        method: 'Test method',
        keyEvidence: [],
        optimalPath: [],
      ),
    );
  }

  group('BindingService', () {
    group('bindCase', () {
      test('successful full binding with all locations matched', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'crime_scene': const LocationRequirement(
              id: 'crime_scene',
              role: StoryRole.crimeScene,
              required: true,
            ),
            'witness_cafe': const LocationRequirement(
              id: 'witness_cafe',
              role: StoryRole.information,
              required: true,
            ),
            'police_station': const LocationRequirement(
              id: 'police_station',
              role: StoryRole.authority,
              required: true,
            ),
          },
        );

        final pois = [
          createPOI(
            osmId: 1,
            name: 'Hyde Park',
            lat: 51.5073,
            lon: -0.1276,
            roles: [StoryRole.crimeScene, StoryRole.hidden],
          ),
          createPOI(
            osmId: 2,
            name: 'Costa Coffee',
            lat: 51.5080,
            lon: -0.1280,
            roles: [StoryRole.information, StoryRole.witness],
          ),
          createPOI(
            osmId: 3,
            name: 'Metropolitan Police',
            lat: 51.5090,
            lon: -0.1290,
            roles: [StoryRole.authority],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.errors, isEmpty);
        expect(result.boundCase.isPlayable, isTrue);
        expect(result.boundCase.boundLocations, hasLength(3));

        expect(result.boundCase.boundLocations['crime_scene']?.poi.name,
            equals('Hyde Park'));
        expect(result.boundCase.boundLocations['witness_cafe']?.poi.name,
            equals('Costa Coffee'));
        expect(result.boundCase.boundLocations['police_station']?.poi.name,
            equals('Metropolitan Police'));
      });

      test('partial binding with optional locations missing', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'crime_scene': const LocationRequirement(
              id: 'crime_scene',
              role: StoryRole.crimeScene,
              required: true,
            ),
            'red_herring': const LocationRequirement(
              id: 'red_herring',
              role: StoryRole.atmosphere,
              required: false, // Optional!
            ),
          },
        );

        final pois = [
          createPOI(
            osmId: 1,
            name: 'The Park',
            lat: 51.5073,
            lon: -0.1276,
            roles: [StoryRole.crimeScene],
          ),
          // No atmosphere POIs available
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isTrue); // Still playable
        expect(result.errors, isEmpty);
        expect(result.boundCase.isPlayable, isTrue);
        expect(result.boundCase.boundLocations, hasLength(1));
        expect(result.boundCase.unboundOptional, contains('red_herring'));
      });

      test('failed binding when required location missing', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'crime_scene': const LocationRequirement(
              id: 'crime_scene',
              role: StoryRole.crimeScene,
              required: true,
            ),
            'witness_cafe': const LocationRequirement(
              id: 'witness_cafe',
              role: StoryRole.information,
              required: true, // Required but no POIs available
            ),
          },
        );

        final pois = [
          createPOI(
            osmId: 1,
            name: 'The Park',
            lat: 51.5073,
            lon: -0.1276,
            roles: [StoryRole.crimeScene],
          ),
          // No information POIs available
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.errors, isNotEmpty);
        expect(result.errors.first, contains('witness_cafe'));
        expect(result.boundCase.isPlayable, isFalse);
        expect(result.boundCase.boundLocations, hasLength(1)); // Only crime_scene bound
      });

      test('closer POIs are preferred over farther ones', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'the_cafe': const LocationRequirement(
              id: 'the_cafe',
              role: StoryRole.information,
              required: true,
            ),
          },
        );

        // Three cafes at different distances
        final pois = [
          createPOI(
            osmId: 1,
            name: 'Far Cafe',
            lat: 51.5200, // ~1.4km away
            lon: -0.1278,
            roles: [StoryRole.information],
          ),
          createPOI(
            osmId: 2,
            name: 'Near Cafe',
            lat: 51.5075, // ~11m away - closest
            lon: -0.1278,
            roles: [StoryRole.information],
          ),
          createPOI(
            osmId: 3,
            name: 'Medium Cafe',
            lat: 51.5100, // ~290m away
            lon: -0.1278,
            roles: [StoryRole.information],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.boundCase.boundLocations['the_cafe']?.poi.name,
          equals('Near Cafe'),
        );
        expect(
          result.boundCase.boundLocations['the_cafe']?.distanceFromStart,
          lessThan(50), // Should be very close
        );
      });

      test('no POI reuse across locations', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'first_cafe': const LocationRequirement(
              id: 'first_cafe',
              role: StoryRole.information,
              required: true,
            ),
            'second_cafe': const LocationRequirement(
              id: 'second_cafe',
              role: StoryRole.information,
              required: true,
            ),
          },
        );

        // Only two cafes available
        final pois = [
          createPOI(
            osmId: 1,
            name: 'Cafe One',
            lat: 51.5075,
            lon: -0.1278,
            roles: [StoryRole.information],
          ),
          createPOI(
            osmId: 2,
            name: 'Cafe Two',
            lat: 51.5080,
            lon: -0.1280,
            roles: [StoryRole.information],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.boundCase.boundLocations, hasLength(2));

        final firstPoi = result.boundCase.boundLocations['first_cafe']?.poi;
        final secondPoi = result.boundCase.boundLocations['second_cafe']?.poi;

        // Ensure different POIs were used
        expect(firstPoi?.osmId, isNot(equals(secondPoi?.osmId)));
      });

      test('fails when POIs exhausted for required role', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'first_cafe': const LocationRequirement(
              id: 'first_cafe',
              role: StoryRole.information,
              required: true,
            ),
            'second_cafe': const LocationRequirement(
              id: 'second_cafe',
              role: StoryRole.information,
              required: true,
            ),
            'third_cafe': const LocationRequirement(
              id: 'third_cafe',
              role: StoryRole.information,
              required: true,
            ),
          },
        );

        // Only two cafes available for three required locations
        final pois = [
          createPOI(
            osmId: 1,
            name: 'Cafe One',
            lat: 51.5075,
            lon: -0.1278,
            roles: [StoryRole.information],
          ),
          createPOI(
            osmId: 2,
            name: 'Cafe Two',
            lat: 51.5080,
            lon: -0.1280,
            roles: [StoryRole.information],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.errors, hasLength(1));
        expect(result.errors.first, contains('third_cafe'));
        expect(result.boundCase.boundLocations, hasLength(2));
      });

      test('fallback role used when primary role unavailable', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'meeting_place': const LocationRequirement(
              id: 'meeting_place',
              role: StoryRole.hidden, // Primary: hidden
              fallbackRole: StoryRole.atmosphere, // Fallback: atmosphere
              required: true,
            ),
          },
        );

        // No hidden POIs, but atmosphere available
        final pois = [
          createPOI(
            osmId: 1,
            name: 'Old Museum',
            lat: 51.5075,
            lon: -0.1278,
            roles: [StoryRole.atmosphere], // Only atmosphere
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.boundCase.boundLocations['meeting_place']?.poi.name,
          equals('Old Museum'),
        );
      });

      test('preferred tags matched when available', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'the_pub': const LocationRequirement(
              id: 'the_pub',
              role: StoryRole.information,
              preferredTags: ['amenity=pub'],
              required: true,
            ),
          },
        );

        final pois = [
          createPOI(
            osmId: 1,
            name: 'The Cafe', // Closer but not a pub
            lat: 51.5075,
            lon: -0.1278,
            tags: {'amenity': 'cafe'},
            roles: [StoryRole.information],
          ),
          createPOI(
            osmId: 2,
            name: 'The Red Lion', // Farther but matches preferred tag
            lat: 51.5090,
            lon: -0.1290,
            tags: {'amenity': 'pub'},
            roles: [StoryRole.information],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(
          result.boundCase.boundLocations['the_pub']?.poi.name,
          equals('The Red Lion'),
        );
      });

      test('display name uses POI name when available', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'location': const LocationRequirement(
              id: 'location',
              role: StoryRole.information,
              required: true,
            ),
          },
        );

        final pois = [
          createPOI(
            osmId: 1,
            name: 'The Famous Café',
            lat: 51.5075,
            lon: -0.1278,
            roles: [StoryRole.information],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(
          result.boundCase.boundLocations['location']?.displayName,
          equals('The Famous Café'),
        );
      });

      test('display name uses description template when POI has no name', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'location': const LocationRequirement(
              id: 'location',
              role: StoryRole.information,
              descriptionTemplate: 'a quiet café on the corner',
              required: true,
            ),
          },
        );

        final pois = [
          createPOI(
            osmId: 1,
            name: null, // No name
            lat: 51.5075,
            lon: -0.1278,
            tags: {'amenity': 'cafe'},
            roles: [StoryRole.information],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(
          result.boundCase.boundLocations['location']?.displayName,
          equals('a quiet café on the corner'),
        );
      });

      test('handles empty POI list', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'location': const LocationRequirement(
              id: 'location',
              role: StoryRole.information,
              required: true,
            ),
          },
        );

        // Act
        final result = service.bindCase(template, [], playerLocation);

        // Assert
        expect(result.isSuccess, isFalse);
        expect(result.errors, isNotEmpty);
        expect(result.boundCase.boundLocations, isEmpty);
      });

      test('handles template with no locations', () {
        // Arrange
        final template = createTemplate(locations: {});

        final pois = [
          createPOI(
            osmId: 1,
            name: 'Some Place',
            lat: 51.5075,
            lon: -0.1278,
            roles: [StoryRole.information],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.boundCase.boundLocations, isEmpty);
        expect(result.boundCase.unboundOptional, isEmpty);
      });

      test('POI with multiple roles can satisfy different requirements', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'crime_scene': const LocationRequirement(
              id: 'crime_scene',
              role: StoryRole.crimeScene,
              required: true,
            ),
            'hidden_spot': const LocationRequirement(
              id: 'hidden_spot',
              role: StoryRole.hidden,
              required: true,
            ),
          },
        );

        // Two parks, both have crimeScene AND hidden roles
        final pois = [
          createPOI(
            osmId: 1,
            name: 'First Park',
            lat: 51.5075,
            lon: -0.1278,
            roles: [StoryRole.crimeScene, StoryRole.hidden],
          ),
          createPOI(
            osmId: 2,
            name: 'Second Park',
            lat: 51.5080,
            lon: -0.1280,
            roles: [StoryRole.crimeScene, StoryRole.hidden],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        expect(result.isSuccess, isTrue);
        expect(result.boundCase.boundLocations, hasLength(2));

        // Each location should use a different POI
        final crimeScenePoi =
            result.boundCase.boundLocations['crime_scene']?.poi;
        final hiddenSpotPoi =
            result.boundCase.boundLocations['hidden_spot']?.poi;

        expect(crimeScenePoi?.osmId, isNot(equals(hiddenSpotPoi?.osmId)));
      });

      test('distance from start is calculated correctly', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'location': const LocationRequirement(
              id: 'location',
              role: StoryRole.information,
              required: true,
            ),
          },
        );

        // POI approximately 100m north of player
        final pois = [
          createPOI(
            osmId: 1,
            name: 'Nearby Cafe',
            lat: 51.5083, // About 100m north
            lon: -0.1278,
            roles: [StoryRole.information],
          ),
        ];

        // Act
        final result = service.bindCase(template, pois, playerLocation);

        // Assert
        final distance =
            result.boundCase.boundLocations['location']?.distanceFromStart;
        expect(distance, isNotNull);
        expect(distance, greaterThan(90));
        expect(distance, lessThan(110));
      });
    });

    group('canBindCase', () {
      test('returns true when all required roles available', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'scene': const LocationRequirement(
              id: 'scene',
              role: StoryRole.crimeScene,
              required: true,
            ),
            'witness': const LocationRequirement(
              id: 'witness',
              role: StoryRole.witness,
              required: true,
            ),
          },
        );

        final roleCounts = {
          StoryRole.crimeScene: 2,
          StoryRole.witness: 3,
        };

        // Act
        final result = service.canBindCase(template, roleCounts);

        // Assert
        expect(result, isTrue);
      });

      test('returns false when required role missing', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'scene': const LocationRequirement(
              id: 'scene',
              role: StoryRole.crimeScene,
              required: true,
            ),
            'police': const LocationRequirement(
              id: 'police',
              role: StoryRole.authority,
              required: true,
            ),
          },
        );

        final roleCounts = {
          StoryRole.crimeScene: 2,
          // No authority POIs
        };

        // Act
        final result = service.canBindCase(template, roleCounts);

        // Assert
        expect(result, isFalse);
      });

      test('returns false when not enough POIs for role', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'cafe1': const LocationRequirement(
              id: 'cafe1',
              role: StoryRole.information,
              required: true,
            ),
            'cafe2': const LocationRequirement(
              id: 'cafe2',
              role: StoryRole.information,
              required: true,
            ),
          },
        );

        final roleCounts = {
          StoryRole.information: 1, // Need 2, only have 1
        };

        // Act
        final result = service.canBindCase(template, roleCounts);

        // Assert
        expect(result, isFalse);
      });

      test('ignores optional locations in count', () {
        // Arrange
        final template = createTemplate(
          locations: {
            'required': const LocationRequirement(
              id: 'required',
              role: StoryRole.crimeScene,
              required: true,
            ),
            'optional': const LocationRequirement(
              id: 'optional',
              role: StoryRole.atmosphere,
              required: false,
            ),
          },
        );

        final roleCounts = {
          StoryRole.crimeScene: 1,
          // No atmosphere POIs, but it's optional
        };

        // Act
        final result = service.canBindCase(template, roleCounts);

        // Assert
        expect(result, isTrue);
      });

      test('returns true for template with no required locations', () {
        // Arrange
        final template = createTemplate(locations: {});

        final roleCounts = <StoryRole, int>{};

        // Act
        final result = service.canBindCase(template, roleCounts);

        // Assert
        expect(result, isTrue);
      });
    });
  });
}
