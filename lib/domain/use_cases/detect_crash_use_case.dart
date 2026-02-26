import 'dart:async';
import '../entities/crash_event.dart';
import '../entities/sensor_reading.dart';
import '../entities/context_metadata.dart';
import '../repositories/location_repository.dart';

abstract class CrashDetectionEngine {
  Future<CrashEvent?> processSensorStream(
    Stream<SensorReading> sensorStream,
    Stream<GpsCoordinates> locationStream,
    LocationRepository locationRepository,
  );
}

class DetectCrashUseCase {
  final CrashDetectionEngine _detectionEngine;
  final LocationRepository _locationRepository;

  DetectCrashUseCase({
    required CrashDetectionEngine detectionEngine,
    required LocationRepository locationRepository,
  })  : _detectionEngine = detectionEngine,
        _locationRepository = locationRepository;

  Future<CrashEvent?> execute({
    required Stream<SensorReading> sensorStream,
    required Stream<GpsCoordinates> locationStream,
  }) async {
    return _detectionEngine.processSensorStream(
      sensorStream,
      locationStream,
      _locationRepository,
    );
  }
}
