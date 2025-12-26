import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../models/poi.dart';
import '../models/story_role.dart';
import '../services/classification_service.dart';
import '../services/overpass_service.dart';
import '../utils/constants.dart';

/// Provider for the Overpass service singleton.
final overpassServiceProvider = Provider<OverpassService>((ref) {
  return OverpassService();
});

/// Provider for the Classification service singleton.
final classificationServiceProvider = Provider<ClassificationService>((ref) {
  return ClassificationService();
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

/// Provider family for fetching raw POIs from Overpass (without classification).
///
/// Use [classifiedPoisProvider] for POIs with story roles assigned.
final rawPoisProvider =
    FutureProvider.family<List<POI>, POIFetchParams>((ref, params) async {
  final service = ref.watch(overpassServiceProvider);
  return service.fetchPOIs(
    params.center,
    radiusMeters: params.radiusMeters,
  );
});

/// Provider family for fetching POIs from Overpass with classification.
///
/// This fetches POIs and then classifies them with story roles.
///
/// Usage:
/// ```dart
/// final poisAsync = ref.watch(classifiedPoisProvider(POIFetchParams(
///   center: LatLng(51.5, -0.1),
///   radiusMeters: 1000,
/// )));
/// ```
final classifiedPoisProvider =
    FutureProvider.family<List<POI>, POIFetchParams>((ref, params) async {
  final overpassService = ref.watch(overpassServiceProvider);
  final classificationService = ref.watch(classificationServiceProvider);

  final rawPois = await overpassService.fetchPOIs(
    params.center,
    radiusMeters: params.radiusMeters,
  );

  return classificationService.classifyAll(rawPois);
});

/// Legacy provider alias for backward compatibility.
/// @deprecated Use [classifiedPoisProvider] instead.
final poisProvider = classifiedPoisProvider;

/// Provider for fetching classified POIs with auto-refresh capability.
///
/// This is useful when you want to refetch POIs when the player moves
/// significantly or when manually triggered.
final poisAutoRefreshProvider = FutureProvider.autoDispose
    .family<List<POI>, POIFetchParams>((ref, params) async {
  final overpassService = ref.watch(overpassServiceProvider);
  final classificationService = ref.watch(classificationServiceProvider);

  final rawPois = await overpassService.fetchPOIs(
    params.center,
    radiusMeters: params.radiusMeters,
  );

  return classificationService.classifyAll(rawPois);
});

/// Provider for grouping classified POIs by their story roles.
///
/// Usage:
/// ```dart
/// final groupedAsync = ref.watch(poisByRoleProvider(POIFetchParams(...)));
/// groupedAsync.when(
///   data: (grouped) => print('Cafes: ${grouped[StoryRole.information]?.length}'),
///   ...
/// );
/// ```
final poisByRoleProvider = FutureProvider.family<Map<StoryRole, List<POI>>,
    POIFetchParams>((ref, params) async {
  final classificationService = ref.watch(classificationServiceProvider);
  final pois = await ref.watch(classifiedPoisProvider(params).future);

  return classificationService.groupByRole(pois);
});
