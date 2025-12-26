import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/case_template.dart';

/// Service for loading case templates from JSON asset files.
class CaseLoaderService {
  /// Cache of loaded cases by ID.
  final Map<String, CaseTemplate> _cache = {};

  /// List of available case IDs.
  static const List<String> availableCaseIds = [
    'vanishing_violinist',
    'midnight_apothecary',
    'dockside_conspiracy',
    'seance_murders',
  ];

  /// Loads a case template from assets by ID.
  ///
  /// Returns the cached version if already loaded.
  Future<CaseTemplate> loadCase(String caseId) async {
    // Return cached version if available
    if (_cache.containsKey(caseId)) {
      return _cache[caseId]!;
    }

    // Load from assets
    final jsonString = await rootBundle.loadString(
      'assets/cases/$caseId.json',
    );
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    final caseTemplate = CaseTemplate.fromJson(json);

    // Cache and return
    _cache[caseId] = caseTemplate;
    return caseTemplate;
  }

  /// Loads all available cases.
  Future<List<CaseTemplate>> loadAllCases() async {
    final cases = <CaseTemplate>[];
    for (final caseId in availableCaseIds) {
      cases.add(await loadCase(caseId));
    }
    return cases;
  }

  /// Clears the cache (useful for hot reload during development).
  void clearCache() {
    _cache.clear();
  }
}
