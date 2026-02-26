import '../entities/sensor_reading.dart';

abstract class SensorRepository {
  Stream<SensorReading> getSensorStream();
  Future<void> startMonitoring();
  Future<void> stopMonitoring();
}
