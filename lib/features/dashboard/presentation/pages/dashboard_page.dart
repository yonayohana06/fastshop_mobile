import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/design_system/design_system.dart';

/// Kerangka root setelah login: bottom navigation + tab yang dijaga
/// state-nya oleh [StatefulNavigationShell] (scroll & filter tidak hilang
/// saat pindah tab).
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
      label: 'Keranjang',
      icon: Icons.shopping_cart_outlined,
      selectedIcon: Icons.shopping_cart,
    ),
    AppNavItem(
      label: 'Pesanan',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
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
