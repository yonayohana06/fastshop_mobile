import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../bloc/product_list/product_list_bloc.dart';
import 'product_card_skeleton.dart';

const _gridSpacing = AppSpacing.md;
const _skeletonItemCount = 6;

/// Tinggi sel dihitung dari lebar kartu: kotak gambar persegi + blok teks
/// (kategori, 2 baris nama, harga) yang ikut membesar mengikuti pengaturan
/// ukuran teks perangkat.
double _gridItemExtent(BuildContext context, double crossAxisExtent) {
  final itemWidth = (crossAxisExtent - _gridSpacing) / 2;
  final textScale = MediaQuery.textScalerOf(context)
      .scale(1)
      .clamp(1.0, 1.6)
      .toDouble();

  return itemWidth + 80 * textScale + 24;
}

/// Isi daftar produk sebagai sliver: skeleton saat loading, error, kosong,
/// atau grid 2 kolom.
class ProductGridSliver extends StatelessWidget {
  const ProductGridSliver({super.key});

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
              const _ProductGridSkeletonSliver(),
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
              return SliverGrid.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: _gridSpacing,
                  crossAxisSpacing: _gridSpacing,
                  mainAxisExtent: _gridItemExtent(
                    context,
                    constraints.crossAxisExtent,
                  ),
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
                    onTap: () => context.push(
                      AppRoutes.productDetailPath(product.id),
                    ),
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

/// Grid placeholder saat halaman pertama produk sedang dimuat.
class _ProductGridSkeletonSliver extends StatelessWidget {
  const _ProductGridSkeletonSliver();

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      sliver: SliverLayoutBuilder(
        builder: (context, constraints) {
          return SliverGrid.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: _gridSpacing,
              crossAxisSpacing: _gridSpacing,
              mainAxisExtent: _gridItemExtent(
                context,
                constraints.crossAxisExtent,
              ),
            ),
            itemCount: _skeletonItemCount,
            itemBuilder: (context, index) => const ProductCardSkeleton(),
          );
        },
      ),
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
