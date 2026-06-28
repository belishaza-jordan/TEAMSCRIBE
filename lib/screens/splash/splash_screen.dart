import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/routes.dart';
import '../../config/theme.dart';
import '../../providers/auth_provider.dart';

/// First screen users see on launch — shown for ~1.8 s.
///
/// Behaviour:
///   • Logo + tagline fade in and scale up (ease-out, 700 ms).
///   • Three dots near the bottom pulse in sequence while waiting.
///   • After the delay, checks [_kOnboardingKey] in SharedPreferences:
///       – First launch  → pushes [AppRoutes.onboarding].
///       – Returning user → pushes [AppRoutes.login].
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const String _kOnboardingKey = 'has_seen_onboarding';

  // Fade + scale for the logo / tagline block
  late final AnimationController _logoController;
  late final Animation<double>   _fadeAnim;
  late final Animation<double>   _scaleAnim;

  // Repeating controller driving the three pulsing dots
  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    // ── Logo animation ─────────────────────────────────────────────────
    _logoController = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 700),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );
    _scaleAnim = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    // ── Pulsing dots animation (repeating) ─────────────────────────────
    _dotsController = AnimationController(
      vsync:    this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _logoController.forward();
    _scheduleNavigation();
  }

  /// Waits ~1.8 s then decides which route to push.
  Future<void> _scheduleNavigation() async {
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;

    final prefs   = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool(_kOnboardingKey) ?? false;

    if (!mounted) return;

    if (hasSeen) {
      final auth     = context.read<AuthProvider>();
      final restored = await auth.restoreSession();
      if (!mounted) return;

      String dest = AppRoutes.login;
      if (restored) {
        // Verified → home, unverified → ask them to check email
        dest = auth.isEmailVerified
            ? AppRoutes.home
            : AppRoutes.emailVerification;
      }
      Navigator.pushReplacementNamed(context, dest);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ── Centered logo + tagline ─────────────────────────────────
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: ScaleTransition(
                scale: _scaleAnim,
                child: const _LogoBlock(),
              ),
            ),
          ),

          // ── Pulsing dots at the bottom ──────────────────────────────
          Positioned(
            bottom: 56,
            left:   0,
            right:  0,
            child: FadeTransition(
              opacity: _fadeAnim, // fade in with the logo
              child: _PulsingDots(controller: _dotsController),
            ),
          ),
        ],
      ),
    );
  }
}

/// Static logo block: blue dot  •  "TeamScribe"  +  tagline.
class _LogoBlock extends StatelessWidget {
  const _LogoBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Wordmark row
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Brand dot
            Container(
              width:  9,
              height: 9,
              decoration: const BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'TeamScribe',
              style: TextStyle(
                color:          AppColors.whiteText,
                fontSize:       28,
                fontWeight:     FontWeight.bold,
                letterSpacing:  -0.5,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Tagline
        const Text(
          'Group projects, organized.',
          style: TextStyle(
            color:    AppColors.grayText,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

/// Three dots that pulse left-to-right in sequence using a sine wave.
/// Each dot is offset by 1/3 of the animation period so they fire in order.
class _PulsingDots extends StatelessWidget {
  final AnimationController controller;

  const _PulsingDots({required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (i) {
            // sin() produces -1 → 1; map that to 0.25 → 1.0 opacity
            final phase   = controller.value + i * (1 / 3);
            final opacity = (sin(phase * 2 * pi) * 0.375 + 0.625)
                .clamp(0.0, 1.0);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width:  7,
              height: 7,
              decoration: BoxDecoration(
                color: AppColors.linkBlue.withValues(alpha: opacity),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
