import 'dart:convert';

import 'package:fastshop_mobile/features/product/data/models/product_category_model.dart';
import 'package:fastshop_mobile/features/product/data/models/product_model.dart';
import 'package:fastshop_mobile/features/product/data/models/product_page_model.dart';
import 'package:flutter_test/flutter_test.dart';

// Contoh JSON di bawah disalin dari API_RESPONSES.md.
void main() {
  group('ProductPageModel.fromJson', () {
    test('mem-parse respons GET /products beserta pagination', () {
      final json = jsonDecode('''
      {
        "code": 200,
        "message": "Berhasil mengambil daftar produk",
        "data": [
          {
            "id": "13",
            "name": "Sepatu Lari Cowok Mizuno Wave Rider",
            "price": "235000",
            "stock": 299,
            "image_url": "https://images.unsplash.com/photo-1",
            "category_name": "Sepatu"
          },
          {
            "id": "1",
            "name": "Sepatu Running Nike",
            "price": "1250000",
            "stock": 14,
            "image_url": "https://images.unsplash.com/photo-2",
            "category_name": "Fashion Pria"
          }
        ],
        "pagination": {
          "currentPage": 1,
          "limit": 15,
          "totalItems": 11,
          "totalPages": 1,
          "hasPreviousPage": false,
          "hasNextPage": false
        }
      }
      ''') as Map<String, dynamic>;

      final page = ProductPageModel.fromJson(json);

      expect(page.products, hasLength(2));
      expect(page.products.first.id, '13');
      expect(page.products.first.price, 235000);
      expect(page.products.first.stock, 299);
      expect(page.products.first.categoryName, 'Sepatu');
      expect(page.currentPage, 1);
      expect(page.totalPages, 1);
      expect(page.totalItems, 11);
      expect(page.hasNextPage, isFalse);
    });
  });

  group('ProductModel.fromJson', () {
    test('stok 0 ditandai habis', () {
      final product = ProductModel.fromJson({
        'id': '5',
        'name': 'T-Shirt Polos - Hitam',
        'price': '120000',
        'stock': 0,
        'image_url': null,
        'category_name': 'T-Shirt',
      });

      expect(product.isOutOfStock, isTrue);
      expect(product.imageUrl, isNull);
    });

    test('harga yang tidak bisa di-parse melempar FormatException', () {
      expect(
        () => ProductModel.fromJson({
          'id': '5',
          'name': 'T-Shirt',
          'price': 'abc',
          'stock': 1,
        }),
        throwsFormatException,
      );
    });
  });

  group('ProductCategoryModel.fromJson', () {
    test('mem-parse kategori dengan icon_url null', () {
      final category = ProductCategoryModel.fromJson({
        'id': 2,
        'name': 'Fashion Pria',
        'slug': 'fashion-pria',
        'icon_url': null,
        'created_at': '2026-09-11T16:13:04.601Z',
        'product_count': 3,
      });

      expect(category.id, 2);
      expect(category.name, 'Fashion Pria');
      expect(category.productCount, 3);
      expect(category.iconUrl, isNull);
    });
  });
}
