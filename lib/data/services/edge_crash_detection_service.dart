import 'dart:math';
import '../../domain/entities/sensor_reading.dart';
import '../../domain/entities/context_metadata.dart';
import '../../domain/entities/crash_event.dart';
import '../../domain/repositories/location_repository.dart';
import '../../domain/use_cases/detect_crash_use_case.dart';
import 'package:uuid/uuid.dart';

class EdgeCrashDetectionService implements CrashDetectionEngine {
  final List<SensorReading> _sensorBuffer = [];

  static const int bufferSize = 500; // ~5 seconds @ 100Hz
  static const double impactThreshold = 3.5; // G-forces
  static const double gyroThreshold = 2.0; // rad/s (simplified from degrees)

  @override
  Future<CrashEvent?> processSensorStream(
    Stream<SensorReading> sensorStream,
    Stream<GpsCoordinates> locationStream,
    LocationRepository locationRepository,
  ) async {
    GpsCoordinates? latestLocation;
    locationStream.listen((loc) {
      latestLocation = loc;
    });

    await for (final reading in sensorStream) {
      _sensorBuffer.add(reading);
      if (_sensorBuffer.length > bufferSize) {
        _sensorBuffer.removeAt(0);
      }

      // Step 1: Detect high-impact acceleration (potential crash)
      if (_detectImpact(reading)) {
        // Step 2: Validate with gyroscope (sudden rotation indicates crash)
        final window = _sensorBuffer.length >= 20
            ? _sensorBuffer.sublist(_sensorBuffer.length - 20)
            : _sensorBuffer;

        if (_validateWithRotation(window)) {
          // Step 3: Cross-check with motion context
          if (latestLocation != null) {
            final context =
                await locationRepository.fetchContextData(latestLocation!);
            if (!_isFalseBraking(context)) {
              final crash = _generateCrashEvent(
                reading,
                context,
                latestLocation!,
              );
              return crash; // Crash detected
            }
          }
        }
      }
    }
    return null;
  }

  bool _detectImpact(SensorReading reading) {
    // Basic magnitude calculation (could apply filtering or gravity removal depending on the sensor used)
    final magnitude = sqrt(pow(reading.accelerometerX, 2) +
        pow(reading.accelerometerY, 2) +
        pow(reading.accelerometerZ, 2));

    // Convert assuming m/s^2 output from sensor. 1G = 9.81 m/s^2.
    // If output is already Gs, remove division
    final gForce = magnitude / 9.81;

    return gForce > impactThreshold;
  }

  bool _validateWithRotation(List<SensorReading> window) {
    if (window.isEmpty) return false;

    // Calculate sum of gyro magnitudes without reduce
    double sumGyroMag = 0.0;
    for (var r in window) {
      sumGyroMag += sqrt(pow(r.gyroX, 2) + pow(r.gyroY, 2) + pow(r.gyroZ, 2));
    }

    final avgGyroMag = sumGyroMag / window.length;
    return avgGyroMag > gyroThreshold;
  }

  bool _isFalseBraking(ContextMetadata context) {
    // Distinguish crash from emergency braking using speed, road type, etc.
    return context.speed < 15 && context.roadType == 'urban';
  }

  CrashEvent _generateCrashEvent(
    SensorReading triggerReading,
    ContextMetadata context,
    GpsCoordinates location,
  ) {
    return CrashEvent(
      id: const Uuid().v4(),
      timestamp: triggerReading.timestamp,
      impactForce: sqrt(pow(triggerReading.accelerometerX, 2) +
              pow(triggerReading.accelerometerY, 2) +
              pow(triggerReading.accelerometerZ, 2)) /
          9.81,
      severity: _classifySeverity(context.speed),
      location: location,
      context: context,
      rawSensorData: List.from(_sensorBuffer),
    );
  }

  String _classifySeverity(int speed) {
    if (speed < 30) return 'LOW';
    if (speed < 60) return 'MEDIUM';
    if (speed < 100) return 'HIGH';
    return 'CRITICAL';
  }
}
