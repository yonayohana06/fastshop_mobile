import 'package:flutter/material.dart';

import '../theme/fastshop_colors.dart';
import '../tokens/app_colors.dart';
import '../tokens/app_radius.dart';

/// Stepper jumlah kompak (keranjang). Tombol nonaktif di batas [min]/[max].
class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.min = 1,
    this.max = 99,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: AppRadius.smAll,
        border: Border.all(color: context.appColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            semanticLabel: 'Kurangi jumlah',
            onTap: value > min ? () => onChanged(value - 1) : null,
          ),
          SizedBox(
            width: 28,
            child: Center(
              child: Text(
                '$value',
                style: Theme.of(context).textTheme.labelLarge,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add,
            semanticLabel: 'Tambah jumlah',
            onTap: value < max ? () => onChanged(value + 1) : null,
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.semanticLabel,
    required this.onTap,
  });

  final IconData icon;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      enabled: onTap != null,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.smAll,
        child: SizedBox(
          width: 32,
          height: 32,
          child: Icon(
            icon,
            size: 16,
            color: onTap != null ? AppColors.neutral800 : AppColors.neutral300,
          ),
        ),
      ),
    );
  }
}
