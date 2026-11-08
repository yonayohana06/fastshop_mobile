import 'package:get_it/get_it.dart';

import 'data/datasources/product_remote_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/get_categories_usecase.dart';
import 'domain/usecases/get_product_detail_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'presentation/bloc/category_list/category_list_bloc.dart';
import 'presentation/bloc/product_detail/product_detail_bloc.dart';
import 'presentation/bloc/product_list/product_list_bloc.dart';

/// Registrasi dependency milik fitur product (produk, detail, kategori).
void registerProductDependencies(GetIt sl) {
  sl
    // Data source
    ..registerLazySingleton<ProductRemoteDataSource>(
      () => ProductRemoteDataSourceImpl(sl()),
    )
    // Repository
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(remote: sl(), networkInfo: sl()),
    )
    // Use cases
    ..registerLazySingleton(() => GetProductsUseCase(sl()))
    ..registerLazySingleton(() => GetProductDetailUseCase(sl()))
    ..registerLazySingleton(() => GetCategoriesUseCase(sl()))
    // Blocs
    ..registerFactory(() => ProductListBloc(getProducts: sl()))
    ..registerFactory(() => ProductDetailBloc(getProductDetail: sl()))
    ..registerFactory(() => CategoryListBloc(getCategories: sl()));
}
