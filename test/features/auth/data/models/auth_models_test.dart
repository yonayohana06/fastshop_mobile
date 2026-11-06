import 'dart:convert';

import 'package:fastshop_mobile/features/auth/data/models/auth_response_model.dart';
import 'package:fastshop_mobile/features/auth/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

// Contoh JSON di bawah disalin dari API_RESPONSES.md (token dipersingkat).
void main() {
  group('AuthResponseModel.fromJson', () {
    test('mem-parse respons POST /auth/login', () {
      final json = jsonDecode('''
      {
        "code": 200,
        "message": "Login berhasil",
        "data": {
          "user": {
            "id": "2",
            "name": "Agus Sumanto",
            "email": "agussumanto@example.com",
            "role": "user"
          },
          "token": "jwt.token.value"
        }
      }
      ''') as Map<String, dynamic>;

      final model = AuthResponseModel.fromJson(json);

      expect(model.accessToken, 'jwt.token.value');
      expect(model.user.id, '2');
      expect(model.user.name, 'Agus Sumanto');
      expect(model.user.email, 'agussumanto@example.com');
      expect(model.user.role, 'user');
      expect(model.user.phoneNumber, isNull);
    });
  });

  group('UserModel.fromJson', () {
    test('id berupa angka (respons register) dinormalisasi menjadi string', () {
      final json = jsonDecode('''
      {
        "id": 2,
        "name": "Agus Sumanto",
        "email": "agussumanto@example.com",
        "role": "user"
      }
      ''') as Map<String, dynamic>;

      expect(UserModel.fromJson(json).id, '2');
    });

    test('mem-parse profil GET /auth/me beserta phone_number', () {
      final json = jsonDecode('''
      {
        "id": "2",
        "name": "Agus Sumanto",
        "email": "agussumanto@example.com",
        "phone_number": "081234567890",
        "role": "user",
        "created_at": "2026-09-11T15:45:31.193Z"
      }
      ''') as Map<String, dynamic>;

      final user = UserModel.fromJson(json);

      expect(user.phoneNumber, '081234567890');
    });

    test('toJson lalu fromJson menghasilkan objek yang sama (cache Hive)', () {
      const user = UserModel(
        id: '2',
        name: 'Agus Sumanto',
        email: 'agussumanto@example.com',
        role: 'user',
      );

      expect(UserModel.fromJson(user.toJson()), user);
    });
  });
}
