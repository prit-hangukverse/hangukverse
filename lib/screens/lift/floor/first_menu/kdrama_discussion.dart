import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class KdramaDiscussionScreen extends StatelessWidget {
  static const routeName = '/kdrama_discussion';
  const KdramaDiscussionScreen({super.key});

  static const String bgImage =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/kdrama_room.jpg';

  static const String dramasImage =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/components/Dramas.png';

  static const String chatRoomImage =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/components/Chat_room.png';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          /// 🔥 Background full screen
          SizedBox.expand(
            child: CachedNetworkImage(
              imageUrl: bgImage,
              fit: BoxFit.cover,
              placeholder: (_, __) => const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
          ),

          /// 🔥 CHAT ROOM (left)
          Positioned(
            left: size.width * 0.15,
            top: size.height * 0.42,
            child: GestureDetector(
              onTap: () {
                print("Chat tapped");
              },
              child: SizedBox(
                width: size.width * 0.28,
                child: CachedNetworkImage(
                  imageUrl: chatRoomImage,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          /// 🔥 DRAMAS (right)
          Positioned(
            right: size.width * 0.12,
            top: size.height * 0.35,
            child: GestureDetector(
              onTap: () {
                print("Dramas tapped");
              },
              child: SizedBox(
                width: size.width * 0.32,
                child: CachedNetworkImage(
                  imageUrl: dramasImage,
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
