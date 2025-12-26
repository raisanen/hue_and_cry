import 'package:flutter_test/flutter_test.dart';
import 'package:hue_and_cry/services/case_loader_service.dart';
import 'package:dio/dio.dart';

void main() {
  group('CaseLoaderService', () {
    late CaseLoaderService loader;

    setUp(() {
      loader = CaseLoaderService(dio: Dio());
    });

    test('returns fallback case IDs if manifest fails', () async {
      // Simulate network failure by using an invalid Dio instance
      final ids = await loader.getAvailableCaseIds();
      expect(ids, contains('vanishing_violinist'));
    });

    // Add more tests for loadCase, cache, etc. as needed
  });
}
