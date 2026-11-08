import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/widgets/auth_required.dart';
import '../../domain/entities/product_detail.dart';
import '../bloc/product_detail/product_detail_bloc.dart';

/// Detail produk: gambar, harga, nama, kategori, stok, dan deskripsi,
/// dengan bar aksi (Keranjang / Beli Sekarang) di bawah.
class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<ProductDetailBloc>()..add(ProductDetailRequested(productId)),
      child: _ProductDetailView(productId: productId),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  const _ProductDetailView({required this.productId});

  final String productId;

  void _back(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _back(context),
        ),
        title: const Text('Detail Produk'),
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (context, state) {
          switch (state.status) {
            case ProductDetailStatus.initial:
            case ProductDetailStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ProductDetailStatus.failure:
              return EmptyState(
                icon: Icons.cloud_off_outlined,
                title: 'Gagal memuat produk',
                message: state.errorMessage,
                actionLabel: 'Coba lagi',
                onAction: () => context
                    .read<ProductDetailBloc>()
                    .add(ProductDetailRequested(productId)),
              );
            case ProductDetailStatus.success:
              return _DetailContent(product: state.product!);
          }
        },
      ),
    );
  }
}

class _DetailContent extends StatelessWidget {
  const _DetailContent({required this.product});

  final ProductDetail product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final category = product.categoryName;
    final description = product.description?.trim();

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductImage(url: product.imageUrl),
                const SizedBox(height: AppSpacing.lg),
                PriceText(price: product.price, large: true),
                const SizedBox(height: AppSpacing.sm),
                Text(product.name, style: textTheme.titleLarge),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    if (category != null) StatusChip(label: category),
                    StatusChip(
                      label: product.isOutOfStock
                          ? 'Stok habis'
                          : 'Stok ${product.stock}',
                      tone: product.isOutOfStock
                          ? StatusTone.error
                          : StatusTone.success,
                    ),
                  ],
                ),
                if (description != null && description.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  AppCard(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Deskripsi', style: textTheme.titleSmall),
                        const SizedBox(height: AppSpacing.sm),
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            description,
                            style: textTheme.bodyMedium?.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        _ActionBar(product: product),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final imageUrl = url;

    Widget placeholder() => Center(
          child: Icon(
            Icons.image_outlined,
            size: 48,
            color: colors.textHint,
          ),
        );

    return ClipRRect(
      borderRadius: AppRadius.xlAll,
      child: AspectRatio(
        aspectRatio: 1.1,
        child: ColoredBox(
          color: colors.surfaceMuted,
          child: imageUrl == null
              ? placeholder()
              : Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) =>
                      progress == null
                          ? child
                          : const Center(child: CircularProgressIndicator()),
                  errorBuilder: (context, error, stackTrace) => placeholder(),
                ),
        ),
      ),
    );
  }
}

/// Bar aksi di dasar halaman. Tamu yang menekan tombolnya diarahkan login
/// dulu, lalu kembali ke halaman ini.
class _ActionBar extends StatelessWidget {
  const _ActionBar({required this.product});

  final ProductDetail product;

  void _onAction(BuildContext context) {
    context.requireLogin(() {
      // TODO(cart): panggil `POST /cart` (Keranjang) / lanjut checkout
      // (Beli Sekarang) setelah fitur keranjang dibuat.
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Fitur keranjang segera hadir')),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    final available = !product.isOutOfStock;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(top: BorderSide(color: context.appColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: AppButton(
                  label: 'Keranjang',
                  icon: Icons.add_shopping_cart,
                  variant: AppButtonVariant.outline,
                  onPressed: available ? () => _onAction(context) : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppButton(
                  label: available ? 'Beli Sekarang' : 'Stok Habis',
                  onPressed: available ? () => _onAction(context) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
