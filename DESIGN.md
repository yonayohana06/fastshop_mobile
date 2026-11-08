# FastShop Design System

Dokumen ini menjelaskan design system FastShop sebagaimana ada di kode (`lib/core/design_system/`). Nilai di sini disalin dari token; jika kode berubah, perbarui dokumen ini.

- **Platform:** Flutter, Material 3 (`useMaterial3: true`), mode terang saja (belum ada dark theme)
- **Gaya:** bersih dan terang, latar abu sangat muda, kartu putih berborder tipis, sudut membulat, bayangan minim. Mengacu pada desain toko sepatu (Home, Product Detail, Cart, Orders, Discount, Notifications).
- **Brand:** primary `#287361` (hijau teal), secondary `#C36433` (terracotta)

## 1. Struktur folder

```
lib/core/design_system/
├── design_system.dart          # barrel export, import ini saja
├── tokens/                     # nilai mentah
│   ├── app_colors.dart
│   ├── app_spacing.dart
│   ├── app_radius.dart
│   ├── app_shadows.dart
│   └── app_typography.dart
├── theme/
│   ├── app_theme.dart          # ThemeData (ColorScheme + tema komponen Material)
│   └── fastshop_colors.dart    # ThemeExtension: warna semantik & e-commerce
├── components/                 # komponen reusable
└── catalog/
    └── component_catalog_page.dart   # katalog visual (/design-system, hanya debug)
```

## 2. Prinsip pemakaian

1. Widget tidak memakai `AppColors` langsung untuk warna semantik. Pakai `Theme.of(context).colorScheme` atau `context.appColors`.
2. Jarak, radius, dan bayangan selalu dari token (`AppSpacing`, `AppRadius`, `AppShadows`), bukan angka literal.
3. Teks selalu dari `Theme.of(context).textTheme`.
4. Warna tidak menjadi satu-satunya penanda status; sertakan ikon atau label (misalnya `StatusChip`).
5. Target sentuh minimal 48 px untuk tombol utama; tinggi bottom nav 64 px.
6. Layout harus tetap aman saat ukuran teks sistem diperbesar (header Beranda menskalakan tinggi dengan text scale yang dibatasi).

## 3. Warna

### 3.1 Primary
| Token | Hex |
|---|---|
| primary50 | `#EEF4F2` |
| primary100 | `#DDE9E6` |
| primary200 | `#BAD2CC` |
| primary300 | `#94B9B0` |
| primary400 | `#5E9688` |
| **primary500 (primary)** | `#287361` |
| primary600 | `#226252` |
| primary700 | `#1C5044` |
| primary800 | `#163F35` |
| primary900 | `#102E27` |

### 3.2 Secondary
| Token | Hex |
|---|---|
| secondary50 | `#FAF3EF` |
| secondary100 | `#F5E6DE` |
| secondary200 | `#ECCDBE` |
| secondary300 | `#E1B299` |
| secondary400 | `#D28B66` |
| **secondary500 (secondary)** | `#C36433` |
| secondary600 | `#A6552B` |
| secondary700 | `#884624` |
| secondary800 | `#6B371C` |
| secondary900 | `#4E2814` |

### 3.3 Neutral
| Token | Hex | Peran |
|---|---|---|
| neutral0 | `#FFFFFF` | permukaan kartu, AppBar |
| neutral50 | `#F6F7F8` | latar halaman |
| neutral100 | `#EEF0F2` | permukaan redup (`surfaceMuted`) |
| neutral200 | `#E4E7EA` | border, divider |
| neutral300 | `#CDD2D7` | |
| neutral400 | `#A3ABB3` | |
| neutral500 | `#6B7480` | hint (4,74:1 di putih) |
| neutral600 | `#5B6470` | teks sekunder (6,0:1) |
| neutral700 | `#3E454D` | |
| neutral800 | `#2A2F35` | |
| neutral900 | `#1C1F23` | teks utama (16,5:1) |

### 3.4 Semantik
| Peran | Utama (ikon/border) | Container | Teks di container |
|---|---|---|---|
| success | `#2E9E5B` | `#E3F5EA` | `#17663A` |
| warning | `#F5A524` | `#FFF3DC` | `#8A5A00` |
| info | `#2F80ED` | `#E4EEFD` | `#1B54A8` |
| error | `#D92D3A` | `#FDE8E9` | `#A12027` |

### 3.5 E-commerce
| Token | Nilai | Catatan |
|---|---|---|
| discount | `#D92D3A` (= error) | latar `DiscountBadge`, teks `onDiscount` putih |
| rating | `#FFB400` | hanya untuk ikon bintang |

### 3.6 Kontras (WCAG AA, 4,5:1 untuk teks kecil)
- Putih di atas primary500 = 5,65:1, aman.
- Putih di atas secondary500 = 4,05:1, **tidak cukup** untuk teks kecil. Pakai secondary600 (5,31:1) untuk tombol dan teks. secondary500 hanya untuk aksen dekoratif (banner, ikon, ilustrasi).
- Putih di atas error = 4,79:1.

### 3.7 Cara mengakses
```dart
Theme.of(context).colorScheme.primary      // warna Material
context.appColors.success                  // ThemeExtension FastShopColors
context.appColors.textSecondary            // neutral600
context.appColors.border                   // neutral200
```
Isi `FastShopColors`: success, warning, info (masing-masing dengan container dan on-container), discount, onDiscount, rating, border, textSecondary, textHint, surfaceMuted.

## 4. Tipografi

Font **Inter** lewat `google_fonts`. Untuk produksi/offline, bundel font ke assets dan set `GoogleFonts.config.allowRuntimeFetching = false`.

| Style | Ukuran | Berat | Line height |
|---|---|---|---|
| displayLarge | 40 | 700 | 1.2 |
| displayMedium | 34 | 700 | 1.2 |
| displaySmall | 28 | 700 | 1.25 |
| headlineLarge | 26 | 700 | 1.25 |
| headlineMedium | 24 | 700 | 1.3 |
| headlineSmall | 20 | 700 | 1.3 |
| titleLarge | 18 | 600 | 1.35 |
| titleMedium | 16 | 600 | 1.4 |
| titleSmall | 14 | 600 | 1.4 |
| bodyLarge | 16 | 400 | 1.5 |
| bodyMedium | 14 | 400 | 1.5 |
| bodySmall | 12 | 400 | 1.4 |
| labelLarge | 14 | 600 | 1.4 |
| labelMedium | 12 | 600 | 1.35 |
| labelSmall | 10 | 600 | 1.3 |

Teks utama `neutral900`; teks sekunder `context.appColors.textSecondary`.

## 5. Spacing (kelipatan 4)

| Token | px |
|---|---|
| xs | 4 |
| sm | 8 |
| md | 12 |
| lg | 16 |
| xl | 24 |
| xxl | 32 |
| xxxl | 40 |

Gutter halaman standar: `lg` (16).

## 6. Radius

| Token | px | Pemakaian umum |
|---|---|---|
| sm | 8 | chip kecil, badge |
| md | 12 | tombol, input, kartu, snackbar |
| lg | 16 | gambar produk, banner |
| xl | 24 | sheet |
| pill | 999 | search field, indikator, lingkaran |

## 7. Bayangan

| Token | Definisi | Pemakaian |
|---|---|---|
| soft | hitam 6%, blur 12, offset (0, 2) | elemen melayang (bottom bar, sheet) |
| raised | hitam 10%, blur 20, offset (0, 6) | elemen terangkat |

Kartu biasa memakai border `neutral200`, bukan bayangan.

## 8. Tema Material (`app_theme.dart`)

- `ColorScheme.fromSeed` dengan seed primary; `scaffoldBackgroundColor` = neutral50
- AppBar: `elevation: 0`
- Tombol (Filled/Outlined): sudut `md`
- Chip, Divider, SnackBar (sudut `md`) mengikuti token
- NavigationBar: tinggi 64, `elevation: 0`

## 9. Komponen

| Komponen | File | Fungsi | Parameter utama |
|---|---|---|---|
| `AppButton` | `app_button.dart` | Tombol | `variant` (primary, secondary, outline, text), `size` (medium 48 px, small 36 px), `icon`, `isLoading`, `expanded` |
| `AppTextField` | `app_text_field.dart` | Input form dengan label, validasi, toggle tampil password | `label`, `validator`, `obscureText`, `autofillHints`, `prefixIcon` |
| `AppSearchField` | `app_search_field.dart` | Kolom cari berbentuk pill | `hint` (default "Cari produk"), `controller`, `onChanged`, `onSubmitted` |
| `AppCard` | `app_card.dart` | Kartu putih berborder | `child`, `padding` (default 12), `onTap` |
| `DiscountBadge` | `app_badge.dart` | Lencana diskon merah | `percent` |
| `StatusChip` | `app_badge.dart` | Chip status | `label`, `tone` (success, info, warning, error, neutral), `icon` |
| `QuantityStepper` | `quantity_stepper.dart` | Tombol tambah/kurang jumlah | `value`, `onChanged`, `min` (1), `max` (99) |
| `RatingLabel` | `rating_label.dart` | Bintang + nilai + keterangan | `rating`, `caption` |
| `PriceText` | `price_text.dart` | Harga (format rupiah) dengan harga coret opsional | `price`, `originalPrice`, `large` |
| `ProductCard` | `product_card.dart` | Kartu produk grid | `name`, `price`, `imageUrl`, `subtitle`, `originalPrice`, `discountPercent`, `rating`, `caption`, `soldOut`, `isFavorite`, `onFavoriteTap`, `onTap` |
| `AppBottomNavBar` | `app_bottom_nav_bar.dart` | Navigasi bawah, border atas tipis, dukung badge | `items` (`AppNavItem`: label, icon, selectedIcon, badgeCount), `currentIndex`, `onTap` |
| `EmptyState` | `empty_state.dart` | Kondisi kosong/error/ajakan masuk | `icon`, `title`, `message`, `actionLabel`/`onAction`, `secondaryActionLabel`/`onSecondaryAction` |

Katalog visual semua komponen ada di rute `/design-system` (hanya mode debug), tersedia lewat tombol di halaman login.

### Aturan khusus
- Tombol berwarna secondary memakai **secondary600** agar kontras teks memenuhi AA.
- `soldOut` pada `ProductCard` menonaktifkan interaksi dan menandai stok habis.
- `ProductCard` menampilkan placeholder jika `imageUrl` kosong atau gagal dimuat.

## 10. Pola layar

**Navigasi:** bottom nav 4 tab (Beranda, Pesanan, Notifikasi, Profil). Keranjang ada di header Beranda, bukan di bottom nav.

**Beranda (urutan section):**
1. Header sticky: sapaan, tombol keranjang (outline), lalu `AppSearchField`. Header dan kolom cari tetap menempel saat scroll.
2. Banner promo: carousel gambar, lebar 92% viewport, rasio 2,1, geser otomatis tiap 4 detik, indikator titik.
3. Kategori: ikon bulat 56 px dengan label; "Semua" di awal; yang terpilih memakai gaya primary.
4. Produk Pilihan: grid `ProductCard`, infinite scroll 10 item per halaman.

**Pencarian:** hanya berjalan saat pengguna menekan tombol cari di keyboard (bukan auto search), lalu membuka halaman hasil dengan infinite scroll 10 item per halaman.

**Detail produk:** gambar (rasio 1,1, sudut `lg`), harga besar, nama, kategori dan chip stok, kartu deskripsi, dan bar aksi bawah (Keranjang outline, Beli Sekarang primary; nonaktif jika stok habis).

**Halaman butuh login (tamu):** `EmptyState` dengan tombol Masuk dan Daftar.

**Status data:** loading (spinner/placeholder), error (`EmptyState` dengan "Coba lagi"), kosong (`EmptyState`), memuat halaman berikutnya (footer spinner; jika gagal, tombol "coba lagi").

## 11. Belum ada / rencana

- Dark theme (`FastShopColors.light` saja)
- Badge angka pada ikon keranjang dan ikon surat di header (ada di referensi, belum ada fiturnya)
- Komponen untuk halaman Pesanan, Notifikasi, Diskon/Kupon, dan Keranjang (kartu pesanan, chip filter, kartu kupon, dll.)
- Font dibundel sebagai aset
