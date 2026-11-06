import 'package:flutter/widgets.dart';

abstract final class AppShadows {
  /// Bayangan sangat halus untuk elemen yang melayang (bottom bar, sheet).
  static const List<BoxShadow> soft = [
    BoxShadow(
      color: Color(0x0F000000), // hitam 6%
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> raised = [
    BoxShadow(
      color: Color(0x1A000000), // hitam 10%
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
  ];
}
