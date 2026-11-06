import 'package:flutter/material.dart';

import '../theme/fastshop_colors.dart';
import '../tokens/app_radius.dart';

/// Kolom pencarian berbentuk pil seperti di beranda.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.hint = 'Cari produk',
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final border = OutlineInputBorder(
      borderRadius: AppRadius.pill,
      borderSide: BorderSide(color: colors.border),
    );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search),
        border: border,
        enabledBorder: border,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
      ),
    );
  }
}
