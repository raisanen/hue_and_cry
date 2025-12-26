import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../services/location_service.dart';

export 'package:geolocator/geolocator.dart' show LocationPermission;

/// Provider for the LocationService instance.
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService();
});

/// Notifier that manages location state with streaming updates.
///
/// Handles:
/// - Initial permission checking and requesting
/// - Position streaming with automatic updates
/// - Error handling and status management
class LocationStateNotifier extends StateNotifier<LocationState> {
  final LocationService _locationService;
  StreamSubscription<LocationState>? _positionSubscription;
  bool _isInitialized = false;

  LocationStateNotifier(this._locationService)
      : super(const LocationState(status: LocationStatus.unknown));

  /// Initializes location tracking.
  ///
  /// Call this when the app needs location access. Will:
  /// 1. Check/request permissions
  /// 2. Start streaming position updates if granted
  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;

    state = state.copyWith(status: LocationStatus.checking, clearError: true);

    try {
      // Use the location service's state stream
      _positionSubscription = _locationService
          .getLocationStateStream(distanceFilter: 10)
          .listen(
        (newState) {
          state = newState;
        },
        onError: (error) {
          state = state.copyWith(
            error: 'Location error: $error',
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: LocationStatus.denied,
        error: 'Failed to initialize location: $e',
      );
    }
  }

  /// Attempts to request permission again.
  ///
  /// Use after the user has been informed about why location is needed.
  Future<void> requestPermission() async {
    state = state.copyWith(status: LocationStatus.checking, clearError: true);

    final permission = await _locationService.requestPermission();

    switch (permission) {
      case LocationPermission.denied:
        state = state.copyWith(
          status: LocationStatus.denied,
          error: 'Location permission denied.',
        );
        break;

      case LocationPermission.deniedForever:
        state = state.copyWith(
          status: LocationStatus.deniedForever,
          error: 'Location permission permanently denied. '
              'Please enable in settings.',
        );
        break;

      case LocationPermission.whileInUse:
      case LocationPermission.always:
        // Permission granted, reinitialize
        _isInitialized = false;
        await _positionSubscription?.cancel();
        _positionSubscription = null;
        await initialize();
        break;

      case LocationPermission.unableToDetermine:
        state = state.copyWith(
          status: LocationStatus.denied,
          error: 'Unable to determine permission status.',
        );
        break;
    }
  }

  /// Opens app settings for the user to grant permission.
  ///
  /// Use when permission is permanently denied.
  Future<bool> openAppSettings() async {
    return _locationService.openAppSettings();
  }

  /// Opens location settings for the user to enable GPS.
  ///
  /// Use when location services are disabled.
  Future<bool> openLocationSettings() async {
    return _locationService.openLocationSettings();
  }

  /// Refreshes the current position.
  ///
  /// Useful for getting an immediate position update rather than
  /// waiting for the stream's distance filter to trigger.
  Future<void> refreshPosition() async {
    if (state.status != LocationStatus.ready) return;

    try {
      final position = await _locationService.getCurrentPosition();
      state = state.copyWith(
        currentPosition: _locationService.positionToLatLng(position),
        lastUpdated: DateTime.now(),
        accuracy: position.accuracy,
        clearError: true,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to get position: $e',
      );
    }
  }

  /// Retries initialization after a failure.
  ///
  /// Use when the user has fixed the issue (enabled GPS, granted permission).
  Future<void> retry() async {
    _isInitialized = false;
    await _positionSubscription?.cancel();
    _positionSubscription = null;
    await initialize();
  }

  /// Sets a fixed demo position.
  ///
  /// Use for web demo mode or testing without real GPS.
  /// This will stop any active position stream and use the fixed position.
  void setDemoPosition(LatLng position) {
    _positionSubscription?.cancel();
    _positionSubscription = null;
    _isInitialized = true;

    state = LocationState(
      status: LocationStatus.ready,
      currentPosition: position,
      lastUpdated: DateTime.now(),
      accuracy: 10.0, // Demo accuracy
    );
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}

/// Provider for location state with streaming updates.
///
/// This is the main provider for location functionality.
/// Access via `ref.watch(locationStateProvider)`.
///
/// Example:
/// ```dart
/// final locationState = ref.watch(locationStateProvider);
/// if (locationState.isReady) {
///   final position = locationState.currentPosition;
///   // Use position
/// }
/// ```
final locationStateProvider =
    StateNotifierProvider<LocationStateNotifier, LocationState>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  return LocationStateNotifier(locationService);
});

/// Provider for just the current position.
///
/// Returns `null` if location is not ready.
/// Use this when you only need the position, not the full state.
final currentPositionProvider = Provider<LatLng?>((ref) {
  final locationState = ref.watch(locationStateProvider);
  return locationState.currentPosition;
});

/// Provider for location status.
///
/// Useful for conditional UI based on location availability.
final locationStatusProvider = Provider<LocationStatus>((ref) {
  return ref.watch(locationStateProvider).status;
});

/// Provider that indicates if location is ready.
///
/// Convenience provider for simple ready/not-ready checks.
final isLocationReadyProvider = Provider<bool>((ref) {
  return ref.watch(locationStateProvider).isReady;
});

/// Provider that indicates if location is still loading.
final isLocationLoadingProvider = Provider<bool>((ref) {
  return ref.watch(locationStateProvider).isLoading;
});

/// Provider for location errors.
///
/// Returns null if no error. Use to display error messages to user.
final locationErrorProvider = Provider<String?>((ref) {
  return ref.watch(locationStateProvider).error;
});

/// Provider for position accuracy in meters.
final locationAccuracyProvider = Provider<double?>((ref) {
  return ref.watch(locationStateProvider).accuracy;
});
