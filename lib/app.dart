import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'providers/theme_provider.dart';
import 'screens/case_setup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/location_screen.dart';
import 'screens/map_screen.dart';
import 'screens/notebook_screen.dart';
import 'screens/solution_screen.dart';
import 'theme/gazette_theme.dart';

/// Router configuration for the app.
final _router = GoRouter(
  initialLocation: '/',
  routes: [
    // Home screen - case selection
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    
    // Case setup - loading and binding POIs
    GoRoute(
      path: '/case/:caseId/setup',
      name: 'caseSetup',
      builder: (context, state) => CaseSetupScreen(
        caseId: state.pathParameters['caseId']!,
      ),
    ),
    
    // Map screen - main gameplay
    GoRoute(
      path: '/case/:caseId/play',
      name: 'play',
      builder: (context, state) => MapScreen(
        caseId: state.pathParameters['caseId']!,
      ),
    ),
    
    // Location screen - location detail and dialogue
    GoRoute(
      path: '/case/:caseId/location/:locationId',
      name: 'location',
      builder: (context, state) => LocationScreen(
        caseId: state.pathParameters['caseId']!,
        locationId: state.pathParameters['locationId']!,
      ),
    ),
    
    // Notebook screen - collected clues
    GoRoute(
      path: '/case/:caseId/notebook',
      name: 'notebook',
      builder: (context, state) => NotebookScreen(
        caseId: state.pathParameters['caseId']!,
      ),
    ),
    
    // Solution screen - submit answer and scoring
    GoRoute(
      path: '/case/:caseId/solve',
      name: 'solve',
      builder: (context, state) => SolutionScreen(
        caseId: state.pathParameters['caseId']!,
      ),
    ),
  ],
);

/// The root application widget for Hue & Cry.
class HueAndCryApp extends ConsumerWidget {
  const HueAndCryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    
    return MaterialApp.router(
      title: 'Hue & Cry',
      theme: GazetteTheme.lightTheme,
      darkTheme: GazetteTheme.darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
