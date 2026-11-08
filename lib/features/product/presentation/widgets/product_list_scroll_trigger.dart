import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product_list/product_list_bloc.dart';

/// Infinite scroll: membungkus daftar yang bisa di-scroll vertikal dan meminta
/// halaman berikutnya ke [ProductListBloc] saat posisi mendekati dasar.
///
/// Scroll horizontal (banner, daftar kategori) diabaikan. Setelah gagal
/// memuat halaman berikutnya, permintaan baru hanya lewat tombol "coba lagi"
/// supaya scroll di dasar daftar tidak memicu request berulang.
class ProductListScrollTrigger extends StatelessWidget {
  const ProductListScrollTrigger({super.key, required this.child});

  final Widget child;

  /// Jarak (px) dari dasar daftar yang memicu pemuatan halaman berikutnya.
  static const _threshold = 400.0;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis != Axis.vertical) return false;
        if (notification.metrics.extentAfter >= _threshold) return false;

        final bloc = context.read<ProductListBloc>();
        final state = bloc.state;
        final canLoadMore = state.status == ProductListStatus.success &&
            !state.hasReachedMax &&
            !state.isLoadingMore &&
            !state.loadMoreFailed;
        if (canLoadMore) bloc.add(const ProductListNextPageRequested());

        return false;
      },
      child: child,
    );
  }
}
