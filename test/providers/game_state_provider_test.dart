import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hue_and_cry/providers/game_state_provider.dart';

void main() {
  test('gameServiceProvider returns a GameService', () {
    final container = ProviderContainer();
    final service = container.read(gameServiceProvider);
    expect(service, isNotNull);
  });

  // Add more tests for gameStateBoxProvider, activeBoundCaseProvider, etc. with mock Hive if needed
}
