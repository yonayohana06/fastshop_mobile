import 'package:flutter/material.dart';

import '../theme/fastshop_colors.dart';
import '../tokens/app_spacing.dart';

/// Bintang + nilai, mis. "★ 4.8  4.8k ulasan · 6.2k terjual".
class RatingLabel extends StatelessWidget {
  const RatingLabel({super.key, required this.rating, this.caption});

  final double rating;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: 14, color: colors.rating),
        const SizedBox(width: 2),
        Text(rating.toStringAsFixed(1), style: textTheme.labelMedium),
        if (caption != null) ...[
          const SizedBox(width: AppSpacing.xs),
          Flexible(
            child: Text(
              caption!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ],
    );
  }
}
