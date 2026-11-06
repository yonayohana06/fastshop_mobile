import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/di/injection.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../product/presentation/bloc/category_list/category_list_bloc.dart';
import '../../../product/presentation/bloc/product_list/product_list_bloc.dart';
import '../../../product/presentation/widgets/category_chip_list.dart';
import '../../../product/presentation/widgets/product_grid_sliver.dart';

/// Tab Beranda: sapaan, pencarian, filter kategori, dan kumpulan produk.
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
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Infinite scroll: minta halaman berikutnya saat mendekati dasar daftar.
  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final bloc = context.read<ProductListBloc>();
    // Setelah gagal, halaman berikutnya hanya dimuat lewat tombol "coba lagi"
    // supaya scroll di dasar daftar tidak memicu permintaan berulang.
    if (bloc.state.hasReachedMax || bloc.state.loadMoreFailed) return;

    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 400) {
      bloc.add(const ProductListNextPageRequested());
    }
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
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final fullName = context.select<AuthBloc, String?>(
      (bloc) => bloc.state.user?.name,
    );
    final firstName = fullName?.trim().split(' ').first;

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
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _onRefresh,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          firstName == null || firstName.isEmpty
                              ? 'Halo!'
                              : 'Halo, $firstName',
                          style: textTheme.headlineSmall,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Mau belanja apa hari ini?',
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppSearchField(
                          controller: _searchController,
                          onChanged: (query) => context
                              .read<ProductListBloc>()
                              .add(ProductListSearchChanged(query)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: CategoryChipList()),
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.lg),
                ),
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
