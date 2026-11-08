import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../auth/presentation/widgets/auth_required.dart';

/// Header Beranda yang menempel (sticky) di atas saat daftar di-scroll:
/// sapaan, ikon keranjang, dan kolom pencarian.
///
/// Pencarian tidak otomatis: [onSearchSubmitted] dipanggil saat pengguna
/// menekan "cari" di keyboard.
class HomeHeaderSliver extends StatelessWidget {
  const HomeHeaderSliver({
    super.key,
    required this.searchController,
    required this.onSearchSubmitted,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onSearchSubmitted;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;
    final name = context.select<AuthBloc, String?>(
      (bloc) => bloc.state.user?.name,
    );
    final isGuest = name == null || name.trim().isEmpty;
    // Tinggi header ikut membesar mengikuti ukuran teks perangkat.
    final textScale = MediaQuery.textScalerOf(context)
        .scale(1)
        .clamp(1.0, 1.3)
        .toDouble();

    return SliverAppBar(
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.neutral0,
      surfaceTintColor: Colors.transparent,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black26,
      centerTitle: false,
      titleSpacing: AppSpacing.lg,
      toolbarHeight: 64 * textScale,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isGuest ? 'Selamat datang' : 'Selamat datang,',
            style: textTheme.bodySmall?.copyWith(color: colors.textSecondary),
          ),
          Text(
            isGuest ? 'di FastShop' : name.trim(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium,
          ),
        ],
      ),
      actions: [
        IconButton.outlined(
          tooltip: 'Keranjang',
          icon: const Icon(Icons.shopping_cart_outlined),
          style: IconButton.styleFrom(
            foregroundColor: AppColors.neutral800,
            side: BorderSide(color: colors.border),
            shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          ),
          // Keranjang butuh login: tamu diarahkan masuk lalu kembali ke sini.
          onPressed: () =>
              context.requireLogin(() => context.push(AppRoutes.cart)),
        ),
        const SizedBox(width: AppSpacing.lg),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(64 * textScale),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            0,
            AppSpacing.lg,
            AppSpacing.md,
          ),
          child: AppSearchField(
            controller: searchController,
            onSubmitted: onSearchSubmitted,
          ),
        ),
      ),
    );
  }
}
