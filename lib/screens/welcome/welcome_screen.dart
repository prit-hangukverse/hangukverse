// lib/screens/welcome/welcome_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hangukverse/screens/auth/login_screen.dart';
import 'package:hangukverse/screens/home/home_screen.dart';
import 'package:hangukverse/screens/lift/lift_sreen.dart'; // <- added import
import '../../providers/auth_provider.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;

  /// When true, the Rectangle + Glamping images are hidden and the "Explore"
  /// UI is shown (we reuse the same flag name for familiarity).
  bool showExploreButton = false;

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

  late final AnimationController _animController;
  late final Animation<double> _doorCurve;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    _doorCurve = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOutCubic,
    );

    _animController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        // optional slight pause to settle visuals
        await Future.delayed(const Duration(milliseconds: 120));
        if (!mounted) return;

        setState(() {
          isLoading = false;
          showExploreButton = false;
        });

        // AFTER animation: check actual Supabase user presence using notifier
        final supaUserPresent =
            ref.read(authNotifierProvider.notifier).currentUser != null;

        if (supaUserPresent) {
          // navigator -> replace with LiftScreen using a custom animated route
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const LiftScreen(),
              transitionDuration: const Duration(milliseconds: 550),
              reverseTransitionDuration: const Duration(milliseconds: 400),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                    final fade = Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeInOut,
                      ),
                    );
                    final slide =
                        Tween<Offset>(
                          begin: const Offset(0.0, 0.18), // slide up slightly
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          ),
                        );

                    return FadeTransition(
                      opacity: fade,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
            ),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  /// Start door animation and show loading overlay until completion.
  Future<void> _startAnimation() async {
    if (_animController.isAnimating) return;
    setState(() {
      isLoading = true;
    });
    await _animController.forward();
  }

  /// Handle tap on either Rectangle or Glamping.
  ///
  /// - If unauthenticated: push LoginScreen (typed route). After successful login,
  ///   show snackbar telling user to tap again (do NOT auto-start animation).
  /// - If authenticated: hide images and start animation immediately.
  Future<void> _handleCenterTapSource(String source) async {
    // debug log which child was tapped
    print('Tapped: $source');

    final supaUserPresent =
        ref.read(authNotifierProvider.notifier).currentUser != null;

    if (!supaUserPresent) {
      // push login as a typed route so we safely receive a bool? result
      final bool? loginResult = await Navigator.of(context).push<bool?>(
        MaterialPageRoute<bool?>(builder: (_) => const LoginScreen()),
      );

      print('LoginScreen returned: $loginResult');

      if (loginResult == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful — tap again to enter'),
            ),
          );
        }
      }
      return;
    }

    // Authenticated: hide images and start animation together
    setState(() {
      showExploreButton = true; // hides Rectangle + Glamping UI
    });

    // tiny delay to ensure UI paints the hide; keeps hide+animation visually simultaneous
    await Future.delayed(const Duration(milliseconds: 8));

    await _startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    final maxW = MediaQuery.of(context).size.width;

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

    final double leftMaxTranslate = -(leftWidth * 1.1);
    final double rightMaxTranslate = (rightWidth * 1.1);

    // reactive auth read for UI
    final authState = ref.watch(authNotifierProvider);
    final isAuthReactive = authState.userEmail != null;
    final isAuthImmediate =
        ref.read(authNotifierProvider.notifier).currentUser != null;
    final isAuth = isAuthReactive || isAuthImmediate;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.black,
          extendBodyBehindAppBar: true,
          body: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              // background image
              Positioned.fill(
                child: Image.network(backgroundUrl, fit: BoxFit.cover),
              ),

              // top asset + subtract1 (fades while doors open)
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
                      child: AnimatedBuilder(
                        animation: _doorCurve,
                        builder: (context, child) {
                          final raw = 1.0 - (_doorCurve.value * 1.2);
                          final opacity = raw.clamp(0.0, 1.0);
                          return Opacity(opacity: opacity, child: child);
                        },
                        child: Image.network(
                          subtract1Url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // doors + center interactive layer
              Positioned.fill(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated doors
                    Transform.translate(
                      offset: doorOffset,
                      child: AnimatedBuilder(
                        animation: _doorCurve,
                        builder: (context, child) {
                          final t = _doorCurve.value;
                          final leftTranslateX = leftMaxTranslate * t;
                          final rightTranslateX = rightMaxTranslate * t;

                          return Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // LEFT
                              Transform.translate(
                                offset: Offset(
                                  effectiveLeftOffset.dx + leftTranslateX,
                                  effectiveLeftOffset.dy,
                                ),
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

                              // RIGHT
                              Transform.translate(
                                offset: Offset(
                                  effectiveRightOffset.dx + rightTranslateX,
                                  effectiveRightOffset.dy,
                                ),
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
                          );
                        },
                      ),
                    ),

                    // CENTER: Rectangle + Glamping (either shown or hidden depending on showExploreButton)
                    Transform.translate(
                      offset: centerRectOffset,
                      child: SizedBox(
                        width: rectWidth,
                        height: rectHeight,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Rectangle (hidden when showExploreButton == true)
                            if (!showExploreButton)
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  print('🟦 Tapped on Rectangle');
                                  await _handleCenterTapSource('Rectangle');
                                },
                                child: Image.network(
                                  centerRectUrl,
                                  fit: BoxFit.contain,
                                  width: rectWidth,
                                  height: rectHeight,
                                ),
                              ),

                            // Glamping image (on top). Hidden when showExploreButton == true
                            if (!showExploreButton)
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () async {
                                  print('🟩 Tapped on Glamping');
                                  await _handleCenterTapSource('Glamping');
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

                            // If images are hidden and user is auth: show a temporary button (animation already started)
                            if (showExploreButton && isAuth)
                              ElevatedButton(
                                onPressed: () async {
                                  print("⭐ Let's Explore (manual) pressed");
                                  // Keep experience consistent: start door animation which will navigate when complete.
                                  await _startAnimation();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 10.0,
                                  ),
                                  child: Text("Let's Explore"),
                                ),
                              ),

                            // Edge-case: if showExploreButton true but user lost session, show login prompt
                            if (showExploreButton && !isAuth)
                              ElevatedButton(
                                onPressed: () async {
                                  final bool? res = await Navigator.of(context)
                                      .push<bool?>(
                                        MaterialPageRoute<bool?>(
                                          builder: (_) => const LoginScreen(),
                                        ),
                                      );
                                  if (res == true && mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Login successful — tap Explore to continue',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 10.0,
                                  ),
                                  child: Text("Login to Explore"),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Loading overlay while animation runs
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
