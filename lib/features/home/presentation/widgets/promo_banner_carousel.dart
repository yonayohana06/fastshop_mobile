import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/design_system/design_system.dart';
import '../dummy/promo_banners.dart';

/// Carousel banner promo berupa gambar, dengan indikator titik dan
/// perpindahan otomatis.
class PromoBannerCarousel extends StatefulWidget {
  const PromoBannerCarousel({
    super.key,
    this.banners = kDummyPromoBanners,
    this.autoPlayInterval = const Duration(seconds: 4),
  });

  final List<PromoBanner> banners;
  final Duration autoPlayInterval;

  @override
  State<PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<PromoBannerCarousel> {
  final _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    if (widget.banners.length > 1) {
      _timer = Timer.periodic(widget.autoPlayInterval, (_) => _advance());
    }
  }

  void _advance() {
    // Tab Beranda yang sedang tidak tampil (IndexedStack) tidak perlu beranimasi.
    if (!mounted || !_controller.hasClients || !TickerMode.of(context)) return;

    final next = (_index + 1) % widget.banners.length;
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.banners;
    if (banners.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 2.1,
          child: PageView.builder(
            controller: _controller,
            itemCount: banners.length,
            onPageChanged: (index) => setState(() => _index = index),
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: _BannerImage(banner: banners[index]),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var i = 0; i < banners.length; i++)
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _index ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _index
                      ? AppColors.primary500
                      : AppColors.neutral300,
                  borderRadius: AppRadius.pill,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _BannerImage extends StatelessWidget {
  const _BannerImage({required this.banner});

  final PromoBanner banner;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: banner.semanticLabel,
      child: ClipRRect(
        borderRadius: AppRadius.lgAll,
        child: Image.network(
          banner.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          loadingBuilder: (context, child, progress) =>
              progress == null ? child : const _BannerPlaceholder(),
          errorBuilder: (context, error, stackTrace) => const _BannerPlaceholder(
            icon: Icons.image_not_supported_outlined,
          ),
        ),
      ),
    );
  }
}

class _BannerPlaceholder extends StatelessWidget {
  const _BannerPlaceholder({this.icon = Icons.image_outlined});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.primary50,
      child: Center(child: Icon(icon, size: 36, color: AppColors.primary300)),
    );
  }
}
