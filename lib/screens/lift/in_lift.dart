import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class InLiftScreen extends StatefulWidget {
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
    with SingleTickerProviderStateMixin {
  late final AnimationController _panelController;
  late final Animation<double> _opacity;
  late final Animation<double> _scale;

  // Simulated door animation duration — panel appears after this.
  static const Duration _doorDuration = Duration(milliseconds: 1600);

  // Panel entrance animation duration
  static const Duration _animDuration = Duration(milliseconds: 350);

  @override
  void initState() {
    super.initState();

    _panelController = AnimationController(
      vsync: this,
      duration: _animDuration,
    );

    // opacity: 0 -> 1
    _opacity = CurvedAnimation(
      parent: _panelController,
      curve: Curves.easeInOut,
    );

    // scale: slightly smaller -> normal (gives a gentle pop)
    _scale = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(parent: _panelController, curve: Curves.easeOutBack),
    );

    // Start the panel animation after the door duration.
    Timer(_doorDuration, () {
      if (!mounted) return;
      _panelController.forward(from: 0.0);
    });
  }

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // BACKGROUND IMAGE (fills screen)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: InLiftScreen.backgroundImage,
                fit: BoxFit.cover,
              ),
            ),

            // FULLSCREEN lift interior (on top of background)
            Positioned.fill(
              child: CachedNetworkImage(
                imageUrl: InLiftScreen.inLiftImage,
                fit: BoxFit.cover,
              ),
            ),

            // Centered panel with buttons stacked on top
            LayoutBuilder(
              builder: (context, constraints) {
                final screenW = constraints.maxWidth;
                final containerW = min(430.0, screenW * 0.43);
                final containerH = containerW * 2.2;

                const topBtn3Frac = 0.18;
                const topBtn2Frac = 0.40;
                const topBtn1Frac = 0.62;
                const bottomRowFrac = 0.86;

                final bigBtnSize = containerW * 0.28;
                final smallBtnSize = containerW * 0.36;

                return Align(
                  alignment: const Alignment(-0.60, 0),
                  child: SizedBox(
                    width: containerW,
                    height: containerH,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Panel background AND buttons are wrapped together
                        // in ScaleTransition + FadeTransition so they animate as one unit.
                        ScaleTransition(
                          scale: _scale,
                          child: FadeTransition(
                            opacity: _opacity,
                            child: SizedBox(
                              width: containerW,
                              height: containerH,
                              child: Stack(
                                children: [
                                  // panel background (fills the container)
                                  Positioned.fill(
                                    child: CachedNetworkImage(
                                      imageUrl: InLiftScreen.panelBack,
                                      fit: BoxFit.contain,
                                    ),
                                  ),

                                  // Button 3 (top)
                                  Positioned(
                                    left: (containerW - bigBtnSize) / 2,
                                    top:
                                        containerH * topBtn3Frac -
                                        (bigBtnSize / 2),
                                    width: bigBtnSize,
                                    height: bigBtnSize,
                                    child: _panelButton(InLiftScreen.btn3, () {
                                      debugPrint("Pressed 3");
                                    }),
                                  ),

                                  // Button 2 (middle)
                                  Positioned(
                                    left: (containerW - bigBtnSize) / 2,
                                    top:
                                        containerH * topBtn2Frac -
                                        (bigBtnSize / 2),
                                    width: bigBtnSize,
                                    height: bigBtnSize,
                                    child: _panelButton(InLiftScreen.btn2, () {
                                      debugPrint("Pressed 2");
                                    }),
                                  ),

                                  // Button 1 (lower)
                                  Positioned(
                                    left: (containerW - bigBtnSize) / 2,
                                    top:
                                        containerH * topBtn1Frac -
                                        (bigBtnSize / 2),
                                    width: bigBtnSize,
                                    height: bigBtnSize,
                                    child: _panelButton(InLiftScreen.btn1, () {
                                      debugPrint("Pressed 1");
                                    }),
                                  ),

                                  // Bottom row: E and Arrow
                                  Positioned(
                                    top:
                                        containerH * bottomRowFrac -
                                        (smallBtnSize / 2),
                                    left: 0,
                                    right: 0,
                                    height: smallBtnSize,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          width: smallBtnSize,
                                          height: smallBtnSize,
                                          child: _panelButton(
                                            InLiftScreen.btnE,
                                            () {
                                              debugPrint("Pressed E");
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: smallBtnSize,
                                          height: smallBtnSize,
                                          child: _panelButton(
                                            InLiftScreen.btnArrow,
                                            () {
                                              debugPrint("Pressed Arrow");
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static Widget _panelButton(String imageUrl, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
        placeholder: (_, __) => const SizedBox.shrink(),
        errorWidget: (_, __, ___) => const SizedBox.shrink(),
      ),
    );
  }
}
