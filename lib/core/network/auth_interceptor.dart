import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'session_events.dart';

/// Menempelkan Bearer token ke setiap request dan memberi tahu
/// [SessionEvents] saat sesi tidak valid (401).
///
/// Untuk endpoint seperti login (401 = kredensial salah, bukan sesi habis),
/// kirim `Options(extra: {AuthInterceptor.skipAuthRedirect: true})`.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokens, this._session);

  static const skipAuthRedirect = 'skipAuthRedirect';

  final TokenStorage _tokens;
  final SessionEvents _session;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokens.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final skip = err.requestOptions.extra[skipAuthRedirect] == true;
    if (err.response?.statusCode == 401 && !skip) {
      _session.notifyUnauthorized();
    }
    handler.next(err);
  }
}
