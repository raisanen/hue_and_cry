import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hue_and_cry/providers/case_provider.dart';

void main() {
  test('caseLoaderServiceProvider returns a CaseLoaderService', () {
    final container = ProviderContainer();
    final service = container.read(caseLoaderServiceProvider);
    expect(service, isNotNull);
  });

  test('bindingServiceProvider returns a BindingService', () {
    final container = ProviderContainer();
    final service = container.read(bindingServiceProvider);
    expect(service, isNotNull);
  });

  // Add more tests for allCasesProvider, caseByIdProvider, etc. with mock data if needed
}
