part of 'product_detail_bloc.dart';

enum ProductDetailStatus { initial, loading, success, failure }

final class ProductDetailState extends Equatable {
  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.errorMessage,
  });

  final ProductDetailStatus status;
  final ProductDetail? product;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, product, errorMessage];
}
