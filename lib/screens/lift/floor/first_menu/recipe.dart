import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  static const String imageUrl =
      'https://hangukversewebassets.s3.ap-south-1.amazonaws.com/assets/first_flor/doors/components/recipe/Recipe_01.png';

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final PageController _pageController = PageController();
  // number of pages (you asked: 10 times with same image)
  static const int _pageCount = 10;

  // prevent multiple vertical swipes from triggering while animating
  bool _isAnimating = false;

  // threshold for vertical swipe velocity (pixels/sec)
  static const double _velocityThreshold = 300.0;

  // optional: show small page indicator
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goToPage(int page) async {
    if (_isAnimating) return;
    if (page < 0 || page >= _pageCount) return;

    _isAnimating = true;
    try {
      await _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentPage = page);
    } finally {
      // small delay to avoid double triggers
      await Future.delayed(const Duration(milliseconds: 50));
      _isAnimating = false;
    }
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    // negative dy velocity means swipe up
    final vy = details.velocity.pixelsPerSecond.dy;
    if (vy < -_velocityThreshold) {
      // swipe up -> next page
      final next = (_currentPage + 1).clamp(0, _pageCount - 1);
      if (next != _currentPage) _goToPage(next);
    } else if (vy > _velocityThreshold) {
      // swipe down -> previous page
      final prev = (_currentPage - 1).clamp(0, _pageCount - 1);
      if (prev != _currentPage) _goToPage(prev);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // Wrap with GestureDetector to detect vertical swipes and translate them to horizontal page changes.
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onVerticalDragEnd: _onVerticalDragEnd,
        child: Stack(
          children: [
            // Horizontal pages (swipe horizontally)
            PageView.builder(
              controller: _pageController,
              itemCount: _pageCount,
              onPageChanged: (index) {
                setState(() => _currentPage = index);
              },
              itemBuilder: (context, index) {
                return SizedBox.expand(
                  child: CachedNetworkImage(
                    imageUrl: RecipeScreen.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                    errorWidget: (_, __, ___) => const Center(
                      child: Text(
                        "Failed to load image",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Simple page indicator (top-right)
            Positioned(
              right: 12,
              top: 40,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.45),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentPage + 1} / $_pageCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
