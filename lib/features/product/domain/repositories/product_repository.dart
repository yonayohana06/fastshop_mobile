import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/product_category.dart';
import '../entities/product_detail.dart';
import '../entities/product_page.dart';

abstract class ProductRepository {
  /// Daftar produk per halaman. [query] mencari berdasarkan kata kunci,
  /// [categoryId] memfilter berdasarkan kategori.
  Future<Either<Failure, ProductPage>> getProducts({
    required int page,
    required int limit,
    String? query,
    int? categoryId,
  });

  Future<Either<Failure, ProductDetail>> getProductDetail(String id);

  Future<Either<Failure, List<ProductCategory>>> getCategories();
}
