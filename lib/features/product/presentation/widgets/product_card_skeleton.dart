import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import 'skeleton_box.dart';

/// Placeholder berbentuk [ProductCard] saat daftar produk sedang dimuat.
///
/// Hanya menampilkan blok netral tanpa teks/ikon agar perhatian pengguna
/// tidak teralih dari indikator pemuatan.
class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: AspectRatio(
                aspectRatio: 1,
                child: SkeletonBox(borderRadius: AppRadius.mdAll),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(height: 10, widthFactor: 0.35),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonBox(height: 12),
                  SizedBox(height: AppSpacing.xs),
                  SkeletonBox(height: 12, widthFactor: 0.7),
                  SizedBox(height: AppSpacing.sm),
                  SkeletonBox(height: 16, widthFactor: 0.5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
