import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';

/// Kerangka root: bottom navigation 4 tab + state tiap tab dijaga oleh
/// [StatefulNavigationShell] (scroll & filter tidak hilang saat pindah tab).
///
/// Keranjang tidak ada di sini; aksesnya lewat ikon di header Beranda.
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  // Urutan harus sama dengan urutan branch di `createRouter`.
  static const _items = [
    AppNavItem(
      label: 'Beranda',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    AppNavItem(
      label: 'Pesanan',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
    ),
    AppNavItem(
      label: 'Notifikasi',
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
    ),
    AppNavItem(
      label: 'Profil',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNavBar(
        items: _items,
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          // Menekan tab yang sedang aktif kembali ke halaman awal tab itu.
          initialLocation: index == navigationShell.currentIndex,
        ),
      ),
    );
  }
}
