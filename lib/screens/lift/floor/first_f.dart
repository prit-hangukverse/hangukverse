import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirstFloorScreen extends StatefulWidget {
  const FirstFloorScreen({super.key});

  static const String corridorImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/corridor.jpg";

  static const String liftAppImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/lift/liftapp.png";

  // ✅ ADDED (from your second file)
  static const String commuImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/commu.png";

  @override
  State<FirstFloorScreen> createState() => _FirstFloorScreenState();
}

class _FirstFloorScreenState extends State<FirstFloorScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _screenAnim;

  // ✅ MUST MATCH InLiftScreen liftDuration
  static const Duration liftArriveDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: liftArriveDuration,
    );

    _screenAnim = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // ✅ Start full-screen arrival animation automatically
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    // ✅ Entire screen content as ONE widget (UNCHANGED)
    final fullScreenContent = Stack(
      fit: StackFit.expand,
      children: [
        // ✅ Corridor background
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: FirstFloorScreen.corridorImage,
            fit: BoxFit.cover,
          ),
        ),

        // ✅ Lift interior (UNCHANGED)
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: FirstFloorScreen.liftAppImage,
            fit: BoxFit.cover,
            placeholder: (c, url) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            errorWidget: (c, url, err) => const Center(
              child: Text(
                'Failed to load image',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),

        // ✅ ✅ ✅ ADDED: Center Commu Image with Action (FROM YOUR SECOND CODE)
        Center(
          child: FractionallySizedBox(
            widthFactor: 0.55, // same as your second file
            child: GestureDetector(
              onTap: () {
                debugPrint("Community image tapped");
                // ✅ Add your navigation here later if needed
              },
              child: CachedNetworkImage(
                imageUrl: FirstFloorScreen.commuImage,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(color: Colors.white),
                errorWidget: (context, url, err) => const Text(
                  "Failed to load image",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ),
      ],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _screenAnim,
          builder: (context, child) {
            // ✅ Entire screen slides from bottom → final place (UNCHANGED)
            final dy = (1 - _screenAnim.value) * screenH;
            return Transform.translate(offset: Offset(0, dy), child: child);
          },
          child: fullScreenContent,
        ),
      ),
    );
  }
}
