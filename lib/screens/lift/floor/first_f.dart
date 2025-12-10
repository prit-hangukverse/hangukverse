import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirstFloorScreen extends StatelessWidget {
  const FirstFloorScreen({super.key});

  static const String corridorImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/corridor.jpg";

  static const String componentImage =
      "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/Component.png";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /// --------------------------------------------------------
          /// BACKGROUND: corridor (never cropped, responsive)
          /// --------------------------------------------------------
          SizedBox(
            width: size.width,
            height: size.height,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: CachedNetworkImage(
                  imageUrl: corridorImage,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => const Center(
                    child: Text(
                      "Failed to load corridor image",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  cacheKey: "first_floor_corridor",
                ),
              ),
            ),
          ),

          /// --------------------------------------------------------
          /// CENTERED COMPONENT PNG (responsive)
          /// --------------------------------------------------------
          Positioned(
            // ------------------------------
            // MOVE CONTROLS
            // ------------------------------
            left: size.width * 0.25, // move horizontally
            top: size.height * 0.50, // move vertically
            // ------------------------------
            // RESIZE CONTROL
            // ------------------------------
            child: CachedNetworkImage(
              imageUrl: componentImage,
              width: size.width * 0.70, // resize here
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (context, url, error) => const Center(
                child: Text(
                  "Failed to load component",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              cacheKey: "first_floor_component",
            ),
          ),
        ],
      ),
    );
  }
}
