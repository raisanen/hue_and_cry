import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hue_and_cry/providers/poi_provider.dart';

void main() {
  test('overpassServiceProvider returns an OverpassService', () {
    final container = ProviderContainer();
    final service = container.read(overpassServiceProvider);
    expect(service, isNotNull);
  });

  test('classificationServiceProvider returns a ClassificationService', () {
    final container = ProviderContainer();
    final service = container.read(classificationServiceProvider);
    expect(service, isNotNull);
  });

  // Add more tests for rawPoisProvider, classifiedPoisProvider, etc. with mock data if needed
}
