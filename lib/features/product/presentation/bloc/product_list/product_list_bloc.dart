import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_products_usecase.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

/// Daftar produk dengan pencarian (debounce), filter kategori,
/// infinite scroll, dan pull-to-refresh.
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({required GetProductsUseCase getProducts})
      : _getProducts = getProducts,
        super(const ProductListState()) {
    // Semua event yang memuat ulang halaman pertama diproses `restartable`:
    // event baru membatalkan yang sedang berjalan (mis. mengetik cepat).
    on<ProductListReloadEvent>(_onReload, transformer: restartable());
    // Permintaan halaman berikutnya yang datang saat masih memuat diabaikan.
    on<ProductListNextPageRequested>(_onNextPage, transformer: droppable());
  }

  static const _pageSize = 15;
  static const _searchDebounce = Duration(milliseconds: 400);

  final GetProductsUseCase _getProducts;

  Future<void> _onReload(
    ProductListReloadEvent event,
    Emitter<ProductListState> emit,
  ) async {
    final ProductFilter filter;
    var keepProducts = false;

    switch (event) {
      case ProductListStarted():
        filter = state.filter;
      case ProductListRefreshed():
        filter = state.filter;
        keepProducts = true;
      case ProductListSearchChanged():
        await Future<void>.delayed(_searchDebounce);
        if (emit.isDone) return;
        final query = event.query.trim();
        if (query == state.filter.query) return;
        filter = ProductFilter(
          query: query,
          categoryId: state.filter.categoryId,
        );
      case ProductListCategorySelected():
        if (event.categoryId == state.filter.categoryId) return;
        filter = ProductFilter(
          query: state.filter.query,
          categoryId: event.categoryId,
        );
    }

    emit(
      ProductListState(
        status: ProductListStatus.loading,
        products: keepProducts ? state.products : const [],
        filter: filter,
      ),
    );

    final result = await _getProducts(_paramsFor(filter, page: 1));
    if (emit.isDone) return;

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (page) => emit(
        state.copyWith(
          status: ProductListStatus.success,
          products: page.products,
          page: page.currentPage,
          hasReachedMax: !page.hasNextPage,
        ),
      ),
    );
  }

  Future<void> _onNextPage(
    ProductListNextPageRequested event,
    Emitter<ProductListState> emit,
  ) async {
    if (state.status != ProductListStatus.success ||
        state.hasReachedMax ||
        state.isLoadingMore) {
      return;
    }

    final filter = state.filter;
    emit(state.copyWith(isLoadingMore: true, loadMoreFailed: false));

    final result = await _getProducts(_paramsFor(filter, page: state.page + 1));

    // Filter berubah saat request berjalan: hasilnya sudah tidak relevan.
    if (state.filter != filter) return;

    result.fold(
      (_) => emit(state.copyWith(isLoadingMore: false, loadMoreFailed: true)),
      (page) => emit(
        state.copyWith(
          products: [...state.products, ...page.products],
          page: page.currentPage,
          hasReachedMax: !page.hasNextPage,
          isLoadingMore: false,
        ),
      ),
    );
  }

  GetProductsParams _paramsFor(ProductFilter filter, {required int page}) {
    return GetProductsParams(
      page: page,
      limit: _pageSize,
      query: filter.query.isEmpty ? null : filter.query,
      categoryId: filter.categoryId,
    );
  }
}
