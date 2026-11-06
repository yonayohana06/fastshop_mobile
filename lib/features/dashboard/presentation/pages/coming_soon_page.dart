import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';

/// Placeholder untuk tab yang fiturnya belum dikerjakan (keranjang, pesanan).
class ComingSoonPage extends StatelessWidget {
  const ComingSoonPage({super.key, required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: EmptyState(
        icon: icon,
        title: '$title segera hadir',
        message: 'Fitur ini sedang dikerjakan.',
      ),
    );
  }
}
