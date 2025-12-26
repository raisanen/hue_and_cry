import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'theme/gazette_theme.dart';

/// The root application widget for Hue & Cry.
class HueAndCryApp extends StatelessWidget {
  const HueAndCryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hue & Cry',
      theme: GazetteTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: Center(
          child: Text('Hue & Cry - Coming Soon'),
        ),
      ),
    );
  }
}
