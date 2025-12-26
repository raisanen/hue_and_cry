import 'package:flutter_test/flutter_test.dart';
import 'package:hue_and_cry/utils/text_interpolation.dart';
import 'package:hue_and_cry/models/bound_case.dart';

import 'package:hue_and_cry/models/poi.dart';

final _mockPoi = POI(
  osmId: 1,
  name: 'Mock POI',
  lat: 0.0,
  lon: 0.0,
);

void main() {
  group('interpolateLocationText', () {
    test('replaces {location:id} with display name', () {
      final template = 'Meet at {location:cafe}.';
      final locations = {
        'cafe': BoundLocation(
          templateId: '',
          poi: _mockPoi,
          displayName: 'Café Central',
          distanceFromStart: 0,
        ),
      };
      final result = interpolateLocationText(template, locations);
      expect(result, 'Meet at Café Central.');
    });

    test('leaves unknown placeholders unchanged', () {
      final template = 'Go to {location:unknown}.';
      final locations = <String, BoundLocation>{};
      final result = interpolateLocationText(template, locations);
      expect(result, 'Go to {location:unknown}.');
    });
  });

  group('interpolateAllCaseText', () {
    test('interpolates all templates in map', () {
      final templates = {
        'briefing': 'Start at {location:start}.',
        'clue': 'Found at {location:clue_spot}.'
      };
      final locations = {
        'start': BoundLocation(
          templateId: '',
          poi: _mockPoi,
          displayName: 'Station',
          distanceFromStart: 0,
        ),
        'clue_spot': BoundLocation(
          templateId: '',
          poi: _mockPoi,
          displayName: 'Library',
          distanceFromStart: 0,
        ),
      };
      final result = interpolateAllCaseText(templates, locations);
      expect(result['briefing'], 'Start at Station.');
      expect(result['clue'], 'Found at Library.');
    });
  });
}
