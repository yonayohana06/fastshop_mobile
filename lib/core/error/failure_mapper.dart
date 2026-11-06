import 'package:dartz/dartz.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Menjalankan [action] dan mengubah exception layer data menjadi `Failure`.
/// Dipakai repository supaya tidak mengulang try/catch yang sama.
Future<Either<Failure, T>> guardFailure<T>(Future<T> Function() action) async {
  try {
    return Right<Failure, T>(await action());
  } on UnauthorizedException catch (e) {
    return Left<Failure, T>(UnauthorizedFailure(e.message));
  } on ServerException catch (e) {
    return Left<Failure, T>(ServerFailure(e.message, statusCode: e.statusCode));
  } on NetworkException catch (e) {
    return Left<Failure, T>(NetworkFailure(e.message));
  } on CacheException catch (e) {
    return Left<Failure, T>(CacheFailure(e.message));
  }
}
