import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/auth/auth_bloc.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/widgets/auth_required.dart';
import '../../features/dashboard/presentation/pages/coming_soon_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/product/presentation/pages/product_detail_page.dart';
import '../../features/product/presentation/pages/product_search_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../design_system/catalog/component_catalog_page.dart';
import 'app_routes.dart';

/// Router aplikasi.
///
/// Aplikasi langsung membuka dashboard (Beranda) tanpa login. Tidak ada
/// redirect paksa ke halaman login: halaman yang butuh login (Pesanan,
/// Notifikasi, Profil, Keranjang) menampilkan ajakan masuk lewat
/// [AuthRequired], dan aksi seperti "Keranjang" memakai `context.requireLogin`.
GoRouter createRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: GoRouterRefreshStream(authBloc.stream),
    redirect: (context, state) {
      final location = state.matchedLocation;
      final onAuthPage =
          location == AppRoutes.login || location == AppRoutes.register;
      final returning =
          state.uri.queryParameters[AppRoutes.returnParam] == '1';

      // Sudah login tidak perlu melihat halaman login/register. Pengecualian:
      // mode "kembali" (login dibuka dari halaman lain), di mana halaman login
      // sendiri yang menutup diri setelah berhasil masuk.
      if (authBloc.state.status == AuthStatus.authenticated &&
          onAuthPage &&
          !returning) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => LoginPage(
          returnToPrevious:
              state.uri.queryParameters[AppRoutes.returnParam] == '1',
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      // Dashboard: bottom navigation 4 tab dengan state tiap tab dipertahankan.
      // Urutan branch harus sama dengan `DashboardPage._items`.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            DashboardPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.orders,
                builder: (context, state) => const AuthRequired(
                  title: 'Pesanan',
                  icon: Icons.receipt_long_outlined,
                  guestMessage: 'Masuk untuk melihat riwayat pesananmu.',
                  child: ComingSoonPage(
                    title: 'Pesanan',
                    icon: Icons.receipt_long_outlined,
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.notifications,
                builder: (context, state) => const AuthRequired(
                  title: 'Notifikasi',
                  icon: Icons.notifications_outlined,
                  guestMessage: 'Masuk untuk melihat notifikasimu.',
                  child: ComingSoonPage(
                    title: 'Notifikasi',
                    icon: Icons.notifications_outlined,
                  ),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      // Halaman di luar dashboard (tanpa bottom navigation).
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => ProductSearchPage(
          initialQuery: state.uri.queryParameters['q'] ?? '',
        ),
      ),
      GoRoute(
        path: AppRoutes.productDetail,
        builder: (context, state) =>
            ProductDetailPage(productId: state.pathParameters['id']!),
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const AuthRequired(
          title: 'Keranjang',
          icon: Icons.shopping_cart_outlined,
          guestMessage: 'Masuk untuk melihat keranjang belanjamu.',
          child: ComingSoonPage(
            title: 'Keranjang',
            icon: Icons.shopping_cart_outlined,
          ),
        ),
      ),
      if (kDebugMode)
        GoRoute(
          path: AppRoutes.designSystem,
          builder: (context, state) => const ComponentCatalogPage(),
        ),
    ],
  );
}

/// Membuat GoRouter me-refresh redirect setiap kali [stream] emit.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
