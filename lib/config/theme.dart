import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Design-token color palette.
/// Every color used in the app should reference this class — never hardcode hex.
class AppColors {
  AppColors._();

  // Backgrounds / surfaces
  static const Color background = Color(0xFF0D1117);
  static const Color surface    = Color(0xFF161B22);
  static const Color border     = Color(0xFF30363D);

  // Brand
  static const Color blue     = Color(0xFF1F6FEB); // primary actions, active dots
  static const Color linkBlue = Color(0xFF2F81F7); // secondary accents, pulse dots

  // Text
  static const Color whiteText = Color(0xFFE6EDF3); // headings, body
  static const Color grayText  = Color(0xFF8B949E); // subtext, skip, captions

  // Error / danger — used only for inline form validation, never elsewhere
  static const Color danger = Color(0xFFF85149);

  // Semantic aliases kept for compatibility with existing widgets
  static const Color primary   = blue;
  static const Color secondary = linkBlue;
  static const Color error     = danger;
}

/// App-wide theme.  TeamScribe is dark-only.
class AppTheme {
  AppTheme._();

  static TextTheme _textTheme() => GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme,
      ).apply(
        bodyColor:    AppColors.whiteText,
        displayColor: AppColors.whiteText,
      );

  static ThemeData get dark => ThemeData(
        useMaterial3:             true,
        brightness:               Brightness.dark,
        scaffoldBackgroundColor:  AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary:          AppColors.blue,
          secondary:        AppColors.linkBlue,
          surface:          AppColors.surface,
          onPrimary:        AppColors.whiteText,
          onSecondary:      AppColors.whiteText,
          onSurface:        AppColors.whiteText,
          error:            AppColors.error,
        ),
        textTheme: _textTheme(),
        // Default FilledButton style so every screen gets the right shape/size.
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: AppColors.whiteText,
            minimumSize:     const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: GoogleFonts.inter(
              fontSize:   16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        // Dividers / borders
        dividerColor: AppColors.border,
      );

  /// Retained so no existing import breaks — maps to [dark].
  static ThemeData get light => dark;
}
