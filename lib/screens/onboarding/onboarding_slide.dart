import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Immutable data that describes a single onboarding slide.
class OnboardingSlideData {
  final IconData icon;
  final String   heading;
  final String   subtext;

  const OnboardingSlideData({
    required this.icon,
    required this.heading,
    required this.subtext,
  });
}

/// Renders one onboarding slide from [OnboardingSlideData].
/// Kept as a separate widget so [OnboardingScreen] stays clean and
/// each slide can later swap the icon for a real illustration asset
/// without touching the screen logic.
class OnboardingSlide extends StatelessWidget {
  final OnboardingSlideData data;

  const OnboardingSlide({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration placeholder — swap with Image.asset() later.
          Container(
            width:  160,
            height: 160,
            decoration: BoxDecoration(
              color:        AppColors.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              data.icon,
              size:  72,
              color: AppColors.blue,
            ),
          ),

          const SizedBox(height: 40),

          // Heading
          Text(
            data.heading,
            style: const TextStyle(
              color:      AppColors.whiteText,
              fontSize:   22,
              fontWeight: FontWeight.bold,
              height:     1.25,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 14),

          // Subtext — constrained to ~280 px so it never goes full-width.
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 280),
            child: Text(
              data.subtext,
              style: const TextStyle(
                color:    AppColors.grayText,
                fontSize: 14,
                height:   1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
