import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';

/// Warna di luar `ColorScheme` Material: semantik (success/warning/info),
/// e-commerce (diskon, rating), dan netral tambahan.
///
/// Akses: `context.appColors.success`.
@immutable
class FastShopColors extends ThemeExtension<FastShopColors> {
  const FastShopColors({
    required this.success,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.info,
    required this.infoContainer,
    required this.onInfoContainer,
    required this.discount,
    required this.onDiscount,
    required this.rating,
    required this.border,
    required this.textSecondary,
    required this.textHint,
    required this.surfaceMuted,
  });

  static const FastShopColors light = FastShopColors(
    success: AppColors.success,
    successContainer: AppColors.successContainer,
    onSuccessContainer: AppColors.onSuccessContainer,
    warning: AppColors.warning,
    warningContainer: AppColors.warningContainer,
    onWarningContainer: AppColors.onWarningContainer,
    info: AppColors.info,
    infoContainer: AppColors.infoContainer,
    onInfoContainer: AppColors.onInfoContainer,
    discount: AppColors.discount,
    onDiscount: AppColors.neutral0,
    rating: AppColors.rating,
    border: AppColors.neutral200,
    textSecondary: AppColors.neutral600,
    textHint: AppColors.neutral500,
    surfaceMuted: AppColors.neutral100,
  );

  final Color success;
  final Color successContainer;
  final Color onSuccessContainer;
  final Color warning;
  final Color warningContainer;
  final Color onWarningContainer;
  final Color info;
  final Color infoContainer;
  final Color onInfoContainer;
  final Color discount;
  final Color onDiscount;
  final Color rating;
  final Color border;
  final Color textSecondary;
  final Color textHint;
  final Color surfaceMuted;

  @override
  FastShopColors copyWith({
    Color? success,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? info,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? discount,
    Color? onDiscount,
    Color? rating,
    Color? border,
    Color? textSecondary,
    Color? textHint,
    Color? surfaceMuted,
  }) {
    return FastShopColors(
      success: success ?? this.success,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      info: info ?? this.info,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      discount: discount ?? this.discount,
      onDiscount: onDiscount ?? this.onDiscount,
      rating: rating ?? this.rating,
      border: border ?? this.border,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
    );
  }

  @override
  FastShopColors lerp(ThemeExtension<FastShopColors>? other, double t) {
    if (other is! FastShopColors) return this;
    return FastShopColors(
      success: Color.lerp(success, other.success, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      warningContainer:
          Color.lerp(warningContainer, other.warningContainer, t)!,
      onWarningContainer:
          Color.lerp(onWarningContainer, other.onWarningContainer, t)!,
      info: Color.lerp(info, other.info, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      discount: Color.lerp(discount, other.discount, t)!,
      onDiscount: Color.lerp(onDiscount, other.onDiscount, t)!,
      rating: Color.lerp(rating, other.rating, t)!,
      border: Color.lerp(border, other.border, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textHint: Color.lerp(textHint, other.textHint, t)!,
      surfaceMuted: Color.lerp(surfaceMuted, other.surfaceMuted, t)!,
    );
  }
}

extension FastShopThemeX on BuildContext {
  FastShopColors get appColors => Theme.of(this).extension<FastShopColors>()!;
}
