import 'package:dio/dio.dart';

import '../error/exceptions.dart';

/// Membungkus pemanggilan Dio dan mengubah error-nya menjadi exception
/// aplikasi, sehingga datasource tidak perlu mengulang try/catch.
///
/// Asumsi format error backend: `{ "message": "..." }`. Sesuaikan
/// [_extractMessage] jika berbeda.
Future<T> guardDio<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on DioException catch (e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        throw const NetworkException();
      default:
        break;
    }

    final status = e.response?.statusCode;
    final message =
        _extractMessage(e.response?.data) ?? 'Terjadi kesalahan pada server.';

    if (status == 401) throw UnauthorizedException(message);
    throw ServerException(message, statusCode: status);
  } on FormatException {
    throw const ServerException('Format respons server tidak sesuai.');
  } on TypeError {
    throw const ServerException('Format respons server tidak sesuai.');
  }
}

String? _extractMessage(dynamic data) {
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) return message;
  }
  return null;
}
