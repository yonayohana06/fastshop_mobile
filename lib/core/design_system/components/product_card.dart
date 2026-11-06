import 'package:flutter/material.dart';

import '../theme/fastshop_colors.dart';
import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';
import 'app_badge.dart';
import 'app_card.dart';
import 'price_text.dart';
import 'rating_label.dart';

/// Kartu produk untuk grid beranda/pencarian: gambar, badge diskon,
/// tombol favorit (opsional), kategori, nama, harga (+ coret), dan rating.
///
/// Semua elemen selain [name] dan [price] opsional, jadi kartu menyesuaikan
/// data yang tersedia dari backend (mis. belum ada diskon/rating).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    this.imageUrl,
    this.subtitle,
    this.originalPrice,
    this.discountPercent,
    this.rating,
    this.caption,
    this.soldOut = false,
    this.isFavorite = false,
    this.onFavoriteTap,
    this.onTap,
  });

  final String name;
  final num price;
  final String? imageUrl;

  /// Teks kecil di atas nama, mis. nama kategori.
  final String? subtitle;
  final num? originalPrice;
  final int? discountPercent;
  final double? rating;

  /// Teks di samping rating, mis. "4.8k ulasan · 6.2k terjual".
  final String? caption;

  /// Stok habis: gambar diberi lapisan dan label "Habis".
  final bool soldOut;
  final bool isFavorite;

  /// Tombol favorit hanya tampil jika callback ini diberikan.
  final VoidCallback? onFavoriteTap;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final percent = discountPercent;
    final productRating = rating;
    final category = subtitle;

    return AppCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: AppRadius.mdAll,
                    child: ColoredBox(
                      color: colors.surfaceMuted,
                      child: imageUrl == null
                          ? const _ImagePlaceholder()
                          : Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              // Gambar dari backend berukuran besar; decode
                              // lebih kecil agar hemat memori di grid.
                              cacheWidth: 400,
                              errorBuilder: (context, error, stackTrace) =>
                                  const _ImagePlaceholder(),
                            ),
                    ),
                  ),
                  if (soldOut)
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: AppRadius.mdAll,
                        child: ColoredBox(
                          color: const Color(0x99FFFFFF),
                          child: const Center(
                            child: StatusChip(
                              label: 'Habis',
                              tone: StatusTone.neutral,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (percent != null)
                    Positioned(
                      top: AppSpacing.sm,
                      left: AppSpacing.sm,
                      child: DiscountBadge(percent: percent),
                    ),
                  if (onFavoriteTap != null)
                    Positioned(
                      top: AppSpacing.xs,
                      right: AppSpacing.xs,
                      child: IconButton(
                        tooltip: isFavorite
                            ? 'Hapus dari favorit'
                            : 'Tambah ke favorit',
                        iconSize: 20,
                        visualDensity: VisualDensity.compact,
                        onPressed: onFavoriteTap,
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite
                              ? colors.discount
                              : colors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              0,
              AppSpacing.md,
              AppSpacing.md,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (category != null) ...[
                  Text(
                    category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                ],
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                PriceText(price: price, originalPrice: originalPrice),
                if (productRating != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  RatingLabel(rating: productRating, caption: caption),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(
        Icons.image_outlined,
        size: 32,
        color: context.appColors.textHint,
      ),
    );
  }
}
