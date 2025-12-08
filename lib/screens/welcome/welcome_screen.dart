import 'package:flutter/material.dart';
import 'package:hangukverse/screens/auth/login_screen.dart';

class WelcomeScreen extends StatelessWidget {
  static const routeName = '/welcome';
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand, // ✅ forces full screen coverage
        children: [
          /// ✅ 1️⃣ FULL SCREEN BACKGROUND — ALWAYS FILLS, NO GAP
          Positioned.fill(
            child: Image.network(
              'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/home+page+for+phone+bg+1.png',
              fit: BoxFit.cover, // ✅ never leaves space
            ),
          ),

          /// ✅ 2️⃣ TOP IMAGE — RESPONSIVE, NO GAP, NO STRETCH BUGS
          SafeArea(
            top: false, // ✅ allow touching status bar
            bottom: false,
            child: Column(
              children: [
                /// 🔹 TOP IMAGE (responsive without breaking aspect)
                Align(
                  alignment: Alignment.topCenter,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        child: Transform.scale(
                          scale: 1.05, // ✅ tiny boost without overflow
                          child: Image.asset(
                            'assets/welcome/subtract.png',
                            fit: BoxFit.contain, // ✅ responsive & safe
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// ✅ 3️⃣ BOTTOM OVERLAY (Subtract-1) — FILLS REMAINING SPACE
                Expanded(
                  child: Image.network(
                    'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/welcome/Subtract-1.png',
                    fit: BoxFit.cover, // ✅ no gaps on tall devices
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
