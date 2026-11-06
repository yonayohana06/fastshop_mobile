import 'package:equatable/equatable.dart';

import 'product.dart';

/// Satu halaman hasil `GET /products` beserta info pagination-nya.
class ProductPage extends Equatable {
  const ProductPage({
    required this.products,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.hasNextPage,
  });

  final List<Product> products;
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool hasNextPage;

  @override
  List<Object?> get props => [
        products,
        currentPage,
        totalPages,
        totalItems,
        hasNextPage,
      ];
}
