import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeScreen extends StatelessWidget {
  const RecipeScreen({super.key});

  static const String imageUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/components/recipe/Recipe_01.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.cover,   // responsive full screen
          placeholder: (_, __) =>
              const Center(child: CircularProgressIndicator(color: Colors.white)),
          errorWidget: (_, __, ___) => const Center(
            child: Text("Failed to load image", style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}
