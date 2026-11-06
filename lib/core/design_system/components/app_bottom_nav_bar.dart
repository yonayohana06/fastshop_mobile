import 'package:flutter/material.dart';

import '../theme/fastshop_colors.dart';

class AppNavItem {
  const AppNavItem({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeCount = 0,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;

  /// 0 = badge disembunyikan.
  final int badgeCount;
}

/// Bottom navigation (Beranda, Pesanan, Diskon, Notifikasi, Profil)
/// dengan dukungan badge angka.
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        destinations: [
          for (final item in items)
            NavigationDestination(
              label: item.label,
              icon: _icon(context, item, selected: false),
              selectedIcon: _icon(context, item, selected: true),
            ),
        ],
      ),
    );
  }

  Widget _icon(
    BuildContext context,
    AppNavItem item, {
    required bool selected,
  }) {
    final colors = context.appColors;
    return Badge(
      isLabelVisible: item.badgeCount > 0,
      label: Text('${item.badgeCount}'),
      backgroundColor: colors.discount,
      textColor: colors.onDiscount,
      child: Icon(selected ? item.selectedIcon : item.icon),
    );
  }
}
