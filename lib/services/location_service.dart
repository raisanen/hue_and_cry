import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// The current status of location services and permissions.
enum LocationStatus {
  /// Initial state, not yet checked.
  unknown,

  /// Currently checking permissions/services.
  checking,

  /// Location permission was denied by user.
  denied,

  /// Location permission was permanently denied.
  /// User must enable in system settings.
  deniedForever,

  /// Location services are disabled on the device.
  disabled,

  /// Location is available and ready to use.
  ready,
}

/// Represents the current state of location tracking.
class LocationState {
  /// Current status of location services.
  final LocationStatus status;

  /// Current position, if available.
  final LatLng? currentPosition;

  /// When the position was last updated.
  final DateTime? lastUpdated;

  /// Error message, if any.
  final String? error;

  /// Accuracy of the current position in meters.
  final double? accuracy;

  const LocationState({
    this.status = LocationStatus.unknown,
    this.currentPosition,
    this.lastUpdated,
    this.error,
    this.accuracy,
  });

  /// Creates a copy with updated fields.
  LocationState copyWith({
    LocationStatus? status,
    LatLng? currentPosition,
    DateTime? lastUpdated,
    String? error,
    double? accuracy,
    bool clearError = false,
    bool clearPosition = false,
  }) {
    return LocationState(
      status: status ?? this.status,
      currentPosition: clearPosition ? null : (currentPosition ?? this.currentPosition),
      lastUpdated: lastUpdated ?? this.lastUpdated,
      error: clearError ? null : (error ?? this.error),
      accuracy: accuracy ?? this.accuracy,
    );
  }

  /// Whether location is ready to use.
  bool get isReady => status == LocationStatus.ready;

  /// Whether we're still determining status.
  bool get isLoading => status == LocationStatus.unknown || status == LocationStatus.checking;

  /// Whether there's a permission or service issue.
  bool get hasIssue =>
      status == LocationStatus.denied ||
      status == LocationStatus.deniedForever ||
      status == LocationStatus.disabled;

  @override
  String toString() {
    return 'LocationState(status: $status, position: $currentPosition, '
        'accuracy: ${accuracy?.toStringAsFixed(1)}m, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationState &&
        other.status == status &&
        other.currentPosition == currentPosition &&
        other.lastUpdated == lastUpdated &&
        other.error == error &&
        other.accuracy == accuracy;
  }

  @override
  int get hashCode {
    return Object.hash(status, currentPosition, lastUpdated, error, accuracy);
  }
}

/// Service for handling GPS location functionality.
///
/// Wraps the geolocator package to provide:
/// - Permission checking and requesting
/// - Current position retrieval
/// - Position streaming with distance filter
/// - Conversion to LatLng for flutter_map compatibility
class LocationService {
  /// Checks the current location permission status.
  ///
  /// Returns [LocationPermission] indicating whether permission is:
  /// - denied: Not yet requested or denied
  /// - deniedForever: Permanently denied, must use settings
  /// - whileInUse: Granted for foreground use
  /// - always: Granted for background use
  Future<LocationPermission> checkPermission() async {
    return Geolocator.checkPermission();
  }

  /// Requests location permission from the user.
  ///
  /// Shows the system permission dialog. Returns the resulting
  /// [LocationPermission] status.
  ///
  /// Note: If permission is [LocationPermission.deniedForever],
  /// calling this will NOT show a dialog. Use [openAppSettings]
  /// or [openLocationSettings] instead.
  Future<LocationPermission> requestPermission() async {
    return Geolocator.requestPermission();
  }

  /// Checks if location services are enabled on the device.
  ///
  /// Returns `true` if GPS/location is enabled in system settings.
  Future<bool> isLocationServiceEnabled() async {
    return Geolocator.isLocationServiceEnabled();
  }

  /// Gets the current device position.
  ///
  /// Throws [LocationServiceDisabledException] if services are disabled.
  /// Throws [PermissionDeniedException] if permission is not granted.
  ///
  /// Uses high accuracy by default.
  Future<Position> getCurrentPosition() async {
    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Gets a stream of position updates.
  ///
  /// [distanceFilter] specifies the minimum distance (in meters) the device
  /// must move before a new position is emitted. Defaults to 10 meters.
  ///
  /// The stream will emit positions continuously until cancelled.
  Stream<Position> getPositionStream({int distanceFilter = 10}) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: distanceFilter,
      ),
    );
  }

  /// Opens the device's app settings page.
  ///
  /// Use this when permission is permanently denied and the user
  /// needs to manually enable location access.
  ///
  /// Returns `true` if the settings page was opened successfully.
  Future<bool> openAppSettings() async {
    return Geolocator.openAppSettings();
  }

  /// Opens the device's location settings page.
  ///
  /// Use this when location services are disabled and the user
  /// needs to enable GPS.
  ///
  /// Returns `true` if the settings page was opened successfully.
  Future<bool> openLocationSettings() async {
    return Geolocator.openLocationSettings();
  }

  /// Converts a geolocator [Position] to a [LatLng] for flutter_map.
  LatLng positionToLatLng(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  /// Gets the current position as a [LatLng].
  ///
  /// Convenience method combining [getCurrentPosition] and [positionToLatLng].
  Future<LatLng> getCurrentLatLng() async {
    final position = await getCurrentPosition();
    return positionToLatLng(position);
  }

  /// Calculates distance between two positions in meters.
  ///
  /// Uses Geolocator's built-in distance calculation which uses
  /// the Haversine formula.
  double distanceBetween(LatLng start, LatLng end) {
    return Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );
  }

  /// Initializes location services and returns the current state.
  ///
  /// This method:
  /// 1. Checks if location services are enabled
  /// 2. Checks current permission status
  /// 3. Requests permission if needed (and not permanently denied)
  /// 4. Returns appropriate [LocationState]
  Future<LocationState> initialize() async {
    // Check if location services are enabled
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationState(
        status: LocationStatus.disabled,
        error: 'Location services are disabled. Please enable GPS.',
      );
    }

    // Check permission
    var permission = await checkPermission();

    // Request if denied (but not forever)
    if (permission == LocationPermission.denied) {
      permission = await requestPermission();
    }

    // Handle permission result
    switch (permission) {
      case LocationPermission.denied:
        return const LocationState(
          status: LocationStatus.denied,
          error: 'Location permission was denied.',
        );

      case LocationPermission.deniedForever:
        return const LocationState(
          status: LocationStatus.deniedForever,
          error: 'Location permission is permanently denied. '
              'Please enable in app settings.',
        );

      case LocationPermission.whileInUse:
      case LocationPermission.always:
        // Permission granted, get initial position
        try {
          final position = await getCurrentPosition();
          return LocationState(
            status: LocationStatus.ready,
            currentPosition: positionToLatLng(position),
            lastUpdated: DateTime.now(),
            accuracy: position.accuracy,
          );
        } catch (e) {
          return LocationState(
            status: LocationStatus.ready,
            error: 'Could not get initial position: $e',
          );
        }

      case LocationPermission.unableToDetermine:
        return const LocationState(
          status: LocationStatus.denied,
          error: 'Unable to determine permission status.',
        );
    }
  }

  /// Creates a stream that emits [LocationState] updates.
  ///
  /// Initializes location first, then streams position updates.
  /// The stream handles errors gracefully and continues running.
  ///
  /// [distanceFilter] specifies minimum movement (meters) between updates.
  Stream<LocationState> getLocationStateStream({int distanceFilter = 10}) async* {
    // First, initialize and yield initial state
    yield const LocationState(status: LocationStatus.checking);

    final initialState = await initialize();
    yield initialState;

    // If not ready, don't start streaming
    if (initialState.status != LocationStatus.ready) {
      return;
    }

    // Stream position updates
    await for (final position in getPositionStream(distanceFilter: distanceFilter)) {
      yield LocationState(
        status: LocationStatus.ready,
        currentPosition: positionToLatLng(position),
        lastUpdated: DateTime.now(),
        accuracy: position.accuracy,
      );
    }
  }
}
