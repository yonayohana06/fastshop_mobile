import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/design_system.dart';
import '../bloc/product_list/product_list_bloc.dart';

/// Isi daftar produk sebagai sliver: loading, error, kosong, atau grid 2 kolom.
class ProductGridSliver extends StatelessWidget {
  const ProductGridSliver({super.key});

  static const _spacing = AppSpacing.md;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, ProductListState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.products != current.products,
      builder: (context, state) {
        final products = state.products;

        if (products.isEmpty) {
          return switch (state.status) {
            ProductListStatus.initial ||
            ProductListStatus.loading =>
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              ),
            ProductListStatus.failure => SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: Icons.cloud_off_outlined,
                  title: 'Gagal memuat produk',
                  message: state.errorMessage,
                  actionLabel: 'Coba lagi',
                  onAction: () => context
                      .read<ProductListBloc>()
                      .add(const ProductListStarted()),
                ),
              ),
            ProductListStatus.success => const SliverFillRemaining(
                hasScrollBody: false,
                child: EmptyState(
                  icon: Icons.search_off,
                  title: 'Produk tidak ditemukan',
                  message: 'Coba kata kunci atau kategori lain.',
                ),
              ),
          };
        }

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          sliver: SliverLayoutBuilder(
            builder: (context, constraints) {
              // Tinggi sel dihitung dari lebar kartu: kotak gambar persegi
              // + blok teks (kategori, 2 baris nama, harga) yang ikut
              // membesar mengikuti pengaturan ukuran teks perangkat.
              final itemWidth = (constraints.crossAxisExtent - _spacing) / 2;
              final textScale = MediaQuery.textScalerOf(context)
                  .scale(1)
                  .clamp(1.0, 1.6)
                  .toDouble();

              return SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: _spacing,
                  crossAxisSpacing: _spacing,
                  mainAxisExtent: itemWidth + 80 * textScale + 24,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductCard(
                    key: ValueKey(product.id),
                    name: product.name,
                    price: product.price,
                    imageUrl: product.imageUrl,
                    subtitle: product.categoryName,
                    soldOut: product.isOutOfStock,
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

/// Indikator di dasar daftar: loading halaman berikutnya, atau tombol ulang
/// jika memuat halaman berikutnya gagal.
class ProductListFooterSliver extends StatelessWidget {
  const ProductListFooterSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListBloc, ProductListState>(
      buildWhen: (previous, current) =>
          previous.isLoadingMore != current.isLoadingMore ||
          previous.loadMoreFailed != current.loadMoreFailed,
      builder: (context, state) {
        if (state.isLoadingMore) {
          return const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        if (state.loadMoreFailed) {
          return SliverToBoxAdapter(
            child: Center(
              child: AppButton(
                label: 'Gagal memuat, coba lagi',
                variant: AppButtonVariant.text,
                expanded: false,
                onPressed: () => context
                    .read<ProductListBloc>()
                    .add(const ProductListNextPageRequested()),
              ),
            ),
          );
        }

        return const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl));
      },
    );
  }
}
