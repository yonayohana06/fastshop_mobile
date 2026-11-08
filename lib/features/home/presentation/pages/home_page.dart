import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../../../product/presentation/bloc/category_list/category_list_bloc.dart';
import '../../../product/presentation/bloc/product_list/product_list_bloc.dart';
import '../../../product/presentation/widgets/category_icon_list.dart';
import '../../../product/presentation/widgets/product_grid_sliver.dart';
import '../../../product/presentation/widgets/product_list_scroll_trigger.dart';
import '../widgets/home_header.dart';
import '../widgets/promo_banner_carousel.dart';

/// Tab Beranda. Dapat dilihat tanpa login. Urutan (atas ke bawah):
/// header + pencarian (sticky) → banner promo → kategori → produk.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<ProductListBloc>()..add(const ProductListStarted()),
        ),
        BlocProvider(
          create: (_) =>
              sl<CategoryListBloc>()..add(const CategoryListStarted()),
        ),
      ],
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Pengguna menekan "cari" di keyboard → buka halaman hasil pencarian.
  Future<void> _onSearchSubmitted(String value) async {
    final query = value.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    await context.push<void>(AppRoutes.searchPath(query));

    // Kembali dari halaman hasil: kosongkan kolom supaya Beranda tidak
    // terlihat seolah sedang difilter.
    if (mounted) _searchController.clear();
  }

  Future<void> _onRefresh() async {
    final bloc = context.read<ProductListBloc>()
      ..add(const ProductListRefreshed());
    // Tunggu sampai pemuatan selesai agar indikator refresh menutup tepat waktu.
    await bloc.stream.firstWhere(
      (state) => state.status != ProductListStatus.loading,
      orElse: () => bloc.state,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductListBloc, ProductListState>(
      // Gagal memuat ulang saat daftar sudah terisi: cukup beri tahu.
      listenWhen: (previous, current) =>
          previous.status != current.status &&
          current.status == ProductListStatus.failure &&
          current.products.isNotEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Gagal memuat produk'),
            ),
          );
      },
      child: Scaffold(
        body: ProductListScrollTrigger(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                HomeHeaderSliver(
                  searchController: _searchController,
                  onSearchSubmitted: _onSearchSubmitted,
                ),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: AppSpacing.lg),
                    child: PromoBannerCarousel(),
                  ),
                ),
                const SliverToBoxAdapter(child: _SectionTitle('Kategori')),
                const SliverToBoxAdapter(child: CategoryIconList()),
                const SliverToBoxAdapter(child: _SectionTitle('Produk Pilihan')),
                const ProductGridSliver(),
                const ProductListFooterSliver(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
