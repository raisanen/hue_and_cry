import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../models/poi.dart';
import '../services/overpass_service.dart';
import '../utils/constants.dart';

/// Provider for the Overpass service singleton.
final overpassServiceProvider = Provider<OverpassService>((ref) {
  return OverpassService();
});

/// Parameters for the POI fetch operation.
class POIFetchParams {
  final LatLng center;
  final double radiusMeters;

  const POIFetchParams({
    required this.center,
    this.radiusMeters = defaultSearchRadiusMeters,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is POIFetchParams &&
          runtimeType == other.runtimeType &&
          center.latitude == other.center.latitude &&
          center.longitude == other.center.longitude &&
          radiusMeters == other.radiusMeters;

  @override
  int get hashCode => Object.hash(
        center.latitude,
        center.longitude,
        radiusMeters,
      );
}

/// Provider family for fetching POIs from Overpass.
///
/// Usage:
/// ```dart
/// final poisAsync = ref.watch(poisProvider(POIFetchParams(
///   center: LatLng(51.5, -0.1),
///   radiusMeters: 1000,
/// )));
/// ```
final poisProvider =
    FutureProvider.family<List<POI>, POIFetchParams>((ref, params) async {
  final service = ref.watch(overpassServiceProvider);
  return service.fetchPOIs(
    params.center,
    radiusMeters: params.radiusMeters,
  );
});

/// Provider for fetching POIs with auto-refresh capability.
///
/// This is useful when you want to refetch POIs when the player moves
/// significantly or when manually triggered.
final poisAutoRefreshProvider = FutureProvider.autoDispose
    .family<List<POI>, POIFetchParams>((ref, params) async {
  final service = ref.watch(overpassServiceProvider);
  return service.fetchPOIs(
    params.center,
    radiusMeters: params.radiusMeters,
  );
});
