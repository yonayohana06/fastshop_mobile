import 'dart:convert';

import 'package:fastshop_mobile/features/product/data/models/product_detail_model.dart';
import 'package:flutter_test/flutter_test.dart';

// Contoh JSON di bawah disalin dari API_RESPONSES.md (`GET /products/:id`).
void main() {
  group('ProductDetailModel.fromJson', () {
    test('mem-parse isi data dari GET /products/:id', () {
      final json = jsonDecode('''
      {
        "id": "5",
        "name": "T-Shirt Polos - Hitam",
        "description": "Kaos polos warna hitam\\n\\nBahan : Katun 100%",
        "price": "120000",
        "stock": 200,
        "image_url": "https://images.unsplash.com/photo-1657364890995",
        "category_id": 12,
        "category_name": "T-Shirt"
      }
      ''') as Map<String, dynamic>;

      final product = ProductDetailModel.fromJson(json);

      expect(product.id, '5');
      expect(product.name, 'T-Shirt Polos - Hitam');
      expect(
        product.description,
        'Kaos polos warna hitam\n\nBahan : Katun 100%',
      );
      expect(product.price, 120000);
      expect(product.stock, 200);
      expect(product.categoryId, 12);
      expect(product.categoryName, 'T-Shirt');
      expect(product.isOutOfStock, isFalse);
    });

    test('field opsional null tidak membuat parsing gagal', () {
      final product = ProductDetailModel.fromJson({
        'id': 7,
        'name': 'Celana Jins',
        'price': '285000',
        'stock': 0,
        'description': null,
        'image_url': null,
        'category_id': null,
        'category_name': null,
      });

      expect(product.id, '7');
      expect(product.description, isNull);
      expect(product.imageUrl, isNull);
      expect(product.categoryId, isNull);
      expect(product.isOutOfStock, isTrue);
    });
  });
}
