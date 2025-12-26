import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the current theme mode.
/// 
/// Dark theme is the default, evoking the atmosphere of reading
/// by gaslight—fitting for a Victorian mystery game.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

/// Helper provider that returns true if dark mode is active.
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeModeProvider) == ThemeMode.dark;
});
