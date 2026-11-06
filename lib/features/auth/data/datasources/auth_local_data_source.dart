import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveSession({
    required String accessToken,
    required UserModel user,
  });

  Future<String?> getAccessToken();

  Future<UserModel?> getCachedUser();

  /// Memperbarui cache user (mis. setelah `GET /auth/me`) tanpa menyentuh token.
  Future<void> cacheUser(UserModel user);

  Future<void> clearSession();
}

/// Token disimpan di secure storage, data user di-cache di Hive.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl({
    required TokenStorage tokens,
    required Box<String> cacheBox,
  })  : _tokens = tokens,
        _cacheBox = cacheBox;

  final TokenStorage _tokens;
  final Box<String> _cacheBox;

  static const _userKey = 'cached_user';

  @override
  Future<void> saveSession({
    required String accessToken,
    required UserModel user,
  }) async {
    try {
      await _tokens.saveTokens(accessToken: accessToken);
      await _cacheBox.put(_userKey, jsonEncode(user.toJson()));
    } on CacheException {
      rethrow;
    } catch (_) {
      throw const CacheException('Gagal menyimpan sesi.');
    }
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      return await _tokens.readAccessToken();
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final raw = _cacheBox.get(_userKey);
      if (raw == null) return null;
      return UserModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      throw const CacheException();
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      await _cacheBox.put(_userKey, jsonEncode(user.toJson()));
    } catch (_) {
      throw const CacheException('Gagal menyimpan data pengguna.');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _tokens.clear();
      await _cacheBox.delete(_userKey);
    } catch (_) {
      throw const CacheException('Gagal menghapus sesi.');
    }
  }
}
