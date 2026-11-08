import 'package:flutter/material.dart';

import '../theme/fastshop_colors.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';
import 'app_button.dart';

/// Tampilan kosong/error (keranjang kosong, hasil tidak ditemukan,
/// koneksi putus, perlu login) dengan satu atau dua aksi opsional.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Aksi kedua yang lebih ringan (tombol teks), mis. "Belum punya akun? Daftar".
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final description = message;
    final label = actionLabel;
    final secondaryLabel = secondaryActionLabel;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primary50,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: AppColors.primary500),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium,
            ),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
            ],
            if (label != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(
                label: label,
                onPressed: onAction,
                expanded: false,
                size: AppButtonSize.small,
              ),
            ],
            if (secondaryLabel != null && onSecondaryAction != null) ...[
              const SizedBox(height: AppSpacing.xs),
              AppButton(
                label: secondaryLabel,
                onPressed: onSecondaryAction,
                variant: AppButtonVariant.text,
                expanded: false,
                size: AppButtonSize.small,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
