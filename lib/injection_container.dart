import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'domain/repositories/crash_repository.dart';
import 'domain/repositories/location_repository.dart';
import 'domain/repositories/sensor_repository.dart';
import 'domain/use_cases/detect_crash_use_case.dart';
import 'domain/use_cases/generate_crash_report_use_case.dart';
import 'domain/use_cases/notify_emergency_contacts_use_case.dart';
import 'data/data_sources/crash_local_data_source.dart';
import 'data/data_sources/crash_remote_data_source.dart';
import 'data/repositories/crash_repository_impl.dart';
import 'data/services/edge_crash_detection_service.dart';
import 'presentation/blocs/crash_event_bloc.dart';
import 'presentation/blocs/location_sensor_bloc.dart';

import '../domain/entities/sensor_reading.dart';
import '../domain/entities/context_metadata.dart';

// Placeholder for missing implementations just for dependency injection setup
class DummySensorRepository implements SensorRepository {
  @override
  Stream<SensorReading> getSensorStream() => const Stream.empty();
  @override
  Future<void> startMonitoring() async {}
  @override
  Future<void> stopMonitoring() async {}
}

class DummyLocationRepository implements LocationRepository {
  @override
  Stream<GpsCoordinates> getLocationStream() => const Stream.empty();
  @override
  Future<ContextMetadata> fetchContextData(GpsCoordinates loc) async {
    return const ContextMetadata(
      roadType: 'unknown',
      weatherCondition: 'unknown',
      trafficCongestion: 0,
      timeOfDay: 'day',
      speed: 0,
    );
  }
}



final sl = GetIt.instance;

Future<void> initDependencies() async {
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Connectivity());
  // Ideally register Hive and SQflite instances here

  // Data sources
  sl.registerLazySingleton(() => CrashRemoteDataSource(dio: sl()));
  // Mocking local source dependencies for now
  // sl.registerLazySingleton(() => CrashLocalDataSource(db: sl(), hiveBox: sl()));

  // Services
  sl.registerLazySingleton<CrashDetectionEngine>(() => EdgeCrashDetectionService());

  // Repositories
  // sl.registerLazySingleton<CrashRepository>(() => CrashRepositoryImpl(
  //       localDataSource: sl(),
  //       remoteDataSource: sl(),
  //       connectivity: sl(),
  //     ));
  
  // Using Dummy Repositories for UI compilation
  sl.registerLazySingleton<SensorRepository>(() => DummySensorRepository());
  sl.registerLazySingleton<LocationRepository>(() => DummyLocationRepository());

  // Mocking CrashRepository until local DB is setup
  // sl.registerLazySingleton<CrashRepository>(() => DummyCrashRepository());

  // Use Cases
  sl.registerLazySingleton(() => DetectCrashUseCase(
        detectionEngine: sl(),
        locationRepository: sl(),
      ));
  sl.registerLazySingleton(() => GenerateCrashReportUseCase());
  // sl.registerLazySingleton(() => NotifyEmergencyContactsUseCase(crashRepository: sl()));

  // Blocs
  // sl.registerFactory(() => CrashEventBloc(
  //       detectCrashUseCase: sl(),
  //       generateCrashReportUseCase: sl(),
  //       notifyEmergencyContactsUseCase: sl(),
  //       sensorRepository: sl(),
  //       locationRepository: sl(),
  //     ));
  
  sl.registerFactory(() => LocationSensorBloc(
        locationRepository: sl(),
        sensorRepository: sl(),
      ));
}
