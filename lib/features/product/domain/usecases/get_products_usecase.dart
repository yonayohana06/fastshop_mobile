import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_page.dart';
import '../repositories/product_repository.dart';

class GetProductsUseCase implements UseCase<ProductPage, GetProductsParams> {
  const GetProductsUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, ProductPage>> call(GetProductsParams params) {
    return _repository.getProducts(
      page: params.page,
      limit: params.limit,
      query: params.query,
      categoryId: params.categoryId,
    );
  }
}

class GetProductsParams extends Equatable {
  const GetProductsParams({
    this.page = 1,
    this.limit = 15,
    this.query,
    this.categoryId,
  });

  final int page;
  final int limit;
  final String? query;
  final int? categoryId;

  @override
  List<Object?> get props => [page, limit, query, categoryId];
}
