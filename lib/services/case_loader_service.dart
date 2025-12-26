import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../models/case_template.dart';

/// Service for loading case templates from GitHub or local assets.
///
/// Attempts to load cases from GitHub first (for dynamic updates),
/// falling back to bundled assets if the network request fails.
class CaseLoaderService {
  /// Cache of loaded cases by ID.
  final Map<String, CaseTemplate> _cache = {};

  /// Cached list of available case IDs from manifest.
  List<String>? _availableCaseIds;

  /// Dio client for HTTP requests.
  final Dio _dio;

  /// Base URL for raw GitHub content.
  static const String _githubBaseUrl =
      'https://raw.githubusercontent.com/raisanen/hue_and_cry/main/cases';

  /// Fallback case IDs if manifest cannot be loaded.
  static const List<String> _fallbackCaseIds = [
    'vanishing_violinist'
  ];

  CaseLoaderService({Dio? dio}) : _dio = dio ?? Dio();

  /// Gets the list of available case IDs.
  ///
  /// Tries to load from GitHub manifest first, falls back to bundled list.
  Future<List<String>> getAvailableCaseIds() async {
    if (_availableCaseIds != null) {
      return _availableCaseIds!;
    }

    // Try loading manifest from GitHub
    try {
      final response = await _dio.get<String>(
        '$_githubBaseUrl/manifest.json',
        options: Options(
          responseType: ResponseType.plain,
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        final manifest = jsonDecode(response.data!) as Map<String, dynamic>;
        final cases = (manifest['cases'] as List<dynamic>).cast<String>();
        _availableCaseIds = cases;
        return cases;
      }
    } catch (e) {
      // Network error, fall back to bundled list
    }

    // Fall back to bundled list
    _availableCaseIds = _fallbackCaseIds;
    return _fallbackCaseIds;
  }

  /// Loads a case template by ID.
  ///
  /// Tries to load from GitHub first, falls back to local assets.
  /// Returns the cached version if already loaded.
  Future<CaseTemplate> loadCase(String caseId) async {
    // Return cached version if available
    if (_cache.containsKey(caseId)) {
      return _cache[caseId]!;
    }

    // Try loading from GitHub first
    try {
      final caseTemplate = await _loadFromGitHub(caseId);
      _cache[caseId] = caseTemplate;
      return caseTemplate;
    } catch (e) {
      // Fall back to local assets
    }

    // Load from bundled assets
    final caseTemplate = await _loadFromAssets(caseId);
    _cache[caseId] = caseTemplate;
    return caseTemplate;
  }

  /// Loads a case from GitHub.
  Future<CaseTemplate> _loadFromGitHub(String caseId) async {
    final response = await _dio.get<String>(
      '$_githubBaseUrl/$caseId.json',
      options: Options(
        responseType: ResponseType.plain,
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    if (response.statusCode == 200 && response.data != null) {
      final json = jsonDecode(response.data!) as Map<String, dynamic>;
      return CaseTemplate.fromJson(json);
    }

    throw Exception('Failed to load case from GitHub: ${response.statusCode}');
  }

  /// Loads a case from bundled assets.
  Future<CaseTemplate> _loadFromAssets(String caseId) async {
    final jsonString = await rootBundle.loadString(
      'assets/cases/$caseId.json',
    );
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return CaseTemplate.fromJson(json);
  }

  /// Loads all available cases.
  Future<List<CaseTemplate>> loadAllCases() async {
    final caseIds = await getAvailableCaseIds();
    final cases = <CaseTemplate>[];
    for (final caseId in caseIds) {
      cases.add(await loadCase(caseId));
    }
    return cases;
  }

  /// Clears the cache (useful for hot reload during development).
  void clearCache() {
    _cache.clear();
    _availableCaseIds = null;
  }

  /// Forces refresh from GitHub, bypassing cache.
  Future<List<CaseTemplate>> refreshFromGitHub() async {
    clearCache();
    return loadAllCases();
  }
}
