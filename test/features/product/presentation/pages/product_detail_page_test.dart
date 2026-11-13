import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fastshop_mobile/core/design_system/design_system.dart';
import 'package:fastshop_mobile/core/di/injection.dart';
import 'package:fastshop_mobile/core/error/failures.dart';
import 'package:fastshop_mobile/features/product/domain/entities/product_detail.dart';
import 'package:fastshop_mobile/features/product/domain/usecases/get_product_detail_usecase.dart';
import 'package:fastshop_mobile/features/product/presentation/bloc/product_detail/product_detail_bloc.dart';
import 'package:fastshop_mobile/features/product/presentation/pages/product_detail_page.dart';
import 'package:fastshop_mobile/features/product/presentation/widgets/product_detail_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductDetailUseCase extends Mock
    implements GetProductDetailUseCase {}

void main() {
  late MockGetProductDetailUseCase getProductDetail;

  setUp(() {
    getProductDetail = MockGetProductDetailUseCase();
    when(() => getProductDetail('5'))
        .thenAnswer((_) => Completer<Either<Failure, ProductDetail>>().future);
    sl.registerFactory<ProductDetailBloc>(
      () => ProductDetailBloc(getProductDetail: getProductDetail),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('menampilkan skeleton detail produk saat data dimuat', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF287361)),
          extensions: const [FastShopColors.light],
        ),
        home: const ProductDetailPage(productId: '5'),
      ),
    );
    await tester.pump();

    expect(find.byType(ProductDetailSkeleton), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
