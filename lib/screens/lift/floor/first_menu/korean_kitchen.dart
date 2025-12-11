import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hangukverse/screens/lift/floor/first_menu/recipe.dart'; // <-- ADD THIS

class KoreanKitchenScreen extends StatelessWidget {
  static const routeName = '/korean_kitchen';
  const KoreanKitchenScreen({super.key});

  static const String bgImage =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/korean_kitchen.jpg';

  static const String discussionRoomImage =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/components/discussion_room.png';

  static const String recipeImage =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/components/Recipe.png';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final discussionLeft = size.width * 0.01;
    final discussionTop = size.height * 0.40;
    final discussionWidth = size.width * 0.33;

    final recipeLeft = size.width * 0.32;
    final recipeTop = size.height * 0.43;
    final recipeWidth = size.width * 0.33;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Full-screen background
          SizedBox.expand(
            child: CachedNetworkImage(
              imageUrl: bgImage,
              fit: BoxFit.cover,
              placeholder: (_, __) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
              errorWidget: (_, __, ___) => const SizedBox.shrink(),
            ),
          ),

          // Discussion sign (no navigation)
          Positioned(
            left: discussionLeft,
            top: discussionTop,
            child: GestureDetector(
              onTap: () {
                debugPrint('Discussion tapped');
              },
              child: SizedBox(
                width: discussionWidth,
                child: CachedNetworkImage(
                  imageUrl: discussionRoomImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Recipe sign → NAVIGATION ADDED
          Positioned(
            left: recipeLeft,
            top: recipeTop,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecipeScreen()),
                );
              },
              child: SizedBox(
                width: recipeWidth,
                child: CachedNetworkImage(
                  imageUrl: recipeImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
