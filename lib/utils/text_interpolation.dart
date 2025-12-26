import '../models/bound_case.dart';

/// Pattern for location placeholders in text templates.
/// Matches: {location:some_id}
final _locationPattern = RegExp(r'\{location:([^}]+)\}');

/// Interpolates location placeholders in a text template.
/// 
/// Replaces patterns like `{location:id}` with the display name of the
/// corresponding bound location.
/// 
/// Example:
/// ```dart
/// final template = "Meet me at {location:cafe_practice}";
/// final locations = {'cafe_practice': BoundLocation(displayName: 'Café Linné', ...)};
/// final result = interpolateLocationText(template, locations);
/// // result: "Meet me at Café Linné"
/// ```
/// 
/// If a location ID is not found in [locations], the placeholder is left
/// unchanged (useful for debugging missing bindings).
String interpolateLocationText(
  String template,
  Map<String, BoundLocation> locations,
) {
  return template.replaceAllMapped(_locationPattern, (match) {
    final locationId = match.group(1);
    if (locationId == null) return match.group(0)!;

    final location = locations[locationId];
    if (location == null) {
      // Leave placeholder unchanged if location not found
      return match.group(0)!;
    }

    return location.displayName;
  });
}

/// Interpolates all text fields in a case that may contain location references.
/// 
/// This includes:
/// - Location description templates
/// - Character dialogues
/// - Clue discovery text and summaries
/// - Case briefing text
/// 
/// Returns a map of interpolated strings keyed by their original identifiers.
Map<String, String> interpolateAllCaseText(
  Map<String, String> templates,
  Map<String, BoundLocation> locations,
) {
  return templates.map(
    (key, template) => MapEntry(key, interpolateLocationText(template, locations)),
  );
}
