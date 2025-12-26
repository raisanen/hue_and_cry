import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app.dart';
import 'providers/game_state_provider.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Open Hive boxes for game state persistence
  await initializeGameStateStorage();

  // Run the app wrapped in ProviderScope for Riverpod state management
  runApp(
    const ProviderScope(
      child: HueAndCryApp(),
    ),
  );
}
