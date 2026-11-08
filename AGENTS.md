# AGENTS.md

Panduan untuk AI coding agent (dan kontributor) yang bekerja di **FastShop**, aplikasi Flutter e-commerce bergaya Shopee/Tokopedia. Baca juga `README.md` (gambaran proyek dan API) dan `DESIGN.md` (design system).

## Perintah

```bash
flutter pub get
flutter analyze          # harus bersih sebelum selesai
flutter test             # seluruh tes
flutter test test/features/product/presentation/bloc/product_list_bloc_test.dart   # satu file
flutter run
```

Setiap perubahan kode harus lolos `flutter analyze` dan `flutter test`. Jika tidak bisa menjalankan Flutter di lingkunganmu, katakan dengan jelas bahwa kode belum dikompilasi.

## Stack

Flutter, Dart `>=3.5.0 <4.0.0`, `flutter_bloc` + `bloc_concurrency`, `dartz` (`Either<Failure, T>`), `dio`, `get_it` (manual), `go_router`, `hive_flutter` (cache), `flutter_secure_storage` (token), `google_fonts` (Inter). Test: `bloc_test`, `mocktail`.

Jangan mengganti paket yang sudah dipilih (misalnya `hive_flutter` ke `hive`) dan jangan menambah code generation (`freezed`, `injectable`, `build_runner`). DI dan JSON sengaja ditulis manual.

### Aturan menambah package

1. **Konfirmasi dulu.** Sebelum memasang package baru, tanyakan ke pemilik proyek: nama package, alasan, dan alternatif yang sudah ada di proyek. Pasang hanya setelah disetujui.
2. **Jangan menulis package langsung di `pubspec.yaml`.** Pasang lewat terminal supaya Flutter memilih versi yang kompatibel dan memperbarui `pubspec.lock`:

```bash
flutter pub add <nama_package>            # dependency
flutter pub add --dev <nama_package>      # dev dependency (tes, lint, tooling)
```

3. Setelah dipasang, jalankan `flutter analyze` dan `flutter test`, lalu sebutkan package dan versi yang terpasang di laporan perubahan.
4. Menghapus package juga lewat `flutter pub remove <nama_package>`.
5. Jika tidak bisa menjalankan terminal Flutter, jangan mengedit `pubspec.yaml` secara manual; tulis perintah yang perlu dijalankan dan minta pemilik proyek menjalankannya.

## Arsitektur

Clean Architecture, feature-first. Alur dependensi satu arah:

```
Page → Bloc → UseCase → Repository (abstract) → RepositoryImpl → DataSource → API
```

```
lib/
├── core/
│   ├── config/          # env.dart (base URL)
│   ├── design_system/   # tokens, theme, components, catalog
│   ├── di/              # injection.dart (get_it)
│   ├── error/           # exceptions, failures, failure_mapper
│   ├── network/         # dio_client, api_endpoints, api_guard, auth_interceptor, session_events
│   ├── router/          # app_router, app_routes
│   ├── storage/         # token_storage
│   ├── usecase/         # UseCase<T, Params>
│   └── utils/           # currency, validators, submission_status
└── features/<fitur>/
    ├── data/            # datasources, models, repositories (impl)
    ├── domain/          # entities, repositories (abstract), usecases
    ├── presentation/    # bloc, pages, widgets
    └── <fitur>_injection.dart
```

Fitur saat ini: `auth`, `product`, `home`, `dashboard`, `profile`. `home` dan `dashboard` hanya presentation (menyusun bloc dari fitur lain).

### Aturan per lapisan
- **domain** murni Dart: tanpa import Flutter, Dio, atau Hive. Entity tidak tahu JSON.
- **data**: model (`fromJson` manual) mengubah JSON menjadi entity. Data source membungkus pemanggilan Dio dengan `guardDio`; repository impl membungkus dengan `guardFailure` sehingga hasilnya `Either<Failure, T>`. Jangan melempar exception ke luar repository.
- **presentation**: Page/widget hanya bicara dengan Bloc, tidak memanggil repository atau data source.
- Pesan error untuk pengguna dalam bahasa Indonesia; ambil `message` dari backend bila ada.

## Alur membuat fitur baru (step by step)

Kerjakan **dari dalam ke luar**: kontrak API → domain → data → DI → bloc → tes → UI → route. Layer dalam tidak bergantung pada layer luar, jadi tiap langkah bisa dites sebelum UI ada. UI selalu dikerjakan terakhir.

Contoh yang bisa ditiru: fitur **detail produk** (`GET /products/:id`). Setiap langkah di bawah menyebut file nyata dari fitur itu. Tanda `<fitur>` di path berarti nama fitur barumu (misalnya `cart`).

### Langkah 0: Pahami kebutuhan dan kontrak API
- Baca endpoint di `API_RESPONSES.md` (Project) atau koleksi Postman: method, path, body, dan **contoh respons asli**. Perhatikan tipe data (`id`/`price` bisa berupa string) dan field yang bisa `null`.
- Tentukan: apakah butuh login? Tampil di tab atau halaman terpisah? Apa saja state-nya (loading, kosong, error)?
- Jika desain atau perilaku belum jelas, **konfirmasi dulu** sebelum menulis kode.

### Langkah 1: Siapkan struktur folder
Fitur baru di `lib/features/<fitur>/`; jika masih bagian dari fitur yang ada (seperti detail produk di `product`), pakai folder fitur itu.

```
lib/features/<fitur>/
├── data/
│   ├── datasources/<fitur>_remote_data_source.dart
│   ├── models/<nama>_model.dart
│   └── repositories/<fitur>_repository_impl.dart
├── domain/
│   ├── entities/<nama>.dart
│   ├── repositories/<fitur>_repository.dart
│   └── usecases/<aksi>_usecase.dart
├── presentation/
│   ├── bloc/<nama>/<nama>_bloc.dart, <nama>_event.dart, <nama>_state.dart
│   ├── pages/<nama>_page.dart
│   └── widgets/
└── <fitur>_injection.dart
```

### Langkah 2: Daftarkan endpoint
`lib/core/network/api_endpoints.dart`: tambah konstanta path. Path dinamis disusun di data source (contoh: `'${ApiEndpoints.products}/${Uri.encodeComponent(id)}'`).

### Langkah 3: Domain (Dart murni, tanpa Flutter/Dio/Hive)
1. **Entity** di `domain/entities/` (contoh: `product_detail.dart`). Field `final`, `const` constructor, `Equatable`.
2. **Repository abstract** di `domain/repositories/`: tambah method yang mengembalikan `Future<Either<Failure, T>>` (contoh: `getProductDetail(String id)` di `product_repository.dart`).
3. **Use case** di `domain/usecases/` yang `implements UseCase<Type, Params>` (contoh: `get_product_detail_usecase.dart`). Satu use case, satu aksi. Tanpa parameter pakai `NoParams`; parameter banyak buat kelas `Params` sendiri.

### Langkah 4: Data
1. **Model** di `data/models/` (contoh: `product_detail_model.dart`): `extends` entity-nya, `fromJson` manual. Tangani string-ke-angka dan field nullable di sini, bukan di UI.
2. **Data source** di `data/datasources/`: abstract + `Impl` yang membungkus Dio dengan `guardDio` (contoh: `product_remote_data_source.dart`). Endpoint auth yang tidak boleh memicu logout global diberi `Options(extra: {AuthInterceptor.skipAuthRedirect: true})`.
3. **Repository impl** di `data/repositories/`: cek `NetworkInfo`, lalu `guardFailure(() => _remote....)` sehingga hasilnya `Either` (contoh: `product_repository_impl.dart`). Jangan melempar exception ke luar.

### Langkah 5: Dependency injection
1. Tambahkan registrasi di `<fitur>_injection.dart` (contoh: `product_injection.dart`):
   - data source, repository, use case → `registerLazySingleton`
   - Bloc → `registerFactory` (satu instance baru per halaman)
2. Fitur baru: buat fungsi `register<Fitur>Dependencies(GetIt sl)` dan panggil di `configureDependencies()` pada `lib/core/di/injection.dart`.

### Langkah 6: Bloc
Di `presentation/bloc/<nama>/`, tiga file dengan `part` (contoh: `product_detail_{bloc,event,state}.dart`):
- **Event**: `sealed` + `Equatable`, nama berbentuk kejadian (`ProductDetailRequested`).
- **State**: satu kelas immutable dengan enum status (`initial/loading/success/failure`), data, dan `errorMessage`; sertakan `copyWith` bila state punya banyak field.
- **Bloc**: constructor dengan initializer list (`: _useCase = useCase`), handler `on<Event>`. Gunakan `restartable()` untuk muat ulang/pencarian dan `droppable()` untuk halaman berikutnya (paket `bloc_concurrency`). `result.fold(...)` mengubah `Failure` menjadi `errorMessage`.

### Langkah 7: Tes untuk layer dalam (sebelum UI)
- `test/features/<fitur>/data/models/<nama>_model_test.dart`: `fromJson` dengan fixture dari dokumentasi API, termasuk kasus `null`.
- `test/features/<fitur>/presentation/bloc/<nama>_bloc_test.dart`: `blocTest` + `mocktail` untuk jalur sukses, gagal, dan muat ulang (contoh: `product_detail_bloc_test.dart`).
- Jalankan `flutter test`. Jika bloc dan model sudah hijau, baru lanjut ke UI.

### Langkah 8: UI
1. **Page** di `presentation/pages/`: sediakan Bloc lewat `BlocProvider(create: (_) => sl<XBloc>()..add(...))`, tampilkan keempat kondisi (loading, error dengan "Coba lagi", kosong, sukses). Gunakan `EmptyState` untuk error/kosong.
2. **Widget** khusus fitur di `presentation/widgets/`. Komponen yang dipakai ulang di banyak fitur masuk `core/design_system/components/` (dan `DESIGN.md`).
3. Pakai token dan komponen design system (lihat `DESIGN.md`); jangan hardcode warna, jarak, atau gaya teks.
4. Aksi yang butuh login: `context.requireLogin(() { ... })`. Halaman yang seluruhnya butuh login: bungkus dengan `AuthRequired`.

### Langkah 9: Route dan navigasi
1. `core/router/app_routes.dart`: tambah konstanta path dan helper (mis. `productDetailPath(id)`).
2. `core/router/app_router.dart`: tambah `GoRoute`. Halaman tanpa bottom nav menjadi route top-level; halaman tab masuk `StatefulShellBranch` (urutan harus sama dengan `DashboardPage._items`).
3. Arahkan dari halaman lain dengan `context.push(AppRoutes.xxxPath(...))`.

### Langkah 10: Verifikasi dan serah terima
- [ ] `flutter analyze` tanpa warning
- [ ] `flutter test` hijau
- [ ] Dijalankan di emulator: jalur sukses, offline, dan error server
- [ ] Mode tamu tidak rusak (tidak ada redirect paksa ke login)
- [ ] Teks besar (text scale) tidak membuat layout overflow
- [ ] `README.md` (endpoint yang kini dipakai) dan `DESIGN.md` (jika ada komponen baru) diperbarui
- [ ] Laporan perubahan: file apa di folder apa, bagian mana yang berubah

### Ringkasan urutan
```
0 Kontrak API → 1 Folder → 2 Endpoint → 3 Domain → 4 Data → 5 DI
→ 6 Bloc → 7 Tes → 8 UI → 9 Route → 10 Verifikasi
```

### Kesalahan umum
- Mengerjakan UI dulu lalu memaksa bentuk data mengikutinya. Mulai dari kontrak API dan entity.
- Memanggil data source atau Dio dari Page. Selalu lewat Bloc → use case.
- Lupa mendaftarkan di `*_injection.dart` (error `GetIt: Object not registered`) atau lupa memanggil fungsi registrasi fitur baru di `injection.dart`.
- Mendaftarkan Bloc sebagai singleton. Pakai `registerFactory`.
- Memakai `any()` untuk argumen `String` pada `mocktail`; stub dengan nilai eksplisit.
- Mengurai JSON di UI atau lupa menangani field `null`/string-angka di model.

## Konvensi kode

- **Gaya konstruktor:** pertahankan gaya asli, yaitu field private diisi lewat initializer list (`Foo(Bar bar) : _bar = bar;`). Jangan diubah ke `this._bar` kecuali diminta.
- **Bloc:** event dan state `sealed` dengan `part`. Pakai `restartable()` untuk event muat ulang/pencarian, `droppable()` untuk halaman berikutnya. Gunakan bound pattern (`case Foo(field: final x)`) pada `switch`, jangan mengandalkan type promotion dari scrutinee.
- **State:** immutable, dengan `copyWith`; status berupa enum (`initial/loading/success/failure`).
- **Navigasi:** `go_router`. Gunakan helper di `AppRoutes` (`productDetailPath(id)`, `searchPath(query)`), jangan menulis string path langsung. Tab dashboard memakai `StatefulShellRoute.indexedStack`; urutan branch harus sama dengan `DashboardPage._items`.
- **Void ternary** dihindari; pakai `if/else`.
- Komentar dan dokumentasi dalam bahasa Indonesia, identifier dalam bahasa Inggris.

## Perilaku aplikasi yang harus dijaga

- **Mode tamu:** aplikasi langsung terbuka di Beranda tanpa login. Jangan menambah redirect paksa ke login.
- Halaman yang butuh login (Pesanan, Notifikasi, Profil, Keranjang) dibungkus `AuthRequired`. Aksi yang butuh login (Keranjang, Beli Sekarang) memakai `context.requireLogin(...)`. Login dari halaman lain memakai `/login?return=1` dan kembali ke halaman sebelumnya.
- **Pencarian:** hanya berjalan saat pengguna menekan tombol cari di keyboard (`onSubmitted`), bukan `onChanged`. Hasil tampil di halaman khusus `/search`.
- **Infinite scroll:** `ProductListBloc.pageSize = 10`; dipicu `ProductListScrollTrigger` (sisa scroll < 400 px, arah vertikal saja).
- Bottom nav 4 tab: Beranda, Pesanan, Notifikasi, Profil. Keranjang ada di header Beranda.
- Header Beranda (sapaan, keranjang, kolom cari) sticky lewat `SliverAppBar(pinned: true)`.
- Token disimpan di `flutter_secure_storage`; 401 memicu logout lewat `SessionEvents`, kecuali permintaan yang diberi `AuthInterceptor.skipAuthRedirect`.

## Kontrak API

Base URL `https://ecommerce-backend-api-nu.vercel.app/api`. Dokumentasi lengkap ada di Project (`API_RESPONSES.md`, koleksi Postman). Hal yang sering salah:

- Login mengembalikan `data.{user, token}`. **Register hanya mengembalikan user, tanpa token.**
- `GET /auth/me` untuk memulihkan sesi. Tidak ada refresh token dan tidak ada endpoint logout.
- `GET /products`: query `search`, `category_id`, `page`, `limit`; respons `data[]` + `pagination`. `id` dan `price` berupa **string**, `stock` berupa angka.
- `GET /products/:id`: `data` berisi `description`, `category_id`, `category_name`.
- `GET /categories`: `icon_url` bisa `null` (sudah ada ikon fallback).
- Cart dan Orders sudah ada di API tetapi belum dipakai.

## Design system

Rincian lengkap ada di `DESIGN.md`. Ringkasnya:

- Import `core/design_system/design_system.dart`; pakai komponen yang ada (`AppButton`, `AppTextField`, `AppSearchField`, `ProductCard`, `EmptyState`, dst.) sebelum membuat baru.
- Warna dari `Theme.of(context).colorScheme` atau `context.appColors`, bukan `AppColors` langsung. Jarak, radius, bayangan dari `AppSpacing`, `AppRadius`, `AppShadows`. Teks dari `textTheme`.
- Teks putih di atas secondary memakai `secondary600` (kontras); `secondary500` hanya untuk dekorasi.
- Komponen baru ikut ditambahkan ke `catalog/component_catalog_page.dart` dan `DESIGN.md`.

## Testing

- Struktur tes mencerminkan `lib/` (`test/features/<fitur>/...`).
- Bloc: `blocTest` + `mocktail`. Untuk argumen `String`, stub dengan nilai eksplisit (`when(() => useCase('5'))`), bukan `any()`. Untuk params custom, daftarkan `registerFallbackValue`.
- Model: tes `fromJson` dengan fixture yang disalin dari `API_RESPONSES.md`. Pada string Dart non-raw, tulis newline sebagai `\\n`.
- Setiap perubahan perilaku Bloc, model, atau repository disertai tes.

## Cara bekerja

- Ubah hanya file yang diperlukan. Saat melaporkan hasil, sebutkan file apa di folder apa dan bagian mana yang berubah. Jangan membuat zip untuk perubahan kecil.
- Jika permintaan ambigu atau bertabrakan dengan aturan di atas, konfirmasi dulu sebelum membangun.
- Jangan menyentuh atau menghapus berkas pengguna di luar cakupan tugas. Hapus file hanya jika memang digantikan (sebutkan dengan jelas di laporan).
- Package baru: konfirmasi dulu, lalu pasang dengan `flutter pub add` (lihat "Aturan menambah package").
- Jangan menaruh secret atau token di kode. Konfigurasi lingkungan lewat `core/config/env.dart`.
- Fitur yang masih stub (Keranjang, Beli Sekarang, halaman Pesanan/Notifikasi/Keranjang) diberi komentar `TODO(<fitur>)`; jangan berpura-pura sudah berfungsi.

## Belum ada

Dark theme, keranjang dan pesanan sungguhan, badge keranjang di header, favorit, ulasan, kupon/diskon, dan notifikasi.
