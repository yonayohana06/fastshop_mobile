import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';
import 'session_events.dart';

class DioClient {
  const DioClient._();

  static Dio create({
    required TokenStorage tokens,
    required SessionEvents session,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Env.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        headers: const {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(AuthInterceptor(tokens, session));

    if (kDebugMode) {
      // Body sengaja tidak di-log supaya password/token tidak bocor ke console.
      dio.interceptors.add(
        LogInterceptor(requestBody: false, responseBody: false),
      );
    }

    return dio;
  }
}
