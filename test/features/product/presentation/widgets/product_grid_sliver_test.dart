import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:fastshop_mobile/core/design_system/design_system.dart';
import 'package:fastshop_mobile/core/error/failures.dart';
import 'package:fastshop_mobile/features/product/domain/entities/product_page.dart';
import 'package:fastshop_mobile/features/product/domain/usecases/get_products_usecase.dart';
import 'package:fastshop_mobile/features/product/presentation/bloc/product_list/product_list_bloc.dart';
import 'package:fastshop_mobile/features/product/presentation/widgets/product_card_skeleton.dart';
import 'package:fastshop_mobile/features/product/presentation/widgets/product_grid_sliver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

void main() {
  late MockGetProductsUseCase getProducts;
  late ProductListBloc bloc;

  setUpAll(() {
    registerFallbackValue(const GetProductsParams());
  });

  setUp(() {
    getProducts = MockGetProductsUseCase();
    bloc = ProductListBloc(getProducts: getProducts);
  });

  tearDown(() => bloc.close());

  Widget buildSubject() {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF287361)),
        extensions: const [FastShopColors.light],
      ),
      home: BlocProvider.value(
        value: bloc,
        child: const Scaffold(
          body: CustomScrollView(slivers: [ProductGridSliver()]),
        ),
      ),
    );
  }

  testWidgets('menampilkan skeleton kartu produk saat daftar dimuat', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final request = Completer<Either<Failure, ProductPage>>();
    when(() => getProducts(any())).thenAnswer((_) => request.future);

    bloc.add(const ProductListStarted());
    await tester.pumpWidget(buildSubject());
    await tester.pump();

    expect(bloc.state.status, ProductListStatus.loading);
    expect(find.byType(ProductCardSkeleton), findsNWidgets(6));
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}
