import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../models/case_template.dart';
import '../models/poi.dart';
import '../models/story_role.dart';
import '../services/binding_service.dart';
import 'poi_provider.dart';

/// Provider for the Binding service singleton.
final bindingServiceProvider = Provider<BindingService>((ref) {
  return BindingService();
});

/// Parameters for binding a case.
class CaseBindingParams {
  final CaseTemplate template;
  final List<POI> pois;
  final LatLng playerLocation;

  const CaseBindingParams({
    required this.template,
    required this.pois,
    required this.playerLocation,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseBindingParams &&
          runtimeType == other.runtimeType &&
          template.id == other.template.id &&
          playerLocation.latitude == other.playerLocation.latitude &&
          playerLocation.longitude == other.playerLocation.longitude &&
          pois.length == other.pois.length;

  @override
  int get hashCode => Object.hash(
        template.id,
        playerLocation.latitude,
        playerLocation.longitude,
        pois.length,
      );
}

/// Provider for binding a case template to POIs.
///
/// Returns a [BindingResult] containing the bound case and any errors.
///
/// Usage:
/// ```dart
/// final result = await ref.watch(boundCaseProvider(CaseBindingParams(
///   template: myTemplate,
///   pois: classifiedPois,
///   playerLocation: LatLng(51.5, -0.1),
/// )).future);
///
/// if (result.isSuccess) {
///   // Use result.boundCase
/// } else {
///   // Handle errors in result.errors
/// }
/// ```
final boundCaseProvider = FutureProvider.family<BindingResult, CaseBindingParams>(
    (ref, params) async {
  final bindingService = ref.watch(bindingServiceProvider);

  return bindingService.bindCase(
    params.template,
    params.pois,
    params.playerLocation,
  );
});

/// Provider for quick compatibility check.
///
/// Checks if a case can potentially be bound with the available POI counts
/// without doing a full binding operation.
final caseCompatibilityProvider =
    Provider.family<bool, CaseCompatibilityParams>((ref, params) {
  final bindingService = ref.watch(bindingServiceProvider);

  return bindingService.canBindCase(
    params.template,
    params.availableRoleCounts,
  );
});

/// Parameters for case compatibility check.
class CaseCompatibilityParams {
  final CaseTemplate template;
  final Map<StoryRole, int> availableRoleCounts;

  const CaseCompatibilityParams({
    required this.template,
    required this.availableRoleCounts,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CaseCompatibilityParams &&
          runtimeType == other.runtimeType &&
          template.id == other.template.id;

  @override
  int get hashCode => template.id.hashCode;
}

/// Helper provider to count POIs by role.
///
/// Useful for the compatibility check.
final poiRoleCountsProvider =
    Provider.family<Map<StoryRole, int>, List<POI>>((ref, pois) {
  final classificationService = ref.watch(classificationServiceProvider);
  final grouped = classificationService.groupByRole(pois);

  return grouped.map((role, poiList) => MapEntry(role, poiList.length));
});
