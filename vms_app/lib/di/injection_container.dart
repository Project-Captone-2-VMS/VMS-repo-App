import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:vms_app/constant/constants.dart';
import 'package:vms_app/features/auth/auth.dart';
import 'package:vms_app/features/home/data/datasources/remote/home_remote_datasource.dart';
import 'package:vms_app/features/home/data/repositories/home_repository.dart';
import 'package:vms_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:vms_app/features/job/data/datasources/remote/job_remote_datasource.dart';
import 'package:vms_app/features/job/data/repositories/job_repository.dart';
import 'package:vms_app/features/job/presentation/cubit/job_cubit.dart';
import 'package:vms_app/features/location/data/repositories/location_repository_impl.dart';
import 'package:vms_app/features/location/domain/location_repository.dart';
import 'package:vms_app/features/location/ui/cubit/location_cubit.dart';

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
      ..registerFactory(() => AuthCubit(sl()))
      ..registerLazySingleton(() => HomeDatasource(sl()))
      ..registerLazySingleton(() => HomeRepository(sl()))
      ..registerFactory(() => HomeCubit(sl()))
      ..registerLazySingleton(() => JobDatasource(sl()))
      ..registerLazySingleton(() => JobRepository(sl()))
      ..registerFactory(() => JobCubit(sl()))
      ..registerLazySingleton<LocationRepository>(
        () => LocationRepositoryImpl(),
      )
      ..registerFactory(() => LocationCubit(sl<LocationRepository>()));
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
