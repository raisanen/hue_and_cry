import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/gazette_colors.dart';

/// The visual state of a location marker.
enum LocationMarkerState {
  /// Location is not yet revealed (hidden by prerequisite clues).
  locked,

  /// Location is revealed and can be visited.
  available,

  /// Location has been visited by the player.
  visited,
}

/// A vintage-styled location marker for the investigation map.
///
/// Displays different visual states based on whether the location
/// is locked, available, or already visited.
class LocationMarker extends StatelessWidget {
  /// The display name of the location.
  final String name;

  /// The current state of this location.
  final LocationMarkerState state;

  /// Whether the player is within interaction range.
  final bool isInRange;

  /// Size of the marker.
  final double size;

  /// Callback when the marker is tapped.
  final VoidCallback? onTap;

  const LocationMarker({
    super.key,
    required this.name,
    required this.state,
    this.isInRange = false,
    this.size = 44,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size * 2,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // The marker itself
            _buildMarker(isDark),
            const SizedBox(height: 2),
            // Location name label
            _buildLabel(isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildMarker(bool isDark) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Glow effect for available + in-range locations
        if (state == LocationMarkerState.available && isInRange)
          _buildGlowEffect(isDark),

        // Main marker shape (vintage flag/banner style)
        _buildMarkerBody(isDark),

        // State icon overlay
        _buildStateIcon(isDark),
      ],
    );
  }

  Widget _buildGlowEffect(bool isDark) {
    final glowColor =
        isDark ? GazetteColors.wanted : GazetteColors.copperplate;

    return Container(
      width: size * 1.3,
      height: size * 1.3,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.4),
            blurRadius: 12,
            spreadRadius: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildMarkerBody(bool isDark) {
    Color backgroundColor;
    Color borderColor;

    switch (state) {
      case LocationMarkerState.locked:
        backgroundColor = isDark
            ? GazetteColors.darkCard.withOpacity(0.7)
            : GazetteColors.newsprint.withOpacity(0.8);
        borderColor = isDark
            ? GazetteColors.darkTextFaded
            : GazetteColors.inkFaded.withOpacity(0.5);
        break;

      case LocationMarkerState.available:
        backgroundColor =
            isDark ? GazetteColors.darkCard : GazetteColors.parchment;
        borderColor = isDark
            ? GazetteColors.wanted
            : GazetteColors.copperplate;
        break;

      case LocationMarkerState.visited:
        backgroundColor = isDark
            ? GazetteColors.darkSurface
            : GazetteColors.newsprint;
        borderColor = isDark
            ? GazetteColors.darkTextSecondary
            : GazetteColors.inkBrown;
        break;
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: 2),
        borderRadius: BorderRadius.circular(4),
        boxShadow: state != LocationMarkerState.locked
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
    );
  }

  Widget _buildStateIcon(bool isDark) {
    IconData iconData;
    Color iconColor;
    double iconSize = size * 0.5;

    switch (state) {
      case LocationMarkerState.locked:
        iconData = Icons.help_outline;
        iconColor = isDark
            ? GazetteColors.darkTextFaded
            : GazetteColors.inkFaded;
        break;

      case LocationMarkerState.available:
        iconData = Icons.location_on;
        iconColor = isDark
            ? GazetteColors.wanted
            : GazetteColors.copperplate;
        break;

      case LocationMarkerState.visited:
        iconData = Icons.check;
        iconColor = isDark
            ? GazetteColors.darkTextSecondary
            : GazetteColors.inkBrown;
        break;
    }

    return Icon(
      iconData,
      size: iconSize,
      color: iconColor,
    );
  }

  Widget _buildLabel(bool isDark) {
    Color textColor;
    FontWeight fontWeight;

    switch (state) {
      case LocationMarkerState.locked:
        textColor = isDark
            ? GazetteColors.darkTextFaded
            : GazetteColors.inkFaded;
        fontWeight = FontWeight.normal;
        break;

      case LocationMarkerState.available:
        textColor = isDark
            ? GazetteColors.darkText
            : GazetteColors.inkBlack;
        fontWeight = FontWeight.w600;
        break;

      case LocationMarkerState.visited:
        textColor = isDark
            ? GazetteColors.darkTextSecondary
            : GazetteColors.inkBrown;
        fontWeight = FontWeight.normal;
        break;
    }

    // Truncate long names
    final displayName = name.length > 15 ? '${name.substring(0, 12)}...' : name;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: (isDark ? GazetteColors.darkBackground : GazetteColors.paperWhite)
            .withOpacity(0.85),
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        displayName,
        style: GoogleFonts.oldStandardTt(
          fontSize: 10,
          fontWeight: fontWeight,
          color: textColor,
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

/// A tooltip widget showing distance to a location.
class LocationDistanceTooltip extends StatelessWidget {
  /// Distance in meters.
  final double distanceMeters;

  const LocationDistanceTooltip({
    super.key,
    required this.distanceMeters,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Convert to yards for period-appropriate measurement
    final distanceYards = (distanceMeters * 1.09361).round();

    String distanceText;
    if (distanceYards < 100) {
      distanceText = '$distanceYards yards';
    } else if (distanceYards < 1760) {
      distanceText = '${(distanceYards / 100).round() * 100} yards';
    } else {
      final miles = distanceYards / 1760;
      distanceText = '${miles.toStringAsFixed(1)} miles';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? GazetteColors.darkCard : GazetteColors.parchment,
        border: Border.all(
          color: isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown,
        ),
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'You are $distanceText distant.',
            style: GoogleFonts.oldStandardTt(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: isDark ? GazetteColors.darkText : GazetteColors.inkBlack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Draw nearer to investigate.',
            style: GoogleFonts.oldStandardTt(
              fontSize: 11,
              color: isDark
                  ? GazetteColors.darkTextSecondary
                  : GazetteColors.inkBrown,
            ),
          ),
        ],
      ),
    );
  }
}
