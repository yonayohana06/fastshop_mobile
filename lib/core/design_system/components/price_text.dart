import 'package:flutter/material.dart';

import '../../utils/currency.dart';
import '../theme/fastshop_colors.dart';
import '../tokens/app_spacing.dart';

/// Harga dalam Rupiah. Jika [originalPrice] lebih besar dari [price],
/// harga asli ditampilkan dicoret di sebelahnya.
class PriceText extends StatelessWidget {
  const PriceText({
    super.key,
    required this.price,
    this.originalPrice,
    this.large = false,
  });

  final num price;
  final num? originalPrice;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final original = originalPrice;

    return Wrap(
      spacing: AppSpacing.sm - 2,
      crossAxisAlignment: WrapCrossAlignment.end,
      children: [
        Text(
          formatRupiah(price),
          style: (large ? textTheme.headlineSmall : textTheme.titleMedium)
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        if (original != null && original > price)
          Text(
            formatRupiah(original),
            style: textTheme.bodySmall?.copyWith(
              color: colors.textHint,
              decoration: TextDecoration.lineThrough,
            ),
          ),
      ],
    );
  }
}
