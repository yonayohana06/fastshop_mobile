import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure_mapper.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_data_source.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
    required NetworkInfo networkInfo,
  })  : _remote = remote,
        _local = local,
        _network = networkInfo;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;
  final NetworkInfo _network;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());

    return guardFailure<User>(() async {
      final response = await _remote.login(email: email, password: password);
      await _local.saveSession(
        accessToken: response.accessToken,
        user: response.user,
      );
      return response.user;
    });
  }

  @override
  Future<Either<Failure, User>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (!await _network.isConnected) return const Left(NetworkFailure());

    return guardFailure<User>(
      () => _remote.register(name: name, email: email, password: password),
    );
  }

  @override
  Future<Either<Failure, User>> getCurrentSession() async {
    try {
      final token = await _local.getAccessToken();
      if (token == null || token.isEmpty) {
        return const Left(UnauthorizedFailure('Belum login.'));
      }

      final cached = await _local.getCachedUser();

      try {
        final fresh = await _remote.getMe();
        await _local.cacheUser(fresh);
        return Right(fresh);
      } on UnauthorizedException {
        // Token kedaluwarsa/dicabut: hapus sesi lokal.
        await _local.clearSession();
        return const Left(UnauthorizedFailure());
      } on NetworkException catch (e) {
        return cached != null ? Right(cached) : Left(NetworkFailure(e.message));
      } on ServerException catch (e) {
        return cached != null
            ? Right(cached)
            : Left(ServerFailure(e.message, statusCode: e.statusCode));
      }
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _local.clearSession();
      return const Right(unit);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
