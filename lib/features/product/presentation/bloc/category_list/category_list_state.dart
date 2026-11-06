part of 'category_list_bloc.dart';

enum CategoryListStatus { initial, loading, success, failure }

final class CategoryListState extends Equatable {
  const CategoryListState({
    this.status = CategoryListStatus.initial,
    this.categories = const [],
    this.errorMessage,
  });

  final CategoryListStatus status;
  final List<ProductCategory> categories;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, categories, errorMessage];
}
