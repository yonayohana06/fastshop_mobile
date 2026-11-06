import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.imageUrl,
    this.categoryName,
  });

  final String id;
  final String name;

  /// Harga dalam Rupiah.
  final num price;
  final int stock;
  final String? imageUrl;
  final String? categoryName;

  bool get isOutOfStock => stock <= 0;

  @override
  List<Object?> get props => [id, name, price, stock, imageUrl, categoryName];
}
