import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';
import '../../../../core/router/app_routes.dart';
import '../bloc/auth/auth_bloc.dart';

/// Pembungkus halaman yang butuh login (Pesanan, Notifikasi, Profil, Keranjang).
///
/// - sudah login  → menampilkan [child]
/// - sesi belum selesai dipulihkan → loading
/// - tamu → ajakan "Masuk" / "Daftar" (tanpa memaksa pindah halaman)
class AuthRequired extends StatelessWidget {
  const AuthRequired({
    super.key,
    required this.title,
    required this.icon,
    required this.guestMessage,
    required this.child,
  });

  final String title;
  final IconData icon;
  final String guestMessage;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final status = context.select<AuthBloc, AuthStatus>(
      (bloc) => bloc.state.status,
    );

    switch (status) {
      case AuthStatus.authenticated:
        return child;
      case AuthStatus.unknown:
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: const Center(child: CircularProgressIndicator()),
        );
      case AuthStatus.unauthenticated:
        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: EmptyState(
            icon: icon,
            title: 'Masuk untuk melanjutkan',
            message: guestMessage,
            actionLabel: 'Masuk',
            onAction: () => GoRouter.of(context).push(AppRoutes.loginAndReturn),
            secondaryActionLabel: 'Belum punya akun? Daftar',
            onSecondaryAction: () =>
                GoRouter.of(context).push(AppRoutes.register),
          ),
        );
    }
  }
}

extension RequireLoginX on BuildContext {
  /// Menjalankan [action] jika pengguna sudah login. Tamu diarahkan ke halaman
  /// login dan kembali ke halaman ini setelah berhasil masuk.
  void requireLogin(VoidCallback action) {
    final status = BlocProvider.of<AuthBloc>(this, listen: false).state.status;

    switch (status) {
      case AuthStatus.authenticated:
        action();
      case AuthStatus.unauthenticated:
        GoRouter.of(this).push(AppRoutes.loginAndReturn);
      case AuthStatus.unknown:
        ScaffoldMessenger.of(this)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('Memeriksa sesi, coba lagi sebentar.'),
            ),
          );
    }
  }
}
