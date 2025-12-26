import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../data/cases/vanishing_violinist.dart';
import '../models/bound_case.dart';
import '../models/case_template.dart';
import '../models/poi.dart';
import '../providers/case_provider.dart';
import '../providers/game_state_provider.dart';
import '../providers/location_provider.dart';
import '../providers/poi_provider.dart';
import '../services/location_service.dart';
import '../theme/gazette_colors.dart';
import '../widgets/common/gazette_button.dart';
import '../widgets/common/gazette_card.dart';
import '../widgets/common/gazette_divider.dart';
import '../widgets/common/loading_step.dart';

/// The phases of case setup.
enum SetupPhase {
  requestingLocation,
  acquiringPosition,
  surveyingDistrict,
  classifyingLocations,
  preparingCaseFile,
  ready,
  error,
}

/// Screen shown while setting up a case (fetching POIs, binding locations).
///
/// Orchestrates the async loading process with atmospheric gazette-styled
/// loading messages and handles errors gracefully.
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
  SetupPhase _phase = SetupPhase.requestingLocation;
  String? _errorMessage;
  String? _errorTitle;

  // Results from setup process
  LatLng? _playerLocation;
  List<POI>? _classifiedPois;
  BoundCase? _boundCase;
  int _totalPoisFound = 0;

  // Demo mode for web testing
  bool _isDemoMode = false;

  // Fixed demo location (Central Örebro for testing)
  static const _demoLocation = LatLng(59.275848, 15.2166516);

  @override
  void initState() {
    super.initState();
    // Defer setup to avoid modifying providers during widget tree build
    Future.microtask(_startSetup);
  }

  CaseTemplate get _caseTemplate {
    // For MVP, we only have one case
    // In the future, look up by widget.caseId
    return vanishingViolinistCase;
  }

  Future<void> _startSetup() async {
    setState(() {
      _phase = SetupPhase.requestingLocation;
      _errorMessage = null;
      _errorTitle = null;
    });

    try {
      // Step 1: Request location permission
      final locationState = await _requestLocationPermission();
      if (!mounted) return;

      if (locationState == null) {
        // Error already set
        return;
      }

      // Step 2: Get current position
      setState(() => _phase = SetupPhase.acquiringPosition);
      final position = await _acquirePosition(locationState);
      if (!mounted) return;

      if (position == null) {
        // Error already set
        return;
      }
      _playerLocation = position;

      // Step 3: Fetch POIs from Overpass
      setState(() => _phase = SetupPhase.surveyingDistrict);
      final pois = await _fetchPOIs(position);
      if (!mounted) return;

      if (pois == null) {
        // Error already set
        return;
      }

      // Step 4: Classify POIs
      setState(() => _phase = SetupPhase.classifyingLocations);
      final classifiedPois = await _classifyPOIs(pois);
      if (!mounted) return;

      _classifiedPois = classifiedPois;
      _totalPoisFound = classifiedPois.length;

      // Step 5: Bind case to POIs
      setState(() => _phase = SetupPhase.preparingCaseFile);
      final boundCase = await _bindCase(classifiedPois, position);
      if (!mounted) return;

      if (boundCase == null) {
        // Error already set
        return;
      }

      _boundCase = boundCase;

      // Success!
      setState(() => _phase = SetupPhase.ready);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _phase = SetupPhase.error;
        _errorTitle = 'An Unexpected Difficulty';
        _errorMessage =
            'We have encountered an unforeseen circumstance: ${e.toString()}';
      });
    }
  }

  Future<LocationState?> _requestLocationPermission() async {
    final locationNotifier = ref.read(locationStateProvider.notifier);

    // Initialize location tracking
    await locationNotifier.initialize();

    // Wait a moment for state to settle
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return null;

    final state = ref.read(locationStateProvider);

    // Check status
    switch (state.status) {
      case LocationStatus.denied:
        setState(() {
          _phase = SetupPhase.error;
          _errorTitle = 'Permission Required';
          _errorMessage =
              'Alas! We cannot proceed without knowledge of your location. '
              'Pray grant the necessary permission so that we may survey '
              'the establishments in your vicinity.';
        });
        return null;

      case LocationStatus.deniedForever:
        setState(() {
          _phase = SetupPhase.error;
          _errorTitle = 'Permission Denied';
          _errorMessage =
              'Your device has been instructed to withhold location access '
              'permanently. Kindly adjust your settings to permit this '
              'application access to your whereabouts.';
        });
        return null;

      case LocationStatus.disabled:
        setState(() {
          _phase = SetupPhase.error;
          _errorTitle = 'Location Services Dormant';
          _errorMessage =
              "Your device's location services appear dormant. "
              'Please enable them in your system settings to proceed '
              'with the investigation.';
        });
        return null;

      case LocationStatus.unknown:
      case LocationStatus.checking:
        // Still checking, wait more
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return null;
        return ref.read(locationStateProvider);

      case LocationStatus.ready:
        return state;
    }
  }

  Future<LatLng?> _acquirePosition(LocationState initialState) async {
    // If we're in demo mode, return the demo location
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return _demoLocation;
    }

    // Wait for position to be available
    int attempts = 0;
    const maxAttempts = 10;

    while (attempts < maxAttempts) {
      final state = ref.read(locationStateProvider);

      if (state.currentPosition != null) {
        return state.currentPosition;
      }

      if (state.status == LocationStatus.denied ||
          state.status == LocationStatus.deniedForever ||
          state.status == LocationStatus.disabled) {
        setState(() {
          _phase = SetupPhase.error;
          _errorTitle = 'Position Unavailable';
          _errorMessage =
              'We were unable to ascertain your current whereabouts. '
              'Please ensure location services are enabled and try again.';
        });
        return null;
      }

      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return null;
      attempts++;
    }

    setState(() {
      _phase = SetupPhase.error;
      _errorTitle = 'Position Timeout';
      _errorMessage =
          'The acquisition of your position has taken an inordinate amount '
          'of time. Please ensure you have a clear view of the sky and '
          'try again.';
    });
    return null;
  }

  Future<List<POI>?> _fetchPOIs(LatLng position) async {
    try {
      final overpassService = ref.read(overpassServiceProvider);
      final pois = await overpassService.fetchPOIs(position);

      if (pois.isEmpty) {
        setState(() {
          _phase = SetupPhase.error;
          _errorTitle = 'District Survey Failed';
          _errorMessage =
              'The telegraph lines appear to be down, or perhaps this '
              'district lacks sufficient establishments of interest. '
              'Shall we attempt the survey again?';
        });
        return null;
      }

      return pois;
    } catch (e) {
      setState(() {
        _phase = SetupPhase.error;
        _errorTitle = 'Communication Failure';
        _errorMessage =
            'We were unable to establish communication with our '
            'cartographic services. The telegraph lines may be down. '
            'Shall we try again?';
      });
      return null;
    }
  }

  Future<List<POI>> _classifyPOIs(List<POI> pois) async {
    // Classification is synchronous but we add a small delay for UX
    await Future.delayed(const Duration(milliseconds: 300));

    final classificationService = ref.read(classificationServiceProvider);
    return classificationService.classifyAll(pois);
  }

  Future<BoundCase?> _bindCase(List<POI> pois, LatLng position) async {
    final bindingService = ref.read(bindingServiceProvider);

    final result = bindingService.bindCase(
      _caseTemplate,
      pois,
      position,
    );

    if (!result.isSuccess) {
      setState(() {
        _phase = SetupPhase.error;
        _errorTitle = 'Insufficient Locations';
        _errorMessage =
            'This district lacks sufficient locations of interest to '
            'conduct a proper investigation. Perhaps venture to a more '
            'populous area, or a neighborhood with greater variety of '
            'establishments.\n\n'
            'Required: ${result.errors.join(", ")}';
      });
      return null;
    }

    return result.boundCase;
  }

  void _retry() {
    _startSetup();
  }

  void _enableDemoMode() {
    setState(() {
      _isDemoMode = true;
    });
    // Set the demo position in the location provider for the map screen
    ref.read(locationStateProvider.notifier).setDemoPosition(_demoLocation);
    _startSetup();
  }

  void _proceedToInvestigation() {
    if (_boundCase == null) return;

    // Use Future.microtask to avoid modifying provider during widget tree build
    Future.microtask(() {
      // Store the bound case for the map screen to use
      ref.read(activeBoundCaseProvider.notifier).setBoundCase(_boundCase!);

      // Initialize game state
      ref.read(activeGameStateProvider.notifier).startCase(_boundCase!);

      // Navigate to map screen
      if (mounted) {
        context.go('/case/${widget.caseId}/play');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PREPARING INVESTIGATION',
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
          tooltip: 'Abandon Setup',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Header
              _buildHeader(textColor, subtitleColor),
              const SizedBox(height: 24),
              const GazetteDivider(),
              const SizedBox(height: 24),

              // Main content
              if (_phase == SetupPhase.error)
                _buildErrorView()
              else if (_phase == SetupPhase.ready)
                _buildReadyView()
              else
                _buildLoadingView(),

              // Web platform notice
              if (kIsWeb && _phase != SetupPhase.error) ...[
                const SizedBox(height: 24),
                _buildWebNotice(subtitleColor),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color textColor, Color subtitleColor) {
    return Column(
      children: [
        Text(
          _caseTemplate.title.toUpperCase(),
          style: GoogleFonts.playfairDisplay(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.5,
            color: textColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          _caseTemplate.subtitle,
          style: GoogleFonts.oldStandardTt(
            fontSize: 14,
            fontStyle: FontStyle.italic,
            color: subtitleColor,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildLoadingView() {
    return GazetteCard(
      showOrnaments: true,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Step 1: Location Permission
          LoadingStep(
            text: 'OBTAINING YOUR WHEREABOUTS',
            status: _getStepStatus(SetupPhase.requestingLocation),
            detail: _phase == SetupPhase.requestingLocation
                ? 'Requesting permission to access your location'
                : null,
          ),

          const LoadingStepDivider(),

          // Step 2: Acquire Position
          LoadingStep(
            text: 'ACQUIRING YOUR POSITION',
            status: _getStepStatus(SetupPhase.acquiringPosition),
            detail: _phase == SetupPhase.acquiringPosition
                ? _isDemoMode
                    ? 'Using demonstration coordinates'
                    : 'Consulting the celestial navigation apparatus'
                : _playerLocation != null
                    ? 'Position acquired successfully'
                    : null,
          ),

          const LoadingStepDivider(),

          // Step 3: Survey District
          LoadingStep(
            text: 'SURVEYING THE DISTRICT',
            status: _getStepStatus(SetupPhase.surveyingDistrict),
            detail: _phase == SetupPhase.surveyingDistrict
                ? 'Cataloguing nearby establishments via telegraph'
                : _totalPoisFound > 0
                    ? '$_totalPoisFound locations catalogued'
                    : null,
          ),

          const LoadingStepDivider(),

          // Step 4: Classify Locations
          LoadingStep(
            text: 'IDENTIFYING PERSONS OF INTEREST',
            status: _getStepStatus(SetupPhase.classifyingLocations),
            detail: _phase == SetupPhase.classifyingLocations
                ? 'Categorizing locations by investigative potential'
                : null,
          ),

          const LoadingStepDivider(),

          // Step 5: Prepare Case File
          LoadingStep(
            text: 'PREPARING YOUR CASE FILE',
            status: _getStepStatus(SetupPhase.preparingCaseFile),
            detail: _phase == SetupPhase.preparingCaseFile
                ? 'Binding case locations to your neighborhood'
                : null,
          ),

          const SizedBox(height: 24),
          const GazetteDivider.simple(),
          const SizedBox(height: 16),

          // Progress hint
          Text(
            'This may take a moment while we prepare the investigation...',
            style: GoogleFonts.oldStandardTt(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: Theme.of(context).brightness == Brightness.dark
                  ? GazetteColors.darkTextFaded
                  : GazetteColors.inkFaded,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  LoadingStepStatus _getStepStatus(SetupPhase stepPhase) {
    final phaseOrder = SetupPhase.values.indexOf(_phase);
    final stepOrder = SetupPhase.values.indexOf(stepPhase);

    if (_phase == SetupPhase.error || _phase == SetupPhase.ready) {
      // All steps before error/ready are completed
      if (stepOrder < SetupPhase.ready.index) {
        return LoadingStepStatus.completed;
      }
    }

    if (phaseOrder == stepOrder) {
      return LoadingStepStatus.inProgress;
    } else if (phaseOrder > stepOrder) {
      return LoadingStepStatus.completed;
    } else {
      return LoadingStepStatus.pending;
    }
  }

  Widget _buildErrorView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;

    return GazetteCard(
      showOrnaments: true,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Error icon
          Icon(
            Icons.report_outlined,
            size: 48,
            color: accentColor,
          ),
          const SizedBox(height: 16),

          // Error title
          Text(
            _errorTitle ?? 'An Error Has Occurred',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: accentColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const GazetteDivider.simple(),
          const SizedBox(height: 16),

          // Error message
          Text(
            _errorMessage ?? 'An unexpected error occurred.',
            style: GoogleFonts.oldStandardTt(
              fontSize: 14,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

          // Action buttons
          GazetteButton(
            text: 'Try Again',
            icon: Icons.refresh,
            onPressed: _retry,
          ),

          // Demo mode option for web
          if (kIsWeb) ...[
            const SizedBox(height: 12),
            GazetteButton.outlined(
              text: 'Use Demo Location',
              icon: Icons.location_on,
              onPressed: _enableDemoMode,
            ),
          ],

          const SizedBox(height: 16),
          TextButton(
            onPressed: () => context.go('/'),
            child: Text(
              'Return to Case Selection',
              style: GoogleFonts.oldStandardTt(
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final successColor = GazetteColors.success;

    return GazetteCard(
      showOrnaments: true,
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Success icon
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: successColor,
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            'DISTRICT SURVEY COMPLETE',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const GazetteDivider.simple(),
          const SizedBox(height: 16),

          // Summary stats
          _buildSummaryRow(
            'Locations Catalogued',
            '$_totalPoisFound',
            textColor,
            subtitleColor,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Investigation Sites Identified',
            '${_boundCase?.boundLocations.length ?? 0}',
            textColor,
            subtitleColor,
          ),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Required Locations Bound',
            '${_boundCase?.boundLocations.values.where((l) => _caseTemplate.locations[l.templateId]?.required ?? false).length ?? 0}',
            textColor,
            subtitleColor,
          ),

          if (_isDemoMode) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(
                  color: subtitleColor.withOpacity(0.5),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 16,
                    color: subtitleColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Using demonstration location (Central London)',
                      style: GoogleFonts.oldStandardTt(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: subtitleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),
          const GazetteDivider.ends(),
          const SizedBox(height: 24),

          // Proceed button
          GazetteButton(
            text: 'Proceed to Investigation',
            icon: Icons.arrow_forward,
            onPressed: _proceedToInvestigation,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    String label,
    String value,
    Color textColor,
    Color subtitleColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.oldStandardTt(
            fontSize: 14,
            color: subtitleColor,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildWebNotice(Color subtitleColor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: subtitleColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.language,
            size: 16,
            color: subtitleColor,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Browser location may be less precise than native devices. '
              'For the best experience, use the Android application.',
              style: GoogleFonts.oldStandardTt(
                fontSize: 11,
                fontStyle: FontStyle.italic,
                color: subtitleColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
