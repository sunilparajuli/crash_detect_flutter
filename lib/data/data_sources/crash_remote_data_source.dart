import 'package:dio/dio.dart';
import '../../domain/entities/crash_event.dart';
import '../../domain/entities/context_metadata.dart';
import '../models/crash_report_dto.dart';
import '../models/context_metadata_dto.dart';

class SyncException implements Exception {
  final String message;
  SyncException(this.message);
}

class CrashRemoteDataSource {
  final Dio _dio;

  CrashRemoteDataSource({required Dio dio}) : _dio = dio;

  Future<void> syncCrashReport(CrashEvent crash) async {
    try {
      final payload = CrashReportDto.fromDomain(crash);
      await _dio.post(
        '/api/v1/crashes/report',
        data: payload.toJson(),
      );
    } catch (e) {
      // Queue for retry if offline
      throw SyncException('Failed to sync crash: $e');
    }
  }

  Future<ContextMetadata> fetchWeatherAndTraffic(
    double latitude,
    double longitude,
    DateTime timestamp,
  ) async {
    try {
      final response = await _dio.get(
        '/api/v1/context',
        queryParameters: {
          'lat': latitude,
          'lng': longitude,
          'time': timestamp.toIso8601String(),
        },
      );
      return ContextMetadataDto.fromJson(response.data).toDomain();
    } catch (e) {
      // Fallback context
      return const ContextMetadata(
        roadType: 'unknown',
        weatherCondition: 'unknown',
        trafficCongestion: 0,
        timeOfDay: 'unknown',
        speed: 0,
      );
    }
  }
}
