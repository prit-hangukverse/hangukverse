import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

// Adjust this import path if your project structure differs:
import 'package:hangukverse/screens/lift/floor/first_f.dart';

class InLiftScreen extends StatefulWidget {
  static const routeName = "/in-lift";

  const InLiftScreen({super.key});

  /// Images
  static const String inLiftImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/liftapp.png";

  static const String backgroundImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/lift_view.png";

  // overlay (panel) + buttons
  static const String panelBack =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/button_back.png";
  static const String btnE =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/e.png";
  static const String btnArrow =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/arrow.png";
  static const String btn1 =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/1.png";
  static const String btn2 =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/2.png";
  static const String btn3 =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/3.png";

  @override
  State<InLiftScreen> createState() => _InLiftScreenState();
}

class _InLiftScreenState extends State<InLiftScreen>
    with TickerProviderStateMixin {
  late final AnimationController _panelController;
  late final Animation<double> _opacity;

  // lift movement animation
  late final AnimationController _liftController;
  late final Animation<double> _liftAnim;

  static const Duration _doorDuration = Duration(milliseconds: 1600);
  static const Duration _animDuration = Duration(milliseconds: 350);

  // how long the elevator moves (tweak to taste)
  static const Duration liftDuration = Duration(milliseconds: 1200);

  // tweak these to change blur/dim intensity
  static const double maxBlur = 6.0;
  static const double maxDimOpacity = 0.28;

  // block repeated taps while moving
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();

    // panel fade controller (same as before)
    _panelController = AnimationController(
      vsync: this,
      duration: _animDuration,
    );
    _opacity = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeInOut,
    );

    // lift movement controller (0 -> 1)
    _liftController = AnimationController(vsync: this, duration: liftDuration);
    _liftAnim = CurvedAnimation(
      parent: _liftController,
      curve: Curves.easeInOut,
    );

    // Start the panel fade after the door duration.
    Timer(_doorDuration, () {
      if (mounted) _panelController.forward(from: 0);
    });

    // when lift animation completes -> navigate to first floor
    _liftController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // navigate to FirstFloorScreen after animation completes
        // use pushReplacement if you want to remove current screen
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const FirstFloorScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _panelController.dispose();
    _liftController.dispose();
    super.dispose();
  }

  // Called when user taps the "1" button
  void _onPressFloor1() {
    if (_isMoving) return; // ignore repeated taps
    setState(() => _isMoving = true);

    // optional: play panel fade-out quickly to emphasize movement
    // _panelController.reverse();

    // start lift animation (0->1)
    _liftController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    // The entire visual content (background + interior + panel + pills)
    // will be passed as `child` to AnimatedBuilder and translated upward
    final mainContent = Stack(
      fit: StackFit.expand,
      children: [
        // BACKGROUND IMAGE (fills screen)
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: InLiftScreen.backgroundImage,
            fit: BoxFit.cover,
          ),
        ),

        // LIFT INTERIOR IMAGE (fills screen)
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: InLiftScreen.inLiftImage,
            fit: BoxFit.cover,
          ),
        ),

        // BLUR + DIM overlay driven by panel opacity (same as before)
        AnimatedBuilder(
          animation: _opacity,
          builder: (context, child) {
            final blurAmount = _opacity.value * maxBlur;
            final dimOpacity = _opacity.value * maxDimOpacity;

            if (_opacity.value <= 0.001) return const SizedBox.shrink();

            return Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurAmount,
                  sigmaY: blurAmount,
                ),
                child: Container(color: Colors.black.withOpacity(dimOpacity)),
              ),
            );
          },
        ),

        // Panel and aligned right-side pills (built in same LayoutBuilder)
        LayoutBuilder(
          builder: (context, constraints) {
            final screenW = constraints.maxWidth;

            // Panel sizing
            final containerW = min(430.0, screenW * 0.43);
            final containerH = containerW * 2.2;

            // fractions for numbered buttons (same as before)
            const topBtn3Frac = 0.18;
            const topBtn2Frac = 0.40;
            const topBtn1Frac = 0.62;
            const bottomRowFrac = 0.86;

            final bigBtnSize = containerW * 0.28;
            final smallBtnSize = containerW * 0.36;

            // Pill sizing and spacing (relative to panel)
            final pillWidth = containerW * 1.05;
            final pillHeight = bigBtnSize * 0.9;
            final gap =
                containerW * 0.01; // horizontal gap between panel and pills

            // compute vertical offsets so pills align with numbered buttons
            final firstTop = containerH * topBtn3Frac - (pillHeight / 2);
            final between1and2 = containerH * (topBtn2Frac - topBtn3Frac);
            final between2and3 = containerH * (topBtn1Frac - topBtn2Frac);

            return Center(
              child: FadeTransition(
                opacity: _opacity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PANEL (background + buttons)
                    SizedBox(
                      width: containerW,
                      height: containerH,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned.fill(
                            child: CachedNetworkImage(
                              imageUrl: InLiftScreen.panelBack,
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Button 3
                          Positioned(
                            left: (containerW - bigBtnSize) / 2,
                            top: containerH * topBtn3Frac - bigBtnSize / 2,
                            width: bigBtnSize,
                            height: bigBtnSize,
                            child: _panelButton(InLiftScreen.btn3, () {
                              // add other floors if needed
                            }),
                          ),

                          // Button 2
                          Positioned(
                            left: (containerW - bigBtnSize) / 2,
                            top: containerH * topBtn2Frac - bigBtnSize / 2,
                            width: bigBtnSize,
                            height: bigBtnSize,
                            child: _panelButton(InLiftScreen.btn2, () {
                              // add other floors if needed
                            }),
                          ),

                          // Button 1 (this triggers the lift movement)
                          Positioned(
                            left: (containerW - bigBtnSize) / 2,
                            top: containerH * topBtn1Frac - bigBtnSize / 2,
                            width: bigBtnSize,
                            height: bigBtnSize,
                            child: _panelButton(InLiftScreen.btn1, () {
                              _onPressFloor1();
                            }),
                          ),

                          // bottom E + arrow
                          Positioned(
                            top: containerH * bottomRowFrac - smallBtnSize / 2,
                            left: 0,
                            right: 0,
                            height: smallBtnSize,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: smallBtnSize,
                                  height: smallBtnSize,
                                  child: _panelButton(InLiftScreen.btnE, () {}),
                                ),
                                SizedBox(
                                  width: smallBtnSize,
                                  height: smallBtnSize,
                                  child: _panelButton(
                                    InLiftScreen.btnArrow,
                                    () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: gap),

                    // Right-side column of pills aligned with numbered buttons
                    SizedBox(
                      width: pillWidth,
                      height: containerH,
                      child: Column(
                        children: [
                          SizedBox(height: firstTop),
                          _pillButton("Coming Soon", pillWidth, pillHeight, () {
                            debugPrint("Pressed top pill");
                          }),
                          SizedBox(height: max(0.0, between1and2 - pillHeight)),
                          _pillButton("Coming Soon", pillWidth, pillHeight, () {
                            debugPrint("Pressed middle pill");
                          }),
                          SizedBox(height: max(0.0, between2and3 - pillHeight)),
                          _pillButton("community", pillWidth, pillHeight, () {
                            debugPrint("Pressed bottom pill");
                          }),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );

    // Wrap the whole content in an AnimatedBuilder to translate it upward
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _liftAnim,
          builder: (context, child) {
            // translate by 0 -> -screenHeight (move up)
            final dy = -_liftAnim.value * screenH;
            return Transform.translate(offset: Offset(0, dy), child: child);
          },
          child: mainContent,
        ),
      ),
    );
  }

  // image button helper
  static Widget _panelButton(String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (_, __) => const SizedBox(),
        errorWidget: (_, __, ___) => const SizedBox(),
      ),
    );
  }

  // pill button widget (simple rounded bordered pill)
  static Widget _pillButton(
    String label,
    double width,
    double height,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        alignment: Alignment.center,
        margin: EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(height / 2),
          border: Border.all(
            color: Colors.cyanAccent.withOpacity(0.95),
            width: 1.6,
          ),
          color: Colors.black.withOpacity(0.35),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
