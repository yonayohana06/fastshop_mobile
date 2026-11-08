# FastShop (Flutter + Clean Architecture)

Aplikasi e-commerce dengan Clean Architecture (feature-first) dan **Bloc**.
Sudah ada: **auth** (login, register, pemulihan sesi, logout), **design system**, dan **dashboard** yang langsung terbuka tanpa login (mode tamu). Beranda berisi header sticky (sapaan, ikon keranjang, kolom cari), banner promo, kategori, dan produk (infinite scroll, limit 10). Ada halaman detail produk dan halaman hasil pencarian.

## Menjalankan

Base URL default mengarah ke backend produksi (`https://ecommerce-backend-api-nu.vercel.app/api`). Untuk environment lain:

```bash
flutter run --dart-define=BASE_URL=https://api-staging-kamu.com/api
```

Versi package di `pubspec.yaml` ditulis berdasarkan pengetahuan saat penulisan; jalankan `flutter pub upgrade --major-versions` bila ingin versi terbaru.

## Struktur

```
lib/
├── core/
│   ├── config/        # Env (BASE_URL via --dart-define)
│   ├── design_system/ # tokens, theme, komponen UI, katalog
│   ├── di/            # get_it (service locator)
│   ├── error/         # Failure, Exception, guardFailure (exception → Failure)
│   ├── network/       # Dio, interceptor, api_guard, endpoint, network info
│   ├── router/        # go_router: mulai di Beranda, StatefulShellRoute 4 tab
│   ├── storage/       # TokenStorage (flutter_secure_storage)
│   ├── usecase/       # base UseCase
│   └── utils/         # validators, currency, SubmissionStatus
├── features/
│   ├── auth/          # data / domain / presentation + auth_injection.dart
│   ├── product/       # produk + kategori: data / domain / presentation + product_injection.dart
│   ├── home/          # tab Beranda (menyusun bloc & widget dari product)
│   ├── dashboard/     # kerangka bottom navigation + halaman "segera hadir"
│   └── profile/       # tab Profil sementara (data akun + keluar)
├── app.dart
└── main.dart
```

Alur: `Page → Bloc → UseCase → Repository (abstract) → RepositoryImpl → DataSource → API`.
Exception dari datasource diubah menjadi `Failure` di repository (`guardFailure`), dan hasilnya dibungkus `Either<Failure, T>` (dartz).

Fitur baru: buat `features/<nama>/{data,domain,presentation}` plus `<nama>_injection.dart`, lalu daftarkan di `core/di/injection.dart`.

## Kontrak API yang dipakai

Sumber: `API_RESPONSES.md` dan koleksi API di Project. Semua path ada di `core/network/api_endpoints.dart`.

| Endpoint              | Dipakai untuk                | Catatan                                                                                                     |
| --------------------- | ---------------------------- | ----------------------------------------------------------------------------------------------------------- |
| `POST /auth/login`    | Login                        | `{email, password}` → `data.{user, token}`                                                                  |
| `POST /auth/register` | Daftar                       | `{name, email, password}` → `data` = user. **Tanpa token**, jadi setelah daftar pengguna diarahkan ke login |
| `GET /auth/me`        | Validasi sesi saat app start | Timeout 8 detik; jika jaringan/server bermasalah dan ada cache user, sesi dipertahankan                     |
| `GET /products`       | Daftar produk                | Query `search`, `category_id`, `page`, `limit` (default 15). Respons: `data[]` + `pagination`               |
| `GET /categories`     | Chip kategori                | Publik                                                                                                      |

Format respons: `{ code, message, data }`; error: `{ code, message }` (pesan ditampilkan apa adanya di snackbar). Catatan format: `id` dan `price` pada produk berupa string, `stock` berupa angka, dan `id` user berupa string (login/me) atau angka (register); semuanya dinormalisasi di model.

Belum dipakai (sudah ada di dokumentasi): `GET/POST/PUT/DELETE /cart`, `/orders` (checkout, upload bukti bayar, daftar, detail), `GET /categories/:id`. `GET /products/:id` dipakai di halaman detail produk.

## Catatan desain

- **Token** di `flutter_secure_storage`, **cache user** di Hive (box `app_cache`). Backend hanya mengirim satu `token` (tanpa refresh token) dan tidak punya endpoint logout, jadi logout hanya menghapus sesi lokal.
- **401** pada request terautentikasi → `SessionEvents` → `AuthBloc` logout otomatis → router redirect ke login. Endpoint auth dikecualikan (`skipAuthRedirect`).
- **Pemulihan sesi**: `GetCurrentSessionUseCase` memanggil `/auth/me`. Token ditolak (401) → sesi dihapus; offline/server error dengan cache user → tetap masuk memakai cache.
- **Daftar produk** (`ProductListBloc`): pencarian dikirim hanya saat pengguna menekan cari di keyboard (tanpa auto search) dan `restartable` (permintaan baru membatalkan yang lama); ukuran halaman 10, halaman berikutnya `droppable`, dan hasil halaman berikutnya dibuang jika filter berubah saat request berjalan. Jika memuat halaman berikutnya gagal, scroll tidak mengulang permintaan; pengguna menekan "coba lagi".
- **Data belum tersedia dari backend**: diskon, rating, dan favorit tidak ada di respons produk, jadi `ProductCard` hanya menampilkan gambar, kategori, nama, harga, dan label "Habis" bila stok 0 (elemen lain di komponen tetap opsional).
- **Mode tamu**: tidak ada redirect paksa ke login. Pesanan, Notifikasi, Profil, dan Keranjang menampilkan ajakan masuk (`AuthRequired`); aksi seperti Keranjang/Beli Sekarang memakai `context.requireLogin`. Login dari halaman lain (`/login?return=1`) kembali ke halaman sebelumnya setelah berhasil.
- Bottom nav 4 tab (Beranda, Pesanan, Notifikasi, Profil); keranjang ada di header Beranda.
- Banner promo memakai data dummy (`features/home/presentation/dummy/promo_banners.dart`, URL gambar Unsplash).
- Halaman Pesanan, Notifikasi, dan Keranjang masih "segera hadir"; tombol Keranjang/Beli Sekarang di detail produk masih stub.
- Splash page dihapus (tidak ada lagi gerbang login saat start).
- DI memakai `get_it` manual (tanpa `injectable`/`build_runner`) dan model memakai JSON manual (tanpa `freezed`) agar tidak butuh code generation.

## Design System (FastShop)

```
lib/core/design_system/
├── tokens/      # app_colors, app_typography, app_spacing, app_radius, app_shadows
├── theme/       # app_theme.dart (ThemeData light), fastshop_colors.dart (ThemeExtension)
├── components/  # AppButton, AppTextField, AppSearchField, AppCard, DiscountBadge,
│                # StatusChip, QuantityStepper, RatingLabel, PriceText, ProductCard,
│                # AppBottomNavBar, EmptyState
├── catalog/     # ComponentCatalogPage (route /design-system, hanya debug)
└── design_system.dart   # barrel: satu import untuk semuanya
```

- **Brand**: primary `#287361`, secondary `#C36433`. Skala 50-900 diturunkan dari keduanya.
- **Aturan**: widget tidak hardcode warna/ukuran/font. Pakai `Theme.of(context).colorScheme`, `context.appColors` (success/warning/info/diskon/rating), dan token `AppSpacing`/`AppRadius`.
- **Kontras**: putih di atas primary500 = 5,65:1 (AA). Putih di atas secondary500 hanya 4,05:1, jadi tombol secondary memakai secondary600 (5,31:1); `#C36433` dipakai untuk aksen dekoratif.
- **Font**: Inter via `google_fonts` (diunduh saat runtime). Untuk produksi/offline, bundel font ke assets dan set `GoogleFonts.config.allowRuntimeFetching = false`.
- **Katalog**: jalankan app (debug) lalu tekan "Katalog komponen (debug)" di halaman login.
- Belum ada dark mode; `AppTheme` baru punya `light`.
