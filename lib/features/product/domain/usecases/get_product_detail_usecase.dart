import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_detail.dart';
import '../repositories/product_repository.dart';

/// Parameter: id produk.
class GetProductDetailUseCase implements UseCase<ProductDetail, String> {
  const GetProductDetailUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, ProductDetail>> call(String id) {
    return _repository.getProductDetail(id);
  }
}
