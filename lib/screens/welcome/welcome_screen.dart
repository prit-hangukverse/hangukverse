import 'package:flutter/material.dart';
import 'package:hangukverse/screens/auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({super.key});

  // ===========================================================
  // 🔧 SHARED DOOR CONTROL SETTINGS — CHANGE THESE ONLY
  // ===========================================================

  /// Width of each door relative to screen (0.1 to 0.6 recommended)
  static const double doorWidthFactor = 0.50;

  /// Optional fixed height. Set null to auto-scale with aspect ratio.
  static const double? doorHeight = null;

  /// Shared zoom (1.0 = normal, <1 smaller, >1 bigger)
  static const double doorScale = 0.84;

  /// Move both doors as a group: offset(dx, dy)
  /// dx: + = right, - = left
  /// dy: + = down, - = up
  static const Offset doorOffset = Offset(0, 100);

  // ===========================================================
  // 🔧 PER-DOOR OVERRIDES — SET TO null TO USE SHARED DEFAULTS
  // ===========================================================

  // Left door overrides (null => use shared)
  static const double? leftDoorWidthFactor = null;
  static const double? leftDoorHeight = null;
  static const double? leftDoorScale = 0.77;
  static const Offset? leftDoorOffset = Offset(9, -30);

  // Right door overrides (null => use shared)
  static const double? rightDoorWidthFactor = null;
  static const double? rightDoorHeight = null;
  static const double? rightDoorScale = null;
  static const Offset? rightDoorOffset = Offset(-10, -30);

  // ===========================================================
  // 🖼 IMAGE URLS (UNCHANGED)
  // ===========================================================

  static const String backgroundUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/home+page+for+phone+bg+1.png';

  static const String topAsset = 'assets/welcome/subtract.png';

  static const String subtract1Url =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/Subtract-1.png';

  static const String leftDoorUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/DOOR+L+final+1.png';

  static const String rightDoorUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/DOOR+L+final+2.png';

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;

    // ===========================================================
    // ✅ RESOLVE EFFECTIVE LEFT DOOR SETTINGS
    // ===========================================================

    final double effectiveLeftWidthFactor =
        leftDoorWidthFactor ?? doorWidthFactor;

    final double effectiveLeftScale = leftDoorScale ?? doorScale;

    final double? effectiveLeftHeight = leftDoorHeight ?? doorHeight;

    final Offset effectiveLeftOffset = leftDoorOffset ?? Offset.zero;

    // ===========================================================
    // ✅ RESOLVE EFFECTIVE RIGHT DOOR SETTINGS
    // ===========================================================

    final double effectiveRightWidthFactor =
        rightDoorWidthFactor ?? doorWidthFactor;

    final double effectiveRightScale = rightDoorScale ?? doorScale;

    final double? effectiveRightHeight = rightDoorHeight ?? doorHeight;

    final Offset effectiveRightOffset = rightDoorOffset ?? Offset.zero;

    // ===========================================================
    // ✅ COMPUTE FINAL DOOR WIDTHS (CLAMPED)
    // ===========================================================

    final double leftWidth = (maxW * effectiveLeftWidthFactor).clamp(
      0.0,
      maxW / 2,
    );

    final double rightWidth = (maxW * effectiveRightWidthFactor).clamp(
      0.0,
      maxW / 2,
    );

    // ===========================================================
    // ✅ UI LAYOUT
    // ===========================================================

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ===========================================================
          // 🔹 BACKGROUND IMAGE
          // ===========================================================
          Positioned.fill(
            child: Image.network(backgroundUrl, fit: BoxFit.cover),
          ),

          // ===========================================================
          // 🔹 TOP + SUBTRACT-1 LAYER
          // ===========================================================
          SafeArea(
            top: false,
            bottom: false,
            child: Column(
              children: [
                /// ✅ TOP IMAGE
                Align(
                  alignment: Alignment.topCenter,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Transform.scale(
                          scale: 1.05,
                          child: Image.asset(topAsset, fit: BoxFit.contain),
                        ),
                      );
                    },
                  ),
                ),

                /// ✅ SUBTRACT-1 FILLER
                Expanded(
                  child: Image.network(
                    subtract1Url,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),

          // ===========================================================
          // 🔥 DOORS — LEFT & RIGHT
          // ===========================================================
          Center(
            child: Transform.translate(
              offset: doorOffset,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // ✅ LEFT DOOR
                  Transform.translate(
                    offset: effectiveLeftOffset,
                    child: SizedBox(
                      width: leftWidth,
                      height: effectiveLeftHeight,
                      child: Transform.scale(
                        scale: effectiveLeftScale,
                        alignment: Alignment.centerRight,
                        child: Image.network(leftDoorUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),

                  // ✅ RIGHT DOOR
                  Transform.translate(
                    offset: effectiveRightOffset,
                    child: SizedBox(
                      width: rightWidth,
                      height: effectiveRightHeight,
                      child: Transform.scale(
                        scale: effectiveRightScale,
                        alignment: Alignment.centerLeft,
                        child: Image.network(rightDoorUrl, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
