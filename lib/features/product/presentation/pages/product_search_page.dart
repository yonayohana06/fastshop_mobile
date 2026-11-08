import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/router/app_routes.dart';
import '../bloc/product_list/product_list_bloc.dart';
import '../widgets/product_grid_sliver.dart';
import '../widgets/product_list_scroll_trigger.dart';

/// Halaman khusus hasil pencarian: produk yang cocok dengan kata kunci,
/// dimuat bertahap (infinite scroll, 10 produk per halaman).
///
/// Pencarian baru hanya diproses saat pengguna menekan "cari" di keyboard.
class ProductSearchPage extends StatelessWidget {
  const ProductSearchPage({super.key, required this.initialQuery});

  final String initialQuery;

  @override
  Widget build(BuildContext context) {
    final query = initialQuery.trim();

    return BlocProvider(
      create: (_) {
        final bloc = sl<ProductListBloc>();
        if (query.isNotEmpty) bloc.add(ProductListQueryChanged(query));
        return bloc;
      },
      child: _SearchView(initialQuery: query),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView({required this.initialQuery});

  final String initialQuery;

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialQuery);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit(String value) {
    final query = value.trim();
    if (query.isEmpty) return;

    FocusScope.of(context).unfocus();
    context.read<ProductListBloc>().add(ProductListQueryChanged(query));
  }

  void _back() {
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
        centerTitle: false,
        titleSpacing: 0,
        leading: IconButton(
          tooltip: 'Kembali',
          icon: const Icon(Icons.arrow_back),
          onPressed: _back,
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: AppSpacing.lg),
          child: AppSearchField(
            controller: _controller,
            onSubmitted: _submit,
          ),
        ),
      ),
      body: ProductListScrollTrigger(
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: BlocBuilder<ProductListBloc, ProductListState>(
                buildWhen: (previous, current) =>
                    previous.filter.query != current.filter.query,
                builder: (context, state) {
                  final query = state.filter.query;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.md,
                    ),
                    child: query.isEmpty
                        ? null
                        : Text(
                            'Hasil pencarian untuk "$query"',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                  );
                },
              ),
            ),
            BlocBuilder<ProductListBloc, ProductListState>(
              buildWhen: (previous, current) =>
                  previous.status != current.status,
              builder: (context, state) {
                // Belum ada pencarian (mis. dibuka tanpa kata kunci).
                if (state.status == ProductListStatus.initial) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: EmptyState(
                      icon: Icons.search,
                      title: 'Cari produk',
                      message: 'Ketik kata kunci lalu tekan cari di keyboard.',
                    ),
                  );
                }
                return const ProductGridSliver();
              },
            ),
            const ProductListFooterSliver(),
          ],
        ),
      ),
    );
  }
}
