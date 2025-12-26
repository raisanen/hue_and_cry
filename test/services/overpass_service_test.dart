import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mocktail/mocktail.dart';

import 'package:hue_and_cry/services/overpass_service.dart';

class MockDio extends Mock implements Dio {}

class MockRequestOptions extends Mock implements RequestOptions {}

void main() {
  late MockDio mockDio;
  late OverpassService service;

  setUp(() {
    mockDio = MockDio();
    service = OverpassService(dio: mockDio);
  });

  setUpAll(() {
    registerFallbackValue(Options());
  });

  group('OverpassService', () {
    group('fetchPOIs', () {
      test('returns list of POIs on successful response', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);
        final mockResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'version': 0.6,
            'elements': [
              {
                'type': 'node',
                'id': 123456,
                'lat': 51.5075,
                'lon': -0.1280,
                'tags': {
                  'amenity': 'cafe',
                  'name': 'Test Café',
                  'cuisine': 'coffee',
                },
              },
              {
                'type': 'node',
                'id': 789012,
                'lat': 51.5080,
                'lon': -0.1290,
                'tags': {
                  'shop': 'books',
                  'name': 'Book Shop',
                },
              },
            ],
          },
        );

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, hasLength(2));

        expect(pois[0].osmId, equals(123456));
        expect(pois[0].name, equals('Test Café'));
        expect(pois[0].lat, equals(51.5075));
        expect(pois[0].lon, equals(-0.1280));
        expect(pois[0].osmTags['amenity'], equals('cafe'));
        expect(pois[0].storyRoles, isEmpty);

        expect(pois[1].osmId, equals(789012));
        expect(pois[1].name, equals('Book Shop'));
        expect(pois[1].osmTags['shop'], equals('books'));
      });

      test('handles way elements with center coordinates', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);
        final mockResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'elements': [
              {
                'type': 'way',
                'id': 111222,
                'center': {
                  'lat': 51.5090,
                  'lon': -0.1300,
                },
                'tags': {
                  'leisure': 'park',
                  'name': 'City Park',
                },
              },
            ],
          },
        );

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, hasLength(1));
        expect(pois[0].osmId, equals(111222));
        expect(pois[0].name, equals('City Park'));
        expect(pois[0].lat, equals(51.5090));
        expect(pois[0].lon, equals(-0.1300));
        expect(pois[0].osmTags['leisure'], equals('park'));
      });

      test('skips elements without valid coordinates', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);
        final mockResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'elements': [
              {
                'type': 'node',
                'id': 123456,
                'lat': 51.5075,
                'lon': -0.1280,
                'tags': {'amenity': 'cafe'},
              },
              {
                'type': 'way',
                'id': 789012,
                // Missing center - should be skipped
                'tags': {'leisure': 'park'},
              },
              {
                'type': 'node',
                'id': 345678,
                'lat': null, // Invalid coordinates
                'lon': -0.1290,
                'tags': {'shop': 'books'},
              },
            ],
          },
        );

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, hasLength(1));
        expect(pois[0].osmId, equals(123456));
      });

      test('handles POIs without names', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);
        final mockResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'elements': [
              {
                'type': 'node',
                'id': 123456,
                'lat': 51.5075,
                'lon': -0.1280,
                'tags': {
                  'amenity': 'parking',
                  // No name tag
                },
              },
            ],
          },
        );

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, hasLength(1));
        expect(pois[0].name, isNull);
        expect(pois[0].displayName, contains('Parking'));
      });

      test('returns empty list on network error', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          type: DioExceptionType.connectionError,
          requestOptions: RequestOptions(path: ''),
          message: 'Network unavailable',
        ));

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, isEmpty);
      });

      test('returns empty list on timeout', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          type: DioExceptionType.receiveTimeout,
          requestOptions: RequestOptions(path: ''),
          message: 'Request timed out',
        ));

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, isEmpty);
      });

      test('returns empty list on rate limiting (429)', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenThrow(DioException(
          type: DioExceptionType.badResponse,
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 429,
          ),
        ));

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, isEmpty);
      });

      test('returns empty list on empty elements array', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);
        final mockResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'version': 0.6,
            'elements': [],
          },
        );

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, isEmpty);
      });

      test('returns empty list when elements is null', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);
        final mockResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'version': 0.6,
            // No elements key
          },
        );

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, isEmpty);
      });

      test('uses custom radius when provided', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);
        final mockResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {'elements': []},
        );

        String? capturedQuery;
        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((invocation) async {
          capturedQuery = invocation.namedArguments[const Symbol('data')] as String?;
          return mockResponse;
        });

        // Act
        await service.fetchPOIs(center, radiusMeters: 500);

        // Assert
        expect(capturedQuery, isNotNull);
        // The bounding box should be smaller with 500m radius
        // We just verify the query was built (detailed bbox testing is in geo_utils)
        expect(capturedQuery, contains('amenity'));
        expect(capturedQuery, contains('shop'));
      });

      test('extracts all tags from POI', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);
        final mockResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 200,
          data: {
            'elements': [
              {
                'type': 'node',
                'id': 123456,
                'lat': 51.5075,
                'lon': -0.1280,
                'tags': {
                  'amenity': 'restaurant',
                  'name': 'The Best Restaurant',
                  'cuisine': 'italian',
                  'opening_hours': 'Mo-Fr 11:00-22:00',
                  'phone': '+44 123 456 7890',
                  'website': 'https://example.com',
                },
              },
            ],
          },
        );

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, hasLength(1));
        expect(pois[0].osmTags, hasLength(6));
        expect(pois[0].osmTags['amenity'], equals('restaurant'));
        expect(pois[0].osmTags['cuisine'], equals('italian'));
        expect(pois[0].osmTags['opening_hours'], equals('Mo-Fr 11:00-22:00'));
      });

      test('handles unexpected status codes', () async {
        // Arrange
        final center = LatLng(51.5074, -0.1278);
        final mockResponse = Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
          data: null,
        );

        when(() => mockDio.post<Map<String, dynamic>>(
              any(),
              data: any(named: 'data'),
              options: any(named: 'options'),
            )).thenAnswer((_) async => mockResponse);

        // Act
        final pois = await service.fetchPOIs(center);

        // Assert
        expect(pois, isEmpty);
      });
    });
  });
}
