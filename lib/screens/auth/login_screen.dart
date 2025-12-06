// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hangukverse/screens/home/home_screen.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = "", _password = "";

  Widget safeImage(
    String path, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Colors.black12,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, color: Colors.white70),
      ),
    );
  }

  Future<void> _onLoginPressed() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    await ref.read(authNotifierProvider.notifier).login(_email, _password);

    final state = ref.read(authNotifierProvider);
    if (state.errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, HomeScreen.routeName);
  }

  void _onGooglePressed() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authNotifierProvider).isLoading;
    final mq = MediaQuery.of(context);
    final bottomInset = mq.viewInsets.bottom;

    const fieldBase = Color(0xFFD9D9D9);
    const loginBg = Color(0xFFFFD8B6);
    const loginText = Color(0xFF232C3D);
    const forgotBg = Color(0xFF73FFFD);
    const forgotText = Color(0xFFDFFAFF);
    const googleBg = Color(0xFF232C3D);
    const googleText = Color(0xFFFFD8B6);
    const signupPrompt = Color(0xFF3B6F90);
    const signupTextColor = Color(0xFF223E50);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: safeImage(
              "assets/Login/Hangukverse (6) 1.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.32)),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final maxW = constraints.maxWidth;
                final scale = (maxW / 400).clamp(0.7, 1.8);

                final headerWidth = (maxW * 0.90).clamp(180.0, maxW);
                final footerHeight = (maxW * 0.45).clamp(140.0, 360.0);

                final cardWidth = (maxW * 0.88).clamp(260.0, 760.0);

                final tinyScreen = maxW < 360;
                final fieldHeight =
                    (tinyScreen ? 44 : 52) * scale.clamp(0.8, 1.2);
                final btnHeight =
                    (tinyScreen ? 44 : 52) * scale.clamp(0.8, 1.2);

                final gapSmall = (8 * scale).clamp(6.0, 18.0);
                final gapMedium = (14 * scale).clamp(8.0, 26.0);

                // removed extra +12 bottom padding so footer image sits flush with bottom inset
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: maxW * 0.05),
                        child: safeImage(
                          "assets/Login/Hangukverse (7) 1.png",
                          width: headerWidth,
                        ),
                      ),

                      Center(
                        child: Column(
                          children: [
                            Container(
                              width: cardWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    "assets/Login/cute korean patten background blue purple theme with red 1.png",
                                  ),
                                  fit: BoxFit.cover,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.26),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: cardWidth * 0.06,
                                    vertical: 16,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(height: gapSmall),

                                        Text(
                                          "Email",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: (15 * scale).clamp(
                                              11,
                                              20,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: gapSmall / 1.2),

                                        SizedBox(
                                          height: fieldHeight,
                                          child: TextFormField(
                                            key: const Key('email_field'),
                                            style: const TextStyle(
                                              color: loginText,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: fieldBase.withOpacity(
                                                0.22,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (v) =>
                                                (v != null && v.contains('@'))
                                                ? null
                                                : 'Invalid email',
                                            onSaved: (v) => _email = v!.trim(),
                                          ),
                                        ),

                                        SizedBox(height: gapMedium),

                                        Text(
                                          "Password",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: (15 * scale).clamp(
                                              11,
                                              20,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(height: gapSmall / 1.2),

                                        SizedBox(
                                          height: fieldHeight,
                                          child: TextFormField(
                                            key: const Key('password_field'),
                                            obscureText: true,
                                            style: const TextStyle(
                                              color: loginText,
                                            ),
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: fieldBase.withOpacity(
                                                0.22,
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 10,
                                                  ),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                borderSide: BorderSide.none,
                                              ),
                                            ),
                                            validator: (v) =>
                                                (v != null && v.length >= 6)
                                                ? null
                                                : 'Min 6 chars',
                                            onSaved: (v) =>
                                                _password = v!.trim(),
                                          ),
                                        ),

                                        SizedBox(height: gapMedium),

                                        SizedBox(
                                          height: btnHeight,
                                          width: double.infinity,
                                          child: ElevatedButton(
                                            onPressed: isLoading
                                                ? null
                                                : _onLoginPressed,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: loginBg,
                                              foregroundColor: loginText,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: isLoading
                                                ? const SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Colors.white,
                                                        ),
                                                  )
                                                : Text(
                                                    "Log In",
                                                    style: TextStyle(
                                                      color: loginText,
                                                      fontSize: (15 * scale)
                                                          .clamp(13, 18),
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                          ),
                                        ),

                                        SizedBox(height: gapSmall),

                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: forgotBg.withOpacity(0.28),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: InkWell(
                                              onTap: () => Navigator.pushNamed(
                                                context,
                                                ForgotPasswordScreen.routeName,
                                              ),
                                              child: Text(
                                                "Forgot Password?",
                                                style: TextStyle(
                                                  color: forgotText,
                                                  fontSize: (12 * scale).clamp(
                                                    10,
                                                    14,
                                                  ),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: gapSmall),

                                        Row(
                                          children: [
                                            const Expanded(
                                              child: Divider(
                                                color: Colors.white,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                              child: Text(
                                                "OR",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900,
                                                  fontFamily: 'Kalnia',
                                                  fontSize: (14 * scale).clamp(
                                                    12,
                                                    18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            const Expanded(
                                              child: Divider(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: gapSmall),

                                        SizedBox(
                                          height: btnHeight,
                                          child: ElevatedButton(
                                            onPressed: _onGooglePressed,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: googleBg,
                                              foregroundColor: googleText,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.g_mobiledata,
                                                  color: googleText,
                                                ),
                                                const SizedBox(width: 8),
                                                Text(
                                                  "Continue with Google",
                                                  style: TextStyle(
                                                    color: googleText,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: gapSmall),

                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color.fromRGBO(
                                                255,
                                                245,
                                                160,
                                                0.64,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Don't have an account? ",
                                                  style: TextStyle(
                                                    color: signupPrompt,
                                                    fontSize: (13 * scale)
                                                        .clamp(11, 16),
                                                  ),
                                                ),
                                                GestureDetector(
                                                  onTap: () =>
                                                      Navigator.pushNamed(
                                                        context,
                                                        RegisterScreen
                                                            .routeName,
                                                      ),
                                                  child: Text(
                                                    "Sign Up",
                                                    style: TextStyle(
                                                      color: signupTextColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: (13 * scale)
                                                          .clamp(11, 16),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: gapMedium),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: maxW * 0.05,
                              ),
                              child: safeImage(
                                "assets/Login/Hangukverse (5) 2.png",
                                height: footerHeight,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
