part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

/// Event yang memuat ulang halaman pertama.
sealed class ProductListReloadEvent extends ProductListEvent {
  const ProductListReloadEvent();
}

/// Muat pertama kali (atau "Coba lagi" setelah gagal), dengan filter saat ini.
final class ProductListStarted extends ProductListReloadEvent {
  const ProductListStarted();
}

/// Pull-to-refresh: daftar lama tetap tampil selama memuat.
final class ProductListRefreshed extends ProductListReloadEvent {
  const ProductListRefreshed();
}

/// Kata kunci pencarian berubah (di-debounce di bloc).
final class ProductListSearchChanged extends ProductListReloadEvent {
  const ProductListSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Kategori dipilih; `null` berarti "Semua".
final class ProductListCategorySelected extends ProductListReloadEvent {
  const ProductListCategorySelected(this.categoryId);

  final int? categoryId;

  @override
  List<Object?> get props => [categoryId];
}

/// Dikirim saat scroll mendekati dasar daftar (infinite scroll).
final class ProductListNextPageRequested extends ProductListEvent {
  const ProductListNextPageRequested();
}
