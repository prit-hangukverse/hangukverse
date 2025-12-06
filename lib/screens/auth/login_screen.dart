// lib/screens/auth/login_screen.dart

import 'package:cached_network_image/cached_network_image.dart';
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
  bool _obscure = true;

  static const String _s3Base =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com';

  static const List<String> _s3Images = [
    'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/login/cute+korean+patten+background+blue+purple+theme+with+red+1.png',
    'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/login/Hangukverse+(5)+2.png',
    'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/login/Hangukverse+(6)+1.png',
    'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/login/Hangukverse+(7)+1.png',
    'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/login/Hangukverse+(7)+2.png',
    'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/login/Hangukverse+(7)+3.png',
    'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/login/Hangukverse+(7)+4.png',
    'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/login/Hangukverse+(7)+5.png',
  ];

  String _useS3Url(String input) {
    if (input.trim().isEmpty) return '';
    if (input.startsWith(_s3Base)) return input;
    if (input.startsWith('http://') || input.startsWith('https://'))
      return input;
    return '';
  }

  Widget _s3ImageWidget(
    String src, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
  }) {
    final url = _useS3Url(src);
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, __) =>
          Container(width: width, height: height, color: Colors.grey.shade200),
      errorWidget: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.broken_image, color: Colors.black26),
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
    final mq = MediaQuery.of(context);
    final maxW = mq.size.width;
    final maxH = mq.size.height;
    final bottomInset = mq.viewInsets.bottom;
    final scale = (maxW / 400).clamp(0.7, 1.2);

    const fieldBase = Color(0xFFD9D9D9);
    const loginBg = Color(0xFFFFD8B6);
    const loginText = Color(0xFF232C3D);
    const forgotBg = Color(0xFF73FFFD);
    const forgotText = Color(0xFFDFFAFF);
    const googleBg = Color(0xFF232C3D);
    const googleText = Color(0xFFFFD8B6);
    const signupPrompt = Color(0xFF3B6F90);
    const signupTextColor = Color(0xFF223E50);

    final fullBackground = _s3Images[2];
    final headerImg = _s3Images[3];
    final cardBg = _s3Images[0];
    final footerImg = _s3Images[1];

    final headerWidth = (maxW * 0.90).clamp(180.0, 760.0);
    final cardWidth = (maxW * 0.88).clamp(260.0, 760.0);
    final footerHeight = (maxW * 0.45).clamp(140.0, 360.0);

    final fieldHeight = (52 * scale).clamp(44.0, 58.0);
    final btnHeight = (52 * scale).clamp(44.0, 58.0);
    final gapSmall = (8 * scale).clamp(6.0, 18.0);
    final gapMedium = (14 * scale).clamp(8.0, 24.0);

    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Full height background
          SizedBox(
            height: maxH,
            width: maxW,
            child: _s3ImageWidget(fullBackground, fit: BoxFit.cover),
          ),

          // Overlay
          Container(color: Colors.black.withOpacity(0.32)),

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.only(bottom: bottomInset + 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: maxH),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // HEADER (big)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: maxW * 0.05),
                      child: SizedBox(
                        width: headerWidth,
                        child: _s3ImageWidget(
                          headerImg,
                          fit: BoxFit.contain,
                          height: headerWidth * 0.45,
                        ),
                      ),
                    ),

                    // CARD
                    Container(
                      width: cardWidth,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
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
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: _s3ImageWidget(cardBg, fit: BoxFit.cover),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: cardWidth * 0.06,
                                vertical: 16,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(height: gapSmall),

                                    // Email label
                                    Text(
                                      "Email",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (15 * scale).clamp(11, 20),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: gapSmall / 1.2),

                                    // Email field
                                    SizedBox(
                                      height: fieldHeight,
                                      child: TextFormField(
                                        key: const Key('email_field'),
                                        initialValue: _email,
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
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

                                    // Password label
                                    Text(
                                      "Password",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: (15 * scale).clamp(11, 20),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: gapSmall / 1.2),

                                    // Password field
                                    SizedBox(
                                      height: fieldHeight,
                                      child: TextFormField(
                                        key: const Key('password_field'),
                                        obscureText: _obscure,
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
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            borderSide: BorderSide.none,
                                          ),
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              _obscure
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.black38,
                                            ),
                                            onPressed: () => setState(
                                              () => _obscure = !_obscure,
                                            ),
                                          ),
                                        ),
                                        validator: (v) =>
                                            (v != null && v.length >= 6)
                                            ? null
                                            : 'Min 6 chars',
                                        onSaved: (v) => _password = v!.trim(),
                                      ),
                                    ),

                                    SizedBox(height: gapMedium),

                                    // Login button
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
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
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
                                      ),
                                    ),

                                    SizedBox(height: gapSmall),

                                    // Forgot password
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: forgotBg.withOpacity(0.28),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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

                                    // OR divider
                                    Row(
                                      children: [
                                        const Expanded(
                                          child: Divider(color: Colors.white),
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            "OR",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontFamily: 'Kalnia',
                                            ),
                                          ),
                                        ),
                                        const Expanded(
                                          child: Divider(color: Colors.white),
                                        ),
                                      ],
                                    ),

                                    SizedBox(height: gapSmall),

                                    // Google button
                                    // Replace the current Google button widget with this:
                                    SizedBox(
                                      height: btnHeight,
                                      child: ElevatedButton(
                                        onPressed: _onGooglePressed,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: googleBg,
                                          foregroundColor: googleText,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "Continue with Google",
                                            style: TextStyle(
                                              color: googleText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(height: 20),

                                    // Sign up prompt
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "Don't have an account? ",
                                              style: TextStyle(
                                                color: signupPrompt,
                                                fontSize: (13 * scale).clamp(
                                                  11,
                                                  16,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => Navigator.pushNamed(
                                                context,
                                                RegisterScreen.routeName,
                                              ),
                                              child: Text(
                                                "Sign Up",
                                                style: TextStyle(
                                                  color: signupTextColor,
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: (13 * scale).clamp(
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
                          ],
                        ),
                      ),
                    ),

                    // Footer image
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: maxW * 0.05),
                      child: SizedBox(
                        height: footerHeight,
                        child: _s3ImageWidget(footerImg, fit: BoxFit.contain),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
