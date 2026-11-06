import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';

/// Kontrak repository auth. Implementasinya ada di layer data.
abstract class AuthRepository {
  /// Login dan simpan sesi (token + user).
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  /// Mendaftarkan akun baru. TIDAK membuat sesi: backend tidak mengembalikan
  /// token pada registrasi, jadi pengguna perlu login setelahnya.
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Memulihkan sesi saat app start: memvalidasi token ke `GET /auth/me`.
  /// - token tidak ada/ditolak server → `Left(UnauthorizedFailure)` (sesi dihapus)
  /// - server/jaringan bermasalah tapi ada cache user → `Right(cachedUser)`
  Future<Either<Failure, User>> getCurrentSession();

  /// Menghapus sesi lokal (backend tidak punya endpoint logout).
  Future<Either<Failure, Unit>> logout();
}
