part of 'product_list_bloc.dart';

enum ProductListStatus { initial, loading, success, failure }

/// Filter yang sedang aktif pada daftar produk.
final class ProductFilter extends Equatable {
  const ProductFilter({this.query = '', this.categoryId});

  final String query;
  final int? categoryId;

  @override
  List<Object?> get props => [query, categoryId];
}

final class ProductListState extends Equatable {
  const ProductListState({
    this.status = ProductListStatus.initial,
    this.products = const [],
    this.filter = const ProductFilter(),
    this.page = 0,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.loadMoreFailed = false,
    this.errorMessage,
  });

  final ProductListStatus status;
  final List<Product> products;
  final ProductFilter filter;

  /// Halaman terakhir yang berhasil dimuat (0 = belum ada).
  final int page;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final bool loadMoreFailed;
  final String? errorMessage;

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? products,
    int? page,
    bool? hasReachedMax,
    bool? isLoadingMore,
    bool? loadMoreFailed,
    String? errorMessage,
  }) {
    return ProductListState(
      status: status ?? this.status,
      products: products ?? this.products,
      filter: filter,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreFailed: loadMoreFailed ?? this.loadMoreFailed,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        products,
        filter,
        page,
        hasReachedMax,
        isLoadingMore,
        loadMoreFailed,
        errorMessage,
      ];
}
