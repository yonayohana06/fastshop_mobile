import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/product_category.dart';
import '../repositories/product_repository.dart';

class GetCategoriesUseCase
    implements UseCase<List<ProductCategory>, NoParams> {
  const GetCategoriesUseCase(this._repository);

  final ProductRepository _repository;

  @override
  Future<Either<Failure, List<ProductCategory>>> call(NoParams params) {
    return _repository.getCategories();
  }
}
