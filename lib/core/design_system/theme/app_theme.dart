import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_typography.dart';
import 'fastshop_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    ).copyWith(
      primary: AppColors.primary500,
      onPrimary: AppColors.neutral0,
      primaryContainer: AppColors.primary100,
      onPrimaryContainer: AppColors.primary800,
      secondary: AppColors.secondary500,
      onSecondary: AppColors.neutral0,
      secondaryContainer: AppColors.secondary100,
      onSecondaryContainer: AppColors.secondary800,
      surface: AppColors.neutral0,
      onSurface: AppColors.neutral900,
      onSurfaceVariant: AppColors.neutral600,
      surfaceContainerHighest: AppColors.neutral100,
      outline: AppColors.neutral300,
      outlineVariant: AppColors.neutral200,
      error: AppColors.error,
      onError: AppColors.neutral0,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
    );

    final textTheme = AppTypography.textTheme();

    OutlineInputBorder inputBorder(Color color, [double width = 1]) {
      return OutlineInputBorder(
        borderRadius: AppRadius.mdAll,
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.neutral50,
      textTheme: textTheme,
      extensions: const [FastShopColors.light],
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.neutral0,
        foregroundColor: AppColors.neutral900,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: textTheme.titleMedium,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.neutral200,
        space: 1,
        thickness: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.neutral0,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: inputBorder(AppColors.neutral200),
        enabledBorder: inputBorder(AppColors.neutral200),
        focusedBorder: inputBorder(AppColors.primary500, 1.5),
        errorBorder: inputBorder(AppColors.error),
        focusedErrorBorder: inputBorder(AppColors.error, 1.5),
        hintStyle: textTheme.bodyMedium?.copyWith(color: AppColors.neutral500),
        labelStyle:
            textTheme.bodyMedium?.copyWith(color: AppColors.neutral600),
        errorStyle: textTheme.bodySmall?.copyWith(color: AppColors.error),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          foregroundColor: AppColors.primary500,
          side: const BorderSide(color: AppColors.primary500),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary500,
          textStyle: textTheme.labelLarge,
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.neutral0,
        selectedColor: AppColors.primary50,
        side: const BorderSide(color: AppColors.neutral200),
        shape: const StadiumBorder(),
        labelStyle: textTheme.labelMedium,
        showCheckmark: false,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.neutral0,
        indicatorColor: AppColors.primary50,
        elevation: 0,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return textTheme.labelSmall?.copyWith(
            color: selected ? AppColors.primary500 : AppColors.neutral500,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 24,
            color: selected ? AppColors.primary500 : AppColors.neutral500,
          );
        }),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.neutral900,
        contentTextStyle:
            textTheme.bodyMedium?.copyWith(color: AppColors.neutral0),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      ),
    );
  }
}
