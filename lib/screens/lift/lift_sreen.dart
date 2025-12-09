import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class LiftScreen extends StatelessWidget {
  static const routeName = "/lift";
  const LiftScreen({super.key});

  // ===========================================================
  // 🔧 LEFT DOOR CONTROL PANEL
  // ===========================================================

  static const double doorWidthFactor = 0.651;
  static const double doorHorizontalOffsetFactor = -0.20;
  static const double doorVerticalOffsetFactor = 0.0;

  // ===========================================================
  // 🔧 RIGHT DOOR CONTROL PANEL (INDEPENDENT)
  // ===========================================================

  static const double rightDoorWidthFactor = 0.651;
  static const double rightDoorHorizontalOffsetFactor = 0.220;
  static const double rightDoorVerticalOffsetFactor = 0.0;

  // ===========================================================
  // 🔧 BACKGROUND CONTROL
  // ===========================================================

  static const double backgroundScaleFactor = 1.0;

  // ===========================================================
  // 🔧 BUTTON CONTROL PANEL ✅ (UNCHANGED)
  // ===========================================================

  static const double buttonSize = 13;
  static const double buttonHorizontalOffset = 0.47;
  static const double buttonVerticalOffset = 0.16;
  static const double buttonSpacing = 12;

  // ===========================================================

  static const String liftBgUrl =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/interior.png";
  static const String liftDoorUrl =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/lift_door.png";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // =========================
          // ✅ LEFT DOOR DIMENSIONS
          // =========================
          final double leftDoorWidth = screenWidth * doorWidthFactor;
          final double leftCenterX = (screenWidth - leftDoorWidth) / 2;
          final double leftCenterY = (screenHeight - leftDoorWidth) / 2;

          final double leftDoorLeft =
              leftCenterX + (screenWidth * doorHorizontalOffsetFactor);
          final double leftDoorTop =
              leftCenterY + (screenHeight * doorVerticalOffsetFactor);

          // =========================
          // ✅ RIGHT DOOR DIMENSIONS
          // =========================
          final double rightDoorWidth = screenWidth * rightDoorWidthFactor;
          final double rightCenterX = (screenWidth - rightDoorWidth) / 2;
          final double rightCenterY = (screenHeight - rightDoorWidth) / 2;

          final double rightDoorLeft =
              rightCenterX + (screenWidth * rightDoorHorizontalOffsetFactor);
          final double rightDoorTop =
              rightCenterY + (screenHeight * rightDoorVerticalOffsetFactor);

          return Stack(
            children: [
              // --------------------------------------------------
              // ✅ BACKGROUND
              // --------------------------------------------------
              ClipRect(
                child: Transform.scale(
                  scale: backgroundScaleFactor,
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: CachedNetworkImage(
                      imageUrl: liftBgUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Text(
                          "Failed to load background image",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      cacheKey: "lift_screen_image",
                    ),
                  ),
                ),
              ),

              // --------------------------------------------------
              // ✅ LEFT DOOR
              // --------------------------------------------------
              Positioned(
                left: leftDoorLeft,
                top: leftDoorTop,
                child: CachedNetworkImage(
                  imageUrl: liftDoorUrl,
                  width: leftDoorWidth,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Text(
                      "Failed to load door image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  cacheKey: "lift_door_left",
                ),
              ),

              // --------------------------------------------------
              // ✅ RIGHT DOOR (MIRRORED)
              // --------------------------------------------------
              Positioned(
                left: rightDoorLeft,
                top: rightDoorTop,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
                  child: CachedNetworkImage(
                    imageUrl: liftDoorUrl,
                    width: rightDoorWidth,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Text(
                        "Failed to load door image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    cacheKey: "lift_door_right",
                  ),
                ),
              ),

              // --------------------------------------------------
              // ✅ CENTERED & FULLY ADJUSTABLE BUTTON PANEL (UNCHANGED)
              // --------------------------------------------------
              Positioned(
                left:
                    (screenWidth / 2) -
                    (buttonSize / 2) +
                    (screenWidth * buttonHorizontalOffset),
                top:
                    (screenHeight / 2) -
                    (buttonSize) +
                    (screenHeight * buttonVerticalOffset),
                child: Column(
                  children: [
                    _liftButton(
                      size: buttonSize,
                      icon: Icons.keyboard_arrow_up,
                      onTap: () {
                        print("UP button pressed");
                      },
                    ),
                    SizedBox(height: buttonSpacing),
                    _liftButton(
                      size: buttonSize,
                      icon: Icons.keyboard_arrow_down,
                      onTap: () {
                        print("DOWN button pressed");
                      },
                    ),
                  ],
                ),
              ),

              // --------------------------------------------------
              // ✅ ✅ ✅ "CALL THE LIFT" CENTER BUTTON
              // --------------------------------------------------
              Positioned(
                left: (screenWidth / 2) - 90,
                top: (screenHeight / 2) + (leftDoorWidth / 0.99),
                child: GestureDetector(
                  onTap: () {
                    print("CALL THE LIFT button pressed");
                  },
                  child: Container(
                    width: 180,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD58AD9),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      "Call the Lift",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ===========================================================
  // ✅ SIMPLE ROUND BUTTON WIDGET (ONLY COLOR CHANGED TO GREEN)
  // ===========================================================

  static Widget _liftButton({
    required double size,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.65),
      ),
    );
  }
}
