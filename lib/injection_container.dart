import 'dart:async';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'domain/repositories/location_repository.dart';
import 'domain/repositories/sensor_repository.dart';
import 'domain/use_cases/detect_crash_use_case.dart';
import 'domain/use_cases/generate_crash_report_use_case.dart';
import 'data/data_sources/crash_remote_data_source.dart';
import 'data/services/edge_crash_detection_service.dart';
import 'presentation/blocs/location_sensor_bloc.dart';

import '../domain/entities/sensor_reading.dart';
import '../domain/entities/context_metadata.dart';
import '../domain/entities/crash_event.dart';
import 'domain/repositories/crash_repository.dart';
import 'domain/use_cases/notify_emergency_contacts_use_case.dart';
import 'presentation/blocs/crash_event_bloc.dart';

class DummyCrashRepository implements CrashRepository {
  @override
  Future<void> saveCrash(CrashEvent crash) async {}
  @override
  Future<List<CrashEvent>> getCrashHistory() async => [];
  @override
  Future<void> syncWithBackend(CrashEvent crash) async {}
}

// Placeholder for missing implementations just for dependency injection setup
class DummySensorRepository implements SensorRepository {
  final _controller = StreamController<SensorReading>.broadcast();
  Timer? _timer;

  @override
  Stream<SensorReading> getSensorStream() => _controller.stream;

  @override
  Future<void> startMonitoring() async {
    // Emit normal 1G resting gravity continuously
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_controller.isClosed) {
        _controller.add(SensorReading(
          accelerometerX: 0.0,
          accelerometerY: 9.81, // 1G
          accelerometerZ: 0.0,
          gyroX: 0.0,
          gyroY: 0.0,
          gyroZ: 0.0,
          timestamp: DateTime.now(),
        ));
      }
    });
  }

  @override
  Future<void> stopMonitoring() async {
    _timer?.cancel();
  }

  void simulateCrash() {
    // Inject a violent 10G impact with rapid 5 rad/s rotation
    for (int i = 0; i < 20; i++) {
      _controller.add(SensorReading(
        accelerometerX: 50.0, 
        accelerometerY: 80.0, 
        accelerometerZ: 20.0,
        gyroX: 5.0,
        gyroY: 5.0,
        gyroZ: 5.0,
        timestamp: DateTime.now(),
      ));
    }
  }
}

class DummyLocationRepository implements LocationRepository {
  @override
  Stream<GpsCoordinates> getLocationStream() async* {
    yield const GpsCoordinates(latitude: 37.7749, longitude: -122.4194);
  }
  @override
  Future<ContextMetadata> fetchContextData(GpsCoordinates loc) async {
    return const ContextMetadata(
      roadType: 'highway', // Must not be urban + low speed
      weatherCondition: 'clear',
      trafficCongestion: 0,
      timeOfDay: 'day',
      speed: 65, // Fast enough to trigger severity
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
  sl.registerLazySingleton<CrashRepository>(() => DummyCrashRepository());

  // Use Cases
  sl.registerLazySingleton(() => DetectCrashUseCase(
        detectionEngine: sl(),
        locationRepository: sl(),
      ));
  sl.registerLazySingleton(() => GenerateCrashReportUseCase());
  sl.registerLazySingleton(() => NotifyEmergencyContactsUseCase(crashRepository: sl()));

  // Blocs
  sl.registerFactory(() => CrashEventBloc(
        detectCrashUseCase: sl(),
        generateCrashReportUseCase: sl(),
        notifyEmergencyContactsUseCase: sl(),
        sensorRepository: sl(),
        locationRepository: sl(),
      ));
  
  sl.registerFactory(() => LocationSensorBloc(
        locationRepository: sl(),
        sensorRepository: sl(),
      ));
}
