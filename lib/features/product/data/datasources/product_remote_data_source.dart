import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_guard.dart';
import '../models/product_category_model.dart';
import '../models/product_page_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductPageModel> getProducts({
    required int page,
    required int limit,
    String? query,
    int? categoryId,
  });

  Future<List<ProductCategoryModel>> getCategories();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  ProductRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ProductPageModel> getProducts({
    required int page,
    required int limit,
    String? query,
    int? categoryId,
  }) {
    return guardDio(() async {
      final search = query?.trim();
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.products,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search != null && search.isNotEmpty) 'search': search,
          'category_id': ?categoryId,
        },
      );
      return ProductPageModel.fromJson(response.data!);
    });
  }

  @override
  Future<List<ProductCategoryModel>> getCategories() {
    return guardDio(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.categories,
      );
      return (response.data!['data'] as List<dynamic>)
          .map((e) => ProductCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList();
    });
  }
}
