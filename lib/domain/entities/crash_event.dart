import 'package:equatable/equatable.dart';
import 'context_metadata.dart';
import 'sensor_reading.dart';

class CrashEvent extends Equatable {
  final String id;
  final DateTime timestamp;
  final double impactForce;
  final String severity; // LOW, MEDIUM, HIGH, CRITICAL
  final GpsCoordinates location;
  final ContextMetadata context;
  final List<SensorReading> rawSensorData;

  const CrashEvent({
    required this.id,
    required this.timestamp,
    required this.impactForce,
    required this.severity,
    required this.location,
    required this.context,
    required this.rawSensorData,
  });

  @override
  List<Object?> get props => [
        id,
        timestamp,
        impactForce,
        severity,
        location,
        context,
        rawSensorData,
      ];
}
