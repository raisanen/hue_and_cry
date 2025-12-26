import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/gazette_colors.dart';

/// Status of a loading step in the setup process.
enum LoadingStepStatus {
  /// Step has not started yet.
  pending,

  /// Step is currently in progress.
  inProgress,

  /// Step completed successfully.
  completed,

  /// Step failed with an error.
  failed,
}

/// A single step in the case setup loading process.
///
/// Displays with gazette-styled atmospheric text and
/// appropriate status indicators (checkmarks, spinners, etc.)
class LoadingStep extends StatelessWidget {
  /// The main text to display for this step.
  final String text;

  /// Current status of this step.
  final LoadingStepStatus status;

  /// Optional detail text to show below the main text.
  final String? detail;

  /// Whether to show an animated ellipsis when in progress.
  final bool animateEllipsis;

  const LoadingStep({
    super.key,
    required this.text,
    required this.status,
    this.detail,
    this.animateEllipsis = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? GazetteColors.darkText : GazetteColors.inkBlack;
    final subtitleColor =
        isDark ? GazetteColors.darkTextSecondary : GazetteColors.inkBrown;
    final fadedColor =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkFaded;
    final accentColor =
        isDark ? GazetteColors.bloodRedLight : GazetteColors.bloodRed;
    final successColor = GazetteColors.success;

    // Determine colors based on status
    Color mainColor;
    switch (status) {
      case LoadingStepStatus.pending:
        mainColor = fadedColor;
        break;
      case LoadingStepStatus.inProgress:
        mainColor = textColor;
        break;
      case LoadingStepStatus.completed:
        mainColor = successColor;
        break;
      case LoadingStepStatus.failed:
        mainColor = accentColor;
        break;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status indicator
          SizedBox(
            width: 28,
            height: 28,
            child: _buildStatusIndicator(mainColor, subtitleColor),
          ),
          const SizedBox(width: 12),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Main text with optional ellipsis animation
                if (status == LoadingStepStatus.inProgress && animateEllipsis)
                  _AnimatedEllipsisText(
                    text: text,
                    style: GoogleFonts.oldStandardTt(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: mainColor,
                    ),
                  )
                else
                  Text(
                    text,
                    style: GoogleFonts.oldStandardTt(
                      fontSize: 14,
                      fontWeight: status == LoadingStepStatus.pending
                          ? FontWeight.normal
                          : FontWeight.w600,
                      color: mainColor,
                    ),
                  ),

                // Detail text
                if (detail != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    detail!,
                    style: GoogleFonts.oldStandardTt(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusIndicator(Color mainColor, Color subtitleColor) {
    switch (status) {
      case LoadingStepStatus.pending:
        return Center(
          child: Text(
            '○',
            style: TextStyle(
              fontSize: 16,
              color: mainColor,
            ),
          ),
        );

      case LoadingStepStatus.inProgress:
        return Center(
          child: SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(mainColor),
            ),
          ),
        );

      case LoadingStepStatus.completed:
        return Center(
          child: Text(
            '✓',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
        );

      case LoadingStepStatus.failed:
        return Center(
          child: Text(
            '✗',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
        );
    }
  }
}

/// Animated ellipsis text that cycles through ".", "..", "..."
class _AnimatedEllipsisText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const _AnimatedEllipsisText({
    required this.text,
    required this.style,
  });

  @override
  State<_AnimatedEllipsisText> createState() => _AnimatedEllipsisTextState();
}

class _AnimatedEllipsisTextState extends State<_AnimatedEllipsisText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dotCount = 1;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _dotCount = (_dotCount % 3) + 1;
          });
          _controller.forward(from: 0);
        }
      });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dots = '.' * _dotCount;
    final padding = ' ' * (3 - _dotCount); // Keep width stable
    return Text(
      '${widget.text}$dots$padding',
      style: widget.style,
    );
  }
}

/// A decorative step divider with ornamental elements.
class LoadingStepDivider extends StatelessWidget {
  const LoadingStepDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color =
        isDark ? GazetteColors.darkTextFaded : GazetteColors.inkFaded;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: color.withOpacity(0.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '✦',
              style: TextStyle(fontSize: 8, color: color),
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: color.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}
