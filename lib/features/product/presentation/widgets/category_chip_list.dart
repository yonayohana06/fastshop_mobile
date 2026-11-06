import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/design_system.dart';
import '../../domain/entities/product_category.dart';
import '../bloc/category_list/category_list_bloc.dart';
import '../bloc/product_list/product_list_bloc.dart';

/// Baris chip kategori (dengan "Semua" di awal) yang memfilter daftar produk.
class CategoryChipList extends StatelessWidget {
  const CategoryChipList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = context.select<CategoryListBloc, List<ProductCategory>>(
      (bloc) => bloc.state.categories,
    );
    final selectedId = context.select<ProductListBloc, int?>(
      (bloc) => bloc.state.filter.categoryId,
    );
    final textTheme = Theme.of(context).textTheme;
    final borderColor = context.appColors.border;

    final items = <({int? id, String label})>[
      (id: null, label: 'Semua'),
      for (final category in categories) (id: category.id, label: category.name),
    ];

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: items.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final item = items[index];
          final selected = item.id == selectedId;

          return ChoiceChip(
            label: Text(item.label),
            selected: selected,
            onSelected: (_) => context
                .read<ProductListBloc>()
                .add(ProductListCategorySelected(item.id)),
            side: BorderSide(
              color: selected ? AppColors.primary500 : borderColor,
            ),
            labelStyle: textTheme.labelMedium?.copyWith(
              color: selected ? AppColors.primary700 : AppColors.neutral700,
            ),
          );
        },
      ),
    );
  }
}
