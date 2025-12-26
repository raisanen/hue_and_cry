import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../widgets/common/gazette_button.dart';
import '../widgets/common/gazette_card.dart';
import '../widgets/common/gazette_divider.dart';
import '../widgets/common/gazette_header.dart';

/// Screen shown while setting up a case (fetching POIs, binding locations).
class CaseSetupScreen extends ConsumerStatefulWidget {
  final String caseId;

  const CaseSetupScreen({
    super.key,
    required this.caseId,
  });

  @override
  ConsumerState<CaseSetupScreen> createState() => _CaseSetupScreenState();
}

class _CaseSetupScreenState extends ConsumerState<CaseSetupScreen> {
  String _status = 'Requesting location permission...';
  bool _isLoading = true;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _setupCase();
  }

  Future<void> _setupCase() async {
    // TODO: Implement actual setup logic
    // 1. Request location permission
    // 2. Get current position
    // 3. Fetch POIs from Overpass
    // 4. Bind case template to POIs
    // 5. Navigate to map screen

    // For now, simulate setup with a delay
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    setState(() {
      _status = 'Acquiring your position...';
    });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    setState(() {
      _status = 'Fetching nearby locations...';
    });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    setState(() {
      _status = 'Binding case to your neighborhood...';
    });

    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    // Navigate to map screen
    context.go('/case/${widget.caseId}/play');
  }

  void _retry() {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _errorMessage = null;
      _status = 'Requesting location permission...';
    });
    _setupCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case Setup'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: GazetteCard(
              showOrnaments: true,
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const GazetteHeader(
                    text: 'Preparing Investigation',
                    major: false,
                    showDividers: false,
                  ),
                  const SizedBox(height: 24),

                  if (_isLoading && !_hasError) ...[
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      _status,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],

                  if (_hasError) ...[
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _errorMessage ?? 'An error occurred',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    GazetteButton(
                      text: 'Retry',
                      onPressed: _retry,
                    ),
                  ],

                  const SizedBox(height: 16),
                  const GazetteDivider.simple(height: 16),
                  const SizedBox(height: 8),

                  Text(
                    'This may take a moment while we survey the area...',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
