import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class KoreanKitchenScreen extends StatelessWidget {
  static const routeName = '/korean_kitchen';
  const KoreanKitchenScreen({super.key});

  static const String imageUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/korean_kitchen.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain, // no cropping
          placeholder: (_, __) =>
              const CircularProgressIndicator(color: Colors.white),
          errorWidget: (_, __, ___) => const Text(
            'Failed to load image',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
