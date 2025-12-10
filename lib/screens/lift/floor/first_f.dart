import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirstFloorScreen extends StatefulWidget {
  static const routeName = "/first-floor";

  const FirstFloorScreen({super.key});

  static const String corridorImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/corridor.jpg";

  static const String liftAppImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/liftapp.png";

  // tappable image
  static const String commuImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/commu.png";

  // zoom-in target image
  static const String firstFloorFullImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/1st_floor.png";

  @override
  State<FirstFloorScreen> createState() => _FirstFloorScreenState();
}

class _FirstFloorScreenState extends State<FirstFloorScreen>
    with TickerProviderStateMixin {
  // ----------------------------
  // ARRIVAL ANIMATION (slide up)
  // ----------------------------
  late final AnimationController _arrivalController;
  late final Animation<double> _arrivalAnim;

  // ----------------------------
  // ZOOM-IN ANIMATION (commu tap)
  // ----------------------------
  late final AnimationController _zoomController;
  late final Animation<double> _zoomScaleAnim;
  late final Animation<double> _zoomOpacityAnim;

  bool _showZoomOverlay = false;

  @override
  void initState() {
    super.initState();

    // ARRIVAL FROM LIFT
    _arrivalController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _arrivalAnim = CurvedAnimation(
      parent: _arrivalController,
      curve: Curves.easeInOut,
    );

    // start arrival animation
    _arrivalController.forward();

    // ZOOM-IN ON TAP
    _zoomController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _zoomScaleAnim = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _zoomController, curve: Curves.easeOutCubic),
    );

    _zoomOpacityAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _zoomController, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _arrivalController.dispose();
    _zoomController.dispose();
    super.dispose();
  }

  void _onCommuTap() {
    setState(() => _showZoomOverlay = true);
    _zoomController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    final baseScreen = Stack(
      fit: StackFit.expand,
      children: [
        // corridor
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: FirstFloorScreen.corridorImage,
            fit: BoxFit.cover,
          ),
        ),

        // lift interior overlay
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: FirstFloorScreen.liftAppImage,
            fit: BoxFit.cover,
          ),
        ),

        // commu button
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.55,
            child: GestureDetector(
              onTap: _onCommuTap,
              child: CachedNetworkImage(
                imageUrl: FirstFloorScreen.commuImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: _arrivalAnim,
        builder: (context, child) {
          final dy = (1 - _arrivalAnim.value) * screenH;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ARRIVAL SLIDE-UP SCREEN
              Transform.translate(offset: Offset(0, dy), child: child),

              // ZOOM-IN OVERLAY (on top)
              if (_showZoomOverlay)
                AnimatedBuilder(
                  animation: _zoomController,
                  builder: (context, _) {
                    return Opacity(
                      opacity: _zoomOpacityAnim.value,
                      child: Transform.scale(
                        scale: _zoomScaleAnim.value,
                        alignment: Alignment.center,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              color: Colors.black.withOpacity(
                                0.55 * _zoomOpacityAnim.value,
                              ),
                            ),
                            CachedNetworkImage(
                              imageUrl: FirstFloorScreen.firstFloorFullImage,
                              fit: BoxFit.cover,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          );
        },
        child: baseScreen,
      ),
    );
  }
}
