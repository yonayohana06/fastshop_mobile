import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../features/auth/auth_injection.dart';
import '../../features/product/product_injection.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../network/session_events.dart';
import '../storage/token_storage.dart';

/// Service locator global.
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // --- External ---
  await Hive.initFlutter();
  final cacheBox = await Hive.openBox<String>('app_cache');

  sl
    ..registerSingleton<Box<String>>(cacheBox)
    ..registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new)
    ..registerLazySingleton<Connectivity>(Connectivity.new)
    // --- Core ---
    ..registerLazySingleton<TokenStorage>(() => SecureTokenStorage(sl()))
    ..registerLazySingleton<SessionEvents>(SessionEvents.new)
    ..registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()))
    ..registerLazySingleton<Dio>(
      () => DioClient.create(tokens: sl(), session: sl()),
    );

  // --- Features ---
  registerAuthDependencies(sl);
  registerProductDependencies(sl);
}
