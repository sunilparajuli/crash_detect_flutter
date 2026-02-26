import 'package:equatable/equatable.dart';

class GpsCoordinates extends Equatable {
  final double latitude;
  final double longitude;

  const GpsCoordinates({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class ContextMetadata extends Equatable {
  final String roadType;
  final String weatherCondition;
  final int trafficCongestion;
  final String timeOfDay;
  final int speed;

  const ContextMetadata({
    required this.roadType,
    required this.weatherCondition,
    required this.trafficCongestion,
    required this.timeOfDay,
    required this.speed,
  });

  @override
  List<Object?> get props => [
        roadType,
        weatherCondition,
        trafficCongestion,
        timeOfDay,
        speed,
      ];
}
