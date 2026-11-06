/// Semua path endpoint dikumpulkan di sini. Sumber: dokumentasi API di project
/// (`E-Commerce API Documentation - Mobile.json`).
class ApiEndpoints {
  const ApiEndpoints._();

  // Auth
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const me = '/auth/me';

  // Katalog (publik)
  static const products = '/products';
  static const categories = '/categories';
}
