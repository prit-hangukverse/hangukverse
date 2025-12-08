import 'package:flutter/material.dart';
import 'package:hangukverse/screens/auth/login_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isLoading = false;

  // ===========================================================
  // 🔧 SHARED DOOR CONTROL SETTINGS — CHANGE THESE ONLY
  // ===========================================================

  static const double doorWidthFactor = 0.50;
  static const double? doorHeight = null;
  static const double doorScale = 0.84;
  static const Offset doorOffset = Offset(0, 100);

  // Left door
  static const double? leftDoorWidthFactor = null;
  static const double? leftDoorHeight = null;
  static const double? leftDoorScale = 0.77;
  static const Offset? leftDoorOffset = Offset(9, -30);

  // Right door
  static const double? rightDoorWidthFactor = null;
  static const double? rightDoorHeight = null;
  static const double? rightDoorScale = null;
  static const Offset? rightDoorOffset = Offset(-10, -30);

  // Images
  static const String backgroundUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/home+page+for+phone+bg+1.png';

  static const String topAsset = 'assets/welcome/subtract.png';
  static const String subtract1Url =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/Subtract-1.png';

  static const String leftDoorUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/DOOR+L+final+1.png';

  static const String rightDoorUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/DOOR+L+final+2.png';

  static const String centerRectUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/Rectangle.png';

  static const double centerRectWidthFactor = 1.0;
  static const double centerRectHeightFactor = 0.24;
  static const Offset centerRectOffset = Offset(0, 65);

  static const String centerGlampUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/Glamping.png';

  static const double glampScale = 1.10;
  static const Offset glampOffset = Offset(0, 0);

  // ===========================================================
  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;
    final maxH = MediaQuery.of(context).size.height;

    final double effectiveLeftWidthFactor =
        leftDoorWidthFactor ?? doorWidthFactor;
    final double effectiveLeftScale = leftDoorScale ?? doorScale;
    final double? effectiveLeftHeight = leftDoorHeight ?? doorHeight;
    final Offset effectiveLeftOffset = leftDoorOffset ?? Offset.zero;

    final double effectiveRightWidthFactor =
        rightDoorWidthFactor ?? doorWidthFactor;
    final double effectiveRightScale = rightDoorScale ?? doorScale;
    final double? effectiveRightHeight = rightDoorHeight ?? doorHeight;
    final Offset effectiveRightOffset = rightDoorOffset ?? Offset.zero;

    final double leftWidth = (maxW * effectiveLeftWidthFactor).clamp(
      0.0,
      maxW / 2,
    );
    final double rightWidth = (maxW * effectiveRightWidthFactor).clamp(
      0.0,
      maxW / 2,
    );

    final double rectWidth = maxW * centerRectWidthFactor;
    final double rectHeight = maxW * centerRectHeightFactor;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Positioned.fill(
                child: Image.network(backgroundUrl, fit: BoxFit.cover),
              ),

              SafeArea(
                top: false,
                bottom: false,
                child: Column(
                  children: [
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

              Center(
                child: Transform.translate(
                  offset: doorOffset,
                  child: Row(
                    children: [
                      Transform.translate(
                        offset: effectiveLeftOffset,
                        child: SizedBox(
                          width: leftWidth,
                          height: effectiveLeftHeight,
                          child: Transform.scale(
                            scale: effectiveLeftScale,
                            alignment: Alignment.centerRight,
                            child: Image.network(
                              leftDoorUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: effectiveRightOffset,
                        child: SizedBox(
                          width: rightWidth,
                          height: effectiveRightHeight,
                          child: Transform.scale(
                            scale: effectiveRightScale,
                            alignment: Alignment.centerLeft,
                            child: Image.network(
                              rightDoorUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // -------------------------
              // 🌟 GLAMPING CLICK ACTION
              // -------------------------
              Center(
                child: Transform.translate(
                  offset: centerRectOffset,
                  child: SizedBox(
                    width: rectWidth,
                    height: rectHeight,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          centerRectUrl,
                          fit: BoxFit.contain,
                          width: rectWidth,
                          height: rectHeight,
                        ),

                        // ------------------------------
                        // USER CLICKS ON GLAMPING IMAGE
                        // ------------------------------
                        GestureDetector(
                          onTap: () async {
                            setState(() => isLoading = true);

                            await Future.delayed(const Duration(seconds: 2));

                            if (!mounted) return;

                            setState(() => isLoading = false);

                            Navigator.pushNamed(context, LoginScreen.routeName);
                          },
                          child: Transform.translate(
                            offset: glampOffset,
                            child: Transform.scale(
                              scale: glampScale,
                              child: Image.network(
                                centerGlampUrl,
                                fit: BoxFit.contain,
                              ),
                            ),
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

        // ------------------------------
        // LOADING OVERLAY (2 seconds)
        // ------------------------------
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.55),
            child: const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ),
      ],
    );
  }
}
