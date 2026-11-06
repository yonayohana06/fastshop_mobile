import '../../domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.price,
    required super.stock,
    super.imageUrl,
    super.categoryName,
  });

  /// Item dari `GET /products`. Perhatikan format backend:
  /// `id` dan `price` berupa string (`"13"`, `"235000"`), `stock` berupa angka.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: '${json['id']}',
      name: json['name'] as String,
      price: num.parse('${json['price']}'),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      imageUrl: json['image_url'] as String?,
      categoryName: json['category_name'] as String?,
    );
  }
}
