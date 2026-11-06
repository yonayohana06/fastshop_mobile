import 'package:get_it/get_it.dart';

import 'data/datasources/auth_local_data_source.dart';
import 'data/datasources/auth_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/usecases/get_current_session_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/register_usecase.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/login/login_bloc.dart';
import 'presentation/bloc/register/register_bloc.dart';

/// Registrasi dependency milik fitur auth.
/// Setiap fitur baru punya file `<fitur>_injection.dart` sendiri.
void registerAuthDependencies(GetIt sl) {
  sl
    // Data sources
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSourceImpl(tokens: sl(), cacheBox: sl()),
    )
    // Repository
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: sl(), local: sl(), networkInfo: sl()),
    )
    // Use cases
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => GetCurrentSessionUseCase(sl()))
    // Blocs (factory: instance baru tiap diminta)
    ..registerFactory(
      () => AuthBloc(
        getCurrentSession: sl(),
        logout: sl(),
        sessionEvents: sl(),
      ),
    )
    ..registerFactory(() => LoginBloc(loginUseCase: sl()))
    ..registerFactory(() => RegisterBloc(registerUseCase: sl()));
}
