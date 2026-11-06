import 'package:flutter/material.dart';

/// Palette mentah FastShop.
///
/// Brand: primary `#287361` (hijau teal) dan secondary `#C36433` (terracotta).
/// Skala 50-900 diturunkan dengan mencampur warna brand (500) ke putih/hitam.
///
/// Widget TIDAK boleh memakai kelas ini langsung untuk warna semantik; pakai
/// `Theme.of(context).colorScheme` atau `context.appColors`. Kelas ini adalah
/// sumber nilai bagi theme.
///
/// Catatan kontras (WCAG AA = 4.5:1 untuk teks kecil):
/// - putih di atas primary500 = 5.65:1 (aman)
/// - putih di atas secondary500 = 4.05:1 (TIDAK cukup untuk teks kecil);
///   pakai secondary600 (5.31:1) untuk tombol/teks, secondary500 untuk
///   aksen dekoratif (banner, ikon, ilustrasi).
abstract final class AppColors {
  // --- Primary ---
  static const Color primary50 = Color(0xFFEEF4F2);
  static const Color primary100 = Color(0xFFDDE9E6);
  static const Color primary200 = Color(0xFFBAD2CC);
  static const Color primary300 = Color(0xFF94B9B0);
  static const Color primary400 = Color(0xFF5E9688);
  static const Color primary500 = Color(0xFF287361);
  static const Color primary600 = Color(0xFF226252);
  static const Color primary700 = Color(0xFF1C5044);
  static const Color primary800 = Color(0xFF163F35);
  static const Color primary900 = Color(0xFF102E27);
  static const Color primary = primary500;

  // --- Secondary ---
  static const Color secondary50 = Color(0xFFFAF3EF);
  static const Color secondary100 = Color(0xFFF5E6DE);
  static const Color secondary200 = Color(0xFFECCDBE);
  static const Color secondary300 = Color(0xFFE1B299);
  static const Color secondary400 = Color(0xFFD28B66);
  static const Color secondary500 = Color(0xFFC36433);
  static const Color secondary600 = Color(0xFFA6552B);
  static const Color secondary700 = Color(0xFF884624);
  static const Color secondary800 = Color(0xFF6B371C);
  static const Color secondary900 = Color(0xFF4E2814);
  static const Color secondary = secondary500;

  // --- Neutral ---
  static const Color neutral0 = Color(0xFFFFFFFF);
  static const Color neutral50 = Color(0xFFF6F7F8); // background halaman
  static const Color neutral100 = Color(0xFFEEF0F2);
  static const Color neutral200 = Color(0xFFE4E7EA); // border
  static const Color neutral300 = Color(0xFFCDD2D7);
  static const Color neutral400 = Color(0xFFA3ABB3);
  static const Color neutral500 = Color(0xFF6B7480); // hint (4.74:1 di putih)
  static const Color neutral600 = Color(0xFF5B6470); // teks sekunder (6.0:1)
  static const Color neutral700 = Color(0xFF3E454D);
  static const Color neutral800 = Color(0xFF2A2F35);
  static const Color neutral900 = Color(0xFF1C1F23); // teks utama (16.5:1)

  // --- Semantic ---
  // `main` dipakai untuk ikon/border; teks di atas container memakai on*.
  static const Color success = Color(0xFF2E9E5B);
  static const Color successContainer = Color(0xFFE3F5EA);
  static const Color onSuccessContainer = Color(0xFF17663A);

  static const Color warning = Color(0xFFF5A524);
  static const Color warningContainer = Color(0xFFFFF3DC);
  static const Color onWarningContainer = Color(0xFF8A5A00);

  static const Color info = Color(0xFF2F80ED);
  static const Color infoContainer = Color(0xFFE4EEFD);
  static const Color onInfoContainer = Color(0xFF1B54A8);

  static const Color error = Color(0xFFD92D3A); // putih di atasnya 4.79:1
  static const Color errorContainer = Color(0xFFFDE8E9);
  static const Color onErrorContainer = Color(0xFFA12027);

  // --- E-commerce ---
  static const Color discount = error;
  static const Color rating = Color(0xFFFFB400); // hanya untuk ikon bintang
}
