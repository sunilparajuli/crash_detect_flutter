// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crash_report_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrashReportDto _$CrashReportDtoFromJson(Map<String, dynamic> json) =>
    CrashReportDto(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      impactForce: (json['impactForce'] as num).toDouble(),
      severity: json['severity'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      roadType: json['roadType'] as String,
      weatherCondition: json['weatherCondition'] as String,
      trafficCongestion: (json['trafficCongestion'] as num).toInt(),
      timeOfDay: json['timeOfDay'] as String,
      speed: (json['speed'] as num).toInt(),
    );

Map<String, dynamic> _$CrashReportDtoToJson(CrashReportDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'timestamp': instance.timestamp.toIso8601String(),
      'impactForce': instance.impactForce,
      'severity': instance.severity,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'roadType': instance.roadType,
      'weatherCondition': instance.weatherCondition,
      'trafficCongestion': instance.trafficCongestion,
      'timeOfDay': instance.timeOfDay,
      'speed': instance.speed,
    };
