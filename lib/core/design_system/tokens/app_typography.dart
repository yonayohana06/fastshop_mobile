import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Skala tipografi FastShop (font Inter).
///
/// Untuk produksi/offline, bundel font ke assets dan set
/// `GoogleFonts.config.allowRuntimeFetching = false`, atau ganti [_inter]
/// dengan `TextStyle(fontFamily: ...)` jika memakai font sendiri.
abstract final class AppTypography {
  static TextStyle _inter(
    double size,
    FontWeight weight,
    double height,
    Color color,
  ) {
    return GoogleFonts.inter(
      fontSize: size,
      fontWeight: weight,
      height: height,
      color: color,
    );
  }

  static TextTheme textTheme({Color color = AppColors.neutral900}) {
    return TextTheme(
      displayLarge: _inter(40, FontWeight.w700, 1.2, color),
      displayMedium: _inter(34, FontWeight.w700, 1.2, color),
      displaySmall: _inter(28, FontWeight.w700, 1.25, color),
      headlineLarge: _inter(26, FontWeight.w700, 1.25, color),
      headlineMedium: _inter(24, FontWeight.w700, 1.3, color),
      headlineSmall: _inter(20, FontWeight.w700, 1.3, color),
      titleLarge: _inter(18, FontWeight.w600, 1.35, color),
      titleMedium: _inter(16, FontWeight.w600, 1.4, color),
      titleSmall: _inter(14, FontWeight.w600, 1.4, color),
      bodyLarge: _inter(16, FontWeight.w400, 1.5, color),
      bodyMedium: _inter(14, FontWeight.w400, 1.5, color),
      bodySmall: _inter(12, FontWeight.w400, 1.4, color),
      labelLarge: _inter(14, FontWeight.w600, 1.4, color),
      labelMedium: _inter(12, FontWeight.w600, 1.35, color),
      labelSmall: _inter(10, FontWeight.w600, 1.3, color),
    );
  }
}
