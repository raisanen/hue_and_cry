import 'dart:math' as math;

import 'package:latlong2/latlong.dart';

/// Radius in meters within which a player can interact with a location.
const double unlockRadiusMeters = 50.0;

/// Radius in meters within which a player is considered to have "visited"
/// a location (used for scoring).
const double visitRadiusMeters = 30.0;

/// Earth's radius in meters (mean radius).
const double earthRadiusMeters = 6371000.0;

/// Calculates the great-circle distance between two points using the
/// Haversine formula.
/// 
/// Returns the distance in meters.
/// 
/// The Haversine formula is accurate for most purposes, with typical
/// errors less than 0.5% due to Earth's slight ellipsoidal shape.
double haversineDistance(LatLng point1, LatLng point2) {
  // Convert degrees to radians
  final lat1 = _toRadians(point1.latitude);
  final lat2 = _toRadians(point2.latitude);
  final deltaLat = _toRadians(point2.latitude - point1.latitude);
  final deltaLon = _toRadians(point2.longitude - point1.longitude);

  // Haversine formula
  final a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
      math.cos(lat1) *
          math.cos(lat2) *
          math.sin(deltaLon / 2) *
          math.sin(deltaLon / 2);

  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

  return earthRadiusMeters * c;
}

/// Checks if a point is within a given radius of a center point.
/// 
/// Returns true if the distance from [center] to [point] is less than
/// or equal to [radiusMeters].
bool isWithinRadius(LatLng center, LatLng point, double radiusMeters) {
  return haversineDistance(center, point) <= radiusMeters;
}

/// Checks if a player can interact with a location.
/// 
/// Uses [unlockRadiusMeters] (50m) as the threshold.
bool canInteract(LatLng playerPos, LatLng locationPos) {
  return isWithinRadius(locationPos, playerPos, unlockRadiusMeters);
}

/// Checks if a player has "visited" a location for scoring purposes.
/// 
/// Uses [visitRadiusMeters] (30m) as the threshold.
bool hasVisited(LatLng playerPos, LatLng locationPos) {
  return isWithinRadius(locationPos, playerPos, visitRadiusMeters);
}

/// A bounding box defined by its south-west and north-east corners.
/// 
/// Used for Overpass API queries.
class BoundingBox {
  /// Southern latitude boundary (minimum latitude).
  final double south;

  /// Western longitude boundary (minimum longitude).
  final double west;

  /// Northern latitude boundary (maximum latitude).
  final double north;

  /// Eastern longitude boundary (maximum longitude).
  final double east;

  const BoundingBox({
    required this.south,
    required this.west,
    required this.north,
    required this.east,
  });

  /// Returns the bounding box as a string for Overpass API queries.
  /// Format: "south,west,north,east"
  String toOverpassString() => '$south,$west,$north,$east';

  /// Returns the center point of the bounding box.
  LatLng get center => LatLng(
        (south + north) / 2,
        (west + east) / 2,
      );

  @override
  String toString() =>
      'BoundingBox(south: $south, west: $west, north: $north, east: $east)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BoundingBox &&
          runtimeType == other.runtimeType &&
          south == other.south &&
          west == other.west &&
          north == other.north &&
          east == other.east;

  @override
  int get hashCode => Object.hash(south, west, north, east);
}

/// Calculates a bounding box around a center point with a given radius.
/// 
/// The bounding box is a square approximation that fully contains the
/// circle defined by [center] and [radiusMeters].
/// 
/// Note: At extreme latitudes (near poles), this approximation becomes
/// less accurate, but it's sufficient for typical gameplay areas.
BoundingBox calculateBoundingBox(LatLng center, double radiusMeters) {
  // Angular distance in radians on a great circle
  final angularDistance = radiusMeters / earthRadiusMeters;

  final centerLatRad = _toRadians(center.latitude);

  // Calculate latitude bounds (simple - same offset north and south)
  final latOffset = _toDegrees(angularDistance);
  final south = center.latitude - latOffset;
  final north = center.latitude + latOffset;

  // Calculate longitude bounds (accounts for latitude - meridians converge)
  // At the equator, 1 degree of longitude ≈ 111km
  // At latitude φ, 1 degree of longitude ≈ 111km * cos(φ)
  final lonOffset = _toDegrees(angularDistance / math.cos(centerLatRad));
  final west = center.longitude - lonOffset;
  final east = center.longitude + lonOffset;

  return BoundingBox(
    south: south.clamp(-90.0, 90.0),
    west: _normalizeLongitude(west),
    north: north.clamp(-90.0, 90.0),
    east: _normalizeLongitude(east),
  );
}

/// Converts degrees to radians.
double _toRadians(double degrees) => degrees * (math.pi / 180.0);

/// Converts radians to degrees.
double _toDegrees(double radians) => radians * (180.0 / math.pi);

/// Normalizes longitude to the range [-180, 180].
double _normalizeLongitude(double longitude) {
  while (longitude > 180) {
    longitude -= 360;
  }
  while (longitude < -180) {
    longitude += 360;
  }
  return longitude;
}
