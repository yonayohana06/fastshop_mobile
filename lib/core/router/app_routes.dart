class AppRoutes {
  const AppRoutes._();

  static const splash = '/splash';

  // Auth
  static const login = '/login';
  static const register = '/register';

  /// Query penanda: halaman login dibuka dari halaman lain (mis. tamu menekan
  /// "Keranjang") dan harus kembali ke halaman itu setelah berhasil masuk.
  static const returnParam = 'return';
  static const loginAndReturn = '/login?$returnParam=1';

  // Tab dashboard (dengan bottom navigation)
  static const home = '/';
  static const orders = '/orders';
  static const notifications = '/notifications';
  static const profile = '/profile';

  // Halaman di luar dashboard (tanpa bottom navigation)
  static const cart = '/cart';
  static const search = '/search';
  static const productDetail = '/products/:id';

  static String productDetailPath(String id) => '/products/$id';

  static String searchPath(String query) {
    return Uri(path: search, queryParameters: {'q': query}).toString();
  }

  /// Hanya tersedia di debug build.
  static const designSystem = '/design-system';
}
