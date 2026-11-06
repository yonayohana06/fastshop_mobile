import 'package:dio/dio.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/network/api_guard.dart';
import '../../../../core/network/auth_interceptor.dart';
import '../models/auth_response_model.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  /// `POST /auth/login` → token + user.
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });

  /// `POST /auth/register` → hanya user (backend tidak mengirim token).
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  });

  /// `GET /auth/me` → profil pengguna dari token yang tersimpan.
  Future<UserModel> getMe();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  /// 401 pada endpoint auth berarti kredensial salah / token tidak valid,
  /// bukan alasan untuk memicu logout global dari interceptor.
  static final Map<String, dynamic> _noSessionRedirect = {
    AuthInterceptor.skipAuthRedirect: true,
  };

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) {
    return guardDio(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
        options: Options(extra: _noSessionRedirect),
      );
      return AuthResponseModel.fromJson(response.data!);
    });
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) {
    return guardDio(() async {
      final response = await _dio.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {'name': name, 'email': email, 'password': password},
        options: Options(extra: _noSessionRedirect),
      );
      return UserModel.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }

  @override
  Future<UserModel> getMe() {
    return guardDio(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        ApiEndpoints.me,
        options: Options(
          extra: _noSessionRedirect,
          // Dipanggil saat app start; jangan menahan splash terlalu lama.
          receiveTimeout: const Duration(seconds: 8),
        ),
      );
      return UserModel.fromJson(
        response.data!['data'] as Map<String, dynamic>,
      );
    });
  }
}
