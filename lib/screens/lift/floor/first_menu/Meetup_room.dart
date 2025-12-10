import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MeetupRoomScreen extends StatelessWidget {
  static const routeName = '/meetup_room';
  const MeetupRoomScreen({super.key});

  static const String imageUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/Meetup_room.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          fit: BoxFit.contain,
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
