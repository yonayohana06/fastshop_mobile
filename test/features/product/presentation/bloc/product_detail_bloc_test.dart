import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:fastshop_mobile/core/error/failures.dart';
import 'package:fastshop_mobile/features/product/domain/entities/product_detail.dart';
import 'package:fastshop_mobile/features/product/domain/usecases/get_product_detail_usecase.dart';
import 'package:fastshop_mobile/features/product/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductDetailUseCase extends Mock
    implements GetProductDetailUseCase {}

void main() {
  late MockGetProductDetailUseCase getProductDetail;

  const tProduct = ProductDetail(
    id: '5',
    name: 'T-Shirt Polos - Hitam',
    price: 120000,
    stock: 200,
    description: 'Kaos polos warna hitam',
    categoryId: 12,
    categoryName: 'T-Shirt',
  );

  setUp(() {
    getProductDetail = MockGetProductDetailUseCase();
  });

  blocTest<ProductDetailBloc, ProductDetailState>(
    'emit [loading, success] saat detail produk berhasil dimuat',
    build: () {
      when(() => getProductDetail('5'))
          .thenAnswer((_) async => const Right(tProduct));
      return ProductDetailBloc(getProductDetail: getProductDetail);
    },
    act: (bloc) => bloc.add(const ProductDetailRequested('5')),
    expect: () => const [
      ProductDetailState(status: ProductDetailStatus.loading),
      ProductDetailState(
        status: ProductDetailStatus.success,
        product: tProduct,
      ),
    ],
    verify: (_) => verify(() => getProductDetail('5')).called(1),
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'emit [loading, failure] dengan pesan dari backend saat produk tidak ada',
    build: () {
      when(() => getProductDetail('999')).thenAnswer(
        (_) async => const Left(
          ServerFailure('Produk tidak ditemukan', statusCode: 404),
        ),
      );
      return ProductDetailBloc(getProductDetail: getProductDetail);
    },
    act: (bloc) => bloc.add(const ProductDetailRequested('999')),
    expect: () => const [
      ProductDetailState(status: ProductDetailStatus.loading),
      ProductDetailState(
        status: ProductDetailStatus.failure,
        errorMessage: 'Produk tidak ditemukan',
      ),
    ],
  );

  blocTest<ProductDetailBloc, ProductDetailState>(
    'memuat ulang saat "Coba lagi" setelah gagal',
    build: () {
      when(() => getProductDetail('5'))
          .thenAnswer((_) async => const Right(tProduct));
      return ProductDetailBloc(getProductDetail: getProductDetail);
    },
    seed: () => const ProductDetailState(
      status: ProductDetailStatus.failure,
      errorMessage: 'Tidak ada koneksi internet.',
    ),
    act: (bloc) => bloc.add(const ProductDetailRequested('5')),
    expect: () => const [
      ProductDetailState(status: ProductDetailStatus.loading),
      ProductDetailState(
        status: ProductDetailStatus.success,
        product: tProduct,
      ),
    ],
  );
}
