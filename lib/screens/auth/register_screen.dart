// lib/screens/auth/register_screen.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '', _email = '', _password = '', _confirm = '';
  bool _agree = false;

  // S3 images (same list used in LoginScreen)
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

  Future<void> _onRegisterPressed() async {
    if (!_formKey.currentState!.validate()) return;

    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept Terms & Conditions')),
      );
      return;
    }

    _formKey.currentState!.save();

    await ref
        .read(authNotifierProvider.notifier)
        .register(_name, _email, _password);

    final state = ref.read(authNotifierProvider);
    if (state.errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      return;
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  void _onGooglePressed() async {
    await ref.read(authNotifierProvider.notifier).signInWithGoogle();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottomInset = mq.viewInsets.bottom;
    final maxW = mq.size.width;
    final scale = (maxW / 400).clamp(0.7, 1.8);

    // Colors copied from LoginScreen to match look
    const fieldBase = Color(0xFFD9D9D9);
    const loginBg = Color(0xFFFFD8B6);
    const loginText = Color(0xFF232C3D);
    const googleBg = Color(0xFF232C3D);
    const googleText = Color(0xFFFFD8B6);
    const signupPrompt = Color(0xFF3B6F90);
    const signupTextColor = Color(0xFF223E50);

    // choose images (same ordering as login)
    final fullBackground = _s3Images.length > 2 ? _s3Images[2] : _s3Images[0];
    final headerImg = _s3Images.length > 3 ? _s3Images[3] : _s3Images[1];
    final cardBg = _s3Images[0];
    final footerImg = _s3Images.length > 1 ? _s3Images[1] : _s3Images[0];

    // responsive sizes (match login)
    final cardWidth = (maxW * 0.88).clamp(260.0, 760.0);
    final headerWidth = (maxW * 0.90).clamp(180.0, maxW);
    final footerHeight = (maxW * 0.45).clamp(140.0, 360.0);

    final tinyScreen = maxW < 360;
    final fieldHeight = (tinyScreen ? 44 : 52) * scale.clamp(0.8, 1.2);
    final btnHeight = (tinyScreen ? 44 : 52) * scale.clamp(0.8, 1.2);

    final gapSmall = (8 * scale).clamp(6.0, 18.0);
    final gapMedium = (14 * scale).clamp(8.0, 26.0);

    final isLoading = ref.watch(authNotifierProvider).isLoading;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: _s3ImageWidget(fullBackground, fit: BoxFit.cover),
          ),
          // dark overlay for readability
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.32)),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // We use a ScrollView so smaller devices can scroll; larger devices will get centered content
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Column(
                    // NOTE: no spacing between header, card and footer — exactly as requested
                    children: [
                      // HEADER IMAGE (no gap)
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

                      // CARD (immediately after header: no SizedBox between)
                      Center(
                        child: Column(
                          children: [
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
                                    // card background image
                                    Positioned.fill(
                                      child: _s3ImageWidget(
                                        cardBg,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    Padding(
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
                                              "Name",
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
                                                key: const Key('name_field'),
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
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                validator: (v) =>
                                                    (v == null ||
                                                        v.trim().isEmpty)
                                                    ? 'Required'
                                                    : null,
                                                onSaved: (v) =>
                                                    _name = v!.trim(),
                                              ),
                                            ),

                                            SizedBox(height: gapMedium),

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
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                keyboardType:
                                                    TextInputType.emailAddress,
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
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                validator: (v) =>
                                                    (v != null && v.length >= 6)
                                                    ? null
                                                    : 'Min 6 chars',
                                                onChanged: (v) => _password = v,
                                              ),
                                            ),

                                            SizedBox(height: gapMedium),

                                            Text(
                                              "Confirm Password",
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
                                                key: const Key('confirm_field'),
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
                                                    borderSide: BorderSide.none,
                                                  ),
                                                ),
                                                validator: (v) => v == _password
                                                    ? null
                                                    : 'Passwords do not match',
                                                onSaved: (v) =>
                                                    _confirm = v!.trim(),
                                              ),
                                            ),

                                            SizedBox(height: gapSmall),

                                            Row(
                                              children: [
                                                Checkbox(
                                                  value: _agree,
                                                  onChanged: (v) => setState(
                                                    () => _agree = v!,
                                                  ),
                                                ),
                                                const Text("I agree to "),
                                                GestureDetector(
                                                  onTap: () {
                                                    // show terms page (you can replace with your real page)
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (_) =>
                                                            const TermsScreen(),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                    "Terms & Conditions",
                                                    style: TextStyle(
                                                      color: Colors.blue,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: gapSmall),

                                            // CREATE ACCOUNT BUTTON (same style as login)
                                            SizedBox(
                                              height: btnHeight,
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                onPressed: isLoading
                                                    ? null
                                                    : _onRegisterPressed,
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
                                                child: Center(
                                                  child: isLoading
                                                      ? const SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                        )
                                                      : Text(
                                                          "Create Account",
                                                          style: TextStyle(
                                                            color: loginText,
                                                            fontSize:
                                                                (15 * scale)
                                                                    .clamp(
                                                                      13,
                                                                      18,
                                                                    ),
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
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                  ),
                                                  child: Text(
                                                    "OR",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w900,
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
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Already have account? prompt — same style as Login
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
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      "Already have an account? ",
                                                      style: TextStyle(
                                                        color: signupPrompt,
                                                        fontSize: (13 * scale)
                                                            .clamp(11, 16),
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      onTap: () =>
                                                          Navigator.pushReplacementNamed(
                                                            context,
                                                            LoginScreen
                                                                .routeName,
                                                          ),
                                                      child: Text(
                                                        "Log In",
                                                        style: TextStyle(
                                                          color:
                                                              signupTextColor,
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
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // FOOTER IMAGE (directly after card; no gap)
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: maxW * 0.05),
                        child: SizedBox(
                          height: footerHeight,
                          width: double.infinity,
                          child: _s3ImageWidget(footerImg, fit: BoxFit.contain),
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

/// A simple Terms screen placeholder — keep or replace with your real terms page.
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "Replace this with your real Terms & Conditions text.",
          style: TextStyle(fontSize: 14),
        ),
      ),
    );
  }
}
