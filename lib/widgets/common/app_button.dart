import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Primary full-width action button used throughout the app.
///
/// When [isLoading] is true the label is replaced with a small spinner
/// and taps are disabled so the user cannot submit twice.
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:  double.infinity,
      height: 50,
      child: FilledButton(
        // Pass null while loading so the button appears disabled
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor:         AppColors.blue,
          // Keep a dim blue while loading rather than the theme's grey
          disabledBackgroundColor: AppColors.blue.withValues(alpha: 0.55),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width:  20,
                height: 20,
                child:  CircularProgressIndicator(
                  color:       AppColors.whiteText,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  color:      AppColors.whiteText,
                  fontSize:   16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
