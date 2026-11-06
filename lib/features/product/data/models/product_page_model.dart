import '../../domain/entities/product_page.dart';
import 'product_model.dart';

/// Respons `GET /products`:
/// ```json
/// {
///   "code": 200,
///   "data": [ { "id": "13", "name": "...", "price": "235000", ... } ],
///   "pagination": {
///     "currentPage": 1, "limit": 15, "totalItems": 11, "totalPages": 1,
///     "hasPreviousPage": false, "hasNextPage": false
///   }
/// }
/// ```
class ProductPageModel extends ProductPage {
  const ProductPageModel({
    required super.products,
    required super.currentPage,
    required super.totalPages,
    required super.totalItems,
    required super.hasNextPage,
  });

  factory ProductPageModel.fromJson(Map<String, dynamic> json) {
    final items = (json['data'] as List<dynamic>)
        .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
        .toList();
    final pagination = json['pagination'] as Map<String, dynamic>;

    return ProductPageModel(
      products: items,
      currentPage: (pagination['currentPage'] as num).toInt(),
      totalPages: (pagination['totalPages'] as num).toInt(),
      totalItems: (pagination['totalItems'] as num).toInt(),
      hasNextPage: pagination['hasNextPage'] as bool,
    );
  }
}
