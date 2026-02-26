import '../entities/crash_event.dart';

class GenerateCrashReportUseCase {
  Future<String> execute(CrashEvent crash) async {
    // Determine crash severity logic or additional compilation here
    return 'Crash Report [${crash.id}]: Severity ${crash.severity} at ${crash.location.latitude}, ${crash.location.longitude}. '
        'Context: ${crash.context.weatherCondition}, ${crash.context.roadType}, ${crash.context.speed} km/h.';
  }
}
