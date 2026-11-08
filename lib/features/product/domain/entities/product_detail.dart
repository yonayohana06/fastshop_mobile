import 'package:equatable/equatable.dart';

/// Detail satu produk dari `GET /products/:id`.
class ProductDetail extends Equatable {
  const ProductDetail({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.description,
    this.imageUrl,
    this.categoryId,
    this.categoryName,
  });

  final String id;
  final String name;

  /// Harga dalam Rupiah.
  final num price;
  final int stock;
  final String? description;
  final String? imageUrl;
  final int? categoryId;
  final String? categoryName;

  bool get isOutOfStock => stock <= 0;

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        stock,
        description,
        imageUrl,
        categoryId,
        categoryName,
      ];
}
