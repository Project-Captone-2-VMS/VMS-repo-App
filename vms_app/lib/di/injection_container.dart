import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vms_app/constant/constants.dart';
import 'package:vms_app/features/auth/auth.dart';

final GetIt sl = GetIt.instance;

class ProductionServiceLocator {
  @mustCallSuper
  Future<void> setup() async {
    if (!sl.isRegistered<AppConstants>()) {
      sl.registerSingleton<AppConstants>(AppConstants());
    }

    final dio = createDio();

    sl
      ..registerSingleton(dio)
      ..registerLazySingleton(() => AuthDatasource(sl()))
      ..registerLazySingleton(() => AuthRepository(sl()))
      ..registerFactory(() => AuthCubit(sl()));
  }

  Dio createDio() {
    return Dio(BaseOptions(baseUrl: sl<AppConstants>().baseUrl));
  }
}

class StagingServiceLocator extends ProductionServiceLocator {
  @override
  Future<void> setup() async {
    sl.registerSingleton<AppConstants>(StagingAppConstants());
    await super.setup();
  }
}

class DevelopmentServiceLocator extends ProductionServiceLocator {
  @override
  Future<void> setup() async {
    sl.registerSingleton<AppConstants>(DevelopmentAppConstants());
    await super.setup();
  }
}
