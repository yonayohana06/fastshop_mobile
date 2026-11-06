import 'package:equatable/equatable.dart';

class ProductCategory extends Equatable {
  const ProductCategory({
    required this.id,
    required this.name,
    required this.slug,
    required this.productCount,
    this.iconUrl,
  });

  final int id;
  final String name;
  final String slug;
  final int productCount;
  final String? iconUrl;

  @override
  List<Object?> get props => [id, name, slug, productCount, iconUrl];
}
