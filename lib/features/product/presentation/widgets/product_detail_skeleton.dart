import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import 'skeleton_box.dart';

/// Placeholder halaman detail produk saat data sedang dimuat.
///
/// Susunannya mengikuti konten asli: gambar, harga, nama, chip kategori/stok,
/// kartu deskripsi, dan bar aksi di bawah agar layout tidak meloncat saat
/// data selesai dimuat.
class ProductDetailSkeleton extends StatelessWidget {
  const ProductDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.1,
                  child: SkeletonBox(borderRadius: AppRadius.xlAll),
                ),
                SizedBox(height: AppSpacing.lg),
                SkeletonBox(height: 28, widthFactor: 0.45),
                SizedBox(height: AppSpacing.sm),
                SkeletonBox(height: 20),
                SizedBox(height: AppSpacing.xs),
                SkeletonBox(height: 20, widthFactor: 0.72),
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    SkeletonBox(
                      height: 28,
                      width: 72,
                      borderRadius: AppRadius.pill,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    SkeletonBox(
                      height: 28,
                      width: 88,
                      borderRadius: AppRadius.pill,
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
                AppCard(
                  padding: EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonBox(height: 16, width: 80),
                      SizedBox(height: AppSpacing.sm),
                      SkeletonBox(height: 14),
                      SizedBox(height: AppSpacing.xs),
                      SkeletonBox(height: 14),
                      SizedBox(height: AppSpacing.xs),
                      SkeletonBox(height: 14, widthFactor: 0.6),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _ActionBarSkeleton(),
      ],
    );
  }
}

/// Placeholder dua tombol aksi tetap di dasar halaman.
class _ActionBarSkeleton extends StatelessWidget {
  const _ActionBarSkeleton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: context.appColors.border)),
      ),
      child: const SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: SkeletonBox(height: 48, borderRadius: AppRadius.mdAll),
              ),
              SizedBox(width: AppSpacing.md),
              Expanded(
                child: SkeletonBox(height: 48, borderRadius: AppRadius.mdAll),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
