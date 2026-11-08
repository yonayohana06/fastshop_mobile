import '../../domain/entities/product_detail.dart';

class ProductDetailModel extends ProductDetail {
  const ProductDetailModel({
    required super.id,
    required super.name,
    required super.price,
    required super.stock,
    super.description,
    super.imageUrl,
    super.categoryId,
    super.categoryName,
  });

  /// Isi `data` dari `GET /products/:id`. Seperti daftar produk, `id` dan
  /// `price` berupa string, sedangkan `stock` dan `category_id` berupa angka.
  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final categoryId = json['category_id'];

    return ProductDetailModel(
      id: '${json['id']}',
      name: json['name'] as String,
      price: num.parse('${json['price']}'),
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      description: json['description'] as String?,
      imageUrl: json['image_url'] as String?,
      categoryId: categoryId == null ? null : int.parse('$categoryId'),
      categoryName: json['category_name'] as String?,
    );
  }
}
