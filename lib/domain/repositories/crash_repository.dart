import '../entities/crash_event.dart';

abstract class CrashRepository {
  Future<void> saveCrash(CrashEvent crash);
  Future<List<CrashEvent>> getCrashHistory();
  Future<void> syncWithBackend(CrashEvent crash);
}
