import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hue_and_cry/providers/theme_provider.dart';
import 'package:flutter/material.dart';

void main() {
  test('themeModeProvider defaults to dark', () {
    final container = ProviderContainer();
    final mode = container.read(themeModeProvider);
    expect(mode, ThemeMode.dark);
  });

  test('isDarkModeProvider returns true for dark', () {
    final container = ProviderContainer();
    expect(container.read(isDarkModeProvider), isTrue);
  });

  test('isDarkModeProvider returns false for light', () {
    final container = ProviderContainer();
    container.read(themeModeProvider.notifier).state = ThemeMode.light;
    expect(container.read(isDarkModeProvider), isFalse);
  });
}
