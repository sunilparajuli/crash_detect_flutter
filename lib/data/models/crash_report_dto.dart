import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/crash_event.dart';

part 'crash_report_dto.g.dart';

@JsonSerializable()
class CrashReportDto {
  final String id;
  final DateTime timestamp;
  final double impactForce;
  final String severity;
  final double latitude;
  final double longitude;
  final String roadType;
  final String weatherCondition;
  final int trafficCongestion;
  final String timeOfDay;
  final int speed;

  CrashReportDto({
    required this.id,
    required this.timestamp,
    required this.impactForce,
    required this.severity,
    required this.latitude,
    required this.longitude,
    required this.roadType,
    required this.weatherCondition,
    required this.trafficCongestion,
    required this.timeOfDay,
    required this.speed,
  });

  factory CrashReportDto.fromDomain(CrashEvent crash) {
    return CrashReportDto(
      id: crash.id,
      timestamp: crash.timestamp,
      impactForce: crash.impactForce,
      severity: crash.severity,
      latitude: crash.location.latitude,
      longitude: crash.location.longitude,
      roadType: crash.context.roadType,
      weatherCondition: crash.context.weatherCondition,
      trafficCongestion: crash.context.trafficCongestion,
      timeOfDay: crash.context.timeOfDay,
      speed: crash.context.speed,
    );
  }

  factory CrashReportDto.fromJson(Map<String, dynamic> json) =>
      _$CrashReportDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CrashReportDtoToJson(this);
}
