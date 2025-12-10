import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class KdramaDiscussionScreen extends StatelessWidget {
  static const routeName = '/kdrama_discussion';
  const KdramaDiscussionScreen({super.key});

  static const String imageUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/kdrama_discussion.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,

          /// ⭐ The key setting
          fit: BoxFit.contain, // Image fully visible → never cropped

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
