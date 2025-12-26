import 'package:dio/dio.dart';
import 'package:latlong2/latlong.dart';

import '../models/poi.dart';
import '../utils/constants.dart';
import '../utils/geo_utils.dart';

/// Service for fetching Points of Interest from the Overpass API.
///
/// Overpass is a read-only API that serves OpenStreetMap data. It allows
/// complex queries to extract specific geographic features.
class OverpassService {
  final Dio _dio;

  /// Creates an OverpassService.
  ///
  /// An optional [dio] instance can be provided for testing.
  OverpassService({Dio? dio})
      : _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: overpassTimeoutSeconds),
              receiveTimeout: const Duration(seconds: overpassTimeoutSeconds),
              sendTimeout: const Duration(seconds: overpassTimeoutSeconds),
            ));

  /// Fetches POIs within a radius of the given center point.
  ///
  /// Returns a list of [POI] objects without story role classification.
  /// Classification should be done by a separate service.
  ///
  /// On error (network, timeout, rate limiting), returns an empty list
  /// and logs the error.
  Future<List<POI>> fetchPOIs(
    LatLng center, {
    double radiusMeters = defaultSearchRadiusMeters,
  }) async {
    final bbox = calculateBoundingBox(center, radiusMeters);
    final query = _buildQuery(bbox);

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        overpassApiUrl,
        data: query,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
          responseType: ResponseType.json,
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        return _parseResponse(response.data!);
      }

      // Unexpected status code
      _logError('Unexpected status code: ${response.statusCode}');
      return [];
    } on DioException catch (e) {
      _handleDioError(e);
      return [];
    } catch (e) {
      _logError('Unexpected error fetching POIs: $e');
      return [];
    }
  }

  /// Builds the Overpass QL query for the given bounding box.
  ///
  /// The query fetches:
  /// - Amenities (excluding trivial ones like benches)
  /// - Shops
  /// - Offices
  /// - Leisure areas
  /// - Tourism POIs
  /// - Historic sites
  /// - Cemeteries
  String _buildQuery(BoundingBox bbox) {
    final bboxStr = bbox.toOverpassString();

    // Build the Overpass QL query as specified in CLAUDE.md
    return '''
[out:json][timeout:$overpassTimeoutSeconds];
(
  node["amenity"]["amenity"!~"^(bench|waste_basket|recycling|parking_space|bicycle_parking|motorcycle_parking|toilets|drinking_water|fountain|clock|post_box|telephone|vending_machine|atm)\$"]($bboxStr);
  way["amenity"]["amenity"!~"^(bench|waste_basket|recycling|parking_space|bicycle_parking|motorcycle_parking|toilets|drinking_water|fountain|clock|post_box|telephone|vending_machine|atm)\$"]($bboxStr);
  node["shop"]($bboxStr);
  way["shop"]($bboxStr);
  node["office"]($bboxStr);
  way["office"]($bboxStr);
  node["leisure"]($bboxStr);
  way["leisure"]($bboxStr);
  node["tourism"]($bboxStr);
  way["tourism"]($bboxStr);
  node["historic"]($bboxStr);
  way["historic"]($bboxStr);
  node["landuse"="cemetery"]($bboxStr);
  way["landuse"="cemetery"]($bboxStr);
);
out center;
''';
  }

  /// Parses the Overpass API response into a list of POIs.
  List<POI> _parseResponse(Map<String, dynamic> data) {
    final elements = data['elements'] as List<dynamic>?;
    if (elements == null) return [];

    final pois = <POI>[];

    for (final element in elements) {
      final poi = _parseElement(element as Map<String, dynamic>);
      if (poi != null) {
        pois.add(poi);
      }
    }

    return pois;
  }

  /// Parses a single Overpass element into a POI.
  ///
  /// Returns null if the element doesn't have valid coordinates.
  POI? _parseElement(Map<String, dynamic> element) {
    final type = element['type'] as String?;
    final id = element['id'] as int?;

    if (type == null || id == null) return null;

    // Extract coordinates
    double? lat;
    double? lon;

    if (type == 'node') {
      // Nodes have direct lat/lon
      lat = (element['lat'] as num?)?.toDouble();
      lon = (element['lon'] as num?)?.toDouble();
    } else if (type == 'way' || type == 'relation') {
      // Ways and relations use the center point (from "out center")
      final center = element['center'] as Map<String, dynamic>?;
      if (center != null) {
        lat = (center['lat'] as num?)?.toDouble();
        lon = (center['lon'] as num?)?.toDouble();
      }
    }

    // Skip if no valid coordinates
    if (lat == null || lon == null) return null;

    // Extract tags
    final tagsRaw = element['tags'] as Map<String, dynamic>?;
    final tags = <String, String>{};
    if (tagsRaw != null) {
      for (final entry in tagsRaw.entries) {
        tags[entry.key] = entry.value.toString();
      }
    }

    // Extract name (may be null)
    final name = tags['name'];

    return POI(
      osmId: id,
      name: name,
      lat: lat,
      lon: lon,
      osmTags: tags,
      storyRoles: const [], // Classification happens in a separate service
    );
  }

  /// Handles Dio errors and logs appropriate messages.
  void _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        _logError('Overpass API timeout: ${e.message}');
        break;

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 429) {
          _logError('Overpass API rate limited. Please wait before retrying.');
        } else if (statusCode == 504) {
          _logError('Overpass API gateway timeout. Query may be too complex.');
        } else {
          _logError('Overpass API error: $statusCode - ${e.message}');
        }
        break;

      case DioExceptionType.connectionError:
        _logError('Network connection error: ${e.message}');
        break;

      case DioExceptionType.cancel:
        _logError('Request cancelled');
        break;

      default:
        _logError('Dio error: ${e.type} - ${e.message}');
    }
  }

  /// Logs an error message.
  ///
  /// In a production app, this would use a proper logging framework.
  void _logError(String message) {
    // TODO: Use proper logging (e.g., logger package)
    // For now, just print to console in debug mode
    assert(() {
      print('[OverpassService] ERROR: $message');
      return true;
    }());
  }
}
