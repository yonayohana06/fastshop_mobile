import 'package:flutter/material.dart';

import '../design_system.dart';

/// Halaman katalog internal (hanya debug) untuk melihat semua token dan
/// komponen beserta state-nya tanpa harus menjalankan alur aplikasi.
class ComponentCatalogPage extends StatefulWidget {
  const ComponentCatalogPage({super.key});

  @override
  State<ComponentCatalogPage> createState() => _ComponentCatalogPageState();
}

class _ComponentCatalogPageState extends State<ComponentCatalogPage> {
  int _quantity = 1;
  int _navIndex = 0;
  bool _favorite = false;
  bool _filterSelected = true;

  static const _navItems = [
    AppNavItem(
      label: 'Beranda',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    AppNavItem(
      label: 'Pesanan',
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
    ),
    AppNavItem(
      label: 'Diskon',
      icon: Icons.local_offer_outlined,
      selectedIcon: Icons.local_offer,
      badgeCount: 3,
    ),
    AppNavItem(
      label: 'Notifikasi',
      icon: Icons.notifications_outlined,
      selectedIcon: Icons.notifications,
      badgeCount: 2,
    ),
    AppNavItem(
      label: 'Profil',
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colors = context.appColors;

    final typography = <(String, TextStyle?)>[
      ('Headline Medium', textTheme.headlineMedium),
      ('Headline Small', textTheme.headlineSmall),
      ('Title Large', textTheme.titleLarge),
      ('Title Medium', textTheme.titleMedium),
      ('Title Small', textTheme.titleSmall),
      ('Body Large', textTheme.bodyLarge),
      ('Body Medium', textTheme.bodyMedium),
      ('Body Small', textTheme.bodySmall),
      ('Label Large', textTheme.labelLarge),
      ('Label Medium', textTheme.labelMedium),
      ('Label Small', textTheme.labelSmall),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Komponen')),
      bottomNavigationBar: AppBottomNavBar(
        items: _navItems,
        currentIndex: _navIndex,
        onTap: (index) => setState(() => _navIndex = index),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          _Section(
            title: 'Warna',
            child: Column(
              children: const [
                _SwatchRow(
                  name: 'Primary #287361',
                  shades: [
                    ('50', AppColors.primary50),
                    ('100', AppColors.primary100),
                    ('200', AppColors.primary200),
                    ('300', AppColors.primary300),
                    ('400', AppColors.primary400),
                    ('500', AppColors.primary500),
                    ('600', AppColors.primary600),
                    ('700', AppColors.primary700),
                    ('800', AppColors.primary800),
                    ('900', AppColors.primary900),
                  ],
                ),
                _SwatchRow(
                  name: 'Secondary #C36433',
                  shades: [
                    ('50', AppColors.secondary50),
                    ('100', AppColors.secondary100),
                    ('200', AppColors.secondary200),
                    ('300', AppColors.secondary300),
                    ('400', AppColors.secondary400),
                    ('500', AppColors.secondary500),
                    ('600', AppColors.secondary600),
                    ('700', AppColors.secondary700),
                    ('800', AppColors.secondary800),
                    ('900', AppColors.secondary900),
                  ],
                ),
                _SwatchRow(
                  name: 'Neutral',
                  shades: [
                    ('0', AppColors.neutral0),
                    ('50', AppColors.neutral50),
                    ('100', AppColors.neutral100),
                    ('200', AppColors.neutral200),
                    ('300', AppColors.neutral300),
                    ('400', AppColors.neutral400),
                    ('500', AppColors.neutral500),
                    ('600', AppColors.neutral600),
                    ('700', AppColors.neutral700),
                    ('900', AppColors.neutral900),
                  ],
                ),
              ],
            ),
          ),
          _Section(
            title: 'Tipografi (Inter)',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final (name, style) in typography)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('$name - Belanja lebih cepat', style: style),
                  ),
              ],
            ),
          ),
          _Section(
            title: 'Tombol',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppButton(label: 'Primary', onPressed: () {}),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Secondary',
                  variant: AppButtonVariant.secondary,
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Outline',
                  variant: AppButtonVariant.outline,
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Text',
                  variant: AppButtonVariant.text,
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Dengan ikon',
                  icon: Icons.shopping_cart_outlined,
                  onPressed: () {},
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(label: 'Loading', isLoading: true, onPressed: () {}),
                const SizedBox(height: AppSpacing.sm),
                const AppButton(label: 'Disabled', onPressed: null),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Ulas Produk',
                        size: AppButtonSize.small,
                        variant: AppButtonVariant.outline,
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: AppButton(
                        label: 'Detail Pesanan',
                        size: AppButtonSize.small,
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const _Section(
            title: 'Input',
            child: Column(
              children: [
                AppSearchField(),
                SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Email',
                  hint: 'nama@email.com',
                  prefixIcon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: AppSpacing.md),
                AppTextField(
                  label: 'Password',
                  prefixIcon: Icons.lock_outline,
                  obscureText: true,
                ),
              ],
            ),
          ),
          _Section(
            title: 'Chip, badge, dan status',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  children: [
                    FilterChip(
                      label: const Text('Tanggal'),
                      selected: _filterSelected,
                      onSelected: (value) =>
                          setState(() => _filterSelected = value),
                    ),
                    FilterChip(
                      label: const Text('Status'),
                      selected: false,
                      onSelected: (_) {},
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                const Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    DiscountBadge(percent: 20),
                    StatusChip(
                      label: 'Terkirim',
                      tone: StatusTone.success,
                      icon: Icons.check_circle_outline,
                    ),
                    StatusChip(
                      label: 'Dikirim',
                      tone: StatusTone.info,
                      icon: Icons.local_shipping_outlined,
                    ),
                    StatusChip(label: 'Menunggu', tone: StatusTone.warning),
                    StatusChip(label: 'Dibatalkan', tone: StatusTone.error),
                    StatusChip(label: 'Draf'),
                  ],
                ),
              ],
            ),
          ),
          _Section(
            title: 'Harga, rating, jumlah',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PriceText(price: 1250000, originalPrice: 1560000),
                const SizedBox(height: AppSpacing.sm),
                const PriceText(
                  price: 1250000,
                  originalPrice: 1560000,
                  large: true,
                ),
                const SizedBox(height: AppSpacing.md),
                const RatingLabel(
                  rating: 4.8,
                  caption: '4,8 rb ulasan - 6,2 rb terjual',
                ),
                const SizedBox(height: AppSpacing.md),
                QuantityStepper(
                  value: _quantity,
                  onChanged: (value) => setState(() => _quantity = value),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Kartu produk',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ProductCard(
                    name: 'Sepatu Sneakers Hijau Super',
                    price: 1250000,
                    originalPrice: 1560000,
                    discountPercent: 20,
                    rating: 4.8,
                    caption: '4,8 rb ulasan',
                    isFavorite: _favorite,
                    onFavoriteTap: () =>
                        setState(() => _favorite = !_favorite),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                const Expanded(
                  child: ProductCard(
                    name: 'Sepatu Sneakers Putih',
                    price: 780000,
                    originalPrice: 870000,
                    discountPercent: 10,
                    rating: 4.6,
                    caption: '2,3 rb ulasan',
                  ),
                ),
              ],
            ),
          ),
          _Section(
            title: 'Kartu pesanan (contoh AppCard)',
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('#S155421', style: textTheme.titleSmall),
                      const StatusChip(
                        label: 'Terkirim',
                        tone: StatusTone.success,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Dipesan 26 Oktober 2025',
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const _Section(
            title: 'Empty state',
            child: SizedBox(
              height: 280,
              child: EmptyState(
                icon: Icons.shopping_cart_outlined,
                title: 'Keranjang masih kosong',
                message: 'Yuk, mulai belanja produk favoritmu.',
                actionLabel: 'Mulai Belanja',
                onAction: _noop,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void _noop() {}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          child,
        ],
      ),
    );
  }
}

class _SwatchRow extends StatelessWidget {
  const _SwatchRow({required this.name, required this.shades});

  final String name;
  final List<(String, Color)> shades;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: textTheme.labelLarge),
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              for (final (label, color) in shades)
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        height: 36,
                        decoration: BoxDecoration(
                          color: color,
                          border: Border.all(color: AppColors.neutral200),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(label, style: textTheme.labelSmall),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
