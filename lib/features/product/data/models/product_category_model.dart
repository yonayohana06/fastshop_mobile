import '../../domain/entities/product_category.dart';

class ProductCategoryModel extends ProductCategory {
  const ProductCategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.productCount,
    super.iconUrl,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: int.parse('${json['id']}'),
      name: json['name'] as String,
      slug: (json['slug'] as String?) ?? '',
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
      iconUrl: json['icon_url'] as String?,
    );
  }
}
