import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/usecase/usecase.dart';
import '../../../domain/entities/product_category.dart';
import '../../../domain/usecases/get_categories_usecase.dart';

part 'category_list_event.dart';
part 'category_list_state.dart';

/// Memuat daftar kategori untuk chip filter. Kegagalan tidak fatal:
/// UI cukup menampilkan chip "Semua".
class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListBloc({required GetCategoriesUseCase getCategories})
      : _getCategories = getCategories,
        super(const CategoryListState()) {
    on<CategoryListStarted>(_onStarted);
  }

  final GetCategoriesUseCase _getCategories;

  Future<void> _onStarted(
    CategoryListStarted event,
    Emitter<CategoryListState> emit,
  ) async {
    emit(const CategoryListState(status: CategoryListStatus.loading));

    final result = await _getCategories(const NoParams());

    result.fold(
      (failure) => emit(
        CategoryListState(
          status: CategoryListStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (categories) => emit(
        CategoryListState(
          status: CategoryListStatus.success,
          categories: categories,
        ),
      ),
    );
  }
}
