// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'context_metadata_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContextMetadataDto _$ContextMetadataDtoFromJson(Map<String, dynamic> json) =>
    ContextMetadataDto(
      roadType: json['roadType'] as String,
      weatherCondition: json['weatherCondition'] as String,
      trafficCongestion: (json['trafficCongestion'] as num).toInt(),
      timeOfDay: json['timeOfDay'] as String,
      speed: (json['speed'] as num).toInt(),
    );

Map<String, dynamic> _$ContextMetadataDtoToJson(ContextMetadataDto instance) =>
    <String, dynamic>{
      'roadType': instance.roadType,
      'weatherCondition': instance.weatherCondition,
      'trafficCongestion': instance.trafficCongestion,
      'timeOfDay': instance.timeOfDay,
      'speed': instance.speed,
    };
