part of 'product_detail_bloc.dart';

sealed class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

/// Muat detail produk (juga dipakai untuk "Coba lagi").
final class ProductDetailRequested extends ProductDetailEvent {
  const ProductDetailRequested(this.id);

  final String id;

  @override
  List<Object?> get props => [id];
}
