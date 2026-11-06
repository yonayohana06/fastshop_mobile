import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fastshop_mobile/core/error/failures.dart';
import 'package:fastshop_mobile/features/product/domain/entities/product.dart';
import 'package:fastshop_mobile/features/product/domain/entities/product_page.dart';
import 'package:fastshop_mobile/features/product/domain/usecases/get_products_usecase.dart';
import 'package:fastshop_mobile/features/product/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

void main() {
  late MockGetProductsUseCase getProducts;

  const tProduct = Product(
    id: '1',
    name: 'Sepatu Running Nike',
    price: 1250000,
    stock: 14,
    categoryName: 'Sepatu',
  );
  const tProduct2 = Product(
    id: '2',
    name: 'Kemeja Kerja Formal',
    price: 135000,
    stock: 250,
    categoryName: 'Kemeja',
  );
  const tPage1 = ProductPage(
    products: [tProduct],
    currentPage: 1,
    totalPages: 2,
    totalItems: 2,
    hasNextPage: true,
  );
  const tPage2 = ProductPage(
    products: [tProduct2],
    currentPage: 2,
    totalPages: 2,
    totalItems: 2,
    hasNextPage: false,
  );

  setUpAll(() {
    registerFallbackValue(const GetProductsParams());
  });

  setUp(() {
    getProducts = MockGetProductsUseCase();
  });

  ProductListBloc buildBloc() => ProductListBloc(getProducts: getProducts);

  group('ProductListStarted', () {
    blocTest<ProductListBloc, ProductListState>(
      'emit [loading, success] saat halaman pertama berhasil dimuat',
      build: () {
        when(() => getProducts(any()))
            .thenAnswer((_) async => const Right(tPage1));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProductListStarted()),
      expect: () => const [
        ProductListState(status: ProductListStatus.loading),
        ProductListState(
          status: ProductListStatus.success,
          products: [tProduct],
          page: 1,
        ),
      ],
      verify: (_) =>
          verify(() => getProducts(const GetProductsParams(page: 1, limit: 15)))
              .called(1),
    );

    blocTest<ProductListBloc, ProductListState>(
      'emit [loading, failure] saat gagal memuat',
      build: () {
        when(() => getProducts(any())).thenAnswer(
          (_) async => const Left(ServerFailure('Terjadi kesalahan')),
        );
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProductListStarted()),
      expect: () => const [
        ProductListState(status: ProductListStatus.loading),
        ProductListState(
          status: ProductListStatus.failure,
          errorMessage: 'Terjadi kesalahan',
        ),
      ],
    );
  });

  group('ProductListNextPageRequested', () {
    blocTest<ProductListBloc, ProductListState>(
      'menambahkan produk halaman berikutnya ke daftar',
      build: () {
        when(() => getProducts(any()))
            .thenAnswer((_) async => const Right(tPage2));
        return buildBloc();
      },
      seed: () => const ProductListState(
        status: ProductListStatus.success,
        products: [tProduct],
        page: 1,
      ),
      act: (bloc) => bloc.add(const ProductListNextPageRequested()),
      expect: () => const [
        ProductListState(
          status: ProductListStatus.success,
          products: [tProduct],
          page: 1,
          isLoadingMore: true,
        ),
        ProductListState(
          status: ProductListStatus.success,
          products: [tProduct, tProduct2],
          page: 2,
          hasReachedMax: true,
        ),
      ],
      verify: (_) =>
          verify(() => getProducts(const GetProductsParams(page: 2, limit: 15)))
              .called(1),
    );

    blocTest<ProductListBloc, ProductListState>(
      'diabaikan saat semua halaman sudah dimuat',
      build: buildBloc,
      seed: () => const ProductListState(
        status: ProductListStatus.success,
        products: [tProduct],
        page: 1,
        hasReachedMax: true,
      ),
      act: (bloc) => bloc.add(const ProductListNextPageRequested()),
      expect: () => const <ProductListState>[],
      verify: (_) => verifyNever(() => getProducts(any())),
    );

    blocTest<ProductListBloc, ProductListState>(
      'menandai loadMoreFailed tanpa menghapus daftar saat gagal',
      build: () {
        when(() => getProducts(any()))
            .thenAnswer((_) async => const Left(NetworkFailure()));
        return buildBloc();
      },
      seed: () => const ProductListState(
        status: ProductListStatus.success,
        products: [tProduct],
        page: 1,
      ),
      act: (bloc) => bloc.add(const ProductListNextPageRequested()),
      expect: () => const [
        ProductListState(
          status: ProductListStatus.success,
          products: [tProduct],
          page: 1,
          isLoadingMore: true,
        ),
        ProductListState(
          status: ProductListStatus.success,
          products: [tProduct],
          page: 1,
          loadMoreFailed: true,
        ),
      ],
    );
  });

  group('ProductListCategorySelected', () {
    blocTest<ProductListBloc, ProductListState>(
      'memuat ulang dari halaman 1 dengan category_id yang dipilih',
      build: () {
        when(() => getProducts(any()))
            .thenAnswer((_) async => const Right(tPage1));
        return buildBloc();
      },
      act: (bloc) => bloc.add(const ProductListCategorySelected(11)),
      expect: () => const [
        ProductListState(
          status: ProductListStatus.loading,
          filter: ProductFilter(categoryId: 11),
        ),
        ProductListState(
          status: ProductListStatus.success,
          products: [tProduct],
          filter: ProductFilter(categoryId: 11),
          page: 1,
        ),
      ],
      verify: (_) => verify(
        () => getProducts(
          const GetProductsParams(page: 1, limit: 15, categoryId: 11),
        ),
      ).called(1),
    );
  });

  group('ProductListSearchChanged', () {
    blocTest<ProductListBloc, ProductListState>(
      'hanya memanggil API sekali untuk beberapa ketikan beruntun (debounce)',
      build: () {
        when(() => getProducts(any()))
            .thenAnswer((_) async => const Right(tPage1));
        return buildBloc();
      },
      act: (bloc) => bloc
        ..add(const ProductListSearchChanged('s'))
        ..add(const ProductListSearchChanged('se'))
        ..add(const ProductListSearchChanged('sepatu')),
      wait: const Duration(milliseconds: 700),
      expect: () => const [
        ProductListState(
          status: ProductListStatus.loading,
          filter: ProductFilter(query: 'sepatu'),
        ),
        ProductListState(
          status: ProductListStatus.success,
          products: [tProduct],
          filter: ProductFilter(query: 'sepatu'),
          page: 1,
        ),
      ],
      verify: (_) {
        verify(() => getProducts(any())).called(1);
        verify(
          () => getProducts(
            const GetProductsParams(page: 1, limit: 15, query: 'sepatu'),
          ),
        ).called(1);
      },
    );
  });
}
