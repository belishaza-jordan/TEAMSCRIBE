import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import 'onboarding_slide.dart';

/// Shown once on first launch, immediately after the splash screen.
/// Four swipeable slides; persists [_kOnboardingKey] to SharedPreferences
/// so the user never sees it again.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const String _kOnboardingKey = 'has_seen_onboarding';

  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Slide content — icon, heading, subtext
  static const List<OnboardingSlideData> _slides = [
    OnboardingSlideData(
      icon:    Icons.group_outlined,
      heading: 'Create your group in seconds.',
      subtext: 'Invite classmates and split the work without endless group chats.',
    ),
    OnboardingSlideData(
      icon:    Icons.checklist_outlined,
      heading: "Know who's actually working.",
      subtext: 'See real-time progress on every section, not just promises.',
    ),
    OnboardingSlideData(
      icon:    Icons.chat_bubble_outline,
      heading: 'Talk it through, right inside the group.',
      subtext: 'Coordinate, share files, and stay on the same page.',
    ),
    OnboardingSlideData(
      icon:    Icons.description_outlined,
      heading: "Merge everyone's work into one document.",
      subtext: 'Combine all sections automatically and export when you\'re ready.',
    ),
  ];

  /// Marks onboarding as seen and pushes the Login screen.
  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingKey, true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  /// Advance to the next slide, or finish on the last slide.
  void _onNextPressed() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve:    Curves.easeInOut,
      );
    } else {
      _finish();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _slides.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar: skip link (hidden on last slide) ──────────────
            SizedBox(
              height: 48,
              child: Align(
                alignment: Alignment.centerRight,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity:  isLastPage ? 0 : 1,
                  child: TextButton(
                    onPressed: isLastPage ? null : _finish,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color:      AppColors.grayText,
                        fontSize:   14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Slide content ──────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller:    _pageController,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemCount:     _slides.length,
                itemBuilder:   (_, i) => OnboardingSlide(data: _slides[i]),
              ),
            ),

            const SizedBox(height: 32),

            // ── Dot pagination ────────────────────────────────────────
            _DotsIndicator(
              count:   _slides.length,
              current: _currentPage,
            ),

            const SizedBox(height: 32),

            // ── Primary action button ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FilledButton(
                onPressed: _onNextPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.blue,
                  foregroundColor: AppColors.whiteText,
                  minimumSize:     const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  isLastPage ? 'Get started' : 'Next',
                  style: const TextStyle(
                    fontSize:   16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

/// Animated dot row: active dot is a wide pill, inactive dots are circles.
class _DotsIndicator extends StatelessWidget {
  final int count;
  final int current;

  const _DotsIndicator({required this.count, required this.current});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 280),
          curve:    Curves.easeInOut,
          margin:   const EdgeInsets.symmetric(horizontal: 4),
          width:    isActive ? 24 : 8,
          height:   8,
          decoration: BoxDecoration(
            color:        isActive ? AppColors.blue : AppColors.border,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
