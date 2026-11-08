import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/design_system.dart';
import '../../domain/entities/product_category.dart';
import '../bloc/category_list/category_list_bloc.dart';
import '../bloc/product_list/product_list_bloc.dart';

/// Baris kategori bergaya ikon (lingkaran + label), dengan "Semua" di awal.
/// Memilih kategori memfilter daftar produk di Beranda.
class CategoryIconList extends StatelessWidget {
  const CategoryIconList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.select<CategoryListBloc, List<ProductCategory>>(
      (bloc) => bloc.state.categories,
    );
    final selectedId = context.select<ProductListBloc, int?>(
      (bloc) => bloc.state.filter.categoryId,
    );
    // Tinggi ikut membesar mengikuti ukuran teks perangkat (label di bawah ikon).
    final textScale = MediaQuery.textScalerOf(context)
        .scale(1)
        .clamp(1.0, 1.3)
        .toDouble();

    final items = <({int? id, String label, String? iconUrl})>[
      (id: null, label: 'Semua', iconUrl: null),
      for (final category in categories)
        (id: category.id, label: category.name, iconUrl: category.iconUrl),
    ];

    return SizedBox(
      height: 92 * textScale,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = items[index];
          return _CategoryTile(
            label: item.label,
            iconUrl: item.iconUrl,
            isAll: item.id == null,
            selected: item.id == selectedId,
            onTap: () => context
                .read<ProductListBloc>()
                .add(ProductListCategorySelected(item.id)),
          );
        },
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.iconUrl,
    required this.isAll,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String? iconUrl;
  final bool isAll;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final url = iconUrl;

    final fallback = Icon(
      isAll ? Icons.grid_view_rounded : Icons.category_outlined,
      size: 26,
      color: selected ? AppColors.primary600 : AppColors.neutral700,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: 'Kategori $label',
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: SizedBox(
          width: 72,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected ? AppColors.primary50 : colors.surfaceMuted,
                  border: selected
                      ? Border.all(color: AppColors.primary500, width: 1.5)
                      : null,
                ),
                child: Center(
                  child: url == null
                      ? fallback
                      : Image.network(
                          url,
                          width: 28,
                          height: 28,
                          errorBuilder: (context, error, stackTrace) =>
                              fallback,
                        ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs + 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: textTheme.bodySmall?.copyWith(
                  color: selected ? AppColors.primary600 : colors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
