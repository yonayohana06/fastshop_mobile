/// Exception dilempar oleh layer data (datasource).
/// Repository bertugas mengubahnya menjadi `Failure`.
class ServerException implements Exception {
  const ServerException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException([
    super.message = 'Sesi berakhir, silakan login kembali.',
  ]) : super(statusCode: 401);
}

class NetworkException implements Exception {
  const NetworkException([this.message = 'Tidak ada koneksi internet.']);

  final String message;
}

class CacheException implements Exception {
  const CacheException([this.message = 'Gagal membaca data lokal.']);

  final String message;
}
