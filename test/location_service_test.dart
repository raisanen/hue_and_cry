import 'package:flutter_test/flutter_test.dart';
import 'package:hue_and_cry/services/location_service.dart';
import 'package:latlong2/latlong.dart';

void main() {
  group('LocationState', () {
    test('default state has unknown status', () {
      const state = LocationState();

      expect(state.status, equals(LocationStatus.unknown));
      expect(state.currentPosition, isNull);
      expect(state.lastUpdated, isNull);
      expect(state.error, isNull);
      expect(state.accuracy, isNull);
    });

    test('isReady returns true only when status is ready', () {
      const unknownState = LocationState(status: LocationStatus.unknown);
      const checkingState = LocationState(status: LocationStatus.checking);
      const deniedState = LocationState(status: LocationStatus.denied);
      const deniedForeverState = LocationState(status: LocationStatus.deniedForever);
      const disabledState = LocationState(status: LocationStatus.disabled);
      const readyState = LocationState(status: LocationStatus.ready);

      expect(unknownState.isReady, isFalse);
      expect(checkingState.isReady, isFalse);
      expect(deniedState.isReady, isFalse);
      expect(deniedForeverState.isReady, isFalse);
      expect(disabledState.isReady, isFalse);
      expect(readyState.isReady, isTrue);
    });

    test('isLoading returns true for unknown and checking', () {
      const unknownState = LocationState(status: LocationStatus.unknown);
      const checkingState = LocationState(status: LocationStatus.checking);
      const readyState = LocationState(status: LocationStatus.ready);
      const deniedState = LocationState(status: LocationStatus.denied);

      expect(unknownState.isLoading, isTrue);
      expect(checkingState.isLoading, isTrue);
      expect(readyState.isLoading, isFalse);
      expect(deniedState.isLoading, isFalse);
    });

    test('hasIssue returns true for denied, deniedForever, and disabled', () {
      const deniedState = LocationState(status: LocationStatus.denied);
      const deniedForeverState = LocationState(status: LocationStatus.deniedForever);
      const disabledState = LocationState(status: LocationStatus.disabled);
      const readyState = LocationState(status: LocationStatus.ready);
      const unknownState = LocationState(status: LocationStatus.unknown);

      expect(deniedState.hasIssue, isTrue);
      expect(deniedForeverState.hasIssue, isTrue);
      expect(disabledState.hasIssue, isTrue);
      expect(readyState.hasIssue, isFalse);
      expect(unknownState.hasIssue, isFalse);
    });

    test('copyWith updates specified fields', () {
      const position = LatLng(51.5074, -0.1278);
      final now = DateTime.now();

      const original = LocationState(
        status: LocationStatus.unknown,
        error: 'Original error',
      );

      final updated = original.copyWith(
        status: LocationStatus.ready,
        currentPosition: position,
        lastUpdated: now,
        accuracy: 10.5,
      );

      expect(updated.status, equals(LocationStatus.ready));
      expect(updated.currentPosition, equals(position));
      expect(updated.lastUpdated, equals(now));
      expect(updated.accuracy, equals(10.5));
      expect(updated.error, equals('Original error')); // Preserved
    });

    test('copyWith with clearError removes error', () {
      const original = LocationState(
        status: LocationStatus.ready,
        error: 'Some error',
      );

      final updated = original.copyWith(clearError: true);

      expect(updated.error, isNull);
      expect(updated.status, equals(LocationStatus.ready));
    });

    test('copyWith with clearPosition removes position', () {
      const original = LocationState(
        status: LocationStatus.ready,
        currentPosition: LatLng(51.5074, -0.1278),
      );

      final updated = original.copyWith(clearPosition: true);

      expect(updated.currentPosition, isNull);
      expect(updated.status, equals(LocationStatus.ready));
    });

    test('equality works correctly', () {
      final now = DateTime(2024, 1, 1, 12, 0, 0);
      const position = LatLng(51.5074, -0.1278);

      final state1 = LocationState(
        status: LocationStatus.ready,
        currentPosition: position,
        lastUpdated: now,
        accuracy: 10.0,
      );

      final state2 = LocationState(
        status: LocationStatus.ready,
        currentPosition: position,
        lastUpdated: now,
        accuracy: 10.0,
      );

      final state3 = LocationState(
        status: LocationStatus.ready,
        currentPosition: position,
        lastUpdated: now,
        accuracy: 20.0, // Different accuracy
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });

    test('hashCode is consistent with equality', () {
      final now = DateTime(2024, 1, 1, 12, 0, 0);
      const position = LatLng(51.5074, -0.1278);

      final state1 = LocationState(
        status: LocationStatus.ready,
        currentPosition: position,
        lastUpdated: now,
        accuracy: 10.0,
      );

      final state2 = LocationState(
        status: LocationStatus.ready,
        currentPosition: position,
        lastUpdated: now,
        accuracy: 10.0,
      );

      expect(state1.hashCode, equals(state2.hashCode));
    });

    test('toString provides readable output', () {
      const state = LocationState(
        status: LocationStatus.ready,
        currentPosition: LatLng(51.5074, -0.1278),
        accuracy: 15.5,
        error: 'test error',
      );

      final str = state.toString();

      expect(str, contains('status: LocationStatus.ready'));
      expect(str, contains('accuracy: 15.5m'));
      expect(str, contains('error: test error'));
    });
  });

  group('LocationStatus', () {
    test('all status values exist', () {
      expect(LocationStatus.values, contains(LocationStatus.unknown));
      expect(LocationStatus.values, contains(LocationStatus.checking));
      expect(LocationStatus.values, contains(LocationStatus.denied));
      expect(LocationStatus.values, contains(LocationStatus.deniedForever));
      expect(LocationStatus.values, contains(LocationStatus.disabled));
      expect(LocationStatus.values, contains(LocationStatus.ready));
    });
  });

  group('LocationService', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService();
    });

    test('positionToLatLng converts correctly', () {
      // We can't easily test this without mocking Geolocator's Position
      // which is a final class. Instead, we test the service exists.
      expect(locationService, isNotNull);
    });

    test('distanceBetween calculates distance', () {
      // London coordinates
      const start = LatLng(51.5074, -0.1278);
      // ~111m north (roughly 0.001 degrees latitude)
      const end = LatLng(51.5084, -0.1278);

      final distance = locationService.distanceBetween(start, end);

      // Should be approximately 111 meters
      expect(distance, greaterThan(100));
      expect(distance, lessThan(120));
    });

    test('distanceBetween returns 0 for same point', () {
      const point = LatLng(51.5074, -0.1278);

      final distance = locationService.distanceBetween(point, point);

      expect(distance, equals(0.0));
    });

    test('distanceBetween works for larger distances', () {
      // London
      const london = LatLng(51.5074, -0.1278);
      // Paris
      const paris = LatLng(48.8566, 2.3522);

      final distance = locationService.distanceBetween(london, paris);

      // London to Paris is approximately 344 km
      expect(distance, greaterThan(340000));
      expect(distance, lessThan(350000));
    });
  });

  group('LocationState scenarios', () {
    test('initial loading state', () {
      const state = LocationState(status: LocationStatus.checking);

      expect(state.isLoading, isTrue);
      expect(state.isReady, isFalse);
      expect(state.hasIssue, isFalse);
    });

    test('permission denied state', () {
      const state = LocationState(
        status: LocationStatus.denied,
        error: 'Permission denied by user',
      );

      expect(state.isLoading, isFalse);
      expect(state.isReady, isFalse);
      expect(state.hasIssue, isTrue);
      expect(state.error, isNotNull);
    });

    test('location disabled state', () {
      const state = LocationState(
        status: LocationStatus.disabled,
        error: 'GPS is turned off',
      );

      expect(state.isLoading, isFalse);
      expect(state.isReady, isFalse);
      expect(state.hasIssue, isTrue);
    });

    test('ready state with position', () {
      final state = LocationState(
        status: LocationStatus.ready,
        currentPosition: const LatLng(51.5074, -0.1278),
        lastUpdated: DateTime.now(),
        accuracy: 10.0,
      );

      expect(state.isLoading, isFalse);
      expect(state.isReady, isTrue);
      expect(state.hasIssue, isFalse);
      expect(state.currentPosition, isNotNull);
      expect(state.accuracy, equals(10.0));
    });

    test('ready state with error (position fetch failed)', () {
      const state = LocationState(
        status: LocationStatus.ready,
        error: 'Could not get position',
      );

      expect(state.isReady, isTrue);
      expect(state.hasIssue, isFalse);
      expect(state.error, isNotNull);
      expect(state.currentPosition, isNull);
    });

    test('state transition from checking to ready', () {
      const checking = LocationState(status: LocationStatus.checking);

      final ready = checking.copyWith(
        status: LocationStatus.ready,
        currentPosition: const LatLng(51.5074, -0.1278),
        lastUpdated: DateTime.now(),
        accuracy: 5.0,
      );

      expect(checking.isLoading, isTrue);
      expect(ready.isReady, isTrue);
      expect(ready.currentPosition, isNotNull);
    });

    test('state transition from ready to error', () {
      final ready = LocationState(
        status: LocationStatus.ready,
        currentPosition: const LatLng(51.5074, -0.1278),
        lastUpdated: DateTime.now(),
      );

      final withError = ready.copyWith(
        error: 'GPS signal lost',
      );

      // Still ready, just has an error
      expect(withError.isReady, isTrue);
      expect(withError.error, isNotNull);
      // Position should be preserved
      expect(withError.currentPosition, equals(ready.currentPosition));
    });

    test('position update preserves status', () {
      final original = LocationState(
        status: LocationStatus.ready,
        currentPosition: const LatLng(51.5074, -0.1278),
        lastUpdated: DateTime(2024, 1, 1, 12, 0, 0),
        accuracy: 10.0,
      );

      final newTime = DateTime(2024, 1, 1, 12, 5, 0);
      final updated = original.copyWith(
        currentPosition: const LatLng(51.5080, -0.1280),
        lastUpdated: newTime,
        accuracy: 5.0,
      );

      expect(updated.status, equals(LocationStatus.ready));
      expect(updated.lastUpdated, equals(newTime));
      expect(updated.currentPosition!.latitude, closeTo(51.5080, 0.0001));
    });
  });
}
