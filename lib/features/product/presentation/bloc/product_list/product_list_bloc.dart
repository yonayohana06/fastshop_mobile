import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/usecases/get_products_usecase.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

/// Daftar produk dengan filter (kata kunci + kategori), infinite scroll,
/// dan pull-to-refresh. Dipakai oleh Beranda dan halaman hasil pencarian
/// (masing-masing punya instance sendiri).
///
/// Kata kunci TIDAK diproses saat mengetik: bloc hanya menerima
/// [ProductListQueryChanged] ketika pengguna menekan "cari" di keyboard.
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({required GetProductsUseCase getProducts})
      : _getProducts = getProducts,
        super(const ProductListState()) {
    // Event yang memuat ulang halaman pertama diproses `restartable`:
    // event baru membatalkan yang sedang berjalan (mis. ganti kategori cepat).
    on<ProductListReloadEvent>(_onReload, transformer: restartable());
    // Permintaan halaman berikutnya yang datang saat masih memuat diabaikan.
    on<ProductListNextPageRequested>(_onNextPage, transformer: droppable());
  }

  /// Jumlah produk per halaman.
  static const pageSize = 10;

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
      case ProductListQueryChanged(query: final submitted):
        final query = submitted.trim();
        // Kata kunci sama dan daftar sudah berhasil dimuat: tidak perlu ulang.
        if (query == state.filter.query &&
            state.status == ProductListStatus.success) {
          return;
        }
        filter = ProductFilter(
          query: query,
          categoryId: state.filter.categoryId,
        );
      case ProductListCategorySelected(categoryId: final categoryId):
        if (categoryId == state.filter.categoryId) return;
        filter = ProductFilter(
          query: state.filter.query,
          categoryId: categoryId,
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
      limit: pageSize,
      query: filter.query.isEmpty ? null : filter.query,
      categoryId: filter.categoryId,
    );
  }
}
