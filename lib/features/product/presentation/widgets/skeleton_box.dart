import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';

/// Blok netral untuk placeholder saat data sedang dimuat.
///
/// [widthFactor] dipakai agar blok dapat mengikuti lebar induk (mis. baris
/// teks yang lebih pendek), sedangkan [width] dipakai untuk ukuran tetap.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.widthFactor = 1,
    this.borderRadius = AppRadius.smAll,
  });

  final double? width;
  final double? height;
  final double widthFactor;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final box = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.appColors.surfaceMuted,
        borderRadius: borderRadius,
      ),
    );

    if (width != null || widthFactor == 1) return box;

    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: box,
    );
  }
}
