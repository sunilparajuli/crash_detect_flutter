import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/context_metadata.dart';

part 'context_metadata_dto.g.dart';

@JsonSerializable()
class ContextMetadataDto {
  final String roadType;
  final String weatherCondition;
  final int trafficCongestion;
  final String timeOfDay;
  final int speed;

  ContextMetadataDto({
    required this.roadType,
    required this.weatherCondition,
    required this.trafficCongestion,
    required this.timeOfDay,
    required this.speed,
  });

  factory ContextMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$ContextMetadataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ContextMetadataDtoToJson(this);

  ContextMetadata toDomain() {
    return ContextMetadata(
      roadType: roadType,
      weatherCondition: weatherCondition,
      trafficCongestion: trafficCongestion,
      timeOfDay: timeOfDay,
      speed: speed,
    );
  }
}
