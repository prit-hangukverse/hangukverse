// lib/screens/auth/login_screen.dart

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
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

  // Your CloudFront base URL
  static const String _cdnBase = 'https://d1q95ty809c5zc.cloudfront.net';

  // Known S3 base (we will replace this with the CloudFront base when a full S3 URL is provided)
  static const String _s3Base =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com';

  /// Convert an input (either an asset path like "assets/Login/xxx.png"
  /// or a full S3 URL) into the CloudFront URL.
  ///
  /// Behavior:
  /// - If [input] starts with "http" and contains the known S3 base,
  ///   it replaces the S3 base with the CloudFront base and returns that.
  /// - If [input] starts with "http" but is not the known S3 base, it returns [input] unchanged.
  /// - Otherwise it treats [input] as a local asset path and converts
  ///   "assets/Login/..." to "assets/login/..." and percent-encodes path segments,
  ///   then returns CloudFront base + encoded path.
  String _cdnUrlFor(String input) {
    if (input.trim().isEmpty) return '';

    // If it's a full URL
    if (input.startsWith('http://') || input.startsWith('https://')) {
      // If it's the known S3 URL, replace base with cloudfront
      if (input.startsWith(_s3Base)) {
        // Keep remainder of path exactly as-is (preserve '+' or other encodings)
        return input.replaceFirst(_s3Base, _cdnBase);
      }
      // Not the known S3 base — return as-is (we assume it's already a CDN or valid URL)
      return input;
    }

    // Otherwise, treat as asset path and convert to cloudfront URL.
    var p = input.replaceAll('\\', '/');

    // Normalize folder name — if you used assets/Login locally, convert to lowercase assets/login
    p = p.replaceFirst('assets/Login/', 'assets/login/');
    p = p.replaceFirst('assets/Login', 'assets/login');
    if (p.startsWith('/')) p = p.substring(1);

    // Encode each segment but keep slashes
    final segments = p.split('/');
    final encoded = segments.map((s) => Uri.encodeComponent(s)).join('/');

    return '$_cdnBase/$encoded';
  }

  // Generic "safe" image loader: try network (cached), fallback to local asset
  Widget safeImage(
    String assetPath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
  }) {
    final url = _cdnUrlFor(assetPath);

    return CachedNetworkImage(
      imageUrl: url,
      // When CachedNetworkImage provides an ImageProvider we show it with Image widget
      imageBuilder: (context, imageProvider) {
        return Image(
          image: imageProvider,
          width: width,
          height: height,
          fit: fit,
          gaplessPlayback: true,
        );
      },
      // While loading, show the bundled asset (fast) as placeholder
      placeholder: (context, url) {
        return Image.asset(
          assetPath,
          width: width,
          height: height,
          fit: fit,
          gaplessPlayback: true,
        );
      },
      // If network fails, fall back to the bundled asset (and if that fails show broken icon)
      errorWidget: (context, url, error) {
        return Image.asset(
          assetPath,
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
      },
      fit: fit,
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
          // Full-screen background image from CDN with asset fallback
          Positioned.fill(
            child: safeImage(
              // this will be converted to CloudFront URL by _cdnUrlFor
              "assets/Login/Hangukverse (6) 1.png",
              fit: BoxFit.cover,
            ),
          ),

          // Semi transparent overlay
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
                          fit: BoxFit.contain,
                        ),
                      ),

                      Center(
                        child: Column(
                          children: [
                            // Card with CDN background (using a Stack so we can use CachedNetworkImage)
                            SizedBox(
                              width: cardWidth,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Stack(
                                  children: [
                                    // Background image from CDN (fills the card)
                                    Positioned.fill(
                                      child: CachedNetworkImage(
                                        imageUrl: _cdnUrlFor(
                                          // this asset path will be mapped to cloudfront
                                          "assets/Login/cute korean patten background blue purple theme with red 1.png",
                                        ),
                                        fit: BoxFit.cover,
                                        placeholder: (ctx, url) => Image.asset(
                                          "assets/Login/cute korean patten background blue purple theme with red 1.png",
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (ctx, url, err) => Image.asset(
                                          "assets/Login/cute korean patten background blue purple theme with red 1.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),

                                    // Semi transparent container + form content
                                    Container(
                                      decoration: BoxDecoration(
                                        // keep a little overlay so text is readable
                                        color: Colors.black.withOpacity(0.05),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(
                                              0.26,
                                            ),
                                            blurRadius: 12,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
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
                                                    fillColor: fieldBase
                                                        .withOpacity(0.22),
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 10,
                                                        ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  validator: (v) =>
                                                      (v != null &&
                                                          v.contains('@'))
                                                      ? null
                                                      : 'Invalid email',
                                                  onSaved: (v) =>
                                                      _email = v!.trim(),
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
                                                  key: const Key(
                                                    'password_field',
                                                  ),
                                                  obscureText: true,
                                                  style: const TextStyle(
                                                    color: loginText,
                                                  ),
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: fieldBase
                                                        .withOpacity(0.22),
                                                    contentPadding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 10,
                                                        ),
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                      borderSide:
                                                          BorderSide.none,
                                                    ),
                                                  ),
                                                  validator: (v) =>
                                                      (v != null &&
                                                          v.length >= 6)
                                                      ? null
                                                      : 'Min 6 chars',
                                                  onSaved: (v) =>
                                                      _password = v!.trim(),
                                                ),
                                              ),

                                              SizedBox(height: gapMedium),

                                              SizedBox(
                                                height: fieldHeight,
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
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                    padding: EdgeInsets.zero,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          horizontal: 12,
                                                          vertical: 10,
                                                        ),
                                                    child: Center(
                                                      child: isLoading
                                                          ? const SizedBox(
                                                              width: 20,
                                                              height: 20,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                    strokeWidth:
                                                                        2,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                            )
                                                          : Text(
                                                              "Log In",
                                                              style: TextStyle(
                                                                color:
                                                                    loginText,
                                                                fontSize:
                                                                    (15 * scale)
                                                                        .clamp(
                                                                          13,
                                                                          18,
                                                                        ),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: gapSmall),

                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 8,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: forgotBg.withOpacity(
                                                      0.28,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: InkWell(
                                                    onTap: () =>
                                                        Navigator.pushNamed(
                                                          context,
                                                          ForgotPasswordScreen
                                                              .routeName,
                                                        ),
                                                    child: Text(
                                                      "Forgot Password?",
                                                      style: TextStyle(
                                                        color: forgotText,
                                                        fontSize: (12 * scale)
                                                            .clamp(10, 14),
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontFamily: 'Kalnia',
                                                        fontSize: (14 * scale)
                                                            .clamp(12, 18),
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
                                                          BorderRadius.circular(
                                                            12,
                                                          ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(height: gapSmall),

                                              Center(
                                                child: Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
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
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
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
                                                            color:
                                                                signupTextColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize:
                                                                (13 * scale)
                                                                    .clamp(
                                                                      11,
                                                                      16,
                                                                    ),
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
                                  ],
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
                                fit: BoxFit.contain,
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
