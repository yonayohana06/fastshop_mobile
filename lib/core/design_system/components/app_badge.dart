import 'package:flutter/material.dart';

import '../theme/fastshop_colors.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_spacing.dart';

/// Badge diskon merah di pojok gambar produk (mis. "20%").
class DiscountBadge extends StatelessWidget {
  const DiscountBadge({super.key, required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.discount,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm - 2,
          vertical: 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.local_offer_outlined, size: 10, color: colors.onDiscount),
            const SizedBox(width: 2),
            Text(
              '$percent%',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colors.onDiscount,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

enum StatusTone { success, info, warning, error, neutral }

/// Chip status (Delivered, Shipped, Pending, dll). Warna latar muda +
/// teks gelap supaya kontras terbaca.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    this.tone = StatusTone.neutral,
    this.icon,
  });

  final String label;
  final StatusTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final (Color background, Color foreground) = switch (tone) {
      StatusTone.success => (colors.successContainer, colors.onSuccessContainer),
      StatusTone.info => (colors.infoContainer, colors.onInfoContainer),
      StatusTone.warning => (colors.warningContainer, colors.onWarningContainer),
      StatusTone.error => (
          Theme.of(context).colorScheme.errorContainer,
          Theme.of(context).colorScheme.onErrorContainer,
        ),
      StatusTone.neutral => (AppColors.neutral100, AppColors.neutral700),
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 12, color: foreground),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}
