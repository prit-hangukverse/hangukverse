import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../welcome/welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/splash';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();

    _controller =
        VideoPlayerController.networkUrl(
            Uri.parse(
              "https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/splash/hangukverse.mp4",
            ),
          )
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          });

    _controller.addListener(() {
      final isFinished =
          _controller.value.position >= _controller.value.duration &&
          _controller.value.isInitialized;

      if (isFinished) {
        Navigator.pushReplacementNamed(context, WelcomeScreen.routeName);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // ✅ Full screen black background
      body: Container(
        color: Colors.black, // ✅ Ensures video background is black (not white)
        child: _controller.value.isInitialized
            ? Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
