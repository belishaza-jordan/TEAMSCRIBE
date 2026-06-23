import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// Labeled text input used on every form in the app.
///
/// Renders a 12 px gray label above the field, a leading icon, hint text,
/// and the standard dark styling (surface fill, border, 8 px radius).
/// Password fields automatically get a visibility-toggle suffix icon.
/// Validation errors are shown below in [AppColors.danger].
class AppTextField extends StatefulWidget {
  final String label;
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;

  const AppTextField({
    super.key,
    required this.label,
    required this.icon,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.focusNode,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  // Tracks whether the text is currently hidden (only relevant for password fields).
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Label ─────────────────────────────────────────────────────
        Text(
          widget.label,
          style: const TextStyle(
            color:       AppColors.grayText,
            fontSize:    12,
            fontWeight:  FontWeight.w500,
            letterSpacing: 0.2,
          ),
        ),
        const SizedBox(height: 6),

        // ── Input ─────────────────────────────────────────────────────
        TextFormField(
          controller:       widget.controller,
          obscureText:      _obscured,
          keyboardType:     widget.keyboardType,
          textInputAction:  widget.textInputAction,
          focusNode:        widget.focusNode,
          validator:        widget.validator,
          style: const TextStyle(
            color:    AppColors.whiteText,
            fontSize: 15,
          ),
          decoration: InputDecoration(
            hintText:  widget.hintText,
            hintStyle: const TextStyle(
              color:    AppColors.grayText,
              fontSize: 15,
            ),
            prefixIcon: Icon(widget.icon, color: AppColors.grayText, size: 20),

            // Password toggle — only rendered for obscured fields
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscured
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.grayText,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscured = !_obscured),
                  )
                : null,

            filled:      true,
            fillColor:   AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical:   14,
            ),

            // Default / enabled border
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:   const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:   const BorderSide(color: AppColors.border),
            ),

            // Focused border — blue highlight
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:   const BorderSide(
                  color: AppColors.blue, width: 1.5),
            ),

            // Error border — danger red
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:   const BorderSide(color: AppColors.danger),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide:   const BorderSide(
                  color: AppColors.danger, width: 1.5),
            ),

            errorStyle: const TextStyle(
              color:    AppColors.danger,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
