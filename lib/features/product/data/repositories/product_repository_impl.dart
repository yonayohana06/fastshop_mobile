import 'package:dartz/dartz.dart';

import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/product_category.dart';
import '../../domain/entities/product_detail.dart';
import '../../domain/entities/product_page.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl({
    required ProductRemoteDataSource remote,
    required NetworkInfo networkInfo,
  })  : _remote = remote,
        _network = networkInfo;

  final ProductRemoteDataSource _remote;
  final NetworkInfo _network;

  @override
  Future<Either<Failure, ProductPage>> getProducts({
    required int page,
    required int limit,
    String? query,
    int? categoryId,
  }) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());

    return guardFailure<ProductPage>(
      () => _remote.getProducts(
        page: page,
        limit: limit,
        query: query,
        categoryId: categoryId,
      ),
    );
  }

  @override
  Future<Either<Failure, ProductDetail>> getProductDetail(String id) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());

    return guardFailure<ProductDetail>(() => _remote.getProductDetail(id));
  }

  @override
  Future<Either<Failure, List<ProductCategory>>> getCategories() async {
    if (!await _network.isConnected) return const Left(NetworkFailure());

    return guardFailure<List<ProductCategory>>(_remote.getCategories);
  }
}
