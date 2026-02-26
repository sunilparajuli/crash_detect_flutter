import 'package:equatable/equatable.dart';

class SensorReading extends Equatable {
  final double accelerometerX;
  final double accelerometerY;
  final double accelerometerZ;
  final double gyroX;
  final double gyroY;
  final double gyroZ;
  final DateTime timestamp;

  const SensorReading({
    required this.accelerometerX,
    required this.accelerometerY,
    required this.accelerometerZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
        accelerometerX,
        accelerometerY,
        accelerometerZ,
        gyroX,
        gyroY,
        gyroZ,
        timestamp,
      ];
}
