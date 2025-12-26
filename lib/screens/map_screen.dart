import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../models/bound_case.dart';
import '../providers/game_state_provider.dart';
import '../providers/location_provider.dart';
import '../theme/gazette_colors.dart';
import '../utils/constants.dart';
import '../utils/geo_utils.dart';
import '../widgets/common/gazette_button.dart';
import '../widgets/common/gazette_divider.dart';
import '../widgets/map/location_marker.dart';
import '../widgets/map/player_marker.dart';

/// The main gameplay map screen.
class MapScreen extends ConsumerStatefulWidget {
  final String caseId;

  const MapScreen({
    super.key,
    required this.caseId,
  });

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();
  String? _selectedLocationId;
  bool _showDistanceTooltip = false;
  double _tooltipDistance = 0;

  @override
  void initState() {
    super.initState();
    // Ensure location tracking is active
    Future.microtask(() {
      ref.read(locationStateProvider.notifier).initialize();
    });
  }

  void _centerOnPlayer() {
    final locationState = ref.read(locationStateProvider);
    if (locationState.currentPosition != null) {
      _mapController.move(
        locationState.currentPosition!,
        _mapController.camera.zoom,
      );
    }
  }

  void _onLocationMarkerTapped(
    String locationId,
    BoundLocation boundLocation,
    LatLng? playerPosition,
  ) {
    if (playerPosition == null) return;

    final locationPos = LatLng(
      boundLocation.poi.lat,
      boundLocation.poi.lon,
    );
    final distance = haversineDistance(playerPosition, locationPos);

    if (distance <= unlockRadiusMeters) {
      // Navigate to location screen
      context.push('/case/${widget.caseId}/location/$locationId');
    } else {
      // Show distance tooltip
      setState(() {
        _selectedLocationId = locationId;
        _showDistanceTooltip = true;
        _tooltipDistance = distance;
      });

      // Auto-hide after a few seconds
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && _selectedLocationId == locationId) {
          setState(() {
            _showDistanceTooltip = false;
            _selectedLocationId = null;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locationState = ref.watch(locationStateProvider);
    final boundCase = ref.watch(activeBoundCaseProvider);
    final gameState = ref.watch(activeGameStateProvider);

    // Calculate stats
    final visitedCount = gameState?.visitedLocations.length ?? 0;
    final totalLocations = boundCase?.boundLocations.length ?? 0;
    final discoveredClues = gameState?.discoveredClues.length ?? 0;
    final totalClues = boundCase?.template.clues.length ?? 0;

    return Scaffold(
      body: Stack(
        children: [
          // The map
          _buildMap(
            isDark,
            locationState.currentPosition,
            boundCase,
            gameState?.visitedLocations ?? {},
            gameState?.unlockedLocations ?? {},
          ),

          // Sepia overlay for vintage effect
          Positioned.fill(
            child: IgnorePointer(
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  (isDark
                          ? GazetteColors.darkBackground
                          : GazetteColors.parchment)
                      .withOpacity(0.08),
                  BlendMode.color,
                ),
                child: Container(),
              ),
            ),
          ),

          // Distance tooltip
          if (_showDistanceTooltip && _selectedLocationId != null)
            _buildDistanceTooltip(),

          // Top bar with back button and title
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _buildTopBar(isDark, boundCase),
          ),

          // Bottom panel
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomPanel(
              isDark,
              visitedCount,
              totalLocations,
              discoveredClues,
              totalClues,
            ),
          ),

          // Floating action buttons
          Positioned(
            right: 16,
            bottom: 140,
            child: _buildFloatingButtons(isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(
    bool isDark,
    LatLng? playerPosition,
    BoundCase? boundCase,
    Set<String> visitedLocations,
    Set<String> unlockedLocations,
  ) {
    // Default center if no position yet
    final center = playerPosition ?? const LatLng(59.275848, 15.2166516);

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: center,
        initialZoom: defaultMapZoom,
        minZoom: minMapZoom,
        maxZoom: maxMapZoom,
        onTap: (_, __) {
          // Dismiss tooltip on map tap
          setState(() {
            _showDistanceTooltip = false;
            _selectedLocationId = null;
          });
        },
      ),
      children: [
        // Base tile layer with sepia tint
        TileLayer(
          urlTemplate: osmTileUrlTemplate,
          userAgentPackageName: osmUserAgent,
          tileBuilder: isDark ? _darkTileBuilder : _sepiaTileBuilder,
        ),

        // Location markers
        if (boundCase != null)
          MarkerLayer(
            markers: _buildLocationMarkers(
              boundCase,
              playerPosition,
              visitedLocations,
              unlockedLocations,
            ),
          ),

        // Player marker
        if (playerPosition != null)
          MarkerLayer(
            markers: [
              Marker(
                point: playerPosition,
                width: 48,
                height: 60,
                child: const PlayerMarker(size: 48),
              ),
            ],
          ),

        // Attribution
        RichAttributionWidget(
          alignment: AttributionAlignment.bottomLeft,
          attributions: [
            TextSourceAttribution(
              osmAttribution,
              textStyle: GoogleFonts.oldStandardTt(
                fontSize: 10,
                color: isDark
                    ? GazetteColors.darkTextFaded
                    : GazetteColors.inkFaded,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Applies a sepia/vintage filter to tiles for light mode.
  Widget _sepiaTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: const ColorFilter.matrix(<double>[
        0.393, 0.769, 0.189, 0, 0, // Red
        0.349, 0.686, 0.168, 0, 0, // Green
        0.272, 0.534, 0.131, 0, 0, // Blue
        0, 0, 0, 1, 0, // Alpha
      ]),
      child: tileWidget,
    );
  }

  /// Applies a dark desaturated filter to tiles for dark mode.
  Widget _darkTileBuilder(
    BuildContext context,
    Widget tileWidget,
    TileImage tile,
  ) {
    return ColorFiltered(
      colorFilter: ColorFilter.matrix(<double>[
        0.2, 0.2, 0.2, 0, 0, // Red - heavily desaturated
        0.2, 0.2, 0.2, 0, 0, // Green
        0.2, 0.2, 0.2, 0, 0, // Blue
        0, 0, 0, 1, 0, // Alpha
      ]),
      child: Opacity(
        opacity: 0.7,
        child: tileWidget,
      ),
    );
  }

  List<Marker> _buildLocationMarkers(
    BoundCase boundCase,
    LatLng? playerPosition,
    Set<String> visitedLocations,
    Set<String> unlockedLocations,
  ) {
    final markers = <Marker>[];

    for (final entry in boundCase.boundLocations.entries) {
      final locationId = entry.key;
      final boundLocation = entry.value;
      final templateLocation = boundCase.template.locations[locationId];

      // Determine marker state
      LocationMarkerState markerState;
      if (visitedLocations.contains(locationId)) {
        markerState = LocationMarkerState.visited;
      } else if (unlockedLocations.contains(locationId) ||
          templateLocation?.required == true) {
        // Required locations start unlocked, optional ones need to be revealed
        markerState = LocationMarkerState.available;
      } else {
        markerState = LocationMarkerState.locked;
      }

      // Check if in range
      final locationPos = LatLng(
        boundLocation.poi.lat,
        boundLocation.poi.lon,
      );
      final isInRange = playerPosition != null &&
          haversineDistance(playerPosition, locationPos) <= unlockRadiusMeters;

      markers.add(
        Marker(
          point: locationPos,
          width: 88,
          height: 80,
          child: LocationMarker(
            name: boundLocation.displayName,
            state: markerState,
            isInRange: isInRange,
            onTap: () => _onLocationMarkerTapped(
              locationId,
              boundLocation,
              playerPosition,
            ),
          ),
        ),
      );
    }

    return markers;
  }

  Widget _buildDistanceTooltip() {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.4,
      left: 40,
      right: 40,
      child: Center(
        child: LocationDistanceTooltip(distanceMeters: _tooltipDistance),
      ),
    );
  }

  Widget _buildTopBar(bool isDark, BoundCase? boundCase) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 8,
        right: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            (isDark ? GazetteColors.darkBackground : GazetteColors.parchment)
                .withOpacity(0.95),
            (isDark ? GazetteColors.darkBackground : GazetteColors.parchment)
                .withOpacity(0.0),
          ],
        ),
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? GazetteColors.darkText : GazetteColors.inkBlack,
            ),
            onPressed: () => context.go('/'),
            tooltip: 'Return Home',
          ),
          const SizedBox(width: 8),

          // Case title
          Expanded(
            child: Text(
              boundCase?.template.title.toUpperCase() ?? 'INVESTIGATION',
              style: GoogleFonts.playfairDisplay(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: isDark ? GazetteColors.darkText : GazetteColors.inkBlack,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Notebook button
          IconButton(
            icon: Icon(
              Icons.menu_book,
              color: isDark ? GazetteColors.darkText : GazetteColors.inkBlack,
            ),
            onPressed: () => context.push('/case/${widget.caseId}/notebook'),
            tooltip: 'Notebook',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel(
    bool isDark,
    int visitedCount,
    int totalLocations,
    int discoveredClues,
    int totalClues,
  ) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom + 8,
        left: 16,
        right: 16,
        top: 12,
      ),
      decoration: BoxDecoration(
        color: isDark ? GazetteColors.darkCard : GazetteColors.parchment,
        border: Border(
          top: BorderSide(
            color:
                isDark ? GazetteColors.darkTextFaded : GazetteColors.inkBrown,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Decorative header
          Row(
            children: [
              Expanded(
                child: GazetteDivider.simple(
                  color: isDark
                      ? GazetteColors.darkTextFaded
                      : GazetteColors.inkFaded,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '❧ INVESTIGATION PROGRESS ❧',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                    color: isDark
                        ? GazetteColors.darkTextSecondary
                        : GazetteColors.inkBrown,
                  ),
                ),
              ),
              Expanded(
                child: GazetteDivider.simple(
                  color: isDark
                      ? GazetteColors.darkTextFaded
                      : GazetteColors.inkFaded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                isDark,
                'Locations',
                '$visitedCount of $totalLocations',
                Icons.location_on,
              ),
              Container(
                width: 1,
                height: 30,
                color: isDark
                    ? GazetteColors.darkTextFaded
                    : GazetteColors.inkFaded,
              ),
              _buildStatItem(
                isDark,
                'Clues',
                '$discoveredClues of $totalClues',
                Icons.vpn_key,
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Accusation button
          GazetteButton(
            text: 'MAKE ACCUSATION',
            icon: Icons.gavel,
            onPressed: () => context.push('/case/${widget.caseId}/solve'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    bool isDark,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: isDark
                  ? GazetteColors.darkTextSecondary
                  : GazetteColors.inkBrown,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.oldStandardTt(
                fontSize: 11,
                color: isDark
                    ? GazetteColors.darkTextSecondary
                    : GazetteColors.inkBrown,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.playfairDisplay(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? GazetteColors.darkText : GazetteColors.inkBlack,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingButtons(bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Re-center on player
        _FloatingActionButton(
          isDark: isDark,
          icon: Icons.my_location,
          tooltip: 'Center on your position',
          onPressed: _centerOnPlayer,
        ),
        const SizedBox(height: 8),

        // Open notebook
        _FloatingActionButton(
          isDark: isDark,
          icon: Icons.menu_book,
          tooltip: 'Open Notebook',
          onPressed: () => context.push('/case/${widget.caseId}/notebook'),
        ),
      ],
    );
  }
}

class _FloatingActionButton extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  const _FloatingActionButton({
    required this.isDark,
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? GazetteColors.darkCard : GazetteColors.parchment,
      elevation: 4,
      borderRadius: BorderRadius.circular(4),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark
                  ? GazetteColors.darkTextFaded
                  : GazetteColors.inkBrown,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Tooltip(
            message: tooltip,
            child: Icon(
              icon,
              color: isDark ? GazetteColors.darkText : GazetteColors.inkBlack,
            ),
          ),
        ),
      ),
    );
  }
}
