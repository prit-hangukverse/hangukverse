import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hangukverse/screens/lift/in_lift.dart' show InLiftScreen;

class LiftScreen extends StatefulWidget {
  static const routeName = "/lift";
  const LiftScreen({super.key});

  @override
  State<LiftScreen> createState() => _LiftScreenState();
}

class _LiftScreenState extends State<LiftScreen>
    with SingleTickerProviderStateMixin {
  // ===========================================================
  // 🔧 LEFT DOOR CONTROL PANEL (unchanged)
  // ===========================================================
  static const double doorWidthFactor = 0.651;
  static const double doorHorizontalOffsetFactor = -0.20;
  static const double doorVerticalOffsetFactor = 0.0;

  // ===========================================================
  // 🔧 RIGHT DOOR CONTROL PANEL (unchanged)
  // ===========================================================
  static const double rightDoorWidthFactor = 0.651;
  static const double rightDoorHorizontalOffsetFactor = 0.220;
  static const double rightDoorVerticalOffsetFactor = 0.0;

  // ===========================================================
  // 🔧 BACKGROUND (interior) CONTROL (unchanged)
  // ===========================================================
  static const double backgroundScaleFactor = 1.0;

  // ===========================================================
  // 🔧 LIFT_BACK (the image you want to zoom/move) (unchanged)
  // ===========================================================
  static const double backScale = -0.65;
  static const double backOffsetXFactor = 0.0;
  static const double backOffsetYFactor = 0.19;

  // ===========================================================
  // 🔧 get.png positioning control (unchanged)
  // ===========================================================
  static const double getOffsetYFactor = 0.22;

  // ===========================================================
  // 🔧 BUTTON CONTROL PANEL (unchanged)
  // ===========================================================
  static const double buttonSize = 13;
  static const double buttonHorizontalOffset = 0.47;
  static const double buttonVerticalOffset = 0.16;
  static const double buttonSpacing = 12;

  // ===========================================================
  // ASSETS
  // ===========================================================
  static const String liftBgUrl =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/interior.png";
  static const String liftDoorUrl =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/lift_door.png";
  static const String liftBackUrl =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/lift_background.png";
  static const String liftGetUrl =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/get.png";

  // Animation controller
  late final AnimationController _controller;
  late final Animation<double> _openAnim; // 0 = closed, 1 = open

  bool _isAnimating = false;
  bool _isOpen = false; // whether doors are currently open

  // NEW: visibility flag for the Call button
  bool _callButtonVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _openAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // animation finished -> mark open (DO NOT hide button here anymore)
        setState(() {
          _isAnimating = false;
          _isOpen = true;
          // _callButtonVisible is NOT changed here — it's hidden immediately when tapped
        });
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _isAnimating = false;
          _isOpen = false;
          // we do NOT re-show the button automatically (per your request)
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onCallPressed() {
    // If already animating or button not visible, ignore taps
    if (_isAnimating || !_callButtonVisible) return;

    // Immediately hide the Call button and mark animating
    setState(() {
      _callButtonVisible = false; // ← disappears immediately on tap
      _isAnimating = true;
    });

    // START opening animation only. No reverse/close action.
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          final screenHeight = constraints.maxHeight;

          // =========================
          // LEFT DOOR geometry
          // =========================
          final double leftDoorWidth = screenWidth * doorWidthFactor;
          final double leftDoorHeight = leftDoorWidth;
          final double leftCenterX = (screenWidth - leftDoorWidth) / 2;
          final double leftCenterY = (screenHeight - leftDoorWidth) / 2;
          final double leftDoorLeft =
              leftCenterX + (screenWidth * doorHorizontalOffsetFactor);
          final double leftDoorTop =
              leftCenterY + (screenHeight * doorVerticalOffsetFactor);

          // =========================
          // RIGHT DOOR geometry
          // =========================
          final double rightDoorWidth = screenWidth * rightDoorWidthFactor;
          final double rightDoorHeight = rightDoorWidth;
          final double rightCenterX = (screenWidth - rightDoorWidth) / 2;
          final double rightCenterY = (screenHeight - rightDoorWidth) / 2;
          final double rightDoorLeft =
              rightCenterX + (screenWidth * rightDoorHorizontalOffsetFactor);
          final double rightDoorTop =
              rightCenterY + (screenHeight * rightDoorVerticalOffsetFactor);

          // compute how far doors move when opening
          final double leftOpenOffset = -leftDoorWidth * 0.98;
          final double rightOpenOffset = rightDoorWidth * 0.98;

          // area that both doors cover (if needed)
          final double totalDoorsWidth =
              (rightDoorLeft + rightDoorWidth) - leftDoorLeft;
          final double totalDoorsHeight = leftDoorHeight > rightDoorHeight
              ? leftDoorHeight
              : rightDoorHeight;

          // compute actual translation for back image based on factor constants
          final double backTranslateX = screenWidth * backOffsetXFactor;
          final double backTranslateY = screenHeight * backOffsetYFactor;

          // ----- get.png sizing: responsive to doors area
          final double getWidth =
              totalDoorsWidth * 0.5; // 50% of door-gap width
          final double getLeft =
              leftDoorLeft + (totalDoorsWidth - getWidth) / 2;
          final double getTop =
              leftDoorTop +
              (totalDoorsHeight * 0.5) -
              (getWidth * 0.5); // center vertically (using width for square)

          // apply your requested vertical offset (percentage of screen height)
          final double getOffsetY = screenHeight * getOffsetYFactor;

          return Stack(
            fit: StackFit.expand,
            children: [
              // --------------------------
              // LIFT BACK (responsive, covers entire area)
              // --------------------------
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: liftBackUrl,
                  fit: BoxFit.cover, // <-- fill and crop edges (no extra space)
                  alignment: Alignment.center, // center the image
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Text(
                      "Failed to load back image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  cacheKey: "lift_back_image",
                ),
              ),

              // --------------------------
              // FRONT INTERIOR (unchanged)
              // --------------------------
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
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Text(
                          "Failed to load interior",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      cacheKey: "lift_screen_image",
                    ),
                  ),
                ),
              ),

              // --------------------------
              // NEW: get.png centered between doors, behind doors (above lift_back)
              // --------------------------
              // --------------------------
              // NEW: get.png with tap → open InLiftScreen
              // --------------------------
              Positioned(
                left: getLeft,
                top: getTop + getOffsetY,
                width: getWidth,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InLiftScreen()),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: liftGetUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (context, url, error) => const Center(
                      child: Text(
                        "Failed to load get image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    cacheKey: "lift_get_image",
                  ),
                ),
              ),

              // --------------------------
              // Animated Doors
              // --------------------------
              AnimatedBuilder(
                animation: _openAnim,
                builder: (context, _) {
                  final t = _openAnim.value;
                  final double leftAnimatedLeft =
                      leftDoorLeft + (leftOpenOffset * t);
                  final double rightAnimatedLeft =
                      rightDoorLeft + (rightOpenOffset * t);

                  // fade out doors slightly at end of animation for smoothness
                  final double doorsOpacity =
                      1.0 - ((t - 0.85).clamp(0.0, 1.0));
                  final double clampedOpacity = doorsOpacity.clamp(0.0, 1.0);

                  // drive opacity strictly from animation value
                  final double renderOpacity = clampedOpacity;

                  return Stack(
                    children: [
                      Positioned(
                        left: leftAnimatedLeft,
                        top: leftDoorTop,
                        child: Opacity(
                          opacity: renderOpacity,
                          child: CachedNetworkImage(
                            imageUrl: liftDoorUrl,
                            width: leftDoorWidth,
                            fit: BoxFit.contain,
                            cacheKey: "lift_door_left",
                          ),
                        ),
                      ),

                      Positioned(
                        left: rightAnimatedLeft,
                        top: rightDoorTop,
                        child: Opacity(
                          opacity: renderOpacity,
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..scale(-1.0, 1.0, 1.0),
                            child: CachedNetworkImage(
                              imageUrl: liftDoorUrl,
                              width: rightDoorWidth,
                              fit: BoxFit.contain,
                              cacheKey: "lift_door_right",
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),

              // --------------------------
              // Up/Down buttons (unchanged)
              // --------------------------
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
                      onTap: () => debugPrint("UP button pressed"),
                    ),
                    SizedBox(height: buttonSpacing),
                    _liftButton(
                      size: buttonSize,
                      icon: Icons.keyboard_arrow_down,
                      onTap: () => debugPrint("DOWN button pressed"),
                    ),
                  ],
                ),
              ),

              // --------------------------
              // Call the lift button (now single-use & invisible immediately after press)
              // --------------------------
              if (_callButtonVisible)
                Positioned(
                  left: (screenWidth / 2) - 90,
                  top: (screenHeight / 2) + (leftDoorWidth / 0.99),
                  child: GestureDetector(
                    onTap: _onCallPressed,
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

  // -----------------------------------------------------------
  // simple round lift button
  // -----------------------------------------------------------
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
