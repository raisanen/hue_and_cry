import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

import 'package:hue_and_cry/utils/geo_utils.dart';

void main() {
  group('haversineDistance', () {
    test('returns 0 for identical points', () {
      final point = LatLng(51.5074, -0.1278); // London
      expect(haversineDistance(point, point), equals(0.0));
    });

    test('calculates correct distance between London and Paris', () {
      final london = LatLng(51.5074, -0.1278);
      final paris = LatLng(48.8566, 2.3522);

      // Known distance: approximately 343 km
      final distance = haversineDistance(london, paris);
      expect(distance, closeTo(343500, 1000)); // Within 1km accuracy
    });

    test('calculates correct distance between New York and Los Angeles', () {
      final newYork = LatLng(40.7128, -74.0060);
      final losAngeles = LatLng(34.0522, -118.2437);

      // Known distance: approximately 3944 km
      final distance = haversineDistance(newYork, losAngeles);
      expect(distance, closeTo(3944000, 10000)); // Within 10km accuracy
    });

    test('calculates short distances accurately', () {
      // Two points approximately 100 meters apart
      final point1 = LatLng(51.5074, -0.1278);
      final point2 = LatLng(51.5083, -0.1278); // ~100m north

      final distance = haversineDistance(point1, point2);
      expect(distance, closeTo(100, 5)); // Within 5m accuracy
    });

    test('is symmetric (order of points does not matter)', () {
      final london = LatLng(51.5074, -0.1278);
      final paris = LatLng(48.8566, 2.3522);

      final distance1 = haversineDistance(london, paris);
      final distance2 = haversineDistance(paris, london);

      expect(distance1, equals(distance2));
    });

    test('handles points across the prime meridian', () {
      final west = LatLng(51.5, -0.5);
      final east = LatLng(51.5, 0.5);

      final distance = haversineDistance(west, east);
      // ~70km at this latitude
      expect(distance, closeTo(70000, 1000));
    });

    test('handles points across the equator', () {
      final north = LatLng(1.0, 0.0);
      final south = LatLng(-1.0, 0.0);

      final distance = haversineDistance(north, south);
      // ~222km (2 degrees of latitude)
      expect(distance, closeTo(222000, 1000));
    });
  });

  group('isWithinRadius', () {
    test('returns true for point at center', () {
      final center = LatLng(51.5074, -0.1278);
      expect(isWithinRadius(center, center, 100), isTrue);
    });

    test('returns true for point within radius', () {
      final center = LatLng(51.5074, -0.1278);
      final nearby = LatLng(51.5075, -0.1278); // ~11m away

      expect(isWithinRadius(center, nearby, 50), isTrue);
    });

    test('returns false for point outside radius', () {
      final center = LatLng(51.5074, -0.1278);
      final far = LatLng(51.5174, -0.1278); // ~1.1km away

      expect(isWithinRadius(center, far, 50), isFalse);
    });

    test('returns true for point just inside radius boundary', () {
      final center = LatLng(51.5074, -0.1278);
      // Calculate a point approximately 45m north (inside 50m radius)
      final justInside = LatLng(51.5078, -0.1278);

      expect(isWithinRadius(center, justInside, 50), isTrue);
    });

    test('returns false for point just outside radius boundary', () {
      final center = LatLng(51.5074, -0.1278);
      // Point approximately 55m north (outside 50m radius)
      final justOutside = LatLng(51.5079, -0.1278);

      expect(isWithinRadius(center, justOutside, 50), isFalse);
    });
  });

  group('canInteract', () {
    test('returns true for player within 50m of location', () {
      final location = LatLng(51.5074, -0.1278);
      final player = LatLng(51.5076, -0.1278); // ~22m away

      expect(canInteract(player, location), isTrue);
    });

    test('returns false for player beyond 50m of location', () {
      final location = LatLng(51.5074, -0.1278);
      final player = LatLng(51.5084, -0.1278); // ~111m away

      expect(canInteract(player, location), isFalse);
    });
  });

  group('hasVisited', () {
    test('returns true for player within 30m of location', () {
      final location = LatLng(51.5074, -0.1278);
      final player = LatLng(51.5076, -0.1278); // ~22m away

      expect(hasVisited(player, location), isTrue);
    });

    test('returns false for player beyond 30m of location', () {
      final location = LatLng(51.5074, -0.1278);
      final player = LatLng(51.5078, -0.1278); // ~44m away

      expect(hasVisited(player, location), isFalse);
    });
  });

  group('calculateBoundingBox', () {
    test('creates bounding box centered on given point', () {
      final center = LatLng(51.5074, -0.1278);
      final bbox = calculateBoundingBox(center, 1000);

      // Check that center is roughly in the middle
      expect(bbox.center.latitude, closeTo(center.latitude, 0.001));
      expect(bbox.center.longitude, closeTo(center.longitude, 0.001));
    });

    test('bounding box extends approximately correct distance', () {
      final center = LatLng(51.5074, -0.1278);
      final bbox = calculateBoundingBox(center, 1000);

      // Check north-south extent (should be ~2km)
      final northSouthDistance = haversineDistance(
        LatLng(bbox.south, center.longitude),
        LatLng(bbox.north, center.longitude),
      );
      expect(northSouthDistance, closeTo(2000, 100));

      // Check that center to edge is approximately the radius
      final centerToNorth = haversineDistance(
        center,
        LatLng(bbox.north, center.longitude),
      );
      expect(centerToNorth, closeTo(1000, 50));
    });

    test('south is less than north', () {
      final center = LatLng(51.5074, -0.1278);
      final bbox = calculateBoundingBox(center, 1000);

      expect(bbox.south, lessThan(bbox.north));
    });

    test('west is less than east for non-wrapping boxes', () {
      final center = LatLng(51.5074, -0.1278);
      final bbox = calculateBoundingBox(center, 1000);

      expect(bbox.west, lessThan(bbox.east));
    });

    test('handles small radius', () {
      final center = LatLng(51.5074, -0.1278);
      final bbox = calculateBoundingBox(center, 50);

      expect(bbox.south, lessThan(center.latitude));
      expect(bbox.north, greaterThan(center.latitude));
      expect(bbox.west, lessThan(center.longitude));
      expect(bbox.east, greaterThan(center.longitude));
    });

    test('handles large radius', () {
      final center = LatLng(51.5074, -0.1278);
      final bbox = calculateBoundingBox(center, 10000);

      // ~20km extent
      final northSouthDistance = haversineDistance(
        LatLng(bbox.south, center.longitude),
        LatLng(bbox.north, center.longitude),
      );
      expect(northSouthDistance, closeTo(20000, 500));
    });

    test('clamps latitude to valid range', () {
      // Near the north pole
      final center = LatLng(89.5, 0.0);
      final bbox = calculateBoundingBox(center, 100000);

      expect(bbox.north, lessThanOrEqualTo(90.0));
      expect(bbox.south, greaterThanOrEqualTo(-90.0));
    });

    test('toOverpassString formats correctly', () {
      final bbox = BoundingBox(
        south: 51.0,
        west: -0.5,
        north: 52.0,
        east: 0.5,
      );

      expect(bbox.toOverpassString(), equals('51.0,-0.5,52.0,0.5'));
    });
  });

  group('BoundingBox', () {
    test('equality works correctly', () {
      final bbox1 = BoundingBox(south: 51.0, west: -0.5, north: 52.0, east: 0.5);
      final bbox2 = BoundingBox(south: 51.0, west: -0.5, north: 52.0, east: 0.5);
      final bbox3 = BoundingBox(south: 51.1, west: -0.5, north: 52.0, east: 0.5);

      expect(bbox1, equals(bbox2));
      expect(bbox1, isNot(equals(bbox3)));
    });

    test('hashCode is consistent with equality', () {
      final bbox1 = BoundingBox(south: 51.0, west: -0.5, north: 52.0, east: 0.5);
      final bbox2 = BoundingBox(south: 51.0, west: -0.5, north: 52.0, east: 0.5);

      expect(bbox1.hashCode, equals(bbox2.hashCode));
    });

    test('toString provides readable output', () {
      final bbox = BoundingBox(south: 51.0, west: -0.5, north: 52.0, east: 0.5);

      expect(bbox.toString(), contains('BoundingBox'));
      expect(bbox.toString(), contains('51.0'));
    });
  });

  group('constants', () {
    test('unlock radius is 50 meters', () {
      expect(unlockRadiusMeters, equals(50.0));
    });

    test('visit radius is 30 meters', () {
      expect(visitRadiusMeters, equals(30.0));
    });

    test('visit radius is less than unlock radius', () {
      expect(visitRadiusMeters, lessThan(unlockRadiusMeters));
    });
  });
}
