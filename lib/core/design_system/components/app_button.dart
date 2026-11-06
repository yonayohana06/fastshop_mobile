import 'package:flutter/material.dart';

import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

enum AppButtonVariant { primary, secondary, outline, text }

enum AppButtonSize { medium, small }

/// Tombol standar FastShop.
///
/// - `primary`: aksi utama (Beli Sekarang, Checkout, Masuk).
/// - `secondary`: aksi sekunder yang tetap menonjol (memakai secondary600
///   supaya kontras teks putih memenuhi AA).
/// - `outline`: aksi pendukung (Lihat Detail, Ulas Produk).
/// - `text`: aksi ringan (link).
///
/// [onPressed] null = disabled. [isLoading] menampilkan spinner dan
/// mengabaikan tap tanpa mengubah tampilan jadi abu-abu.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;

  /// `true`: selebar parent. `false`: selebar konten.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final VoidCallback? effectiveOnPressed =
        onPressed == null ? null : (isLoading ? () {} : onPressed);

    final height = size == AppButtonSize.medium ? 48.0 : 36.0;
    final minimumSize = Size(expanded ? double.infinity : 0, height);

    switch (variant) {
      case AppButtonVariant.primary:
        return FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(minimumSize: minimumSize),
          child: _content(AppColors.neutral0),
        );
      case AppButtonVariant.secondary:
        return FilledButton(
          onPressed: effectiveOnPressed,
          style: FilledButton.styleFrom(
            minimumSize: minimumSize,
            backgroundColor: AppColors.secondary600,
            foregroundColor: AppColors.neutral0,
          ),
          child: _content(AppColors.neutral0),
        );
      case AppButtonVariant.outline:
        return OutlinedButton(
          onPressed: effectiveOnPressed,
          style: OutlinedButton.styleFrom(minimumSize: minimumSize),
          child: _content(AppColors.primary500),
        );
      case AppButtonVariant.text:
        return TextButton(
          onPressed: effectiveOnPressed,
          style: TextButton.styleFrom(minimumSize: Size(0, height)),
          child: _content(AppColors.primary500),
        );
    }
  }

  Widget _content(Color loaderColor) {
    if (isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2, color: loaderColor),
      );
    }
    if (icon == null) return Text(label);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: AppSpacing.sm),
        Text(label),
      ],
    );
  }
}
