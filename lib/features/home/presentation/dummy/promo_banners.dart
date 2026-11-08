/// Banner promo.
///
/// DUMMY: gambar diambil dari Unsplash (foto yang sama dengan data produk di
/// API) dan dimuat lewat internet saat app berjalan, tidak dibundel di app.
/// TODO: ganti dengan data dari API saat endpoint banner tersedia.
class PromoBanner {
  const PromoBanner({required this.imageUrl, required this.semanticLabel});

  final String imageUrl;

  /// Deskripsi gambar untuk pembaca layar.
  final String semanticLabel;
}

const List<PromoBanner> kDummyPromoBanners = [
  PromoBanner(
    imageUrl:
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=1200&auto=format&fit=crop&q=70',
    semanticLabel: 'Promo sepatu lari',
  ),
  PromoBanner(
    imageUrl:
        'https://images.unsplash.com/photo-1718781412866-3b6b465ddb1e?w=1200&auto=format&fit=crop&q=70',
    semanticLabel: 'Promo sepatu sporty',
  ),
  PromoBanner(
    imageUrl:
        'https://images.unsplash.com/photo-1717127036020-83774f354008?w=1200&auto=format&fit=crop&q=70',
    semanticLabel: 'Promo fashion pria',
  ),
  PromoBanner(
    imageUrl:
        'https://images.unsplash.com/photo-1718252540511-e958742e4165?w=1200&auto=format&fit=crop&q=70',
    semanticLabel: 'Promo celana jeans',
  ),
];
