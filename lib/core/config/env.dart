/// Konfigurasi environment lewat `--dart-define`.
///
/// Default mengarah ke backend produksi. Untuk environment lain:
///   flutter run --dart-define=BASE_URL=https://api.staging.example.com/api
///
/// Tulis tanpa trailing slash; path endpoint diawali `/` (lihat `ApiEndpoints`).
class Env {
  const Env._();

  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://ecommerce-backend-api-nu.vercel.app/api',
  );
}
