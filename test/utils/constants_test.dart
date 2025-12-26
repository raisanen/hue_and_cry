import 'package:flutter_test/flutter_test.dart';
import 'package:hue_and_cry/utils/constants.dart';

void main() {
  test('appName and tagline are correct', () {
    expect(appName, 'Hue & Cry');
    expect(appTagline, contains('Mystery'));
  });

  test('overpassApiUrl is a valid URL', () {
    expect(overpassApiUrl, startsWith('https://'));
  });

  test('overpassApiMirrors contains at least one mirror', () {
    expect(overpassApiMirrors, isNotEmpty);
  });

  test('defaultSearchRadiusMeters is positive', () {
    expect(defaultSearchRadiusMeters, greaterThan(0));
  });

  test('osmTileUrlTemplate contains {z}, {x}, {y}', () {
    expect(osmTileUrlTemplate, contains('{z}'));
    expect(osmTileUrlTemplate, contains('{x}'));
    expect(osmTileUrlTemplate, contains('{y}'));
  });

  test('osmUserAgent is non-empty', () {
    expect(osmUserAgent, isNotEmpty);
  });

  test('osmAttribution contains OpenStreetMap', () {
    expect(osmAttribution, contains('OpenStreetMap'));
  });

  test('overpassTimeoutSeconds > 0', () {
    expect(overpassTimeoutSeconds, greaterThan(0));
  });

  test('locationTimeoutSeconds > 0', () {
    expect(locationTimeoutSeconds, greaterThan(0));
  });

  test('minimumLocationAccuracyMeters > 0', () {
    expect(minimumLocationAccuracyMeters, greaterThan(0));
  });

  test('locationDistanceFilterMeters > 0', () {
    expect(locationDistanceFilterMeters, greaterThan(0));
  });

  test('defaultMapZoom, minMapZoom, maxMapZoom are valid', () {
    expect(defaultMapZoom, inInclusiveRange(minMapZoom, maxMapZoom));
  });
}
