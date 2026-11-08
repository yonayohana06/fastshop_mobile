import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product_detail.dart';
import '../../../domain/usecases/get_product_detail_usecase.dart';

part 'product_detail_event.dart';
part 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  ProductDetailBloc({required GetProductDetailUseCase getProductDetail})
      : _getProductDetail = getProductDetail,
        super(const ProductDetailState()) {
    on<ProductDetailRequested>(_onRequested);
  }

  final GetProductDetailUseCase _getProductDetail;

  Future<void> _onRequested(
    ProductDetailRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailState(status: ProductDetailStatus.loading));

    final result = await _getProductDetail(event.id);

    result.fold(
      (failure) => emit(
        ProductDetailState(
          status: ProductDetailStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (product) => emit(
        ProductDetailState(
          status: ProductDetailStatus.success,
          product: product,
        ),
      ),
    );
  }
}
